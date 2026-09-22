#!/usr/bin/env node

const fs = require('node:fs')

const HEADER_SIZE = 14
const INSTRUMENT_SIZE = 215
const TABLE_SIZE = 128
const TABLE_COUNT = 256
const INSTRUMENT_COUNT = 128
const TABLES_OFFSET = 0xba3e
const INSTRUMENTS_OFFSET = 0x13a3e

function fail (message) {
  throw new Error(message)
}

function read (path) {
  return fs.readFileSync(path)
}

function standaloneParts (path) {
  const bytes = read(path)
  const expectedSize = HEADER_SIZE + INSTRUMENT_SIZE + TABLE_SIZE

  if (bytes.length !== expectedSize) {
    fail(`${path}: expected ${expectedSize} bytes, found ${bytes.length}`)
  }

  return {
    instrument: bytes.subarray(HEADER_SIZE, HEADER_SIZE + INSTRUMENT_SIZE),
    table: bytes.subarray(HEADER_SIZE + INSTRUMENT_SIZE)
  }
}

function verifyEmbeddedInstrument (song, index, standalonePath) {
  const standalone = standaloneParts(standalonePath).instrument
  const offset = INSTRUMENTS_OFFSET + (index * INSTRUMENT_SIZE)
  const embedded = song.subarray(offset, offset + INSTRUMENT_SIZE)

  for (let relativeOffset = 0; relativeOffset < INSTRUMENT_SIZE; relativeOffset++) {
    const isName = relativeOffset >= 1 && relativeOffset <= 12

    if (isName) {
      if (embedded[relativeOffset] !== 0xff) {
        fail(`instruments[${index}].name: expected unset byte at +0x${relativeOffset.toString(16)}`)
      }
    } else if (embedded[relativeOffset] !== standalone[relativeOffset]) {
      fail(`instruments[${index}]: standalone mismatch at +0x${relativeOffset.toString(16)}`)
    }
  }
}

function main () {
  const song = read('fixtures/6.5.x/songs/INSTRUMENTS.m8s')
  const wav = standaloneParts('fixtures/6.5.x/instruments/WAV_DEFAULT.m8i')

  if (INSTRUMENTS_OFFSET - TABLES_OFFSET !== TABLE_COUNT * TABLE_SIZE) {
    fail('Song Table region constants do not describe 256 128-byte records')
  }

  for (let index = 0; index < TABLE_COUNT; index++) {
    const offset = TABLES_OFFSET + (index * TABLE_SIZE)
    const table = song.subarray(offset, offset + TABLE_SIZE)

    if (!table.equals(wav.table)) {
      fail(`tables[${index}]: does not match the standalone default Table`)
    }
  }

  verifyEmbeddedInstrument(song, 0, 'fixtures/6.5.x/instruments/WAV_DEFAULT.m8i')
  verifyEmbeddedInstrument(song, 127, 'fixtures/6.5.x/instruments/HYP_DEFAULT.m8i')

  const instrumentEnd = INSTRUMENTS_OFFSET + (INSTRUMENT_COUNT * INSTRUMENT_SIZE)
  if (instrumentEnd !== 0x1a5be) {
    fail('Song Instrument region does not end at the Effects & Scope boundary')
  }

  console.log('embedded_instruments\tok')
  console.log(`tables\t${TABLE_COUNT}\t${TABLE_SIZE} bytes each`)
  console.log(`instruments\t${INSTRUMENT_COUNT}\t${INSTRUMENT_SIZE} bytes each`)
  console.log('standalone_comparisons\tWAV_DEFAULT.m8i,HYP_DEFAULT.m8i')
}

main()
