# song_eq_6_5_0

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.5.0/song/eq.ksy](../../../../schemas/file-versions/6.5.0/song/eq.ksy).

Byte order: `le`.

Shared EQ layout for Song Instrument banks and Mix, Mod FX, Delay, and
Reverb EQs in file schema version 6.5.0.


File schema version: `6.5.0`.

## Contents

- [Layout](eq.md#layout)
- [eq_settings](eq.md#type-eq_settings)
- [instrument_eqs](eq.md#type-instrument_eqs)
- [eq_band](eq.md#type-eq_band)
- [eq_filter_type (enum)](eq.md#enum-eq_filter_type)
- [eq_filter_mode (enum)](eq.md#enum-eq_filter_mode)

## Layout

Root record.



## Type: eq_settings

`eq_settings`

Three-band EQ storage. Each known EQ uses three adjacent 6-byte band
records.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `low_band` | `0x00..0x05` | 6 | [eq_band](eq.md#type-eq_band) | - |  |
| `mid_band` | `0x06..0x0b` | 6 | [eq_band](eq.md#type-eq_band) | - |  |
| `high_band` | `0x0c..0x11` | 6 | [eq_band](eq.md#type-eq_band) | - |  |

## Type: instrument_eqs

`instrument_eqs`

128 assignable Instrument EQ banks, each with the standard 18-byte EQ layout.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x8ff` | 2304 | [eq_settings](eq.md#type-eq_settings) | `repeat`: `expr`; `repeat-expr`: `128` |  |

## Type: eq_band

`eq_band`

Six-byte EQ band record. The type and mode are packed into one byte: bits
0..4 hold the filter type and bits 5..7 hold the filter mode. Frequency
is stored as an unsigned little-endian integer. Gain is stored as signed
hundredths, so 10.50 is stored as 1050.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type_and_mode` | `0x00` | 1 | `u1` | - |  |
| `frequency` | `0x01..0x02` | 2 | `u2` | - |  |
| `gain` | `0x03..0x04` | 2 | `s2` | - |  |
| `q` | `0x05` | 1 | `u1` | - |  |

### Instances

Value expressions do not consume bytes. Positioned instances read the specified location.

| Name | Type | Expression / Position / Rules | Description |
| --- | --- | --- | --- |
| `filter_type` | derived; [eq_filter_type](eq.md#enum-eq_filter_type) | `value`: `type_and_mode & 0x1f` |  |
| `filter_mode` | derived; [eq_filter_mode](eq.md#enum-eq_filter_mode) | `value`: `type_and_mode >> 5` |  |

## Enum: eq_filter_type

`eq_filter_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `lowcut` | LOWCUT |  |
| `0x01` | `lowshelf` | LOWSHELF |  |
| `0x02` | `bell` | BELL |  |
| `0x03` | `bandpass` | BANDPASS |  |
| `0x04` | `hi_shelf` | HI.SHELF |  |
| `0x05` | `hi_cut` | HI.CUT |  |
| `0x06` | `allpass` | ALLPASS |  |

## Enum: eq_filter_mode

`eq_filter_mode`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `stereo` | STEREO |  |
| `0x01` | `mid` | MID |  |
| `0x02` | `side` | SIDE |  |
| `0x03` | `left` | LEFT |  |
| `0x04` | `right` | RIGHT |  |
