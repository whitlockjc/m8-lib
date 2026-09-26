# song_6_5_0

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.5.0/song.ksy](../../../schemas/file-versions/6.5.0/song.ksy).

Byte order: `le`.

Body schema for song files with header schema version 6.5.0.

Initial schema verified against M8 6.5.2C Project, MIDI Settings, Song View,
Phrase View, Bookmarks, Chain View, Scales View, Mixer, Grooves, Effects
Settings, Mix & Limiter Scope, Instrument EQs, Mix EQ, ModFX EQ, Delay EQ, Reverb EQ, and
MIDI Mapping, Instrument, and Table fixtures. The Project settings, MIDI Settings,
Song rows, Phrases, Bookmarks, Chains, Tables, Instruments, embedded Scales,
Mixer, Grooves, Effects Settings, Mix & Limiter Scope, Instrument EQs, Mix EQ, ModFX EQ, Delay
EQ, Reverb EQ, and MIDI Mapping regions are partially mapped. Remaining Song
regions are preserved as raw bytes until future fixtures provide evidence for
their layout.


File schema version: `6.5.0`.

## Imports

- [instrument_6_0_1](../6.0.1/instrument.md)
- [instrument_table_6_0_1](../6.0.1/instrument/table.md)
- [scale_4_0_1](../4.0.1/scale.md)
- [fx_slot](../../common/fx_slot.md)
- [song_eq_6_5_0](song/eq.md)
- [song_sequencing_6_5_0](song/sequencing.md)
- [song_project_6_5_0](song/project.md)
- [song_mixer_effects_6_5_0](song/mixer_effects.md)
- [song_midi_mapping_6_5_0](song/midi_mapping.md)

## Contents

