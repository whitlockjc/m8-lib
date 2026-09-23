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

function parse (fixture) {
  const bytes = fs.readFileSync(fixture)
  return { bytes, file: new File65X(new KaitaiStream(bytes)) }
}

for (const name of ['NONE', 'WAV', 'MAC', 'SAM', 'MID', 'FM', 'HYP', 'EXT']) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_DEFAULT.m8i`)
  const instrument = file.body.instrument
  const settings = instrument.generalSettings

  assert.equal(settings.type, bytes[0x0e], `${name} type`)
  assert.deepEqual(Buffer.from(settings.name), bytes.subarray(0x0f, 0x1b), `${name} name`)
  assert.equal(settings.transpose, bytes[0x1b], `${name} transpose`)
  assert.equal(settings.tableTic, bytes[0x1c], `${name} table TIC`)
  assert.equal(instrument.eq, bytes[0x4c], `${name} EQ assignment`)
  assert.equal(file.body.table.rows.length, 16, `${name} table rows`)
  assert.equal(file.body.table.rows[0].fx.length, 3, `${name} table FX slots`)
}

for (const name of ['WAV', 'MAC', 'SAM', 'MID', 'FM', 'HYP', 'EXT']) {
  for (const variant of ['A', 'B']) {
    const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_MODS_${variant}.m8i`)
    const slots = file.body.instrument.tail.modulators.slots
    assert.equal(slots.length, 4, `${name} modulation slots`)

    for (const [index, slot] of slots.entries()) {
      const offset = 0x4d + index * 6
      assert.equal(slot.typeAndDestination, bytes[offset], `${name} mod ${index} type/destination`)
      assert.equal(slot.amount, bytes[offset + 1], `${name} mod ${index} amount`)
      assert.equal(slot.modulationType, bytes[offset] >> 4, `${name} mod ${index} type`)
      assert.equal(slot.destination, bytes[offset] & 0x0f, `${name} mod ${index} destination`)
    }
  }
}

for (const [name, playMode] of [['SAM', 0x08], ['SAMS', 0x0b], ['SAMB', 0x0e]]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const params = file.body.instrument.bodyBeforeEq.controls
  assert.equal(params.modeValue, bytes[0x1f], `${name} mode value`)
  assert.equal(params.playMode, playMode, `${name} play mode`)
  assert.deepEqual(
    [params.slice, params.start, params.loopStart, params.length, params.degrade],
    [...bytes.subarray(0x21, 0x26)], `${name} Sampler parameters`
  )
}

{
  const { bytes, file } = parse('fixtures/6.5.x/instruments/SAM_PARAMS.m8i')
  const pathBytes = Buffer.from(file.body.instrument.tail.samplePath)
  assert.equal(pathBytes.length, 128)
  assert.deepEqual(pathBytes, bytes.subarray(0x65, 0xe5))
  assert.equal(pathBytes.subarray(0, 17).toString('utf8'), '/Samples/Kick.wav')
  assert.ok(pathBytes.subarray(17).every(byte => byte === 0))
}

for (const [name, firstOffset, count] of [['MID', 0x26, 10], ['EXT', 0x25, 4]]) {
  const { bytes, file } = parse(`fixtures/6.5.x/instruments/${name}_PARAMS.m8i`)
  const entries = file.body.instrument.bodyBeforeEq.params.customCcs
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
  const filter = file.body.instrument.bodyBeforeEq.filter
  assert.deepEqual([filter.type, filter.cutoff, filter.resonance],
    [...bytes.subarray(offset, offset + 3)], `${name} filter layout`)
  assert.equal(filter.type, expectedType, `${name} filter type`)
}

{
  const { file } = parse('fixtures/6.5.x/instruments/HYP_PARAMS.m8i')
  const instrument = file.body.instrument
  const current = instrument.bodyBeforeEq.params.currentChord
  const stored = instrument.tail.chords[current.index]
  assert.equal(instrument.tail.chords.length, 16)
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
