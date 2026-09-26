#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { generate } = require('./generate-docs')

function anchors (source) {
  const counts = new Map()
  return new Set([...source.matchAll(/^#{1,6} (.+)$/gm)].map(([, title]) => {
    const slug = title.toLowerCase().replace(/[^\p{L}\p{N}_\- ]/gu, '').replaceAll(' ', '-')
    const count = counts.get(slug) || 0
    counts.set(slug, count + 1)
    return slug + (count ? `-${count}` : '')
  }))
}

function verifyLinks (outputs) {
  let count = 0
  for (const [file, source] of outputs) {
    for (const [, href] of source.matchAll(/\[[^\]\n]*\]\(([^)\s]+)\)/g)) {
      if (/^[a-z]+:/i.test(href)) continue
      const [relative, anchor] = href.split('#')
      const target = relative ? path.resolve(path.dirname(file), decodeURIComponent(relative)) : file
      assert.ok(outputs.has(target) || fs.existsSync(target), `${file}: broken link ${href}`)
      if (anchor && target.endsWith('.md')) {
        const content = outputs.get(target) || fs.readFileSync(target, 'utf8')
        assert.ok(anchors(content).has(anchor), `${file}: missing anchor ${href}`)
      }
      count++
    }
  }
  return count
}

if (require.main === module) {
  const outputs = generate(undefined, { check: true })
  console.log(`documented_links\tok\t${verifyLinks(outputs)}`)
}

module.exports = { verifyLinks }
