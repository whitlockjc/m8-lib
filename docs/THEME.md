# Theme

Human-readable schema reference for M8 Theme files.

## Schema

| Name | Value |
| --- | --- |
| File type | Theme |
| File extension | `.m8t` |
| M8 file schema version | `1.0.2` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/1.0.2/theme.ksy` |
| Total file size | 53 bytes |
| Header size | 14 bytes |
| Body size | 39 bytes |

## Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x00..0x0d` | 14 | [M8 File Header](FILE_HEADER.md) |
| `background` | `0x0e..0x10` | 3 | [`Color`](#color) |
| `textEmpty` | `0x11..0x13` | 3 | [`Color`](#color) |
| `textInfo` | `0x14..0x16` | 3 | [`Color`](#color) |
| `textDefault` | `0x17..0x19` | 3 | [`Color`](#color) |
| `textValue` | `0x1a..0x1c` | 3 | [`Color`](#color) |
| `textTitles` | `0x1d..0x1f` | 3 | [`Color`](#color) |
| `playMarkers` | `0x20..0x22` | 3 | [`Color`](#color) |
| `cursor` | `0x23..0x25` | 3 | [`Color`](#color) |
| `selection` | `0x26..0x28` | 3 | [`Color`](#color) |
| `scopeSlider` | `0x29..0x2b` | 3 | [`Color`](#color) |
| `meterLow` | `0x2c..0x2e` | 3 | [`Color`](#color) |
| `meterMid` | `0x2f..0x31` | 3 | [`Color`](#color) |
| `meterPeak` | `0x32..0x34` | 3 | [`Color`](#color) |

### Color

Offsets are relative to the start of each `Color`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `r` | `+0x00` | 1 | `u1` |
| `g` | `+0x01` | 1 | `u1` |
| `b` | `+0x02` | 1 | `u1` |

## Notes

- Theme display name is derived from the `.m8t` filename, not stored in the
  file body.
- RGB/HSV editing mode is not stored in the Theme file. If the mode is stored in
  an M8 file, it should be documented with that file's schema after fixture
  evidence identifies its location.

## Evidence

| Name | Path |
| --- | --- |
| Baseline fixture | `fixtures/6.5.x/themes/DEFAULT.m8t` |
| Modified fixture | `fixtures/6.5.x/themes/MODIFIED.m8t` |
| Manifest | `fixtures/6.5.x/themes/MODIFIED.yaml` |
| Verification command | `npm run verify` |

The manifest-driven mapper matched all 39 changed body bytes exactly and
reported zero unaccounted changed bytes.
