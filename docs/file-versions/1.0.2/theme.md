# theme_1_0_2

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/1.0.2/theme.ksy](../../../schemas/file-versions/1.0.2/theme.ksy).

Byte order: `le`.

Body schema for theme files with header schema version 1.0.2.

Verified against M8 6.5.2C theme fixtures. The body contains 13 color triples
and no unaccounted bytes.

RGB versus HSV editing mode is not stored in any M8 file and is outside this
schema.


File schema version: `1.0.2`.

## Contents

- [Layout](theme.md#layout)
- [color](theme.md#type-color)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `background` | `0x00..0x02` | 3 | [color](theme.md#type-color) | - |  |
| `text_empty` | `0x03..0x05` | 3 | [color](theme.md#type-color) | - |  |
| `text_info` | `0x06..0x08` | 3 | [color](theme.md#type-color) | - |  |
| `text_default` | `0x09..0x0b` | 3 | [color](theme.md#type-color) | - |  |
| `text_value` | `0x0c..0x0e` | 3 | [color](theme.md#type-color) | - |  |
| `text_titles` | `0x0f..0x11` | 3 | [color](theme.md#type-color) | - |  |
| `play_markers` | `0x12..0x14` | 3 | [color](theme.md#type-color) | - |  |
| `cursor` | `0x15..0x17` | 3 | [color](theme.md#type-color) | - |  |
| `selection` | `0x18..0x1a` | 3 | [color](theme.md#type-color) | - |  |
| `scope_slider` | `0x1b..0x1d` | 3 | [color](theme.md#type-color) | - |  |
| `meter_low` | `0x1e..0x20` | 3 | [color](theme.md#type-color) | - |  |
| `meter_mid` | `0x21..0x23` | 3 | [color](theme.md#type-color) | - |  |
| `meter_peak` | `0x24..0x26` | 3 | [color](theme.md#type-color) | - |  |

## Type: color

`color`

Three adjacent color component bytes.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `r` | `0x00` | 1 | `u1` | - |  |
| `g` | `0x01` | 1 | `u1` | - |  |
| `b` | `0x02` | 1 | `u1` | - |  |
