#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const YAML = require('yaml')
const { load, sequenceLayout, resolve } = require('./ksy-layout')

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

function hexRange ({ from, size }, width = 2) {
  const first = `0x${from.toString(16).padStart(width, '0')}`
  if (size === 1) return first
  return `${first}..0x${(from + size - 1).toString(16).padStart(width, '0')}`
}

function layoutRows (doc, heading) {
  return sectionRows(doc, heading)
    .filter(([, range]) => /^0x[\da-f]+(?:\.\.0x[\da-f]+)?$/i.test(range))
    .map(([name, range, size]) => [name, range, Number(size)])
}

function row (name, field, width = 2) {
  return [name, hexRange(field, width), field.size]
}

const scale = load('schemas/file-versions/4.0.1/scale.ksy')
const scaleFields = sequenceLayout(scale.data.seq, scale, 14)
assert.deepEqual(layoutRows('docs/SCALE.md', '## Layout'), [
  ['M8 File Header', '0x00..0x0d', 14],
  ...scaleFields.map(field => row(field.id.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase()), field))
], 'docs/SCALE.md Layout differs from Scale schema')

const instrument = load('schemas/file-versions/6.0.1/instrument.ksy')
const instrumentFields = sequenceLayout(instrument.data.seq, instrument, 14)
const instrumentData = instrumentFields[0]
const [, instrumentType] = resolve(instrument, 'instrument_data')
const dataFields = sequenceLayout(instrumentType.seq, instrument, instrumentData.from)
const [, generalType] = resolve(instrument, 'general_instrument_settings')
const generalFields = sequenceLayout(generalType.seq, instrument, dataFields[0].from)
assert.deepEqual(layoutRows('docs/INSTRUMENT.md', '## Common Layout'), [
  ['M8 File Header', '0x00..0x0d', 14],
  row('instrument_data', instrumentData),
  row('general_settings', dataFields[0]),
  row('general_settings.type', generalFields[0]),
  ...generalFields.slice(1).map(field => row(field.id, field)),
  ...dataFields.slice(1).map(field => row(field.id, field)),
  row('table', instrumentFields[1])
], 'docs/INSTRUMENT.md Common Layout differs from Instrument schema')

const song = load('schemas/file-versions/6.5.0/song.ksy')
const songFields = sequenceLayout(song.data.seq.slice(0, -1), song, 14)
const lastEnd = songFields.at(-1).from + songFields.at(-1).size
const songSize = fs.statSync('fixtures/6.5.x/songs/DEFAULT.m8s').size
assert.equal(song.data.seq.at(-1).id, 'unknown_after_reverb_eq')
assert.equal(song.data.seq.at(-1)['size-eos'], true)
assert.ok(songSize > lastEnd, 'Song final field must have bytes')
songFields.push({ id: 'unknown_after_reverb_eq', from: lastEnd, size: songSize - lastEnd })
assert.deepEqual(layoutRows('docs/SONG.md', '## Layout'), [
  ['M8 File Header', '0x0000..0x000d', 14],
  ...songFields.map(field => row(field.id.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase()), field, 4))
], 'docs/SONG.md Layout differs from Song schema and default fixture size')

function relativeRange ({ from, size }) {
  const first = `+0x${from.toString(16).padStart(2, '0')}`
  if (size === 1) return first
  return `${first}..+0x${(from + size - 1).toString(16).padStart(2, '0')}`
}

function nestedLayout (doc, heading, schemaPath, typeName, expectedSize) {
  const owner = load(schemaPath)
  const [, definition] = resolve(owner, typeName)
  const fields = sequenceLayout(definition.seq, owner, 0)
  assert.equal(fields.reduce((total, field) => total + field.size, 0), expectedSize,
    `${schemaPath} ${typeName} size`)
  const expected = fields.map((field, index) => {
    const schemaField = definition.seq[index]
    let name = field.id.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase())
    if (schemaField.repeat) name += `[0..${schemaField['repeat-expr'] - 1}]`
    return [name, relativeRange(field), field.size]
  })
  const actual = sectionRows(doc, heading)
    .filter(([, range]) => /^\+0x[\da-f]+(?:\.\.\+0x[\da-f]+)?$/i.test(range))
    .map(([name, range, size]) => [name, range, Number(size)])
  assert.deepEqual(actual, expected, `${doc} ${heading} differs from ${typeName}`)
}

nestedLayout('docs/FX_COMMANDS.md', '## Storage',
  'schemas/common/fx_slot.ksy', 'fx_slot', 2)
nestedLayout('docs/INSTRUMENT.md', '### Instrument Table Row',
  'schemas/file-versions/6.0.1/instrument/table.ksy', 'table_row', 8)
nestedLayout('docs/INSTRUMENT.md', '### Modulation Slot',
  'schemas/file-versions/6.0.1/instrument/modulation.ksy', 'modulation_slot', 6)
nestedLayout('docs/SONG.md', '### EQ Band',
  'schemas/file-versions/6.5.0/song/eq.ksy', 'eq_band', 6)

console.log(`documented_enums\tok\t${checks.length} tables`)
console.log('documented_layouts\tok\tTheme, Scale, Instrument, Song')
console.log('documented_nested_layouts\tok\tFX slot, Instrument Table row, modulation slot, EQ band')
