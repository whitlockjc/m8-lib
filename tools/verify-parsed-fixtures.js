#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const KaitaiStream = require('kaitai-struct/KaitaiStream')

const compiledDir = process.argv[2]
if (!compiledDir) {
  throw new Error('usage: node tools/verify-parsed-fixtures.js <compiled-schema-dir>')
}

const { File65X } = require(path.resolve(compiledDir, 'File65X.js'))
const { Wavsynth601 } = require(path.resolve(compiledDir, 'Wavsynth601.js'))
const { Macrosynth601 } = require(path.resolve(compiledDir, 'Macrosynth601.js'))
const { Sampler601 } = require(path.resolve(compiledDir, 'Sampler601.js'))
const { MidiOut601 } = require(path.resolve(compiledDir, 'MidiOut601.js'))
const { FmSynth601 } = require(path.resolve(compiledDir, 'FmSynth601.js'))
const { Hypersynth601 } = require(path.resolve(compiledDir, 'Hypersynth601.js'))
const { External601 } = require(path.resolve(compiledDir, 'External601.js'))
const { None601 } = require(path.resolve(compiledDir, 'None601.js'))
const { Sequencing650 } = require(path.resolve(compiledDir, 'Sequencing650.js'))
const { Project650 } = require(path.resolve(compiledDir, 'Project650.js'))
const { MixerEffects650 } = require(path.resolve(compiledDir, 'MixerEffects650.js'))
const { MidiMapping650 } = require(path.resolve(compiledDir, 'MidiMapping650.js'))

function parse (fixture) {
  const bytes = fs.readFileSync(fixture)
  return { bytes, file: new File65X(new KaitaiStream(bytes)) }
}

function verifyTable (table, bytes, offset, label) {
  assert.equal(table.rows.length, 16, `${label} row count`)
  for (const [index, row] of table.rows.entries()) {
    const rowOffset = offset + index * 8
    assert.equal(row.transpose, bytes[rowOffset], `${label} row ${index} transpose`)
    assert.equal(row.volume, bytes[rowOffset + 1], `${label} row ${index} volume`)
    assert.equal(row.fx.length, 3, `${label} row ${index} FX count`)
    for (const [slotIndex, slot] of row.fx.entries()) {
      const slotOffset = rowOffset + 2 + slotIndex * 2
      assert.deepEqual([slot.command, slot.value],
        [...bytes.subarray(slotOffset, slotOffset + 2)],
        `${label} row ${index} FX ${slotIndex}`)
    }
  }
}

for (const [catalog, expected] of [
  [Wavsynth601.FxCommand, 'OSCILLATOR'],
  [Macrosynth601.FxCommand, 'OSCILLATOR'],
  [Sampler601.FxCommand, 'PLAY'],
  [FmSynth601.FxCommand, 'ALGORITHM'],
  [MidiOut601.FxCommand, 'MIDI_PROGRAM_BANK'],
  [Hypersynth601.FxCommand, 'CHORD'],
  [External601.FxCommand, 'MIDI_PROGRAM']
]) {
  assert.equal(catalog[0x80], 'VOLUME')
  assert.equal(catalog[0x83], expected)
  assert.equal(catalog[0xff], 'UNSET')
}
assert.equal(None601.FxCommand[0xff], 'UNSET')
assert.equal(Sequencing650.FxCommand[0x4d], 'MICRO_TIME')
assert.equal(Sequencing650.FxCommand[0xff], 'UNSET')
assert.equal(Project650.SyncTransport[0x02], 'TRANSPORT_SPP')
assert.equal(Project650.RecordDelayKill[0x03], 'BOTH')
assert.equal(Project650.InputMode[0x02], 'POLY')
assert.equal(MixerEffects650.ModFxType[0x02], 'FLANGER')
assert.equal(MixerEffects650.DjFilterType[0x02], 'BANDPASS_HIGHPASS')
assert.equal(MidiMapping650.DestinationType[0x05], 'INSTRUMENT')
assert.equal(MidiMapping650.DestinationType[0x19], 'EQ')

