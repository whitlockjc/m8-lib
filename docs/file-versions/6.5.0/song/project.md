# song_project_6_5_0

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.5.0/song/project.ksy](../../../../schemas/file-versions/6.5.0/song/project.ksy).

Byte order: `le`.

Project page and MIDI Settings storage for Song file schema version 6.5.0.
The Song body determines the Project settings position.


File schema version: `6.5.0`.

## Contents

- [Layout](#layout)
- [project_settings](#type-project_settings)
- [midi_settings](#type-midi_settings)
- [midi_sync_settings](#type-midi_sync_settings)
- [midi_sync_transport (enum)](#enum-midi_sync_transport)
- [record_delay_kill (enum)](#enum-record_delay_kill)
- [midi_input_mode (enum)](#enum-midi_input_mode)

## Layout

Root record.



## Type: project_settings

`project_settings`

Project page settings.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `transpose` | `0x00` | 1 | `u1` | - | Project transpose value. |
| `tempo` | `0x01..0x04` | 4 | `f4` | - | Song tempo as a 32-bit little-endian float.  |
| `live_quantize` | `0x05` | 1 | `u1` | - | 0x00 displays as CHAIN LEN. Values from 0x01 through 0xff display as step counts.  |
| `name` | `0x06..0x11` | 12 | bytes | `size`: `12` | Fixed-size byte range for the Project name. Padding bytes are preserved as stored.  |
| `midi_settings` | `0x12..0x2c` | 27 | [midi_settings](#type-midi_settings) | - | Current Song MIDI input and sync settings. |
| `scale` | `0x2d` | 1 | `u1` | - | Project page Scale selector and Scale View key storage. The high nibble stores the key index; the low nibble stores the embedded Scale index. Key index, Scale index, and the selected Scale definition are distinct values.  |
| `groove` | `0x2e` | 1 | `u1` | - | Index of the selected Song groove. |
| `unknown` | `0x2f..0x30` | 2 | bytes | `size`: `2` | Preserved bytes of unknown purpose.  |

## Type: midi_settings

`midi_settings`

MIDI Settings page storage.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `sync_settings` | `0x00..0x03` | 4 | [midi_sync_settings](#type-midi_sync_settings) | - | Two-byte Sync In and two-byte Sync Out storage. Each setting is represented as a clock-enabled boolean plus a transport mode byte.  |
| `record_note_channel` | `0x04` | 1 | `u1` | - | Displayed as decimal in the M8 UI. |
| `record_velocity` | `0x05` | 1 | `u1` | - | 0x01 means ON; 0x00 means OFF.  |
| `record_delay_kill` | `0x06` | 1 | `u1`; [record_delay_kill](#enum-record_delay_kill) | - | MIDI recording delay and note-off handling mode. |
| `control_map_channel` | `0x07` | 1 | `u1` | - | 0x00 means OFF, 0x11 means ALL, and 0x01 through 0x10 display as decimal channels 01 through 16.  |
| `song_row_cue_channel` | `0x08` | 1 | `u1` | - | Displayed as decimal in the M8 UI. |
| `track_midi_input_channels` | `0x09..0x10` | 8 | `u1` | `repeat`: `expr`; `repeat-expr`: `8` | MIDI channel for each of the 8 tracks. Displayed as decimal in the M8 UI.  |
| `track_midi_input_instruments` | `0x11..0x18` | 8 | `u1` | `repeat`: `expr`; `repeat-expr`: `8` | Instrument index/number for each of the 8 tracks. |
| `program_change` | `0x19` | 1 | `u1` | - | 0x01 means ON; 0x00 means OFF.  |
| `mode` | `0x1a` | 1 | `u1`; [midi_input_mode](#enum-midi_input_mode) | - | MIDI input mode. |

## Type: midi_sync_settings

`midi_sync_settings`

Sync In and Sync Out storage. The M8 UI combines each clock boolean and
transport byte into one displayed label.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `sync_in_clock` | `0x00` | 1 | `u1` | - | 0x01 means clock enabled; 0x00 means clock disabled.  |
| `sync_in_transport` | `0x01` | 1 | `u1`; [midi_sync_transport](#enum-midi_sync_transport) | - |  |
| `sync_out_clock` | `0x02` | 1 | `u1` | - | 0x01 means clock enabled; 0x00 means clock disabled.  |
| `sync_out_transport` | `0x03` | 1 | `u1`; [midi_sync_transport](#enum-midi_sync_transport) | - |  |

## Enum: midi_sync_transport

`midi_sync_transport`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `transport` | TRANSPORT |  |
| `0x02` | `transport_spp` | TRANSPORT+SPP |  |

## Enum: record_delay_kill

`record_delay_kill`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `none` | NONE |  |
| `0x01` | `note_off` | NOTE OFF |  |
| `0x02` | `delay` | DELAY |  |
| `0x03` | `both` | BOTH |  |

## Enum: midi_input_mode

`midi_input_mode`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `mono` | MONO |  |
| `0x01` | `legato` | LEGATO |  |
| `0x02` | `poly` | POLY |  |
