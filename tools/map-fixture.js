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

  if (/^[0-9]+$/.test(trimmed)) {
    return Number.parseInt(trimmed, 10)
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

function hexOffset (value) {
  return `0x${value.toString(16).padStart(4, '0')}`
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
    if (typeof change.new !== 'number') {
      throw new Error(`${change.name}: only single-byte numeric changes are supported for now`)
    }

    if (change.new < 0 || change.new > 0xff) {
      throw new Error(`${change.name}: new value is outside byte range: ${change.new}`)
    }

    const matches = []

    for (const offset of changed) {
      if (
        baseline[offset] === change.original &&
        modified[offset] === change.new
      ) {
        matches.push(offset)
      }
    }

    if (matches.length === 1) {
      accounted.add(matches[0])
    }

    results.push({ change, matches })
  }

  console.log(`baseline\t${baselinePath}`)
  console.log(`modified\t${modifiedPath}`)
  console.log(`manifest\t${manifestPath}`)
  console.log(`changed_bytes\t${changed.size}`)
  console.log('')
  console.log(['field', 'offset', 'original', 'new', 'status'].join('\t'))

  for (const result of results) {
    const { change, matches } = result
    const offset = matches.length === 1
      ? hexOffset(matches[0])
      : matches.map(hexOffset).join(',')
    const status = matches.length === 1
      ? 'exact'
      : matches.length === 0 ? 'missing' : 'ambiguous'

    console.log([
      change.name,
      offset,
      hexByte(change.original),
      hexByte(change.new),
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
