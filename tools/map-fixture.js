#!/usr/bin/env node

const fs = require('node:fs')

function usage () {
  console.error('usage: node tools/map-fixture.js <baseline> <modified> <manifest>')
}

function parseScalar (value) {
  const trimmed = value.trim()

  if (/^0x[0-9a-f]+$/i.test(trimmed)) {
    return Number.parseInt(trimmed.slice(2), 16)
  }

  if (/^-?[0-9]+$/.test(trimmed)) {
    return Number.parseInt(trimmed, 10)
  }

  if (/^-?[0-9]+\.[0-9]+$/.test(trimmed)) {
    return Number.parseFloat(trimmed)
  }

  return trimmed
}

function parseManifest (filePath) {
  const lines = fs.readFileSync(filePath, 'utf8').split(/\r?\n/)
  const manifest = { changes: [] }
  let currentChange = null
  let inChanges = false

  for (const [index, line] of lines.entries()) {
    if (!line.trim() || line.trimStart().startsWith('#')) {
      continue
    }

    const topLevel = /^([A-Za-z][A-Za-z0-9]*):\s*(.*)$/.exec(line)
    if (topLevel && !line.startsWith(' ')) {
      const [, key, value] = topLevel
      if (key === 'changes') {
        inChanges = true
        continue
      }
      manifest[key] = parseScalar(value)
      continue
    }

    if (!inChanges) {
      throw new Error(`${filePath}:${index + 1}: unsupported manifest line: ${line}`)
    }

    const changeStart = /^  - name:\s*(.+)$/.exec(line)
    if (changeStart) {
      currentChange = { name: parseScalar(changeStart[1]) }
      manifest.changes.push(currentChange)
      continue
    }

    const changeField = /^    ([A-Za-z][A-Za-z0-9]*):\s*(.+)$/.exec(line)
    if (changeField && currentChange) {
      const [, key, value] = changeField
      currentChange[key] = parseScalar(value)
      continue
    }

    throw new Error(`${filePath}:${index + 1}: unsupported manifest line: ${line}`)
  }

  return manifest
}

function changedOffsets (baseline, modified) {
  const offsets = []
  const length = Math.min(baseline.length, modified.length)

  for (let offset = 0; offset < length; offset++) {
    if (baseline[offset] !== modified[offset]) {
      offsets.push(offset)
    }
  }

  return offsets
}

function hexByte (value) {
  return `0x${value.toString(16).padStart(2, '0')}`
}

function hexBytes (bytes) {
  return [...bytes].map(hexByte).join(' ')
}

function hexOffset (value) {
  return `0x${value.toString(16).padStart(4, '0')}`
}

function hexRange (offset, size) {
  if (size === 1) {
    return hexOffset(offset)
  }

  return `${hexOffset(offset)}..${hexOffset(offset + size - 1)}`
}

function parseHexBytes (value) {
  if (typeof value !== 'string') {
    throw new Error(`expected hex byte string, got ${value}`)
  }

  const compact = value.replace(/\s+/g, '')

  if (!compact || compact.length % 2 !== 0 || /[^0-9a-f]/i.test(compact)) {
    throw new Error(`invalid hex byte string: ${value}`)
  }

  return Buffer.from(compact, 'hex')
}

function integerBytes (value, type) {
  const bytes = Buffer.alloc(type.endsWith('2le') ? 2 : 1)

  switch (type) {
    case 'u1':
      bytes.writeUInt8(value)
      break
    case 'u2le':
      bytes.writeUInt16LE(value)
      break
    case 'i2le':
      bytes.writeInt16LE(value)
      break
    default:
      throw new Error(`unsupported numeric type: ${type}`)
  }

  return bytes
}

