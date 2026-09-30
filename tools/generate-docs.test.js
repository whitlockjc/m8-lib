const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const test = require('node:test')
const YAML = require('yaml')
const { load } = require('./ksy-layout')
const { renderTarget, generate, validateTargets, sizeOf, graph } = require('./generate-docs')
const { verifyLinks } = require('./verify-docs')
const targets = require('./doc-targets.json')
const target = targets['6.5.x']
const rendered = renderTarget('6.5.x', target)
const page = suffix => [...rendered].find(([file]) => file.endsWith(suffix))[1]

test('all generated pages are deterministic and up to date', () => {
  assert.deepEqual(renderTarget('6.5.x', target), rendered)
  assert.ok(generate(undefined, { check: true }).size >= 15)
})

test('schema descriptions contain data semantics, not research status', () => {
  const provenance = /\b(fixture|fixtures|verif(?:ied|ication|y)|observed|historical|research|evidence|not yet)\b|m8-js/i
  const seen = new Set()
  const visit = (value, location) => {
    if (!value || typeof value !== 'object') return
    for (const [key, child] of Object.entries(value)) {
      const next = `${location}.${key}`
      if (key === 'doc' && typeof child === 'string') {
        assert.doesNotMatch(child, provenance, next)
      } else {
        visit(child, next)
      }
    }
  }
  for (const target of Object.values(targets)) {
    for (const context of graph(load(target.entry))) {
      if (seen.has(context.file)) continue
      seen.add(context.file)
      visit(context.data, context.file)
    }
  }
})

test('every reachable type, instance, and enum is documented', () => {
  for (const context of graph(load(target.entry))) {
    const suffix = path.relative('schemas', context.file).replace(/\.ksy$/, '.md')
    const source = page(suffix)
    const definitions = [context.data, ...Object.values(context.data.types || {})]
    for (const name of Object.keys(context.data.types || {})) assert.ok(source.includes(`## Type: ${name}\n`))
    for (const definition of definitions) {
      for (const field of definition.seq || []) assert.ok(source.includes('`' + field.id + '`'))
      for (const name of Object.keys(definition.instances || {})) assert.ok(source.includes('`' + name + '`'))
    }
    for (const name of Object.keys(context.data.enums || {})) {
      if (name === 'fx_command' || name === 'instrument_mod_fx_command' || name.endsWith('_fx_command')) {
        assert.ok(!source.includes(`## Enum: ${name}\n`))
      } else assert.ok(source.includes(`## Enum: ${name}\n`))
    }
  }
})

test('adjacent unknown byte regions are represented as one field', () => {
  for (const context of graph(load(target.entry))) {
    for (const definition of [context.data, ...Object.values(context.data.types || {})]) {
      const fields = definition.seq || []
      for (let index = 1; index < fields.length; index++) {
        const isUnknown = field => /^unknown(?:_\d+)?$/.test(field.id)
        assert.ok(!(isUnknown(fields[index - 1]) && isUnknown(fields[index])),
          `${context.file}: adjacent unknown fields ${fields[index - 1].id} and ${fields[index].id}`)
      }
    }
  }
  for (const version of ['6.0.1', '6.0.2']) {
    const source = YAML.parse(fs.readFileSync(`schemas/file-versions/${version}/instrument.ksy`, 'utf8'))
    assert.deepEqual(source.types.wavsynth_body.seq.slice(0, 1), [{ id: 'unknown_0', size: 3 }])
    assert.deepEqual(source.types.data.seq.map(field => field.id), ['general_settings', 'body'])
    assert.deepEqual(source.types.none_body.seq, [{ id: 'unknown', size: 200 }])
    for (const name of ['wavsynth', 'macrosynth', 'sampler', 'midi_out', 'fm_synth', 'hypersynth', 'external']) {
      const fields = source.types[`${name}_body`].seq
      assert.equal(fields.filter(field => field.id === 'eq').length, 1, `${version} ${name} EQ`)
    }
  }
})

