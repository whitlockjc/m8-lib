const assert = require('node:assert/strict')
const test = require('node:test')
const { targetFor, schemaVersions, fixtureFiles, verifyFixtureMetadata } = require('./firmware-targets')
const { readHeader, verifyHeader } = require('./inspect-headers')
const { parseArgs } = require('./verify')

test('6.5.x header expectations follow the entry schema', () => {
  const target = targetFor('6.5.x')
  assert.deepEqual(Object.fromEntries(schemaVersions(target)), {
    instrument: '6.0.1', scale: '4.0.1', song: '6.5.0', theme: '1.0.2'
  })
  const files = fixtureFiles(target)
  assert.ok(files.length > 40)
  for (const file of files) assert.doesNotThrow(() => verifyHeader(readHeader(file), target))
  assert.equal(verifyFixtureMetadata(target), 54)
  assert.throws(() => verifyHeader(readHeader(files[0])), /firmware target required/)
})

test('unknown firmware and missing verification suites fail closed', () => {
  assert.deepEqual(parseArgs([]), ['6.5.x'])
  assert.deepEqual(parseArgs(['--firmware', '6.5.x']), ['6.5.x'])
  assert.throws(() => parseArgs(['--firmware', '6.6.x']), /unsupported firmware/)
  assert.throws(() => targetFor('6.6.x'), /unsupported firmware/)
  assert.throws(() => parseArgs(['--firmware']), /usage/)
})
