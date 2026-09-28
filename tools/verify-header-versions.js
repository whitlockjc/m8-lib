#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const os = require('node:os')
const path = require('node:path')
const { readHeader, verifyHeader } = require('./inspect-headers')
const { targetFor, fixtureFiles } = require('./firmware-targets')

const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'm8-header-'))
if (process.argv.length !== 4 || process.argv[2] !== '--firmware') {
  throw new Error('usage: verify-header-versions.js --firmware <range>')
}
const firmware = process.argv[3]
const target = targetFor(firmware)

try {
  const fixtures = fixtureFiles(target)
  assert.deepEqual(new Set(fixtures.map(file => path.extname(file))), new Set(['.m8i', '.m8n', '.m8s', '.m8t']))
  for (const fixture of fixtures) {
    assert.doesNotThrow(() => verifyHeader(readHeader(fixture), target), fixture)

    const changed = fs.readFileSync(fixture)
    changed.writeUInt16LE(0, 10)
    const tempFixture = path.join(tempDir, path.basename(fixture))
    fs.writeFileSync(tempFixture, changed)
    assert.throws(
      () => verifyHeader(readHeader(tempFixture), target),
      /expected .* schema version .* got 0\.0\.0/,
      `${fixture} rejects a mismatched schema version`
    )
  }
} finally {
  fs.rmSync(tempDir, { recursive: true, force: true })
}

console.log('header_versions\tok')
