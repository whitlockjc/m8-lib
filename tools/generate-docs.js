#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const { load, fixedSize, sequenceLayout } = require('./ksy-layout')

const themeDocPath = 'docs/THEME.md'

function range (from, size, relative = false) {
  const prefix = relative ? '+' : ''
  const first = `${prefix}0x${from.toString(16).padStart(2, '0')}`
  if (size === 1) return first
  const last = `${prefix}0x${(from + size - 1).toString(16).padStart(2, '0')}`
  return `${first}..${last}`
}

function renderThemeLayout () {
  const header = load('schemas/common/file_header.ksy')
  const theme = load('schemas/file-versions/1.0.2/theme.ksy')
  const headerSize = header.data.seq.reduce((sum, field) => sum + fixedSize(field, header), 0)
  const color = theme.data.types.color
  const colorSize = fixedSize({ type: 'color' }, theme)
  const fields = sequenceLayout(theme.data.seq, theme, headerSize)
  const lines = [
    '## Layout',
    '',
    'Offsets are absolute file offsets.',
    '',
    '| Name | Offset / Range | Size | Type |',
    '| --- | --- | ---: | --- |',
    `| M8 File Header | \`${range(0, headerSize)}\` | ${headerSize} | [M8 File Header](FILE_HEADER.md) |`
  ]

  for (const field of fields) {
    const name = field.id.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase())
    lines.push(`| \`${name}\` | \`${range(field.from, field.size)}\` | ${field.size} | [\`Color\`](#color) |`)
  }

  lines.push('', '### Color', '', 'Offsets are relative to the start of each `Color`.', '',
    '| Name | Relative Offset | Size | Type |', '| --- | --- | ---: | --- |')
  for (const field of sequenceLayout(color.seq, theme, 0)) {
    const component = color.seq.find(item => item.id === field.id)
    assert.ok(component, `missing color component ${field.id}`)
    lines.push(`| \`${field.id}\` | \`${range(field.from, field.size, true)}\` | ${field.size} | \`${component.type}\` |`)
  }
  return `${lines.join('\n')}\n`
}

function generateThemeDoc (source) {
  const layoutHeading = '\n## Layout\n'
  const notesHeading = '\n## Notes\n'
  const start = source.indexOf(layoutHeading)
  const end = source.indexOf(notesHeading, start + layoutHeading.length)
  assert.ok(start !== -1 && end > start, `${themeDocPath}: missing Layout or Notes heading`)
  assert.equal(source.indexOf(layoutHeading, start + 1), -1, 'duplicate Layout heading')
  assert.equal(source.indexOf(notesHeading, end + 1), -1, 'duplicate Notes heading')
  return source.slice(0, start + 1) + renderThemeLayout() + source.slice(end)
}

if (require.main === module) {
  const check = process.argv.includes('--check')
  assert.ok(process.argv.length === 2 || (process.argv.length === 3 && check),
    'usage: node tools/generate-docs.js [--check]')
  const current = fs.readFileSync(themeDocPath, 'utf8')
  const generated = generateThemeDoc(current)
  if (check) {
    assert.equal(current, generated, `${themeDocPath} is stale; run npm run docs:generate`)
    console.log('generated_docs\tok')
  } else if (current !== generated) {
    fs.writeFileSync(themeDocPath, generated)
    console.log(`updated\t${themeDocPath}`)
  } else {
    console.log(`unchanged\t${themeDocPath}`)
  }
}

module.exports = { generateThemeDoc }
