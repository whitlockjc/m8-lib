#!/usr/bin/env node

const fs = require('node:fs')
const path = require('node:path')
const { targets, targetFor, schemaVersions, fixtureFiles } = require('./firmware-targets')

const FILE_KINDS = new Map([
  [0x00, 'song'],
  [0x10, 'instrument'],
  [0x20, 'theme'],
  [0x30, 'scale']
])

const EXT_KINDS = new Map([
  ['.m8i', 'instrument'],
  ['.m8n', 'scale'],
  ['.m8s', 'song'],
  ['.m8t', 'theme']
])

function readHeader (filePath) {
  const bytes = fs.readFileSync(filePath)

  if (bytes.length < 14) {
    throw new Error(`${filePath}: file is too short to contain an M8 header`)
  }

  const magic = bytes.subarray(0, 9).toString('ascii')
  const schemaVersionRaw = bytes.readUInt16LE(10)
  const schemaVersion = [
    (schemaVersionRaw >> 8) & 0x0f,
    (schemaVersionRaw >> 4) & 0x0f,
    schemaVersionRaw & 0x0f
  ].join('.')
  const fileKindRaw = bytes[13]
  const fileKind = FILE_KINDS.get(fileKindRaw) || `unknown:${fileKindRaw}`

  return {
    path: filePath,
    size: bytes.length,
    magic,
    schemaVersion,
    fileKind,
    fileKindRaw
  }
}

function verifyHeader (header, target) {
  if (!target) throw new Error('firmware target required for header validation; use readHeader for inspection')
  const expectedKind = EXT_KINDS.get(path.extname(header.path))

  if (header.magic !== 'M8VERSION') {
    throw new Error(`${header.path}: expected magic M8VERSION, got ${header.magic}`)
  }

  if (expectedKind && header.fileKind !== expectedKind) {
    throw new Error(`${header.path}: expected ${expectedKind}, got ${header.fileKind}`)
  }

  const expectedVersion = target ? schemaVersions(target).get(header.fileKind) : undefined
  if (expectedVersion && header.schemaVersion !== expectedVersion) {
    throw new Error(`${header.path}: expected ${header.fileKind} schema version ${expectedVersion}, got ${header.schemaVersion}`)
  }
}

if (require.main === module) {
  const args = process.argv.slice(2)
  const inspectOnly = args[0] === '--inspect'
  if (inspectOnly) args.shift()
  if (inspectOnly && args.length === 0) throw new Error('usage: inspect-headers.js --inspect <files...>')
  const firmware = args[0] === '--firmware' ? args.splice(0, 2)[1] : undefined
  if (inspectOnly && firmware) throw new Error('choose --inspect or --firmware')
  if (process.argv[2] === '--firmware' && !firmware) throw new Error('usage: inspect-headers.js [--firmware <range>] [files...]')
  if (args.length > 0 && !firmware && !inspectOnly) throw new Error('provide --firmware to validate, or --inspect to report observed headers')
  if (firmware) targetFor(firmware)
  const selected = inspectOnly ? [] : firmware ? [firmware] : Object.keys(targets)
  const files = inspectOnly
    ? args.map(file => ({ file, target: undefined }))
    : args.length > 0
    ? args.map(file => ({ file, target: firmware ? targetFor(firmware) : undefined }))
    : selected.flatMap(name => fixtureFiles(targetFor(name)).map(file => ({ file, target: targetFor(name) })))

  console.log(['path', 'kind', 'schema_version', 'size'].join('\t'))

  for (const { file, target } of files.sort((a, b) => a.file.localeCompare(b.file))) {
    const header = readHeader(file)

    if (!inspectOnly) verifyHeader(header, target)

    console.log([
      header.path,
      header.fileKind,
      header.schemaVersion,
      header.size
    ].join('\t'))
  }
}

module.exports = { readHeader, verifyHeader }
