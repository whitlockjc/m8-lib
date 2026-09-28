const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const YAML = require('yaml')
const { load, resolve } = require('./ksy-layout')
const targets = require('./doc-targets.json')

const root = path.resolve(__dirname, '..')
const kinds = ['instrument', 'scale', 'song', 'theme']

function targetFor (firmware) {
  const target = targets[firmware]
  assert.ok(target, `unsupported firmware target: ${firmware}`)
  assert.equal(target.fixtureRoot, `fixtures/${firmware}`, `${firmware}: fixture root must match firmware range`)
  assert.equal(target.entry, `schemas/${firmware}.ksy`, `${firmware}: entry must match firmware range`)
  assert.ok(target.verifiedFirmware.startsWith(firmware.slice(0, -1)), `${firmware}: invalid verified firmware`)
  for (const key of ['fixtureChecks', 'parsedFixtures']) {
    assert.ok(target[key] && fs.existsSync(path.join(root, target[key])), `${firmware}: missing ${key}`)
  }
  return target
}

function schemaVersions (target) {
  const entry = load(path.join(root, target.entry))
  const cases = entry.data.seq.find(field => field.id === 'body')?.type?.cases
  assert.ok(cases, `${target.entry}: missing file-kind dispatch`)
  const versions = new Map()
  for (const kind of kinds) {
    const name = cases[`file_header::file_kind::${kind}`]
    assert.ok(name, `${target.entry}: missing ${kind} case`)
    const [owner] = resolve(entry, name)
    const relative = path.relative(path.join(root, 'schemas', 'file-versions'), owner.file)
    assert.ok(!relative.startsWith('..'), `${target.entry}: ${kind} must resolve to a file-version component`)
    versions.set(kind, relative.split(path.sep)[0])
  }
  return versions
}

function fixtureFiles (target) {
  const directory = path.join(root, target.fixtureRoot)
  assert.ok(fs.existsSync(directory), `missing fixture directory ${directory}`)
  const extensions = new Set(['.m8i', '.m8n', '.m8s', '.m8t'])
  const walk = dir => fs.readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
    const file = path.join(dir, entry.name)
    return entry.isDirectory() ? walk(file) : extensions.has(path.extname(file)) ? [file] : []
  })
  return walk(directory).sort()
}

function verifyFixtureMetadata (target) {
  const directory = path.join(root, target.fixtureRoot)
  const manifests = []
  const walk = dir => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const file = path.join(dir, entry.name)
      if (entry.isDirectory()) walk(file)
      else if (entry.name.endsWith('.yaml')) manifests.push(file)
    }
  }
  walk(directory)
  assert.ok(manifests.length, `${target.fixtureRoot}: no fixture manifests`)
  const range = path.basename(target.fixtureRoot).slice(0, -1)
  for (const file of manifests) {
    const manifest = YAML.parse(fs.readFileSync(file, 'utf8'))
    assert.ok(typeof manifest?.firmware === 'string' && manifest.firmware.startsWith(range),
      `${file}: firmware must match ${path.basename(target.fixtureRoot)}`)
    assert.ok(Array.isArray(manifest.changes), `${file}: missing changes`)
  }
  return manifests.length
}

function unregisteredFixtureRoots (directory = path.join(root, 'fixtures')) {
  return fs.readdirSync(directory, { withFileTypes: true })
    .filter(entry => entry.isDirectory() && /^\d+\.\d+\.x$/.test(entry.name) && !targets[entry.name])
    .map(entry => entry.name).sort()
}

module.exports = { targets, targetFor, schemaVersions, fixtureFiles, verifyFixtureMetadata, unregisteredFixtureRoots, kinds }
