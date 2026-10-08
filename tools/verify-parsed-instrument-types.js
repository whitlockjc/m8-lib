#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const KaitaiStream = require('kaitai-struct/KaitaiStream')
const { targetFor } = require('./firmware-targets')

const [firmware, compiledDir] = process.argv.slice(2)
if (!firmware || !compiledDir) {
  throw new Error('usage: node tools/verify-parsed-instrument-types.js <firmware> <compiled-schema-dir>')
}
const target = targetFor(firmware)
const className = `File${firmware.replaceAll('.', '').toUpperCase()}`
const Parser = require(path.resolve(compiledDir, `${className}.js`))[className]

function rejectsType (bytes, offset, type, label) {
  // Synthetic invalid input: preserve the fixture and change only its type byte.
  const changed = Buffer.from(bytes)
  changed[offset] = type
  const stream = new KaitaiStream(changed)
  assert.throws(() => new Parser(stream), KaitaiStream.ValidationNotAnyOfError,
    `${label}: reject instrument type 0x${type.toString(16)}`)
  assert.equal(stream.pos, offset + 1, `${label}: stop at the invalid type byte`)
}

// Valid variants, including NONE, must still consume the full standalone file.
for (const name of ['WAV', 'MAC', 'SAM', 'MID', 'FM', 'HYP', 'EXT', 'NONE']) {
  const bytes = fs.readFileSync(path.join(target.fixtureRoot, 'instruments', `${name}_DEFAULT.m8i`))
  const stream = new KaitaiStream(bytes)
  const file = new Parser(stream)
  assert.equal(file.body.instrument.generalSettings.type, bytes[0x0e], name)
  assert.equal(stream.pos, bytes.length, `${name}: complete standalone record`)
}

const instrument = fs.readFileSync(path.join(target.fixtureRoot, 'instruments', 'WAV_DEFAULT.m8i'))
for (let type = 0x07; type < 0xff; type++) {
  rejectsType(instrument, 0x0e, type, 'standalone')
}

// Fixture-established Song bank: 128 records, each 215 bytes, at 0x13a3e.
const song = fs.readFileSync(path.join(target.fixtureRoot, 'songs', 'DEFAULT.m8s'))
for (const index of [0, 127]) {
  for (const type of [0x07, 0x7f, 0xfe]) {
    rejectsType(song, 0x13a3e + index * 215, type, `Song instrument ${index}`)
  }
}

console.log(`parsed_instrument_types_${firmware}\tok`)
