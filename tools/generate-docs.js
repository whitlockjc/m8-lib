#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { load, resolve } = require('./ksy-layout')
const targets = require('./doc-targets.json')

const root = path.resolve(__dirname, '..')
const schemaRoot = path.join(root, 'schemas')
const kinds = ['instrument', 'scale', 'song', 'theme']
const hex = n => `0x${n.toString(16).padStart(2, '0')}`
const escape = value => String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;')
  .replaceAll('>', '&gt;').replaceAll('|', '&#124;').replaceAll('`', '&#96;').replace(/\r?\n/g, ' ')
const code = value => {
  const content = String(value).replaceAll('|', '\\|').replace(/\r?\n/g, ' ')
  const fence = '`'.repeat(Math.max(0, ...(content.match(/`+/g) || []).map(run => run.length)) + 1)
  return `${fence}${content}${fence}`
}
const text = value => typeof value === 'object' ? JSON.stringify(value) : String(value)
const range = (start, size) => size === 1 ? hex(start) : `${hex(start)}..${hex(start + size - 1)}`

function link (from, to, label, anchor = '') {
  if (from === to && anchor) return `[${escape(label)}](#${anchor})`
  const relative = path.relative(path.dirname(from), to).split(path.sep).join('/')
  return `[${escape(label)}](${relative || path.basename(to)}${anchor ? `#${anchor}` : ''})`
}

function component (entry, kind) {
  const name = entry.data.seq.find(field => field.id === 'body').type.cases[`file_header::file_kind::${kind}`]
  assert.ok(name, `missing ${kind} dispatch in ${entry.file}`)
  return resolve(entry, name)[0]
}

function graph (entry) {
  const seen = new Set()
  const visit = context => {
    if (seen.has(context)) return
    seen.add(context)
    context.imports.forEach(visit)
  }
  visit(entry)
  return [...seen].sort((a, b) => a.file.localeCompare(b.file, 'en'))
}

const fxInstrumentNames = [
  ['wavsynth', 'Wavsynth'], ['macrosynth', 'Macrosynth'], ['sampler', 'Sampler'],
  ['fm_synth', 'FM Synth'], ['midi_out', 'MIDI Out'], ['hypersynth', 'Hypersynth'],
  ['external', 'External'], ['none', 'NONE']
]
const isFxEnum = name => name === 'fx_command' || name === 'instrument_mod_fx_command' || name.endsWith('_fx_command')

function fxFile () {
  return path.join(root, 'docs', 'common', 'fx_commands.md')
}

function renderFxCommands (firmware, target) {
  const file = fxFile()
  const lines = ['# M8 FX Commands', '',
    link(file, path.join(root, 'docs', 'README.md'), 'Documentation index'), '',
    'Phrase steps and Instrument Table rows use the same two-byte FX slot. The M8 UI groups command labels by purpose; availability and behavior depend on the slot context, active instrument, and modulation type.', '']
  const rows = entries => [
    '| Stored Value | M8 Label | Identifier |', '| --- | --- | --- |',
    ...entries.map(([value, entry]) => `| ${code(hex(Number(value)))} | ${escape(entry['-label'] || '')} | ${code(entry.id)} |`), ''
  ]
    const modules = graph(load(path.resolve(root, target.entry)))
    const sequencing = modules.find(context => context.data.meta['-fx-sequencer-ranges'])
    assert.ok(sequencing?.data.enums?.fx_command, `missing FX catalog for ${firmware}`)
    const ranges = sequencing.data.meta['-fx-sequencer-ranges']
    const entries = Object.entries(sequencing.data.enums.fx_command)
      .sort(([a], [b]) => Number(a) - Number(b))
    const isSequencer = value => ranges.some(([first, last]) => value >= first && value <= last)
    lines.push(`Values come from ${link(file, sequencing.file, path.relative(root, sequencing.file))} and the instrument-specific schemas linked below.`, '',
      '## Instrument (Current Instrument)', '',
      'Current Instrument command labels vary by instrument type.', '')
    for (const [name, label] of fxInstrumentNames) {
      const owner = modules.find(context => context.data.meta.id === `${name}_6_0_1`)
      const values = owner?.data.enums?.fx_command
      assert.ok(values, `missing ${name} FX commands for ${firmware}`)
      lines.push(`### ${label}`, '', `Source: ${link(file, owner.file, path.relative(root, owner.file))}.`, '',
        ...rows(Object.entries(values).sort(([a], [b]) => Number(a) - Number(b))))
    }
    const mods = sequencing.data.meta['-fx-instrument-mods']
    const modCommands = sequencing.data.enums.instrument_mod_fx_command
    assert.ok(mods && modCommands, `missing Instrument Mods catalog for ${firmware}`)
    const modTypes = [
      ['ahd_env', 'AHD ENV'], ['adsr_env', 'ADSR ENV'], ['drum_env', 'DRUM ENV'],
      ['lfo', 'LFO'], ['trig_env', 'TRIG ENV'], ['tracking', 'TRACKING']
    ]
    const modRows = []
    for (let slot = 1; slot <= mods.slots; slot++) {
      for (let parameter = 1; parameter <= mods['parameters-per-slot']; parameter++) {
        const value = mods.base + (slot - 1) * mods['parameters-per-slot'] + parameter - 1
        assert.equal(modCommands[value]?.id, `mod_${slot}_parameter_${parameter}`)
        modRows.push(`| ${code(hex(value))} | ${modTypes.map(([type]) => {
          const prefixes = mods.prefixes[type]
          assert.equal(prefixes.length, mods['parameters-per-slot'])
          return code(`${prefixes[parameter - 1]}${slot}`)
        }).join(' | ')} |`)
      }
    }
    lines.push('## Instrument Mods', '',
      'The stored value selects a modulator slot and parameter position. Its label depends on that slot\'s modulation type.', '',
      `| Stored Value | ${modTypes.map(([, label]) => label).join(' | ')} |`,
      `| --- | ${modTypes.map(() => '---').join(' | ')} |`,
      ...modRows, '',
      '## Mixer & Effects', '',
      ...rows(entries.filter(([value]) => Number(value) !== 0xff && !isSequencer(Number(value)))),
      '## Sequencer', '',
      ...rows(entries.filter(([value]) => isSequencer(Number(value)))))
  return lines.join('\n').trimEnd() + '\n'
}

// Variable lengths propagate instead of producing guessed subsequent offsets.
function sizeOf (field, context, stack = new Set()) {
  if (field.if !== undefined || field['size-eos']) return null
  let size
  if (field.size !== undefined) size = Number.isInteger(field.size) ? field.size : null
  else if (field.contents !== undefined) size = typeof field.contents === 'string'
    ? Buffer.byteLength(field.contents, 'utf8') : field.contents.length
  else if (field.type === undefined || field.type === 'strz') size = null
  else if (typeof field.type === 'object') {
    const sizes = Object.values(field.type.cases).map(type => sizeOf({ type }, context, stack))
    size = sizes.length && sizes.every(value => value === sizes[0]) ? sizes[0] : null
  } else if (/^[us][1248](le|be)?$|^f[48](le|be)?$/.test(field.type)) size = Number(field.type[1])
  else {
    const [owner, definition] = resolve(context, field.type)
    if (stack.has(definition)) return null
    const nested = new Set(stack).add(definition)
    const sizes = (definition.seq || []).map(child => sizeOf(child, owner, nested))
    size = sizes.includes(null) ? null : sizes.reduce((a, b) => a + b, 0)
  }
  if (field.repeat) {
    if (field.repeat !== 'expr' || !Number.isInteger(field['repeat-expr'])) return null
    if (size !== null) size *= field['repeat-expr']
  }
  return size
}

function enumOwner (context, name) {
  const parts = name.split('::')
  if (parts.length === 2) {
    const owner = context.imports.find(item => item.data.meta.id === parts[0])
    assert.ok(owner?.data.enums?.[parts[1]], `unresolved enum ${name}`)
    return [owner, parts[1]]
  }
  assert.ok(context.data.enums?.[name], `unresolved enum ${name}`)
  return [context, name]
}

function renderTarget (firmware, target, catalog = targets) {
  const entry = load(path.resolve(root, target.entry))
  const output = path.join(root, 'docs')
  const modules = graph(entry)
  const pages = new Map(modules.map(context => {
    const relative = path.relative(schemaRoot, context.file)
    assert.ok(!relative.startsWith('..'), 'schema import outside schemas directory')
    return [context, path.join(output, relative.replace(/\.ksy$/, '.md'))]
  }))
  const index = pages.get(entry)
  const typeLink = (file, context, type) => {
    if (/^[us][1248](le|be)?$|^f[48](le|be)?$|^strz?$/.test(type)) return code(type)
    const [owner, definition] = resolve(context, type)
    const id = definition === owner.data ? 'layout' : `type-${type.split('::').at(-1)}`
    return link(file, pages.get(owner), type, id)
  }
  const fieldType = (file, context, field) => {
    let result = field.type === undefined ? 'bytes' : typeof field.type === 'object'
      ? `switch on ${code(field.type['switch-on'])}: ` + Object.entries(field.type.cases)
        .map(([value, type]) => `${code(value)}: ${typeLink(file, context, type)}`).join('; ')
      : typeLink(file, context, field.type)
    if (field.enum) {
      const [owner, name] = enumOwner(context, field.enum)
      result += `; ${link(file, pages.get(owner), name, `enum-${name}`)}`
    }
    if (field.type === 'fx_slot' && file === index) result += `; ${link(file, fxFile(), 'FX commands')}`
    return result
  }
  const attributes = (field, context) => {
    const values = Object.entries(field)
    .filter(([key]) => !['id', 'doc', 'type', 'enum'].includes(key))
    .map(([key, value]) => `${code(key)}: ${code(text(value))}`)
    if (context && typeof field.type === 'string' && !field.repeat &&
        !/^[us][1248](le|be)?$|^f[48](le|be)?$|^strz?$/.test(field.type)) {
      const [, definition] = resolve(context, field.type)
      if (definition.seq?.length === 1 && definition.seq[0].repeat === 'expr') {
        values.push(`${code('repeat')}: ${code(definition.seq[0]['repeat-expr'])} via ${code(definition.seq[0].id)}`)
      }
    }
    return values.join('; ') || '-'
  }
  const description = field => field.doc || ''
  const summaryDescription = field => {
    const prose = description(field).trim().replace(/\s+/g, ' ')
    return prose.match(/^.*?[.!?](?=\s|$)/)?.[0] || prose
  }
  const layout = (file, context, seq, start = 0, { summary = false } = {}) => {
    let offset = start
    const lines = ['| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |',
      '| --- | --- | ---: | --- | --- | --- |']
    for (const field of seq) {
      const size = sizeOf(field, context)
      const position = offset === null ? 'dynamic' : size === null ? `${hex(offset)} onward` : range(offset, size)
      const detail = summary ? summaryDescription(field) : description(field)
      lines.push(`| ${code(field.id)} | ${code(position)} | ${size === null ? 'variable' : size} | ${fieldType(file, context, field)} | ${attributes(field, context)} | ${escape(detail)} |`)
      offset = size === null || offset === null ? null : offset + size
    }
    return lines
  }
  const preamble = (file, heading) => [`# ${heading}`, '',
    link(file, path.join(output, 'README.md'), 'Documentation index'), '']
  const orderedTypes = data => {
    const types = data.types || {}
    const seen = new Set()
    const ordered = []
    const visit = fields => {
      for (const field of fields || []) {
        const refs = typeof field.type === 'object' ? Object.values(field.type.cases) : [field.type]
        for (const ref of refs) {
          if (!Object.hasOwn(types, ref) || seen.has(ref)) continue
          seen.add(ref)
          ordered.push(ref)
          visit(types[ref].seq)
        }
      }
    }
    visit(data.seq)
    for (const name of Object.keys(types)) {
      if (seen.has(name)) continue
      seen.add(name)
      ordered.push(name)
      visit(types[name].seq)
    }
    return ordered
  }
  const outputs = new Map([[fxFile(), renderFxCommands(firmware, target)]])
  for (const context of modules) {
    const file = pages.get(context)
    const data = context.data
    const typeNames = orderedTypes(data)
    const lines = [...preamble(file, data.meta.id),
      `Source: ${link(file, context.file, path.relative(root, context.file))}.`, '',
      `Byte order: ${code(data.meta.endian || 'unspecified')}.`, '']
    if (data.doc) lines.push(data.doc.trim(), '')
    const version = path.relative(schemaRoot, context.file).match(/^file-versions[/\\]([^/\\]+)/)?.[1]
    if (version) lines.push(`File schema version: ${code(version)}.`, '')
    if (context.imports.length) lines.push('## Imports', '', ...context.imports.map(imported =>
      `- ${link(file, pages.get(imported), imported.data.meta.id)}`), '')
    lines.push('## Contents', '', `- ${link(file, file, 'Layout', 'layout')}`,
      ...typeNames.map(name => `- ${link(file, file, name, `type-${name}`)}`),
      ...Object.keys(data.enums || {}).filter(name => !isFxEnum(name))
        .map(name => `- ${link(file, file, `${name} (enum)`, `enum-${name}`)}`), '')
    if (context.data.meta.id === 'fx_slot' || context.data.meta.id.startsWith('table_') ||
        Object.keys(data.enums || {}).some(isFxEnum)) {
      lines.push(`FX command values: ${link(file, fxFile(), 'FX command reference')}.`, '')
    }
    const renderDefinition = (definition, anchor) => {
      const sectionTitle = anchor === 'layout' ? 'Layout' : `Type: ${anchor.slice(5)}`
      lines.push(`## ${sectionTitle}`, '')
      if (definition.doc) lines.push(definition.doc.trim(), '')
      if (definition.seq) lines.push('Offsets are relative to the start of this record. Repeated-field sizes include all entries.', '',
        ...layout(file, context, definition.seq), '')
      if (definition.instances) {
        lines.push('### Instances', '', 'Value expressions do not consume bytes. Positioned instances read the specified location.', '',
          '| Name | Type | Expression / Position / Rules | Description |', '| --- | --- | --- | --- |')
        for (const [name, instance] of Object.entries(definition.instances)) lines.push(
          `| ${code(name)} | ${instance.type || instance.enum ? fieldType(file, context, instance).replace(/^bytes;/, 'derived;') : 'derived'} | ${attributes(instance)} | ${escape(instance.doc || '')} |`)
        lines.push('')
      }
      const extras = Object.fromEntries(Object.entries(definition).filter(([key]) =>
        !['meta', 'seq', 'instances', 'types', 'enums', 'doc'].includes(key)))
      if (Object.keys(extras).length) lines.push('Additional schema attributes:', '', '```json', JSON.stringify(extras, null, 2), '```', '')
    }
    renderDefinition({ ...data, doc: undefined }, 'layout')
    for (const name of typeNames) renderDefinition(data.types[name], `type-${name}`)
    for (const [name, entries] of Object.entries(data.enums || {})) {
      if (isFxEnum(name)) continue
      lines.push(`## Enum: ${name}`, '', code(name), '', '| Stored Value | Identifier | M8 Label | Description |', '| --- | --- | --- | --- |')
      for (const [value, entry] of Object.entries(entries).sort(([a], [b]) => Number(a) - Number(b))) {
        const item = typeof entry === 'object' ? entry : { id: entry }
        lines.push(`| ${code(hex(Number(value)))} | ${code(item.id)} | ${escape(item['-label'] || '')} | ${escape(item.doc || '')} |`)
      }
      lines.push('')
    }
    outputs.set(file, lines.join('\n').trimEnd() + '\n')
  }
  const headerField = entry.data.seq.find(field => field.id === 'header')
  const headerSize = sizeOf(headerField, entry)
  assert.ok(Number.isInteger(headerSize), 'file header must have fixed size')
  const indexLines = [...preamble(index, `M8 ${firmware} File Reference`),
    `Documentation for M8 **${firmware}** file structures (based on firmware **${target.verifiedFirmware}**).`, '',
    `Entry schema: ${link(index, entry.file, target.entry)}.`, '',
    `FX commands: ${link(index, fxFile(), 'command reference')}.`, '',
    '## Files', '', '| File Kind | File Schema Version | Schema |', '| --- | --- | --- |']
  for (const kind of kinds) {
    const context = component(entry, kind)
    const version = path.relative(schemaRoot, context.file).split(path.sep)[1]
    indexLines.push(`| ${link(index, index, kind[0].toUpperCase() + kind.slice(1), kind)} | ${code(version)} | ${link(index, pages.get(context), context.data.meta.id)} |`)
  }
  for (const kind of kinds) {
    const context = component(entry, kind)
    const bodySize = sizeOf({ type: context.data.meta.id }, entry)
    indexLines.push('', `## ${kind[0].toUpperCase() + kind.slice(1)}`, '',
      `Header: ${headerSize} bytes. Body: ${bodySize === null ? 'variable' : `${bodySize} bytes`}.`, '',
      `Definition: ${link(index, pages.get(context), context.data.meta.id)}.`, '',
      'Offsets are absolute file offsets. Follow type links for relative record layouts.', '',
      ...layout(index, entry, [headerField], 0, { summary: true }),
      ...layout(index, context, context.data.seq, headerSize, { summary: true }).slice(2), '')
  }
  indexLines.push('', '## Layout', '', 'Entry dispatch; offsets are absolute file offsets.', '', ...layout(index, entry, entry.data.seq, 0, { summary: true }), '',
    '## Components', '', ...modules.filter(context => context !== entry).map(context => `- ${link(index, pages.get(context), context.data.meta.id)}`), '',
    'Component links follow schema imports. Unchanged schemas and their documentation are shared across firmware entries.', '',
    'Unknown byte ranges retain their schema names.', '')
  outputs.set(index, indexLines.join('\n'))
  return outputs
}

function validateTargets (catalog) {
  for (const [firmware, target] of Object.entries(catalog)) {
    assert.match(firmware, /^\d+\.\d+\.x$/)
    assert.ok(target.verifiedFirmware.startsWith(firmware.slice(0, -1)), 'firmware provenance mismatch')
    assert.equal(path.resolve(root, target.entry), path.join(schemaRoot, `${firmware}.ksy`), 'entry must be schemas/<firmware-range>.ksy')
  }
}

function generate (catalog = targets, { check = false, firmware } = {}) {
  validateTargets(catalog)
  assert.ok(!firmware || catalog[firmware], `unsupported firmware target: ${firmware}`)
  const selected = firmware ? [[firmware, catalog[firmware]]] : Object.entries(catalog)
  const outputs = new Map()
  for (const [name, target] of selected) {
    for (const [file, content] of renderTarget(name, target, catalog)) {
      if (outputs.has(file)) assert.equal(outputs.get(file), content, `conflicting shared documentation: ${file}`)
      outputs.set(file, content)
    }
  }
  const existingMarkdown = directory => fs.existsSync(directory)
    ? fs.readdirSync(directory, { withFileTypes: true }).flatMap(item => {
      const file = path.join(directory, item.name)
      return item.isDirectory() ? existingMarkdown(file) : item.name.endsWith('.md') ? [file] : []
    }) : []
  // Only a full run can classify shared outputs as obsolete.
  if (!firmware) for (const directory of ['common', 'file-versions']) {
    for (const file of existingMarkdown(path.join(root, 'docs', directory))) {
      assert.ok(outputs.has(file), `unexpected generated page ${file}; review obsolete outputs before removing them`)
    }
  }
  for (const [file, content] of outputs) {
    if (check) assert.equal(fs.readFileSync(file, 'utf8'), content, `${file} is stale; run npm run docs:generate`)
    else {
      fs.mkdirSync(path.dirname(file), { recursive: true })
      fs.writeFileSync(file, content)
    }
  }
  return outputs
}

if (require.main === module) {
  const options = {}
  const args = process.argv.slice(2)
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--check') options.check = true
    else if (args[i] === '--firmware' && args[i + 1] && !options.firmware) options.firmware = args[++i]
    else throw new Error('usage: generate-docs.js [--check] [--firmware 6.5.x]')
  }
  console.log(`generated_docs\tok\t${generate(targets, options).size} files`)
}

module.exports = { renderTarget, generate, validateTargets, sizeOf, graph }
