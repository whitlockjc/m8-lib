#!/usr/bin/env node

const { execFileSync } = require('node:child_process')

for (const [kind, baseline, modified] of [
  ['instruments', 'HYP_DEFAULT.m8i', 'HYP_SHAPE.m8i'],
  ['songs', 'DEFAULT.m8s', 'MODFX_COMB.m8s'],
  ['songs', 'DEFAULT.m8s', 'BOOKMARKS.m8s']
]) {
  const root = `fixtures/6.6.x/${kind}`
  execFileSync(process.execPath, [
    'tools/map-fixture.js',
    `${root}/${baseline}`,
    `${root}/${modified}`,
    `${root}/${modified.slice(0, -4)}.yaml`
  ], { stdio: 'inherit' })
}