function valueBytes (change, key) {
  const bytesKey = `${key}Bytes`

  if (change[bytesKey] !== undefined) {
    return parseHexBytes(change[bytesKey])
  }

  const value = change[key]
  const type = change.type || 'u1'

  if (typeof value !== 'number') {
    throw new Error(`${change.name}: ${key} must be numeric unless ${bytesKey} is provided`)
  }

  return integerBytes(value, type)
}

function buffersEqualAt (buffer, offset, expected) {
  if (offset + expected.length > buffer.length) {
    return false
  }

  for (let index = 0; index < expected.length; index++) {
    if (buffer[offset + index] !== expected[index]) {
      return false
    }
  }

  return true
}

function main () {
  const [baselinePath, modifiedPath, manifestPath] = process.argv.slice(2)

  if (!baselinePath || !modifiedPath || !manifestPath) {
    usage()
    process.exitCode = 1
    return
  }

  const baseline = fs.readFileSync(baselinePath)
  const modified = fs.readFileSync(modifiedPath)
  const manifest = parseManifest(manifestPath)

  if (baseline.length !== modified.length) {
    throw new Error(`fixture sizes differ: ${baseline.length} != ${modified.length}`)
  }

  const changed = new Set(changedOffsets(baseline, modified))
  const accounted = new Set()
  const results = []

  for (const change of manifest.changes) {
    const originalBytes = valueBytes(change, 'original')
    const newBytes = valueBytes(change, 'new')

    if (originalBytes.length !== newBytes.length) {
      throw new Error(`${change.name}: original and new byte lengths differ`)
    }

    const matches = []
    const size = newBytes.length
    const expectedOffset = change.offset

    if (expectedOffset !== undefined && typeof expectedOffset !== 'number') {
      throw new Error(`${change.name}: offset must be numeric`)
    }

    const startOffset = expectedOffset === undefined ? 0 : expectedOffset
    const endOffset = expectedOffset === undefined
      ? baseline.length - size
      : expectedOffset

    for (let offset = startOffset; offset <= endOffset; offset++) {
      const overlapsChangedByte = [...changed].some((changedOffset) => (
        changedOffset >= offset && changedOffset < offset + size
      ))

      if (
        overlapsChangedByte &&
        buffersEqualAt(baseline, offset, originalBytes) &&
        buffersEqualAt(modified, offset, newBytes)
      ) {
        matches.push(offset)
      }
    }

    if (matches.length === 1) {
      for (let index = 0; index < size; index++) {
        if (changed.has(matches[0] + index)) {
          accounted.add(matches[0] + index)
        }
      }
    }

    results.push({ change, matches, originalBytes, newBytes })
  }

  console.log(`baseline\t${baselinePath}`)
  console.log(`modified\t${modifiedPath}`)
  console.log(`manifest\t${manifestPath}`)
  console.log(`changed_bytes\t${changed.size}`)
  console.log('')
  console.log(['field', 'offset', 'original', 'new', 'status'].join('\t'))

  for (const result of results) {
    const { change, matches, originalBytes, newBytes } = result
    const offset = matches.length === 1
      ? hexRange(matches[0], newBytes.length)
      : matches.map((match) => hexRange(match, newBytes.length)).join(',')
    const status = matches.length === 1
      ? 'exact'
      : matches.length === 0 ? 'missing' : 'ambiguous'

    console.log([
      change.name,
      offset,
      hexBytes(originalBytes),
      hexBytes(newBytes),
      status
    ].join('\t'))
  }

  const unaccounted = [...changed].filter((offset) => !accounted.has(offset))

  console.log('')
  console.log(`accounted_changed_bytes\t${accounted.size}`)
  console.log(`unaccounted_changed_bytes\t${unaccounted.length}`)

  for (const offset of unaccounted) {
    console.log([
      hexOffset(offset),
      hexByte(baseline[offset]),
      hexByte(modified[offset])
    ].join('\t'))
  }

  if (results.some((result) => result.matches.length !== 1) || unaccounted.length > 0) {
    process.exitCode = 1
  }
}

main()
