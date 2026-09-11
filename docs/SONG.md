# Song

Human-readable schema reference for M8 Song files.

This document starts with fields mapped from the Project and MIDI Settings
pages. Most of the Song body remains preserved as unknown bytes until
additional Song fixtures map those regions.

## Schema

| Name | Value |
| --- | --- |
| File type | Song |
| File extension | `.m8s` |
| M8 file schema version | `6.5.0` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/6.5.0/song.ksy` |
| Total file size | 112326 bytes |
| Header size | 14 bytes |
| Body size | 112312 bytes |

## Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x0000..0x000d` | 14 | [M8 File Header](FILE_HEADER.md) |
| `unknownBeforeProject` | `0x000e..0x008d` | 128 | unknown bytes |
| `project` | `0x008e..0x00be` | 49 | [Project Settings](#project-settings) |
| `unknownAfterProject` | `0x00bf..0x1b6c5` | 112135 | unknown bytes |

### Project Settings

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `transpose` | `0x008e` | 1 | `u1` |
| `tempo` | `0x008f..0x0092` | 4 | `f4` |
| `liveQuantize` | `0x0093` | 1 | [Live Quantize](#live-quantize) |
| `name` | `0x0094..0x009f` | 12 | [Fixed String](#fixed-string) |
| `midiSettings` | `0x00a0..0x00ba` | 27 | [MIDI Settings](#midi-settings) |
| `scale` | `0x00bb` | 1 | `u1` |
| `groove` | `0x00bc` | 1 | `u1` |
| `unknownTrailingState` | `0x00bd..0x00be` | 2 | unknown bytes |

### Live Quantize

The Project page displays `CHAIN LEN` for `0x00`. Values from `0x01` through
`0xff` display as step counts.

| Stored Value | Label |
| --- | --- |
| `0x00` | `CHAIN LEN` |
| `0x01..0xff` | `STEPS` |

### Fixed String

The Project name is stored in a fixed 12-byte range. The visible string may use
only part of the range, and padding bytes must be preserved.

The verified fixture pair shows:

| Fixture | Stored Value |
| --- | --- |
| `DEFAULT.m8s` | `DEFAULT` followed by five `0x00` bytes |
| `PROJECT.m8s` | `PROJECT` followed by five `0x00` bytes |
| `MIDI_SETTING.m8s` | `MIDI_SETTING` with no padding bytes |

### MIDI Settings

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `syncSettings` | `0x00a0..0x00a3` | 4 | [MIDI Sync Settings](#midi-sync-settings) |
| `recordNoteChannel` | `0x00a4` | 1 | `u1` |
| `recordVelocity` | `0x00a5` | 1 | [Boolean](#boolean) |
| `recordDelayKill` | `0x00a6` | 1 | [Record Delay/Kill](#record-delaykill) |
| `controlMapChannel` | `0x00a7` | 1 | [Control Map Channel](#control-map-channel) |
| `songRowCueChannel` | `0x00a8` | 1 | `u1` |
| `trackMidiInputChannels` | `0x00a9..0x00b0` | 8 | `u1[8]` |
| `trackMidiInputInstruments` | `0x00b1..0x00b8` | 8 | `u1[8]` |
| `programChange` | `0x00b9` | 1 | [Boolean](#boolean) |
| `mode` | `0x00ba` | 1 | [MIDI Input Mode](#midi-input-mode) |

### MIDI Sync Settings

The MIDI Settings fixture changed Sync In from `OFF` to `CLK+TRANSP+SPP` and
Sync Out from `OFF` to `TRANSPORT+SPP`. The corresponding byte block changed
from `00 00 00 00` to `01 02 00 02`.

Sync In and Sync Out are each stored as a clock-enabled byte followed by a
transport mode byte. The M8 UI combines those two stored values into one label.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `syncInClock` | `+0x00` | 1 | [Boolean](#boolean) |
| `syncInTransport` | `+0x01` | 1 | [MIDI Sync Transport](#midi-sync-transport) |
| `syncOutClock` | `+0x02` | 1 | [Boolean](#boolean) |
| `syncOutTransport` | `+0x03` | 1 | [MIDI Sync Transport](#midi-sync-transport) |

Documented UI labels:

| Clock | Transport | UI Label |
| --- | --- | --- |
| `0x00` | `0x00` | `OFF` |
| `0x01` | `0x00` | `CLOCK` |
| `0x00` | `0x01` | `TRANSPORT` |
| `0x01` | `0x01` | `CLOCK+TRANSP.` |
| `0x00` | `0x02` | `TRANSPORT+SPP` |
| `0x01` | `0x02` | `CLK+TRANSP+SPP` |

### MIDI Sync Transport

| Stored Value | Label |
| --- | --- |
| `0x00` | `OFF` |
| `0x01` | `TRANSPORT` |
| `0x02` | `TRANSPORT+SPP` |

### Boolean

| Stored Value | Label |
| --- | --- |
| `0x00` | `OFF` |
| `0x01` | `ON` |

### Record Delay/Kill

| Stored Value | Label |
| --- | --- |
| `0x00` | `NONE` |
| `0x01` | `NOTE OFF` |
| `0x02` | `DELAY` |
| `0x03` | `BOTH` |

### Control Map Channel

| Stored Value | Label |
| --- | --- |
| `0x00` | `OFF` |
| `0x01..0x10` | `01..16` |
| `0x11` | `ALL` |

### Track MIDI Input

The M8 manual describes Track MIDI Input as per-track `CHAN` and `INST#`
settings for each of the 8 tracks. The Song file stores those values in two
adjacent 8-byte arrays.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `channels[0..7]` | `0x00a9..0x00b0` | 8 | `u1[8]` |
| `instruments[0..7]` | `0x00b1..0x00b8` | 8 | `u1[8]` |

The `instrument` value is a reference to an instrument index/number.

### MIDI Input Mode

| Stored Value | Label |
| --- | --- |
| `0x00` | `MONO` |
| `0x01` | `LEGATO` |
| `0x02` | `POLY` |

## Notes

- `tempo` is verified as a 32-bit little-endian float. The fixture changed the
  UI value from `120.00` to `121.99`; the stored float changed from `120.0` to
  approximately `121.98999786376953`.
- `scale` is a stored byte value that selects one of the Scales embedded in the
  Song file. The UI label comes from the referenced embedded Scale name, which
  will be mapped later.
- The active MIDI Settings block is verified at `0x00a0..0x00ba`.
- `unknownBeforeProject` changed in the fixture diff, but those changes were
  not mapped to Project UI fields. This region is preserved until targeted Song
  fixtures identify whether it contains save/path state, project state, or other
  fields.
- `unknownTrailingState` changed in the fixture diff but does not yet have a
  Project UI meaning. It is preserved and should be revisited with additional
  Project or Song fixtures.

## Evidence

| Name | Path |
| --- | --- |
| Baseline fixture | `fixtures/6.5.x/songs/DEFAULT.m8s` |
| Project fixture | `fixtures/6.5.x/songs/PROJECT.m8s` |
| Project manifest | `fixtures/6.5.x/songs/PROJECT.yaml` |
| MIDI Settings fixture | `fixtures/6.5.x/songs/MIDI_SETTING.m8s` |
| MIDI Settings manifest | `fixtures/6.5.x/songs/MIDI_SETTING.yaml` |
| Manual | <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699> |
| Verification command | `npm run verify` |

The manifest-driven mapper matched the Project and MIDI Settings field changes
exactly. It also accounts for fixture-changed bytes in explicitly ignored
unknown ranges so page field mapping can be verified without assigning
unsupported meanings to save/state bytes.
