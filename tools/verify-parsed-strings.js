#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const KaitaiStream = require('kaitai-struct/KaitaiStream')
const { targetFor, fixtureFiles } = require('./firmware-targets')

const [firmware, compiledDir] = process.argv.slice(2)
if (!firmware || !compiledDir) {
  throw new Error('usage: node tools/verify-parsed-strings.js <firmware> <compiled-schema-dir>')
}
const target = targetFor(firmware)
const className = `File${firmware.replaceAll('.', '').toUpperCase()}`
const Parser = require(path.resolve(compiledDir, `${className}.js`))[className]
const parse = bytes => new Parser(new KaitaiStream(bytes))

function checkName (value, bytes, offset, size, label) {
  assert.deepEqual(Buffer.from(value), bytes.subarray(offset, offset + size), label)
}

function checkPath (value, bytes, offset, label) {
  const region = bytes.subarray(offset, offset + 128)
  const terminator = region.indexOf(0)
  assert.notEqual(terminator, -1, `${label}: terminator inside the field`)
  assert.equal(value.path, region.subarray(0, terminator).toString('ascii'), label)
  assert.deepEqual(Buffer.from(value.trailing), region.subarray(terminator + 1), label)
  assert.deepEqual(Buffer.concat([Buffer.from(value.path, 'ascii'), Buffer.from([0]),
    Buffer.from(value.trailing)]), region, `${label}: reconstruct all 128 bytes`)
}

for (const fixture of fixtureFiles(target)) {
  const bytes = fs.readFileSync(fixture)
  const { body } = parse(bytes)
  switch (path.extname(fixture)) {
    case '.m8i':
      checkName(body.instrument.generalSettings.name, bytes, 0x0f, 12, fixture)
      if (body.instrument.generalSettings.type === 2) checkPath(body.instrument.body.samplePath, bytes, 0x65, fixture)
      break
    case '.m8n':
      checkName(body.name, bytes, 0x28, 16, fixture)
      break
    case '.m8s':
      checkPath(body.directory, bytes, 0x0e, fixture)
      checkName(body.projectSettings.name, bytes, 0x94, 12, fixture)
      for (const [index, instrument] of body.instruments.entries()) {
        const offset = 0x13a3e + index * 215
        checkName(instrument.generalSettings.name, bytes, offset + 1, 12, `${fixture}: instrument ${index}`)
        if (instrument.generalSettings.type === 2) checkPath(instrument.body.samplePath, bytes, offset + 87, fixture)
      }
      for (const [index, scale] of body.scales.entries()) {
        checkName(scale.name, bytes, 0x1aa7e + index * 46 + 26, 16, `${fixture}: scale ${index}`)
      }
      break
  }
}

// Synthetic parser checks, not evidence of values the M8 UI permits. Verify
// names preserve embedded nulls and high bytes, and need no null terminator.
for (const [fixture, offset, size, select] of [
  ['instruments/WAV_DEFAULT.m8i', 0x0f, 12, file => file.body.instrument.generalSettings.name],
  ['songs/DEFAULT.m8s', 0x94, 12, file => file.body.projectSettings.name],
  [firmware === '6.5.x' ? 'scales/CHROMATIC_DEFAULT.m8n' : 'scales/CHROMATIC.m8n',
    0x28, 16, file => file.body.name]
]) {
  for (const withNull of [false, true]) {
    const bytes = fs.readFileSync(path.join(target.fixtureRoot, fixture))
    bytes.fill(0xa5, offset, offset + size)
    if (withNull) bytes[offset + 1] = 0
    checkName(select(parse(bytes)), bytes, offset, size, `${fixture}: synthetic name`)
  }
}

for (const [fixture, offset, select, next] of [
  ['instruments/SAM_DEFAULT.m8i', 0x65, file => file.body.instrument.body.samplePath,
    file => file.body.table.rows[0].transpose],
  ['songs/DEFAULT.m8s', 0x0e, file => file.body.directory,
    file => file.body.projectSettings.transpose]
]) {
  const original = fs.readFileSync(path.join(target.fixtureRoot, fixture))
  for (const length of [0, 17, 127]) {
    const bytes = Buffer.from(original)
    bytes.fill(0x61, offset, offset + 128)
    bytes[offset + length] = 0
    bytes.fill(0xa5, offset + length + 1, offset + 128)
    const file = parse(bytes)
    checkPath(select(file), bytes, offset, `${fixture}: synthetic path length ${length}`)
    assert.equal(next(file), original[offset + 128], `${fixture}: next field stays aligned`)
  }
  const bytes = Buffer.from(original)
  bytes.fill(0x61, offset, offset + 128)
  assert.throws(() => parse(bytes), /end of stream|EOF/i,
    `${fixture}: missing terminator must not read beyond the path field`)
}

console.log(`parsed_strings_${firmware}\tok`)
