#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const os = require('node:os')
const path = require('node:path')
const { execFileSync } = require('node:child_process')
const { targets, targetFor, verifyFixtureMetadata, unregisteredFixtureRoots } = require('./firmware-targets')

const root = path.resolve(__dirname, '..')

function run (command, args, options = {}) {
  execFileSync(command, args, { cwd: root, stdio: 'inherit', ...options })
}

function compiler () {
  try {
    return execFileSync('which', ['kaitai-struct-compiler'], { encoding: 'utf8' }).trim()
  } catch {
    throw new Error('kaitai-struct-compiler is required for full verification')
  }
}

function parseArgs (args) {
  if (args.length === 0) return Object.keys(targets)
  assert.equal(args.length, 2, 'usage: npm run verify -- [--firmware <range>]')
  assert.equal(args[0], '--firmware', 'usage: npm run verify -- [--firmware <range>]')
  targetFor(args[1])
  return [args[1]]
}

function verify (firmwares) {
  const compilerPath = compiler()
  const selected = firmwares.map(firmware => [firmware, targetFor(firmware)])
  for (const directory of unregisteredFixtureRoots()) {
    console.warn(`research_only_fixture_root\t${directory}\tNOT VERIFIED`)
  }

  run(process.execPath, ['tools/verify-docs.js'])
  run(process.execPath, ['tools/generate-docs.js', '--check'])
  run(process.execPath, ['--test', 'tools/generate-docs.test.js', 'tools/ksy-layout.test.js', 'tools/firmware-targets.test.js'])

  for (const [firmware, target] of selected) {
    console.log(`verifying firmware ${firmware} (${target.verifiedFirmware})`)
    console.log(`fixture_manifests\t${verifyFixtureMetadata(target)}`)
    run(process.execPath, ['tools/inspect-headers.js', '--firmware', firmware])
    run(process.execPath, ['tools/verify-header-versions.js', '--firmware', firmware])
    run(path.join(root, target.fixtureChecks), [])

    const temp = fs.mkdtempSync(path.join(os.tmpdir(), `m8-lib-${firmware}-`))
    const schemaDir = path.join(temp, 'schemas')
    try {
      fs.cpSync(path.join(root, 'schemas'), schemaDir, { recursive: true })
      run(compilerPath, ['-t', 'javascript', `${firmware}.ksy`], { cwd: schemaDir })
      run(process.execPath, [target.parsedFixtures, schemaDir], {
        env: { ...process.env, NODE_PATH: [path.join(root, 'node_modules'), process.env.NODE_PATH].filter(Boolean).join(path.delimiter) }
      })
    } finally {
      fs.rmSync(temp, { recursive: true, force: true })
    }
  }
}

if (require.main === module) verify(parseArgs(process.argv.slice(2)))

module.exports = { parseArgs, verify }
