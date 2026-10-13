#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const KaitaiStream = require('kaitai-struct/KaitaiStream')

const compiledDir = process.argv[2]
if (!compiledDir) throw new Error('usage: node tools/verify-parsed-6.6.x.js <compiled-schema-dir>')

const { File66X } = require(path.resolve(compiledDir, 'File66X.js'))
const { Hypersynth602 } = require(path.resolve(compiledDir, 'Hypersynth602.js'))
const { Song662 } = require(path.resolve(compiledDir, 'Song662.js'))
const { MixerEffects662 } = require(path.resolve(compiledDir, 'MixerEffects662.js'))

function parse (fixture) {
  const bytes = fs.readFileSync(fixture)
  return { bytes, file: new File66X(new KaitaiStream(bytes)) }
}

assert.equal(Hypersynth602.Shape[0x0b], 'SINE_ORGAN')
assert.equal(MixerEffects662.ModFxType[0x03], 'COMB')
assert.equal(Song662.RowBookmarkColorValue[0x05], 'TEXT_TITLES')
assert.equal(Song662.RowBookmarkColorValue[0x15], 'TEXT_TITLES_ARROWS')

for (const name of ['NONE', 'WAV', 'MAC', 'SAM', 'FM', 'HYP', 'MID', 'EXT']) {
  const { bytes, file } = parse(`fixtures/6.6.x/instruments/${name}_DEFAULT.m8i`)
  assert.equal(bytes.length, 357, `${name} length`)
  assert.equal(file.body.instrument.generalSettings.type, bytes[0x0e], `${name} type`)
  if (name === 'NONE') {
    assert.equal(file.body.instrument.body.eq, undefined)
    assert.deepEqual(Buffer.from(file.body.instrument.body.unknown), bytes.subarray(0x1d, 0xe5))
  } else assert.equal(file.body.instrument.body.eq, bytes[0x4c], `${name} EQ`)
  assert.equal(file.body.table.rows.length, 16, `${name} table length`)
  if (name === 'HYP') assert.equal(file.body.instrument.body.shape, 0x00)
}

{
  const { bytes, file } = parse('fixtures/6.6.x/instruments/HYP_SHAPE.m8i')
  assert.equal(file.body.instrument.body.shape, 0x0b)
  assert.equal(bytes[0x39], 0x0b)
}

{
  const before = parse('fixtures/6.6.x/instruments/HYP_EMB_A.m8i')
  const after = parse('fixtures/6.6.x/instruments/HYP_EMB_B.m8i')
  for (const [entry, suffix, shape] of [[before, 'A', 0x00], [after, 'B', 0x0b]]) {
    assert.equal(entry.bytes.length, 357)
    assert.equal(entry.file.body.instrument.generalSettings.type, 5)
    assert.deepEqual(Buffer.from(entry.file.body.instrument.generalSettings.name),
      Buffer.from(`HYP_EMB_${suffix}\0\0\0`, 'ascii'))
    assert.equal(entry.file.body.instrument.body.shape, shape)
    assert.equal(entry.file.body.table.rows.length, 16)
    const song = parse(`fixtures/6.6.x/songs/HYP_EMB_${suffix}.m8s`)
    const embedded = song.file.body.instruments[127]
    assert.equal(song.bytes.length, 112582)
    assert.equal(song.file.body.instruments.length, 128)
    assert.equal(embedded.generalSettings.type, 5)
    assert.equal(embedded.body.shape, shape)
    assert.deepEqual(Buffer.from(embedded.generalSettings.name),
      Buffer.from(entry.file.body.instrument.generalSettings.name))
    assert.deepEqual(Buffer.from(song.file.body.projectSettings.name),
      Buffer.from(`HYP_EMB_${suffix}\0\0\0`, 'ascii'))
    // Fixture comparison proves equality of the entire record, not only Shape.
    const recordOffset = 0x13a3e + 127 * 215
    assert.deepEqual(song.bytes.subarray(recordOffset, recordOffset + 215), entry.bytes.subarray(14, 229))
    const tableOffset = 0xba3e + 127 * 128
    assert.deepEqual(song.bytes.subarray(tableOffset, tableOffset + 128), entry.bytes.subarray(229, 357))
    const tableValues = table => table.rows.map(row => [row.transpose, row.volume,
      ...row.fx.flatMap(fx => [fx.command, fx.value])])
    assert.deepEqual(tableValues(song.file.body.tables[127]), tableValues(entry.file.body.table))
  }
  const changed = [...before.bytes.keys()].filter(offset => before.bytes[offset] !== after.bytes[offset])
  assert.deepEqual(changed, [0x17, 0x39], 'export pair changes only name and Shape')
  const songBefore = parse('fixtures/6.6.x/songs/HYP_EMB_A.m8s').bytes
  const songAfter = parse('fixtures/6.6.x/songs/HYP_EMB_B.m8s').bytes
  assert.deepEqual([...songBefore.keys()].filter(offset => songBefore[offset] !== songAfter[offset]),
    [0x9c, 0xbd, 0x1a4f0, 0x1a512], 'Song pair changes names, unknown state, and Shape')
}