test('absolute file offsets and relative repeated layouts are correct', () => {
  assert.match(page('/6.5.x.md'), /`background` \| `0x0e\.\.0x10/)
  assert.match(page('/6.5.x.md'), /Header: 14 bytes\. Body: 46 bytes/)
  assert.match(page('/6.5.x.md'), /Header: 14 bytes\. Body: 343 bytes/)
  assert.match(page('/6.5.x.md'), /`instruments` \| `0x13a3e\.\.0x1a5bd/)
  assert.match(page('/6.5.x.md'), /`unknown_2` \| `0x1b6a6 onward` \| variable/)
  assert.match(page('/6.5.x.md'), /`repeat`: `256` via `entries`/)
  assert.match(page('/6.5.x.md'), /## Instrument/)
  assert.match(page('/instrument/table.md'), /`fx` \| `0x02\.\.0x07` \| 6/)
})

test('firmware indexes summarize fields without repeating linked type details or research links', () => {
  for (const firmware of ['6.5.x', '6.6.x']) {
    const source = renderTarget(firmware, targets[firmware]).get(path.resolve(`docs/${firmware}.md`))
    assert.match(source, /\[data\]\(file-versions\/6\.0\.[12]\/instrument\.md#type-data\)/)
    assert.match(source, /\| `background` \|[^\n]*Background color\./)
    assert.match(source, /\| `tuning_offset` \|[^\n]*Tuning offset in Hz from A440, stored as a 32-bit float\./)
    assert.doesNotMatch(source, /instrument_data|Fixture observations and research history/)
    assert.doesNotMatch(source, /The encoded version appears|The M8 manual groups general_settings|FX slots can use/)
  }
})

test('dynamic strings, switches, processing expressions, and raw labels survive', () => {
  assert.match(page('/instrument/sampler.md'), /_io.size - _io.pos/)
  assert.match(page('/6.0.1/instrument.md'), /switch on/)
  assert.match(page('/instrument/modulation.md'), /type_and_destination & 0x0f/)
  assert.match(page('/instrument/fm_synth.md'), /A&gt;B&gt;C&gt;D/)
  assert.match(page('/song/eq.md'), /type_and_mode >> 5/)
  assert.match(page('/common/file_header.md'), /schema_version_patch/)
})

test('FX values are shared while firmware catalogs agree and linked from phrase and table references', () => {
  const catalog = page('/common/fx_commands.md')
  for (const firmware of ['6.5.x', '6.6.x']) {
    const pages = renderTarget(firmware, targets[firmware])
    assert.equal(pages.get(path.resolve('docs/common/fx_commands.md')), catalog)
    for (const heading of ['Instrument (Current Instrument)', 'Instrument Mods', 'Mixer & Effects', 'Sequencer']) {
      assert.ok(catalog.includes(`## ${heading}\n`))
    }
    assert.match(catalog, /\| `0x00` \| ARP \|/)
    assert.match(catalog, /\| `0x1b` \| VMV \|/)
    assert.match(catalog, /\| `0x83` \| OSC \|/)
    assert.match(catalog, /\| `0x92` \| `EA1` \| `EA1` \| `EA1` \| `LA1` \| `EA1` \| `TA1` \|/)
    assert.match(catalog, /\| `0x97` \| `EA2` \| `EA2` \| `EA2` \| `LA2` \| `EA2` \| `TA2` \|/)
    assert.match(catalog, /\| `0xa5` \| `ET4` \| `ET4` \| `ET4` \| `LT4` \| `ET4` \| `TX4` \|/)
    assert.match(pages.get(path.resolve('docs', `${firmware}.md`)), /\[command reference\]\(common\/fx_commands\.md\)/)
  }
  for (const suffix of ['/instrument/table.md', '/song/sequencing.md']) {
    const source = page(suffix)
    assert.match(source, /\[FX command reference\]\([^)]*common\/fx_commands\.md\)/)
    assert.doesNotMatch(source, /\| `0x83` \| OSC \|/)
    assert.doesNotMatch(source, /^## Enum: .*fx_command$/m)
  }
})

test('all generated cross-links resolve, including type and enum anchors', () => {
  assert.ok(verifyLinks(rendered) > 100)
  assert.throws(() => verifyLinks(new Map([[path.resolve('docs/bad.md'), '[bad](missing.md)']])), /broken link/)
})

test('generated contents links are local anchors to rendered headings', () => {
  let checked = 0
  for (const [file, source] of rendered) {
    const contents = source.split('## Contents\n')[1]?.split('\n## ')[0]
    if (!contents) continue
    for (const [, href] of contents.matchAll(/^- \[[^\]\n]+\]\(([^)]+)\)$/gm)) {
      assert.match(href, /^#[a-z0-9_-]+$/, `${file}: ${href}`)
      checked++
    }
  }
  assert.ok(checked > 20)
  verifyLinks(rendered)
})

test('unknown length and unequal-size switch never yield fabricated offsets', () => {
  const context = load(target.entry)
  assert.equal(sizeOf({ type: { 'switch-on': 'x', cases: { 0: 'u1', 1: 'u2' } } }, context), null)
  assert.equal(sizeOf({ type: 'strz' }, context), null)
  assert.equal(sizeOf({ type: 'u1', if: 'x' }, context), null)
  assert.throws(() => sizeOf({ type: 'missing_type' }, context), /cannot resolve/)
})

test('reused components are independent of firmware provenance', () => {
  const next = { ...target, verifiedFirmware: '6.6.0', research: {} }
  const outputs = renderTarget('6.6.x', next)
  for (const [file, content] of outputs) {
    if (file.endsWith('/6.5.x.md')) continue
    assert.equal(content, rendered.get(file))
    assert.ok(!content.includes('Verified release:'))
  }
  verifyLinks(outputs)
  assert.deepEqual(renderTarget('6.5.x', target), rendered)
  assert.throws(() => validateTargets({ '6.6.x': next }), /entry must/)
  assert.throws(() => generate(undefined, { firmware: '6.7.x' }), /unsupported firmware/)
})

test('a new firmware entry can replace a component without modifying the earlier reference', () => {
  const directory = fs.mkdtempSync(path.resolve('schemas/doc-test-'))
  try {
    const entry = YAML.parse(fs.readFileSync(target.entry, 'utf8'))
    const theme = YAML.parse(fs.readFileSync('schemas/file-versions/1.0.2/theme.ksy', 'utf8'))
    theme.seq.push({ id: 'test_extra_byte', type: 'u1' })
    fs.writeFileSync(path.join(directory, 'theme.ksy'), YAML.stringify(theme))
    entry.meta.imports = entry.meta.imports.map(name => name.endsWith('/theme') ? 'theme' : `../${name}`)
    fs.writeFileSync(path.join(directory, 'entry.ksy'), YAML.stringify(entry))
    const next = { ...target, entry: path.join(directory, 'entry.ksy'), output: 'docs/6.6.x', verifiedFirmware: '6.6.0', research: {} }
    const result = renderTarget('6.6.x', next)
    assert.match(result.get(path.resolve('docs', path.basename(directory), 'entry.md')), /test_extra_byte/)
    assert.ok(!page('/6.5.x.md').includes('test_extra_byte'))
    verifyLinks(result)
    assert.deepEqual(renderTarget('6.5.x', target), rendered)
  } finally {
    fs.rmSync(directory, { recursive: true, force: true })
  }
})
