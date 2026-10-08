#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const KaitaiStream = require('kaitai-struct/KaitaiStream')
const { targetFor, fixtureFiles } = require('./firmware-targets')

const [firmware, compiledDir] = process.argv.slice(2)
if (!firmware || !compiledDir) {
  throw new Error('usage: node tools/verify-parsed-headers.js <firmware> <compiled-schema-dir>')
}
const target = targetFor(firmware)
const className = `File${firmware.replaceAll('.', '').toUpperCase()}`
const Parser = require(path.resolve(compiledDir, `${className}.js`))[className]

for (const fixture of fixtureFiles(target)) {
  const bytes = fs.readFileSync(fixture)
  assert.doesNotThrow(() => new Parser(new KaitaiStream(bytes)), fixture)

  // Only the header is changed; the original body remains available to expose
  // a parser that silently dispatches to a layout for the wrong file version.
  const originalVersion = bytes.readUInt16LE(10)
  const wrongVersions = new Set([0, originalVersion ^ 1, originalVersion | 0x1000,
    0x0601, 0x0602, 0x0401, 0x0650, 0x0662, 0x0102])
  wrongVersions.delete(originalVersion)
  for (const version of wrongVersions) {
    const changed = Buffer.from(bytes)
    changed.writeUInt16LE(version, 10)
    const stream = new KaitaiStream(changed)
    assert.throws(() => new Parser(stream), KaitaiStream.ValidationExprError,
      `${fixture}: reject schema version 0x${version.toString(16)}`)
    assert.equal(stream.pos, 14, `${fixture}: reject before reading the body`)
  }

  const changed = Buffer.from(bytes)
  changed[13] = 0x7f
  const stream = new KaitaiStream(changed)
  assert.throws(() => new Parser(stream), KaitaiStream.ValidationExprError,
    `${fixture}: reject an unsupported file kind`)
  assert.equal(stream.pos, 14, `${fixture}: reject before reading the body`)
}

console.log(`parsed_headers_${firmware}\tok`)
