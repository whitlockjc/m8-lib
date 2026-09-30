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
- [midi_mappings](#type-midi_mappings)
- [midi_mapping](#type-midi_mapping)
- [midi_mapping_destination_type (enum)](#enum-midi_mapping_destination_type)

## Layout

Root record.



## Type: midi_mappings

`midi_mappings`

MIDI Mapping page storage. Offsets are relative to absolute file offset
0x1a5fe in 6.5.x fixtures. M8 supports 128 mapping records.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x37f` | 896 | [midi_mapping](#type-midi_mapping) | `repeat`: `expr`; `repeat-expr`: `128` | Up to 128 MIDI control mappings. |

## Type: midi_mapping

`midi_mapping`

Seven-byte MIDI Mapping record. Historical m8-js reference code reads
these fields in this byte order. The 6.5.x MIDI_MAPPING fixture verifies
the record size and table base offset.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `channel` | `0x00` | 1 | `u1` | - | 0x00 is observed for empty mappings. Other values are displayed as decimal MIDI channels in the M8 UI.  |
| `control_number` | `0x01` | 1 | `u1` | - | Observed values include 0x00, 0x7f, 0x80, and 0x81. The M8 UI displays 0x80 as T:X and 0x81 as T:Y in the current fixture.  |
| `destination_type` | `0x02` | 1 | `u1`; [midi_mapping_destination_type](#enum-midi_mapping_destination_type) | - | Raw destination type byte. Observed labels identify the UI destination group. Destination index and parameter interpretation is destination-specific and deferred to the corresponding page schemas.  |
| `destination_index` | `0x03` | 1 | `u1` | - | Index within the destination group; interpretation depends on destination type. |
| `destination_parameter` | `0x04` | 1 | `u1` | - | Parameter within the selected destination; labels depend on destination type. |
| `minimum_value` | `0x05` | 1 | `u1` | - | Lower bound of the mapped parameter range. |
| `maximum_value` | `0x06` | 1 | `u1` | - | Upper bound of the mapped parameter range. |

## Enum: midi_mapping_destination_type

`midi_mapping_destination_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x05` | `instrument` | I |  |
| `0x0b` | `effects` | X |  |
| `0x0d` | `mixer` | M |  |
| `0x19` | `eq` | Q |  |