for (const name of ['NONE', 'WAV', 'MAC', 'SAM', 'MID', 'FM', 'HYP', 'EXT']) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_DEFAULT.m8i`)
  const instrument = file.body.instrument
  const settings = instrument.generalSettings

  assert.equal(settings.type, bytes[0x0e], `${name} type`)
  assert.deepEqual(Buffer.from(settings.name), bytes.subarray(0x0f, 0x1b), `${name} name`)
  assert.equal(settings.transpose, bytes[0x1b], `${name} transpose`)
  assert.equal(settings.tableTic, bytes[0x1c], `${name} table TIC`)
  assert.equal(instrument.body.eq, bytes[0x4c], `${name} EQ assignment`)
  assert.equal(file.body.table.rows.length, 16, `${name} table rows`)
  assert.equal(file.body.table.rows[0].fx.length, 3, `${name} table FX slots`)
}

const instrumentFixtures = fs.readdirSync('fixtures/6.5.x/instruments')
  .filter(name => name.endsWith('.m8i'))
const chordNoteFields = ['note1', 'note2', 'note3', 'note4', 'note5', 'note6']
for (const fixture of instrumentFixtures) {
  const name = fixture.split('_')[0]
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${fixture}`)
  const body = file.body.instrument.body
  const table = file.body.table

  assert.equal(bytes.length, 0x165, `${fixture} standalone length`)
  verifyTable(table, bytes, 0xe5, fixture)
  if (name === 'NONE') {
    assert.deepEqual(Buffer.from(body.unknown1), bytes.subarray(0x4d, 0xe5), `${fixture} NONE tail`)
  } else {
    assert.equal(body.modulators.slots.length, 4, `${fixture} modulator boundary`)
    if (name === 'SAM' || name === 'SAMS' || name === 'SAMB') {
      const region = bytes.subarray(0x65, 0xe5)
      const terminator = region.indexOf(0)
      assert.notEqual(terminator, -1, `${fixture} sample path terminator`)
      assert.equal(body.samplePath.path, region.subarray(0, terminator).toString('ascii'),
        `${fixture} sample path text`)
      assert.deepEqual(Buffer.from(body.samplePath.trailing), region.subarray(terminator + 1),
        `${fixture} sample path`)
    } else if (name === 'HYP') {
      assert.equal(body.chords.length, 16, `${fixture} chord count`)
      for (const [index, chord] of body.chords.entries()) {
        const offset = 0x65 + index * 7
        assert.equal(chord.enabledNotes, bytes[offset], `${fixture} chord ${index} mask`)
        assert.deepEqual(chordNoteFields.map(field => chord.notes[field]),
          [...bytes.subarray(offset + 1, offset + 7)],
          `${fixture} chord ${index} notes`)
      }
      assert.deepEqual(Buffer.from(body.unknown2), bytes.subarray(0xd5, 0xe5),
        `${fixture} unknown after chords`)
    } else {
      assert.deepEqual(Buffer.from(body[name === 'MID' ? 'unknown1' : 'unknown2']), bytes.subarray(0x65, 0xe5),
        `${fixture} unknown after modulators`)
    }
  }
}

{
  const { bytes, file } = parse('fixtures/6.5.x/songs/INSTRUMENTS.m8s')
  assert.equal(file.body.instruments.entries.length, 128, 'Song instrument count')
  for (const [index, name] of [[0, 'WAV'], [127, 'HYP']]) {
    const standalone = parse(`fixtures/6.5.x/instruments/${name}_DEFAULT.m8i`)
    const embedded = file.body.instruments.entries[index]
    const offset = 0x13a3e + index * 215
    assert.equal(embedded.generalSettings.type, standalone.file.body.instrument.generalSettings.type)
    assert.equal(embedded.body.eq, standalone.file.body.instrument.body.eq)
    assert.deepEqual(bytes.subarray(offset, offset + 1), standalone.bytes.subarray(0x0e, 0x0f))
    assert.deepEqual(bytes.subarray(offset + 13, offset + 215),
      standalone.bytes.subarray(0x1b, 0xe5), `${name} embedded record except name`)
  }
}

