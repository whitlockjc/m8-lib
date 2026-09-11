# Song

Human-readable schema reference for M8 Song files.

This document starts with fields mapped from the Project page. Most of the Song
body remains preserved as unknown bytes until additional Song fixtures map those
regions.

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
| `unknownBeforeScale` | `0x00a0..0x00ba` | 27 | unknown bytes |
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

## Notes

- `tempo` is verified as a 32-bit little-endian float. The fixture changed the
  UI value from `120.00` to `121.99`; the stored float changed from `120.0` to
  approximately `121.98999786376953`.
- `scale` is a stored byte value that selects one of the Scales embedded in the
  Song file. The UI label comes from the referenced embedded Scale name, which
  will be mapped later.
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
| Modified fixture | `fixtures/6.5.x/songs/PROJECT.m8s` |
| Manifest | `fixtures/6.5.x/songs/PROJECT.yaml` |
| Verification command | `npm run verify` |

The manifest-driven mapper matched the Project page field changes exactly. It
also accounts for fixture-changed bytes in explicitly ignored unknown ranges so
the Project field mapping can be verified without assigning unsupported
meanings to save/state bytes.
