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

for (const name of ['DEFAULT', 'MODFX_COMB', 'BOOKMARKS']) {
  const { bytes, file } = parse(`fixtures/6.6.x/songs/${name}.m8s`)
  const song = file.body
  assert.equal(bytes.length, 112582, `${name} length`)
  assert.equal(song.rows.entries.length, 256, `${name} Song rows`)
  assert.equal(song.instruments.entries.length, 128, `${name} instruments`)
  assert.equal(song.bookmarks.entries.length, 256, `${name} chain bookmark rows`)
  assert.equal(song.rowBookmarkColors.entries.length, 256, `${name} color bookmark rows`)
  assert.deepEqual(Buffer.from(song.unknown2), bytes.subarray(0x1b6a6, 0x1b6c6))
  for (let row = 0; row < 256; row++) {
    assert.equal(song.bookmarks.entries[row].trackMask, bytes[0x1a97e + row], `${name} chain row ${row}`)
    assert.equal(song.rowBookmarkColors.entries[row].color, bytes[0x1b6c6 + row], `${name} color row ${row}`)
  }
  assert.equal(song.effectsAndScope.modFxType, name === 'MODFX_COMB' ? 0x03 : 0x00)
}

{
  const { file } = parse('fixtures/6.6.x/songs/BOOKMARKS.m8s')
  const song = file.body
  for (const [row, mask] of [[0, 0x55], [1, 0xaa], [254, 0x55], [255, 0xaa]]) {
    assert.equal(song.bookmarks.entries[row].trackMask, mask)
  }
  const colors = [5, 6, 7, 8, 9, 10, 11, 12, 4, 3, 2, 1]
  for (let row = 0; row < 256; row++) {
    const expected = row >= 1 && row <= 12 ? colors[row - 1]
      : row >= 0xf3 && row <= 0xfe ? colors[row - 0xf3] + 0x10 : 0
    assert.equal(song.rowBookmarkColors.entries[row].color, expected, `row ${row}`)
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

console.log('parsed_fixtures_6.6.x\tok')
