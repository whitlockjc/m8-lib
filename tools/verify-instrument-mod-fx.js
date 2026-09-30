#!/usr/bin/env node

const assert = require('node:assert/strict')
const fs = require('node:fs')
const YAML = require('yaml')

const bytes = fs.readFileSync('fixtures/6.5.x/songs/INST_MODS_FX.m8s')
const baseline = fs.readFileSync('fixtures/6.5.x/songs/DEFAULT.m8s')
const manifest = YAML.parse(fs.readFileSync('fixtures/6.5.x/songs/INST_MODS_FX.yaml', 'utf8'))
const schema = YAML.parse(fs.readFileSync('schemas/file-versions/6.5.0/song/sequencing.ksy', 'utf8'))
const catalog = schema.meta['-fx-instrument-mods']
const commands = schema.enums.instrument_mod_fx_command
const modulation = YAML.parse(fs.readFileSync('schemas/file-versions/6.0.1/instrument/modulation.ksy', 'utf8'))
const types = modulation.enums.modulation_type
const slotsByInstrument = [
  ['ahd_env', 'adsr_env', 'drum_env', 'lfo'],
  ['trig_env', 'tracking']
]

assert.equal(bytes.length, 112326)
assert.equal(baseline.length, bytes.length)
assert.equal(manifest.firmware, '6.5.2C')
assert.equal(manifest.changes.length, 30)
assert.equal(catalog.base, 0x92)
assert.equal(catalog.slots, 4)
assert.equal(catalog['parameters-per-slot'], 5)

for (const [instrument, slots] of slotsByInstrument.entries()) {
  const firstStep = 0x0aee + instrument * 144
  const record = 0x13a3e + instrument * 215
  assert.deepEqual([...bytes.subarray(0x9a5e + instrument * 2, 0x9a60 + instrument * 2)],
    [instrument, 0x00])
  assert.deepEqual([...bytes.subarray(firstStep, firstStep + 3)], [0x24, 0x64, instrument])
  assert.equal(bytes[firstStep + 2], instrument)
  assert.equal(bytes[record], instrument)
  for (const [slot, type] of slots.entries()) {
    const stored = bytes[record + 0x3f + slot * 6] >> 4
    assert.equal(types[stored].id, type, `instrument ${instrument} modulator ${slot + 1}`)
  }
}
assert.deepEqual([...bytes.subarray(0x9a7e, 0x9a80)], [0xff, 0x00])

const seen = new Set()
for (const change of manifest.changes) {
  const { phrase, step, fx, command, value, label } = change
  assert.ok(phrase === 0 || phrase === 1)
  assert.ok(step >= 0 && step < 16)
  assert.ok(fx >= 0 && fx < 3)
  const offset = 0x0aee + phrase * 144 + step * 9 + 3 + fx * 2
  assert.ok(!seen.has(offset), `duplicate FX slot at ${offset}`)
  seen.add(offset)
  assert.deepEqual([...baseline.subarray(offset, offset + 2)], [0xff, 0x00])
  assert.deepEqual([...bytes.subarray(offset, offset + 2)], [command, value],
    `phrase ${phrase} step ${step} FX ${fx}`)
  const slot = Math.floor((command - catalog.base) / catalog['parameters-per-slot'])
  const parameter = (command - catalog.base) % catalog['parameters-per-slot']
  assert.equal(commands[command]?.id, `mod_${slot + 1}_parameter_${parameter + 1}`)
  const type = slotsByInstrument[phrase][slot]
  assert.equal(`${catalog.prefixes[type]?.[parameter]}${slot + 1}`, label)
}

assert.equal(Object.keys(commands).length, 20)
console.log('instrument_mod_fx\tok\t30 fixture slots and 20 schema commands')
