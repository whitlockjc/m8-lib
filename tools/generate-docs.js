#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const { load, fixedSize, sequenceLayout } = require('./ksy-layout')

const themeDocPath = 'docs/THEME.md'
const scaleDocPath = 'docs/SCALE.md'

function headerSize () {
  const header = load('schemas/common/file_header.ksy')
  return header.data.seq.reduce((sum, field) => sum + fixedSize(field, header), 0)
}

function range (from, size, relative = false) {
  const prefix = relative ? '+' : ''
  const first = `${prefix}0x${from.toString(16).padStart(2, '0')}`
  if (size === 1) return first
  const last = `${prefix}0x${(from + size - 1).toString(16).padStart(2, '0')}`
  return `${first}..${last}`
}

function renderThemeLayout () {
  const theme = load('schemas/file-versions/1.0.2/theme.ksy')
  const headerBytes = headerSize()
  const color = theme.data.types.color
  const colorSize = fixedSize({ type: 'color' }, theme)
  const fields = sequenceLayout(theme.data.seq, theme, headerBytes)
  const lines = [
    '## Layout',
    '',
    'Offsets are absolute file offsets.',
    '',
    '| Name | Offset / Range | Size | Type |',
    '| --- | --- | ---: | --- |',
    `| M8 File Header | \`${range(0, headerBytes)}\` | ${headerBytes} | [M8 File Header](FILE_HEADER.md) |`
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

function replaceSection (source, file, startHeading, endHeading, rendered) {
  const startToken = `\n${startHeading}\n`
  const endToken = `\n${endHeading}\n`
  const start = source.indexOf(startToken)
  const end = source.indexOf(endToken, start + startToken.length)
  assert.ok(start !== -1 && end > start, `${file}: missing ${startHeading} or ${endHeading} heading`)
  assert.equal(source.indexOf(startToken, start + 1), -1, `duplicate ${startHeading} heading`)
  assert.equal(source.indexOf(endToken, end + 1), -1, `duplicate ${endHeading} heading`)
  return source.slice(0, start + 1) + rendered + source.slice(end)
}

function generateThemeDoc (source) {
  return replaceSection(source, themeDocPath, '## Layout', '## Notes', renderThemeLayout())
}

function renderScaleLayout () {
  const scale = load('schemas/file-versions/4.0.1/scale.ksy')
  const headerBytes = headerSize()
  const fields = sequenceLayout(scale.data.seq, scale, headerBytes)
  const lines = [
    '## Layout',
    '',
    'Offsets are absolute file offsets.',
    '',
    '| Name | Offset / Range | Size | Type |',
    '| --- | --- | ---: | --- |',
    `| M8 File Header | \`${range(0, headerBytes)}\` | ${headerBytes} | [M8 File Header](FILE_HEADER.md) |`
  ]
  const typeLabels = {
    enabled_notes: '[Enabled Notes](#enabled-notes)',
    name: '[Fixed String](#fixed-string)'
  }
  fields.forEach((field, index) => {
    const schemaField = scale.data.seq[index]
    const name = field.id.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase())
    let type = typeLabels[field.id]
    if (!type && scale.data.types[schemaField.type]) {
      const typeName = schemaField.type.replace(/^./, letter => letter.toUpperCase())
      type = `[${typeName}](#${schemaField.type})`
      if (schemaField.repeat) type += ` \`[${schemaField['repeat-expr']}]\``
    }
    if (!type) type = `\`${schemaField.type}\``
    lines.push(`| \`${name}\` | \`${range(field.from, field.size)}\` | ${field.size} | ${type} |`)
  })
  return `${lines.join('\n')}\n`
}

function generateScaleDoc (source) {
  return replaceSection(source, scaleDocPath, '## Layout', '### Enabled Notes', renderScaleLayout())
}

if (require.main === module) {
  const check = process.argv.includes('--check')
  assert.ok(process.argv.length === 2 || (process.argv.length === 3 && check),
    'usage: node tools/generate-docs.js [--check]')
  for (const [file, generate] of [
    [themeDocPath, generateThemeDoc],
    [scaleDocPath, generateScaleDoc]
  ]) {
    const current = fs.readFileSync(file, 'utf8')
    const generated = generate(current)
    if (check) {
      assert.equal(current, generated, `${file} is stale; run npm run docs:generate`)
    } else if (current !== generated) {
      fs.writeFileSync(file, generated)
      console.log(`updated\t${file}`)
    } else {
      console.log(`unchanged\t${file}`)
    }
  }
  if (check) console.log('generated_docs\tok\t2 files')
}

module.exports = { generateThemeDoc, generateScaleDoc }
