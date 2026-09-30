# song_midi_mapping_6_5_0

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.5.0/song/midi_mapping.ksy](../../../../schemas/file-versions/6.5.0/song/midi_mapping.ksy).

Byte order: `le`.

MIDI Mapping records and destination groups for Song file schema version
6.5.0. The Song body determines the 128-entry table position.


File schema version: `6.5.0`.

## Contents

- [Layout](#layout)
- [mappings](#type-mappings)
- [mapping](#type-mapping)
- [destination_type (enum)](#enum-destination_type)

## Layout

Root record.



## Type: mappings

`mappings`

MIDI Mapping page storage containing 128 mapping records.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x37f` | 896 | [mapping](#type-mapping) | `repeat`: `expr`; `repeat-expr`: `128` | Up to 128 MIDI control mappings. |

## Type: mapping

`mapping`

Seven-byte MIDI Mapping record.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `channel` | `0x00` | 1 | `u1` | - | 0x00 represents an empty mapping. Other values are displayed as decimal MIDI channels in the M8 UI.  |
| `control_number` | `0x01` | 1 | `u1` | - | MIDI control number. The M8 UI displays 0x80 as T:X and 0x81 as T:Y.  |
| `destination_type` | `0x02` | 1 | `u1`; [destination_type](#enum-destination_type) | - | Destination group. Index and parameter meanings depend on this type.  |
| `destination_index` | `0x03` | 1 | `u1` | - | Index within the destination group; interpretation depends on destination type. |
| `destination_parameter` | `0x04` | 1 | `u1` | - | Parameter within the selected destination; labels depend on destination type. |
| `minimum_value` | `0x05` | 1 | `u1` | - | Lower bound of the mapped parameter range. |
| `maximum_value` | `0x06` | 1 | `u1` | - | Upper bound of the mapped parameter range. |

## Enum: destination_type

`destination_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x05` | `instrument` | I |  |
| `0x0b` | `effects` | X |  |
| `0x0d` | `mixer` | M |  |
| `0x19` | `eq` | Q |  |
