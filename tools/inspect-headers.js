#!/usr/bin/env node

const fs = require('node:fs')
const path = require('node:path')

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

function fixtureFiles (dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true })
  const files = []

  for (const entry of entries) {
    const entryPath = path.join(dir, entry.name)

    if (entry.isDirectory()) {
      files.push(...fixtureFiles(entryPath))
    } else if (EXT_KINDS.has(path.extname(entry.name))) {
      files.push(entryPath)
    }
  }

  return files
}

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

function verifyHeader (header) {
  const expectedKind = EXT_KINDS.get(path.extname(header.path))

  if (header.magic !== 'M8VERSION') {
    throw new Error(`${header.path}: expected magic M8VERSION, got ${header.magic}`)
  }

  if (expectedKind && header.fileKind !== expectedKind) {
    throw new Error(`${header.path}: expected ${expectedKind}, got ${header.fileKind}`)
  }
}

const args = process.argv.slice(2)
const files = args.length > 0 ? args : fixtureFiles('fixtures')

console.log(['path', 'kind', 'schema_version', 'size'].join('\t'))

for (const file of files.sort()) {
  const header = readHeader(file)

  verifyHeader(header)

  console.log([
    header.path,
    header.fileKind,
    header.schemaVersion,
    header.size
  ].join('\t'))
}
