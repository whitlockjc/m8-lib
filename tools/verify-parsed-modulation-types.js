#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const KaitaiStream = require('kaitai-struct/KaitaiStream')
const { targetFor } = require('./firmware-targets')

const [firmware, compiledDir] = process.argv.slice(2)
if (!firmware || !compiledDir) {
  throw new Error('usage: node tools/verify-parsed-modulation-types.js <firmware> <compiled-schema-dir>')
}
const target = targetFor(firmware)
const className = `File${firmware.replaceAll('.', '').toUpperCase()}`
const Parser = require(path.resolve(compiledDir, `${className}.js`))[className]
const { Modulation601 } = require(path.resolve(compiledDir, 'Modulation601.js'))

// Synthetic inputs test dispatch, not whether the M8 UI permits a destination
// for a particular instrument. Only the high nibble selects the payload shape.
for (let packed = 0; packed <= 0xff; packed++) {
  const stream = new KaitaiStream(Buffer.from([packed, 0x40, 0, 0, 0, 0]))
  if ((packed >> 4) <= 5) {
    const slot = new Modulation601.Slot(stream)
    assert.equal(slot.modulationType, packed >> 4)
    assert.equal(slot.destination, packed & 0x0f)
    assert.ok(slot.params)
    assert.equal(stream.pos, 6, `0x${packed.toString(16)} consumes a full slot`)
  } else {
    assert.throws(() => new Modulation601.Slot(stream), KaitaiStream.ValidationExprError,
      `reject type nibble 0x${(packed >> 4).toString(16)}`)
    assert.equal(stream.pos, 1, 'stop at the invalid packed byte')
  }
}

for (const [fixture, recordOffset] of [
  ['instruments/WAV_DEFAULT.m8i', 0x0e],
  ['songs/DEFAULT.m8s', 0x13a3e],
  ['songs/DEFAULT.m8s', 0x13a3e + 127 * 215]
]) {
  const original = fs.readFileSync(path.join(target.fixtureRoot, fixture))
  // Replace the Song record with a known Wavsynth record so even an empty
  // (NONE) Song instrument exercises the shared modulation layout.
  const wav = fs.readFileSync(path.join(target.fixtureRoot, 'instruments/WAV_DEFAULT.m8i'))
  wav.copy(original, recordOffset, 0x0e, 0xe5)
  assert.doesNotThrow(() => new Parser(new KaitaiStream(original)))
  for (const slot of [0, 3]) {
    const offset = recordOffset + 0x3f + slot * 6
    for (const type of [6, 15]) {
      const changed = Buffer.from(original)
      changed[offset] = (type << 4) | (changed[offset] & 0x0f)
      const stream = new KaitaiStream(changed)
      assert.throws(() => new Parser(stream), KaitaiStream.ValidationExprError,
        `${fixture}: record ${recordOffset}, slot ${slot}, type ${type}`)
      assert.equal(stream.pos, offset + 1, 'reject before consuming the payload')
    }
  }
}

console.log(`parsed_modulation_types_${firmware}\tok`)