for (const name of ['DEFAULT', 'MODFX_COMB', 'BOOKMARKS']) {
  const { bytes, file } = parse(`fixtures/6.6.x/songs/${name}.m8s`)
  const song = file.body
  assert.equal(bytes.length, 112582, `${name} length`)
  assert.equal(song.rows.length, 256, `${name} Song rows`)
  assert.equal(song.instruments.length, 128, `${name} instruments`)
  assert.equal(song.bookmarks.length, 256, `${name} chain bookmark rows`)
  assert.equal(song.rowBookmarkColors.length, 256, `${name} color bookmark rows`)
  assert.deepEqual(Buffer.from(song.unknown2), bytes.subarray(0x1b6a6, 0x1b6c6))
  for (let row = 0; row < 256; row++) {
    assert.equal(song.bookmarks[row].trackMask, bytes[0x1a97e + row], `${name} chain row ${row}`)
    assert.equal(song.rowBookmarkColors[row].color, bytes[0x1b6c6 + row], `${name} color row ${row}`)
  }
  assert.equal(song.effectsAndScope.modFxType, name === 'MODFX_COMB' ? 0x03 : 0x00)
}

{
  const { file } = parse('fixtures/6.6.x/songs/BOOKMARKS.m8s')
  const song = file.body
  for (const [row, mask] of [[0, 0x55], [1, 0xaa], [254, 0x55], [255, 0xaa]]) {
    assert.equal(song.bookmarks[row].trackMask, mask)
  }
  const colors = [5, 6, 7, 8, 9, 10, 11, 12, 4, 3, 2, 1]
  for (let row = 0; row < 256; row++) {
    const expected = row >= 1 && row <= 12 ? colors[row - 1]
      : row >= 0xf3 && row <= 0xfe ? colors[row - 0xf3] + 0x10 : 0
    assert.equal(song.rowBookmarkColors[row].color, expected, `row ${row}`)
  }
}

for (const [kind, fixture, expectedSize] of [
  ['scales', 'CHROMATIC.m8n', 60],
  ['themes', 'DEFAULT.m8t', 53]
]) {
  const { bytes, file } = parse(`fixtures/6.6.x/${kind}/${fixture}`)
  assert.equal(bytes.length, expectedSize)
  assert.ok(file.body)
}

for (const [suffix, tuning] of [['A', 0], ['B', 1]]) {
  const scale = parse(`fixtures/6.6.x/scales/SCALE_${suffix}.m8n`)
  const song = parse(`fixtures/6.6.x/songs/SCALE_${suffix}.m8s`)
  const embedded = song.file.body.scales[0]
  assert.equal(scale.bytes.length, 60)
  assert.equal(song.bytes.length, 112582)
  assert.equal(song.file.body.scales.length, 16)
  assert.equal(scale.file.body.tuningOffset, tuning)
  assert.equal(embedded.tuningOffset, tuning)
  assert.deepEqual(song.bytes.subarray(0x1aa7e, 0x1aaac), scale.bytes.subarray(14),
    `SCALE_${suffix}: complete embedded record matches export`)
  assert.equal(embedded.enabledNotes, scale.file.body.enabledNotes)
  assert.deepEqual(embedded.intervals.map(interval => interval.offset),
    scale.file.body.intervals.map(interval => interval.offset))
  assert.deepEqual(Buffer.from(embedded.name), Buffer.from(scale.file.body.name))
  assert.equal(Buffer.from(embedded.name).subarray(0, 7).toString('ascii'), `SCALE_${suffix}`)
}

for (const [kind, extension, expected] of [
  ['scales', 'm8n', [0x2e, 0x3a, 0x3b]],
  ['songs', 'm8s', [0x9a, 0xbd, 0x1aa9e, 0x1aaaa, 0x1aaab]]
]) {
  const before = parse(`fixtures/6.6.x/${kind}/SCALE_A.${extension}`).bytes
  const after = parse(`fixtures/6.6.x/${kind}/SCALE_B.${extension}`).bytes
  assert.deepEqual([...before.keys()].filter(offset => before[offset] !== after[offset]), expected,
    `Scale pair: all changed ${kind} bytes accounted for`)
}

console.log('parsed_fixtures_6.6.x\tok')