{
  const song = parse('fixtures/6.5.x/songs/DEFAULT.m8s')
  const standalone = parse('fixtures/6.5.x/scales/CHROMATIC_DEFAULT.m8n')
  const embedded = song.file.body.scales.entries[0]
  const scale = standalone.file.body
  assert.equal(embedded.enabledNotes, scale.enabledNotes)
  assert.equal(embedded.tuningOffset, scale.tuningOffset)
  assert.deepEqual(Buffer.from(embedded.name), Buffer.from(scale.name))
  assert.deepEqual(song.bytes.subarray(0x1aa7e, 0x1aa7e + 46),
    standalone.bytes.subarray(14, 60), 'embedded Scale body')
}

{
  const { bytes, file } = parse('fixtures/6.5.x/songs/TABLES.m8s')
  const tables = file.body.tables.entries
  assert.equal(tables.length, 256, 'Song table count')
  for (const [index, table] of tables.entries()) {
    verifyTable(table, bytes, 0xba3e + index * 128, `Song table ${index}`)
  }
  for (const [tableIndex, rowIndex, expected] of [
    [0, 0, [0xff, 0x7f, 0x00, 0xfe, 0x45, 0xfd, 0x01, 0xfc]],
    [0, 15, [0xfb, 0x7e, 0x1b, 0xfa, 0x2a, 0xf9, 0x2b, 0xf8]],
    [255, 0, [0xff, 0x7f, 0x4d, 0xfe, 0x1a, 0xfd, 0x05, 0xfc]],
    [255, 15, [0xfb, 0x7e, 0x4c, 0xfa, 0x4b, 0xf9, 0x4a, 0xf8]]
  ]) {
    const row = tables[tableIndex].rows[rowIndex]
    assert.deepEqual([row.transpose, row.volume, ...row.fx.flatMap(slot => [slot.command, slot.value])],
      expected, `Song table ${tableIndex} row ${rowIndex} fixture values`)
  }
}

const modulationFields = [
  ['attack', 'hold', 'decay', 'unknown'],
  ['attack', 'decay', 'sustain', 'release'],
  ['peak', 'body', 'decay', 'unknown'],
  ['oscillator', 'trigger', 'frequency', 'unknown'],
  ['attack', 'hold', 'decay', 'source'],
  ['source', 'lowestValue', 'highestValue', 'unknown']
]
const observedModulationTypes = new Set()
const destinationCatalogs = {
  WAV: [Wavsynth601.Destination, 0x0b],
  MAC: [Macrosynth601.Destination, 0x0b],
  SAM: [Sampler601.Destination, 0x0a],
  MID: [MidiOut601.Destination, 0x0b],
  FM: [FmSynth601.Destination, 0x0b],
  HYP: [Hypersynth601.Destination, 0x0b],
  EXT: [External601.Destination, 0x0a]
}
const modulationDestinationLabels = ['MOD_AMOUNT', 'MOD_RATE', 'MOD_BOTH', 'MOD_BINV']
const observedDestinations = new Map()