- [Layout](song.md#layout)
- [bookmarks](song.md#type-bookmarks)
- [bookmark_row](song.md#type-bookmark_row)
- [directory_region](song.md#type-directory_region)
- [tables](song.md#type-tables)
- [instruments](song.md#type-instruments)
- [embedded_scales](song.md#type-embedded_scales)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `directory_region` | `0x00..0x7f` | 128 | [directory_region](song.md#type-directory_region) | `size`: `128` | Fixed 128-byte directory field. The null-terminated path is followed by the remaining reserved bytes in this field. The path is /Songs/6_5_X/ in current 6.5.x Song fixtures. Post-terminator bytes vary between saves and must be preserved verbatim, not assumed to be zero-filled padding.  |
| `project` | `0x80..0xb0` | 49 | [song_project_6_5_0::project_settings](song/project.md#type-project_settings) | - |  |
| `unknown_between_project_and_mixer` | `0xb1..0xbf` | 15 | bytes | `size`: `15` | Preserved bytes between Project settings and Mixer settings. |
| `mixer` | `0xc0..0xdf` | 32 | [song_mixer_effects_6_5_0::mixer_settings](song/mixer_effects.md#type-mixer_settings) | - |  |
| `grooves` | `0xe0..0x2df` | 512 | [song_sequencing_6_5_0::grooves](song/sequencing.md#type-grooves) | - |  |
| `rows` | `0x2e0..0xadf` | 2048 | [song_sequencing_6_5_0::song_rows](song/sequencing.md#type-song_rows) | - |  |
| `phrases` | `0xae0..0x9a4f` | 36720 | [song_sequencing_6_5_0::phrases](song/sequencing.md#type-phrases) | - |  |
| `chains` | `0x9a50..0xba2f` | 8160 | [song_sequencing_6_5_0::chains](song/sequencing.md#type-chains) | - |  |
| `tables` | `0xba30..0x13a2f` | 32768 | [tables](song.md#type-tables) | - | Song table storage. Record boundaries and default bytes are verified by INSTRUMENTS.m8s. Tables 0x00 through 0x7f are associated by matching index with Instruments 0x00 through 0x7f.  |
| `instruments` | `0x13a30..0x1a5af` | 27520 | [instruments](song.md#type-instruments) | - |  |
| `effects_and_scope` | `0x1a5b0..0x1a5cc` | 29 | [song_mixer_effects_6_5_0::effects_and_scope_settings](song/mixer_effects.md#type-effects_and_scope_settings) | - |  |
| `unknown_between_effects_and_scope_and_midi_mappings` | `0x1a5cd..0x1a5ef` | 35 | bytes | `size`: `35` | Preserved bytes between Effects/Mix &amp; Limiter Scope storage and the MIDI Mapping table.  |
| `midi_mappings` | `0x1a5f0..0x1a96f` | 896 | [song_midi_mapping_6_5_0::midi_mappings](song/midi_mapping.md#type-midi_mappings) | - |  |
| `bookmarks` | `0x1a970..0x1aa6f` | 256 | [bookmarks](song.md#type-bookmarks) | - |  |
| `scales` | `0x1aa70..0x1ad4f` | 736 | [embedded_scales](song.md#type-embedded_scales) | - |  |
| `instrument_eqs` | `0x1ad50..0x1b64f` | 2304 | [song_eq_6_5_0::instrument_eqs](song/eq.md#type-instrument_eqs) | - |  |
| `mix_eq` | `0x1b650..0x1b661` | 18 | [song_eq_6_5_0::eq_settings](song/eq.md#type-eq_settings) | - |  |
| `mod_fx_eq` | `0x1b662..0x1b673` | 18 | [song_eq_6_5_0::eq_settings](song/eq.md#type-eq_settings) | - |  |
| `delay_eq` | `0x1b674..0x1b685` | 18 | [song_eq_6_5_0::eq_settings](song/eq.md#type-eq_settings) | - |  |
| `reverb_eq` | `0x1b686..0x1b697` | 18 | [song_eq_6_5_0::eq_settings](song/eq.md#type-eq_settings) | - |  |
| `unknown_after_reverb_eq` | `0x1b698 onward` | variable | bytes | `size-eos`: `true` |  |

## Type: bookmarks

`bookmarks`

Song View bookmark storage. Offsets are relative to absolute file offset
0x1a97e in 6.5.x fixtures. The M8 stores one bitmask byte per Song row.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0xff` | 256 | [bookmark_row](song.md#type-bookmark_row) | `repeat`: `expr`; `repeat-expr`: `256` |  |

## Type: bookmark_row

`bookmark_row`

Bookmark state for one Song row. Bits 0..7 correspond to tracks 1..8.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `track_mask` | `0x00` | 1 | `u1` | - |  |

### Instances

Value expressions do not consume bytes. Positioned instances read the specified location.

| Name | Type | Expression / Position / Rules | Description |
| --- | --- | --- | --- |
| `track_1` | derived | `value`: `(track_mask & 0x01) != 0` |  |
| `track_2` | derived | `value`: `(track_mask & 0x02) != 0` |  |
| `track_3` | derived | `value`: `(track_mask & 0x04) != 0` |  |
| `track_4` | derived | `value`: `(track_mask & 0x08) != 0` |  |
| `track_5` | derived | `value`: `(track_mask & 0x10) != 0` |  |
| `track_6` | derived | `value`: `(track_mask & 0x20) != 0` |  |
| `track_7` | derived | `value`: `(track_mask & 0x40) != 0` |  |
| `track_8` | derived | `value`: `(track_mask & 0x80) != 0` |  |

## Type: directory_region

`directory_region`

Fixed 128-byte Song directory field, including reserved post-terminator space.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `path` | `0x00 onward` | variable | `strz` | `encoding`: `ASCII` |  |
| `trailing` | `dynamic` | variable | bytes | `size`: `_io.size - _io.pos` | Reserved directory-field capacity after the path terminator; preserve stored bytes. |

## Type: tables

`tables`

Song table storage at absolute offsets 0xba3e..0x13a3d. The region contains
256 fixed 128-byte tables using the same table structure appended to a
standalone Instrument file. Tables 0x00 through 0x7f are associated with
Instruments 0x00 through 0x7f by matching index. The purpose of Tables
0x80 through 0xff is not yet documented by this schema. TABLES.m8s
verifies rows 0 and 15 in Tables 0x00 and 0xff.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x7fff` | 32768 | [instrument_table_6_0_1](../6.0.1/instrument/table.md#layout) | `repeat`: `expr`; `repeat-expr`: `256` |  |

## Type: instruments

`instruments`

Song instrument storage at absolute offsets 0x13a3e..0x1a5bd. The region
contains 128 fixed 215-byte instrument records using the same structure as
the instrument portion of a standalone Instrument file.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x6b7f` | 27520 | [instrument_6_0_1::instrument_data](../6.0.1/instrument.md#type-instrument_data) | `repeat`: `expr`; `repeat-expr`: `128` |  |

## Type: embedded_scales

`embedded_scales`

Embedded Scale storage. Offsets are relative to absolute file offset
0x1aa7e in 6.5.x fixtures. The M8 stores 16 Scale body records without
standalone Scale file headers.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x2df` | 736 | [scale_4_0_1](../4.0.1/scale.md#layout) | `repeat`: `expr`; `repeat-expr`: `16` |  |
