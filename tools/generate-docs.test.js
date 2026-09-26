const assert = require('node:assert/strict')
const fs = require('node:fs')
const test = require('node:test')
const { generateThemeDoc, generateScaleDoc } = require('./generate-docs')

const themeDoc = fs.readFileSync('docs/THEME.md', 'utf8')
const scaleDoc = fs.readFileSync('docs/SCALE.md', 'utf8')

test('Theme generation is stable and restores stale layout bytes', () => {
  assert.equal(generateThemeDoc(themeDoc), themeDoc)
  const stale = themeDoc.replace('`0x0e..0x10`', '`0x0e..0x11`')
  assert.notEqual(stale, themeDoc)
  assert.equal(generateThemeDoc(stale), themeDoc)
})

test('Theme generation preserves authored notes and evidence', () => {
  const edited = themeDoc.replace('Theme display name', 'Displayed theme name')
  assert.notEqual(edited, themeDoc)
  assert.equal(generateThemeDoc(edited), edited)
})

test('Theme generation requires unique section headings', () => {
  assert.throws(() => generateThemeDoc(themeDoc.replace('## Notes', '## Other')),
    /missing ## Layout or ## Notes heading/)
})

test('Scale generation is stable and restores stale layout bytes', () => {
  assert.equal(generateScaleDoc(scaleDoc), scaleDoc)
  const stale = scaleDoc.replace('`0x10..0x27`', '`0x10..0x28`')
  assert.notEqual(stale, scaleDoc)
  assert.equal(generateScaleDoc(stale), scaleDoc)
})

test('Scale generation preserves authored processing and evidence', () => {
  const edited = scaleDoc.replace('The scale name is stored', 'A scale name is stored')
  assert.notEqual(edited, scaleDoc)
  assert.equal(generateScaleDoc(edited), edited)
})