for (const name of ['WAV', 'MAC', 'SAM', 'MID', 'FM', 'HYP', 'EXT']) {
  const [catalog, firstModDestination] = destinationCatalogs[name]
  const observed = new Set()
  for (const variant of ['A', 'B']) {
    const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_MODS_${variant}.m8i`)
    const slots = file.body.instrument.body.modulators.slots
    assert.equal(slots.length, 4, `${name} modulation slots`)

    for (const [index, slot] of slots.entries()) {
      const offset = 0x4d + index * 6
      assert.equal(slot.typeAndDestination, bytes[offset], `${name} mod ${index} type/destination`)
      assert.equal(slot.amount, bytes[offset + 1], `${name} mod ${index} amount`)
      assert.equal(slot.modulationType, bytes[offset] >> 4, `${name} mod ${index} type`)
      assert.equal(slot.destination, bytes[offset] & 0x0f, `${name} mod ${index} destination`)
      if (slot.destination >= firstModDestination) {
        const label = modulationDestinationLabels[slot.destination - firstModDestination]
        assert.ok(label, `${name} mod ${index} known high destination`)
        assert.equal(catalog[slot.destination], label,
          `${name} mod ${index} contextual destination label`)
        observed.add(slot.destination)
      }
      const fields = modulationFields[slot.modulationType]
      assert.ok(fields, `${name} mod ${index} known modulation type`)
      assert.deepEqual(fields.map(field => slot.params[field]),
        [...bytes.subarray(offset + 2, offset + 6)],
        `${name} mod ${index} type-specific payload`)
      observedModulationTypes.add(slot.modulationType)
    }
  }
  observedDestinations.set(name, observed)
}
assert.deepEqual([...observedModulationTypes].sort(), [0, 1, 2, 3, 4, 5])
for (const [name, [, firstModDestination]] of Object.entries(destinationCatalogs)) {
  assert.deepEqual([...observedDestinations.get(name)].sort(),
    [0, 1, 2, 3].map(index => firstModDestination + index),
    `${name} high destinations covered by fixtures`)
}
assert.equal(Wavsynth601.Destination[0x03], 'SIZE')
assert.equal(Macrosynth601.Destination[0x03], 'TIMBRE')
assert.equal(MidiOut601.Destination[0x03], 'CC_C')

{
  const { bytes, file } = parse('fixtures/6.5.x/instruments/NONE_DEFAULT.m8i')
  assert.equal(file.body.instrument.body.modulators, undefined)
  assert.deepEqual(Buffer.from(file.body.instrument.body.unknown1),
    bytes.subarray(0x4d, 0xe5))
}

for (const [name, playMode] of [['SAM', 0x08], ['SAMS', 0x0b], ['SAMB', 0x0e]]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const params = file.body.instrument.body.params
  assert.equal(params.modeValue, bytes[0x1f], `${name} mode value`)
  assert.equal(params.playMode, playMode, `${name} play mode`)
  assert.deepEqual(
    [params.slice, params.start, params.loopStart, params.length, params.degrade],
    [...bytes.subarray(0x21, 0x26)], `${name} Sampler parameters`
  )
}

{
  const { file } = parse('fixtures/6.5.x/instruments/SAM_PARAMS.m8i')
  const samplePath = file.body.instrument.body.samplePath
  assert.equal(samplePath.path, '/Samples/Kick.wav')
  assert.equal(samplePath.trailing.length, 110)
  assert.ok(Buffer.from(samplePath.trailing).every(byte => byte === 0))
}

for (const [name, firstOffset, count] of [['MID', 0x26, 10], ['EXT', 0x25, 4]]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const entries = file.body.instrument.body.params.customCcs
  assert.equal(entries.length, count, `${name} custom CC count`)
  for (const [index, entry] of entries.entries()) {
    assert.deepEqual([entry.cc, entry.value],
      [...bytes.subarray(firstOffset + index * 2, firstOffset + index * 2 + 2)],
      `${name} custom CC ${index}`)
  }
}

for (const [name, offset, expectedType] of [
  ['WAV', 0x25, 0x0b], ['MAC', 0x25, 0x07], ['SAM', 0x26, 0x07],
  ['FM', 0x41, 0x07], ['HYP', 0x2c, 0x07], ['EXT', 0x2d, 0x07]
]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const filter = file.body.instrument.body.filter
  assert.deepEqual([filter.type, filter.cutoff, filter.resonance],
    [...bytes.subarray(offset, offset + 3)], `${name} filter layout`)
  assert.equal(filter.type, expectedType, `${name} filter type`)
}

for (const [name, offset, expectedAmp, expectedPan] of [
  ['WAV', 0x28, 0xf9, 0xf8], ['MAC', 0x28, 0xf9, 0xf8],
  ['SAM', 0x29, 0xf8, 0xf7], ['FM', 0x44, 0xf1, 0xf0],
  ['HYP', 0x2f, 0xf3, 0xf2], ['EXT', 0x30, 0xfc, 0xfb]
]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const amp = file.body.instrument.body.amp
  assert.deepEqual([amp.amp, amp.limit, amp.pan],
    [...bytes.subarray(offset, offset + 3)], `${name} amplifier layout`)
  assert.deepEqual([amp.amp, amp.limit, amp.pan],
    [expectedAmp, 0x08, expectedPan], `${name} amplifier values`)
}

for (const [name, offset, expected] of [
  ['WAV', 0x2b, [0xf7, 0xf6, 0xf5, 0xf4]],
  ['MAC', 0x2b, [0xf7, 0xf6, 0xf5, 0xf4]],
  ['SAM', 0x2c, [0xf6, 0xf5, 0xf4, 0xf3]],
  ['FM', 0x47, [0xef, 0xee, 0xed, 0xec]],
  ['HYP', 0x32, [0xf1, 0xf0, 0xef, 0xee]],
  ['EXT', 0x33, [0xfa, 0xf9, 0xf8, 0xf7]]
]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const mixer = file.body.instrument.body.mixer
  const values = [mixer.dry, mixer.modFx, mixer.delay, mixer.reverb]
  assert.deepEqual(values, [...bytes.subarray(offset, offset + 4)],
    `${name} instrument mixer layout`)
  assert.deepEqual(values, expected, `${name} instrument mixer values`)
}

{
  const { file } = parse('fixtures/6.5.x/instruments/HYP_PARAMS.m8i')
  const instrument = file.body.instrument
  const current = instrument.body.params.currentChord
  const stored = instrument.body.chords[current.index]
  assert.equal(instrument.body.chords.length, 16)
  assert.equal(instrument.body.chords[0].enabledNotes, 0xfe)
  assert.deepEqual(chordNoteFields.map(field => instrument.body.chords[0].notes[field]),
    [0x00, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa])
  assert.equal(instrument.body.chords[15].enabledNotes, 0xdf)
  assert.deepEqual(chordNoteFields.map(field => instrument.body.chords[15].notes[field]),
    [0x01, 0x02, 0x03, 0x04, 0x05, 0x00])
  for (const note of ['note1', 'note2', 'note3', 'note4', 'note5', 'note6']) {
    assert.equal(current.notes[note], stored.notes[note], `Hypersynth current ${note}`)
  }
}

{
  const { bytes, file } = parse('fixtures/6.5.x/instruments/WAV_TABLE.m8i')
  const row = file.body.table.rows[0]
  assert.deepEqual(row.fx.map(({ command, value }) => [command, value]),
    [[0x80, 0x01], [0x81, 0x02], [0x82, 0x03]])
  assert.equal(row.fx[0].command, bytes[0xe7])
  assert.equal(row.fx[0].value, bytes[0xe8])
}

{
  const { file } = parse('fixtures/6.5.x/songs/PHRASES.m8s')
  const step = file.body.phrases.entries[0].steps[0]
  assert.deepEqual(step.fx.map(({ command, value }) => [command, value]),
    [[0x00, 0xff], [0x45, 0xfe], [0x01, 0xfd]])
}

{
  const { file } = parse('fixtures/6.5.x/songs/MIDI_MAPPING.m8s')
  assert.equal(file.body.midiMappings.entries.length, 128)
  assert.equal(file.body.midiMappings.entries[0].channel, 1)
}

{
  const { file } = parse('fixtures/6.5.x/songs/SONG_ROWS.m8s')
  assert.deepEqual(file.body.rows.entries[0].tracks, [1, 2, 3, 4, 5, 6, 7, 8])
  assert.deepEqual(file.body.rows.entries[255].tracks,
    [0xf7, 0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe])
}

{
  const { bytes, file } = parse('fixtures/6.5.x/songs/SCALES.m8s')
  const first = file.body.scales.entries[0]
  const last = file.body.scales.entries[15]
  assert.equal(file.body.scales.entries.length, 16)
  assert.equal(first.enabledNotes, bytes.readUInt16LE(0x1aa7e))
  assert.equal(first.intervals[0].offset, bytes.readInt16LE(0x1aa80))
  assert.deepEqual(Buffer.from(first.name), bytes.subarray(0x1aa98, 0x1aaa8))
  assert.equal(first.tuningOffset, bytes.readFloatLE(0x1aaa8))
  assert.equal(last.enabledNotes, bytes.readUInt16LE(0x1ad30))
}

console.log('parsed_fixtures\tok')
