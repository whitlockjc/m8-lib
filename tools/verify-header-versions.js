#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const os = require('node:os')
const path = require('node:path')
const { readHeader, verifyHeader } = require('./inspect-headers')

const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'm8-header-'))

try {
  for (const fixture of [
    'fixtures/6.5.x/instruments/NONE_DEFAULT.m8i',
    'fixtures/6.5.x/scales/CHROMATIC_DEFAULT.m8n',
    'fixtures/6.5.x/songs/DEFAULT.m8s',
    'fixtures/6.5.x/themes/DEFAULT.m8t'
  ]) {
    assert.doesNotThrow(() => verifyHeader(readHeader(fixture)), fixture)

    const changed = fs.readFileSync(fixture)
    changed.writeUInt16LE(0, 10)
    const tempFixture = path.join(tempDir, path.basename(fixture))
    fs.writeFileSync(tempFixture, changed)
    assert.throws(
      () => verifyHeader(readHeader(tempFixture)),
      /expected .* schema version .* got 0\.0\.0/,
      `${fixture} rejects a mismatched schema version`
    )
  }
} finally {
  fs.rmSync(tempDir, { recursive: true, force: true })
}

console.log('header_versions\tok')
