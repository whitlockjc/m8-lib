# Instrument

Human-readable schema reference for M8 Instrument files.

This document starts with the common instrument prefix and the Wavsynth
instrument body. Other instrument types will replace currently unknown ranges as
fixture evidence is collected.

## Schema

| Name | Value |
| --- | --- |
| File type | Instrument |
| File extension | `.m8i` |
| M8 file schema version | `6.0.1` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/6.0.1/instrument.ksy` |
| Total file size | 357 bytes |
| Header size | 14 bytes |
| Body size | 343 bytes |

## Common Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x00..0x0d` | 14 | [M8 File Header](FILE_HEADER.md) |
| `instrumentType` | `0x0e` | 1 | [Instrument Type](#instrument-type) |
| `name` | `0x0f..0x1a` | 12 | [Fixed String](#fixed-string) |
| `transpose` | `0x1b` | 1 | `u1` |
| `tableTic` | `0x1c` | 1 | `u1` |
| `unknownCommon0` | `0x1d..0x1f` | 3 | unknown bytes |
| `typeSpecificBeforeEq` | `0x20..0x4b` | 44 | depends on `instrumentType` |
| `eq` | `0x4c` | 1 | `u1` |
| `unknownTail` | `0x4d..0x164` | 280 | unknown bytes |

The `typeSpecificBeforeEq` layout depends on `instrumentType`. For `none`, this
range is preserved but not documented as meaningful fields, because the M8 UI
does not expose editable `NONE` instrument parameters.

### Instrument Type

The instrument type is stored as one unsigned byte.

| Name | Stored Value |
| --- | --- |
| `wavsynth` | `0x00` |
| `none` | `0xff` |

Additional instrument types will be added only after fixture evidence verifies
their stored values.

### Fixed String

The instrument name is stored in a fixed 12-byte range.

The verified fixtures show both full and padded values:

| Fixture | Stored Value |
| --- | --- |
| `NONE_DEFAULT.m8i` | `NONE_DEFAULT`, filling all 12 bytes |
| `WAV_DEFAULT.m8i` | `WAV_DEFAULT` followed by one `0x00` byte |
| `WAV_PARAMS.m8i` | `WAV_PARAMS` followed by two `0x00` bytes |

## Wavsynth Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `wavsynth` | `0x20..0x24` | 5 | [Wavsynth Parameters](#wavsynth-parameters) |
| `filter` | `0x25..0x27` | 3 | [Filter Parameters](#filter-parameters) |
| `amp` | `0x28..0x2a` | 3 | [Amplification Parameters](#amplification-parameters) |
| `mixer` | `0x2b..0x2e` | 4 | [Mixer Parameters](#mixer-parameters) |
| `unknown2` | `0x2f..0x4b` | 29 | unknown bytes |

### Wavsynth Parameters

Offsets are relative to the start of `wavsynth`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `shape` | `+0x00` | 1 | [Wavsynth Shape](#wavsynth-shape) |
| `size` | `+0x01` | 1 | `u1` |
| `mult` | `+0x02` | 1 | `u1` |
| `warp` | `+0x03` | 1 | `u1` |
| `scan` | `+0x04` | 1 | `u1` |

### Filter Parameters

Offsets are relative to the start of `filter`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `type` | `+0x00` | 1 | [Filter Type](#filter-type) |
| `cutoff` | `+0x01` | 1 | `u1` |
| `resonance` | `+0x02` | 1 | `u1` |

### Amplification Parameters

Offsets are relative to the start of `amp`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `amp` | `+0x00` | 1 | `u1` |
| `limit` | `+0x01` | 1 | [Limit Type](#limit-type) |
| `pan` | `+0x02` | 1 | `u1` |

### Mixer Parameters

Offsets are relative to the start of `mixer`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `dry` | `+0x00` | 1 | `u1` |
| `modFx` | `+0x01` | 1 | `u1` |
| `delay` | `+0x02` | 1 | `u1` |
| `reverb` | `+0x03` | 1 | `u1` |

## Enums

### Filter Type

| Name | Stored Value | Scope |
| --- | --- | --- |
| `OFF` | `0x00` | All instruments |
| `LOWPASS` | `0x01` | All instruments |
| `HIGHPAS` | `0x02` | All instruments |
| `BANDPAS` | `0x03` | All instruments |
| `BANDSTP` | `0x04` | All instruments |
| `LP > HP` | `0x05` | All instruments |
| `ZDF LP` | `0x06` | All instruments |
| `ZDF HP` | `0x07` | All instruments |
| `WAV LP` | `0x08` | Wavsynth only |
| `WAV HP` | `0x09` | Wavsynth only |
| `WAV BP` | `0x0a` | Wavsynth only |
| `WAV BS` | `0x0b` | Wavsynth only |

### Limit Type

| Name | Stored Value |
| --- | --- |
| `CLIP` | `0x00` |
| `SIN` | `0x01` |
| `FOLD` | `0x02` |
| `WRAP` | `0x03` |
| `POST` | `0x04` |
| `POST:AD` | `0x05` |
| `POST:W1` | `0x06` |
| `POST:W2` | `0x07` |
| `POST:W3` | `0x08` |

### Wavsynth Shape

Shape `0x45` is verified by the `WAV_PARAMS.m8i` fixture. Other labels are from
the M8 6.5.2 manual and <https://github.com/whitlockjc/m8-js> reference
material until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `PULSE 12%` | `0x00` |
| `PULSE 25%` | `0x01` |
| `PULSE 50%` | `0x02` |
| `PULSE 75%` | `0x03` |
| `SAW` | `0x04` |
| `TRIANGLE` | `0x05` |
| `SINE` | `0x06` |
| `NOISE PITCHED` | `0x07` |
| `NOISE` | `0x08` |
| `OSC:CRUSH` | `0x09` |
| `OSC:FOLDING` | `0x0a` |
| `OSC:FREQ` | `0x0b` |
| `OSC:FUZZY` | `0x0c` |
| `OSC:GHOST` | `0x0d` |
| `OSC:GRAPHIC` | `0x0e` |
| `OSC:LFOPLAY` | `0x0f` |
| `OSC:LIQUID` | `0x10` |
| `OSC:MORPHING` | `0x11` |
| `OSC:MYSTIC` | `0x12` |
| `OSC:STICKY` | `0x13` |
| `OSC:TIDAL` | `0x14` |
| `OSC:TIDY` | `0x15` |
| `OSC:TUBE` | `0x16` |
| `OSC:UMBRELLA` | `0x17` |
| `OSC:UNWIND` | `0x18` |
| `OSC:VIRAL` | `0x19` |
| `OSC:WAVES` | `0x1a` |
| `BNK:DRIP` | `0x1b` |
| `BNK:FROGGY` | `0x1c` |
| `BNK:INSONIC` | `0x1d` |
| `BNK:RADIUS` | `0x1e` |
| `BNK:SCRATCH` | `0x1f` |
| `BNK:SMOOTH` | `0x20` |
| `BNK:WOBBLE` | `0x21` |
| `HRM:ASYMMTRY` | `0x22` |
| `HRM:BLEEN` | `0x23` |
| `HRM:FRACTAL` | `0x24` |
| `HRM:GENTLE` | `0x25` |
| `HRM:HARMONIC` | `0x26` |
| `HRM:HYPNOTIC` | `0x27` |
| `HRM:ITERATIV` | `0x28` |
| `HRM:MICROWAV` | `0x29` |
| `HRM:PLAITS01` | `0x2a` |
| `HRM:PLAITS02` | `0x2b` |
| `HRM:RISEFALL` | `0x2c` |
| `HRM:TONAL` | `0x2d` |
| `HRM:TWINE` | `0x2e` |
| `EFX:ALIEN` | `0x2f` |
| `EFX:CYBERNET` | `0x30` |
| `EFX:DISORDR` | `0x31` |
| `EFX:FORMANT` | `0x32` |
| `EFX:HYPER` | `0x33` |
| `EFX:JAGGED` | `0x34` |
| `EFX:MIXED` | `0x35` |
| `EFX:MULTIPLY` | `0x36` |
| `EFX:NOWHERE` | `0x37` |
| `EFX:PINBALL` | `0x38` |
| `EFX:RINGS` | `0x39` |
| `EFX:SHIMMER` | `0x3a` |
| `EFX:SPECTRAL` | `0x3b` |
| `EFX:SPOOKY` | `0x3c` |
| `EFX:TRANSFRM` | `0x3d` |
| `EFX:TWISTED` | `0x3e` |
| `EFX:VOCAL` | `0x3f` |
| `EFX:WASHED` | `0x40` |
| `EFX:WONDER` | `0x41` |
| `EFX:WOWEE` | `0x42` |
| `EFX:ZAP` | `0x43` |
| `VOX:BRAIDS` | `0x44` |
| `VOX:VOXSYNTH` | `0x45` |

## Unknown Ranges

| Name | Offset / Range | Size | Status |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1f` | 3 | Preserved until future fixtures map this common region |
| `unusedBodyBeforeEq` | `0x20..0x4b` | 44 | Preserved for `none` and any unmapped instrument type |
| `wavsynth.unknown2` | `0x2f..0x4b` | 29 | Preserved until MODS fixtures map this region |
| `unknownTail` | `0x4d..0x164` | 280 | Preserved until table/sample-path-related regions are mapped |

The `NONE` instrument cannot be meaningfully edited beyond its name, so this
single fixture is used only to verify the `none` instrument type value, the
fixed name location, and preservation of unused bytes. It should not drive a
separate `NONE` parameter model.

## Notes

- Standalone Instrument files and instruments embedded in Song files are
  expected to share the same in-memory representation. This should be verified
  when Song instrument regions are mapped.
- Enumerated values should document both stored representation and UI label.
  Verified instrument type values are `wavsynth = 0x00` and `none = 0xff`.
- `transpose` is modeled as part of the common instrument layout at `0x1b`.
  Verified values are `ON = 0x01` and `OFF = 0x00`.
- `eq` is modeled as part of the common instrument layout at `0x4c`. Verified
  display values are `-- = 0x80` and `7F = 0x7f`.

## Evidence

| Name | Path |
| --- | --- |
| NONE fixture | `fixtures/6.5.x/instruments/NONE_DEFAULT.m8i` |
| Wavsynth baseline fixture | `fixtures/6.5.x/instruments/WAV_DEFAULT.m8i` |
| Wavsynth params fixture | `fixtures/6.5.x/instruments/WAV_PARAMS.m8i` |
| Wavsynth params manifest | `fixtures/6.5.x/instruments/WAV_PARAMS.yaml` |
| Verification command | `npm run verify` |
| M8 manual | <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699>, version 6.5.2, 04/21/2026 |
| Reference material | <https://github.com/whitlockjc/m8-js> |

The `NONE_DEFAULT.m8i` fixture verifies the file header, instrument type byte,
and 12-byte name location.

The `WAV_PARAMS.m8i` fixture verifies common transpose/table TIC values,
Wavsynth params, filter params, amp params, mixer params, and common EQ
assignment. The manifest-driven mapper matched all 24 changed bytes exactly and
reported zero unaccounted changed bytes.
