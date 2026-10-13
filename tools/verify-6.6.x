#!/usr/bin/env node

const { execFileSync } = require('node:child_process')

for (const [kind, baseline, modified] of [
  ['instruments', 'HYP_DEFAULT.m8i', 'HYP_SHAPE.m8i'],
  ['instruments', 'HYP_EMB_A.m8i', 'HYP_EMB_B.m8i'],
  ['songs', 'DEFAULT.m8s', 'MODFX_COMB.m8s'],
  ['songs', 'DEFAULT.m8s', 'BOOKMARKS.m8s'],
  ['songs', 'HYP_EMB_A.m8s', 'HYP_EMB_B.m8s'],
  ['scales', 'SCALE_A.m8n', 'SCALE_B.m8n'],
  ['songs', 'SCALE_A.m8s', 'SCALE_B.m8s']
]) {
  const root = `fixtures/6.6.x/${kind}`
  execFileSync(process.execPath, [
    'tools/map-fixture.js',
    `${root}/${baseline}`,
    `${root}/${modified}`,
    `${root}/${modified.slice(0, -4)}.yaml`
  ], { stdio: 'inherit' })
}
