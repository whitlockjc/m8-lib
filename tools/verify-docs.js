#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const YAML = require('yaml')

const checks = [
  ['docs/FX_COMMANDS.md', 'Sequencer', 'schemas/file-versions/6.5.0/song/sequencing.ksy', 'phrase_fx_command', false],
  ['docs/FX_COMMANDS.md', 'Mixer & Effects', 'schemas/file-versions/6.5.0/song/sequencing.ksy', 'phrase_fx_command', false],
  ['docs/SONG.md', 'MIDI Sync Transport', 'schemas/file-versions/6.5.0/song/project.ksy', 'midi_sync_transport', true],
  ['docs/SONG.md', 'Record Delay/Kill', 'schemas/file-versions/6.5.0/song/project.ksy', 'record_delay_kill', true],
  ['docs/SONG.md', 'MIDI Input Mode', 'schemas/file-versions/6.5.0/song/project.ksy', 'midi_input_mode', true],
  ['docs/SONG.md', 'DJ Filter Type', 'schemas/file-versions/6.5.0/song/mixer_effects.ksy', 'dj_filter_type', true],
  ['docs/SONG.md', 'Mod FX Type', 'schemas/file-versions/6.5.0/song/mixer_effects.ksy', 'mod_fx_type', true],
  ['docs/SONG.md', 'EQ Filter Type', 'schemas/file-versions/6.5.0/song/eq.ksy', 'eq_filter_type', true],
  ['docs/SONG.md', 'EQ Filter Mode', 'schemas/file-versions/6.5.0/song/eq.ksy', 'eq_filter_mode', true],
  ['docs/SONG.md', 'MIDI Mapping Destination Type', 'schemas/file-versions/6.5.0/song/midi_mapping.ksy', 'midi_mapping_destination_type', true]
]

function schema (path) {
  return YAML.parse(fs.readFileSync(path, 'utf8'))
}

function sectionRows (file, heading) {
  const lines = fs.readFileSync(file, 'utf8').split(/\r?\n/)
  const start = lines.indexOf(heading)
  assert.notEqual(start, -1, `${file}: missing ${heading}`)
  const rows = []
  for (const line of lines.slice(start + 1)) {
    if (line.startsWith('#')) break
    if (!line.startsWith('|')) continue
    rows.push(line.split('|').slice(1, -1).map(cell => cell.trim().replaceAll('`', '')))
  }
  return rows
}

for (const [doc, heading, schemaPath, enumName, complete] of checks) {
  const entries = schema(schemaPath).enums[enumName]
  assert.ok(entries, `${schemaPath}: missing ${enumName}`)
  const rows = sectionRows(doc, `### ${heading}`)
    .filter(([value]) => /^0x[\da-f]+$/i.test(value))
  assert.ok(rows.length, `${doc}: no hex-valued rows in ${heading}`)
  const seen = new Set()

  for (const [stored, label] of rows) {
    const value = Number.parseInt(stored, 16)
    assert.ok(!seen.has(value), `${doc} ${heading}: duplicate ${stored}`)
    seen.add(value)
    assert.equal(label, entries[value]?.['-label'], `${doc} ${heading}: ${stored}`)
  }
  if (complete) {
    assert.deepEqual([...seen].sort((a, b) => a - b),
      Object.keys(entries).map(Number).sort((a, b) => a - b),
      `${doc} ${heading}: incomplete enum table`)
  }
}

const theme = schema('schemas/file-versions/1.0.2/theme.ksy')
const colorSize = theme.types.color.seq.reduce((size, component) => {
  assert.equal(component.type, 'u1', 'Theme color component type')
  return size + 1
}, 0)
const layout = sectionRows('docs/THEME.md', '## Layout')
  .filter(([, range]) => /^0x[\da-f]+\.\.0x[\da-f]+$/i.test(range))
  .map(([name, range, size]) => [name, range, Number(size)])
const expectedLayout = [['M8 File Header', '0x00..0x0d', 14]]
theme.seq.forEach((field, index) => {
  assert.equal(field.type, 'color', `Theme field ${field.id} type`)
  const name = field.id.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase())
  const from = 14 + index * colorSize
  const to = from + colorSize - 1
  expectedLayout.push([name, `0x${from.toString(16).padStart(2, '0')}..0x${to.toString(16).padStart(2, '0')}`, colorSize])
})
assert.deepEqual(layout, expectedLayout, 'docs/THEME.md Layout differs from Theme schema')

console.log(`documented_enums\tok\t${checks.length} tables`)
console.log('documented_layouts\tok\tTheme')
