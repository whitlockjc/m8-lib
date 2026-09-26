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
  assert.equal(generate(undefined, { check: true }).size, 15)
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
    for (const name of Object.keys(context.data.enums || {})) assert.ok(source.includes(`## Enum: ${name}\n`))
  }
})

test('absolute file offsets and relative repeated layouts are correct', () => {
  assert.match(page('/6.5.x.md'), /`background` \| `0x0e\.\.0x10/)
  assert.match(page('/6.5.x.md'), /Header: 14 bytes\. Body: 46 bytes/)
  assert.match(page('/6.5.x.md'), /Header: 14 bytes\. Body: 343 bytes/)
  assert.match(page('/6.5.x.md'), /`instruments` \| `0x13a3e\.\.0x1a5bd/)
  assert.match(page('/6.5.x.md'), /`unknown_after_reverb_eq` \| `0x1b6a6 onward` \| variable/)
  assert.match(page('/instrument/table.md'), /`fx` \| `0x02\.\.0x07` \| 6/)
})

test('dynamic strings, switches, processing expressions, and raw labels survive', () => {
  assert.match(page('/6.0.1/instrument.md'), /_io.size - _io.pos/)
  assert.match(page('/6.0.1/instrument.md'), /switch on/)
  assert.match(page('/instrument/modulation.md'), /type_and_destination & 0x0f/)
  assert.match(page('/instrument/parameters.md'), /A&gt;B&gt;C&gt;D/)
  assert.match(page('/song/eq.md'), /type_and_mode >> 5/)
  assert.match(page('/common/file_header.md'), /schema_version_patch/)
})

test('all generated cross-links resolve, including type and enum anchors', () => {
  assert.ok(verifyLinks(rendered) > 100)
  assert.throws(() => verifyLinks(new Map([[path.resolve('docs/bad.md'), '[bad](missing.md)']])), /broken link/)
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
  assert.throws(() => generate(undefined, { firmware: '6.6.x' }), /unsupported firmware/)
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
