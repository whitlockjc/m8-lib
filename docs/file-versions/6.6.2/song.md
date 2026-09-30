# song_6_6_2

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.6.2/song.ksy](../../../schemas/file-versions/6.6.2/song.ksy).

Byte order: `le`.

Song body for file schema version 6.6.2, containing project settings,
sequencing, instruments, tables, scales, MIDI mappings, mixer and effects
settings, and row bookmark colors.


File schema version: `6.6.2`.

## Imports

- [instrument_6_0_2](../6.0.2/instrument.md)
- [table_6_0_1](../6.0.1/instrument/table.md)
- [scale_4_0_1](../4.0.1/scale.md)
- [fx_slot](../../common/fx_slot.md)
- [eq_6_5_0](../6.5.0/song/eq.md)
- [sequencing_6_5_0](../6.5.0/song/sequencing.md)
- [project_6_5_0](../6.5.0/song/project.md)
- [mixer_effects_6_6_2](song/mixer_effects.md)
- [midi_mapping_6_5_0](../6.5.0/song/midi_mapping.md)

## Contents

- [Layout](#layout)
- [eqs](#type-eqs)
- [row_bookmark_colors](#type-row_bookmark_colors)
- [row_bookmark_color](#type-row_bookmark_color)
- [bookmarks](#type-bookmarks)
- [bookmark_row](#type-bookmark_row)
- [directory](#type-directory)
- [tables](#type-tables)
- [instruments](#type-instruments)
- [scales](#type-scales)
- [row_bookmark_color_value (enum)](#enum-row_bookmark_color_value)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `directory` | `0x00..0x7f` | 128 | [directory](#type-directory) | `size`: `128` | Fixed 128-byte directory field. The null-terminated path is followed by the remaining reserved bytes in this field. Post-terminator bytes vary between saves and must be preserved verbatim, not assumed to be zero-filled padding.  |
| `project_settings` | `0x80..0xb0` | 49 | [project_6_5_0::settings](../6.5.0/song/project.md#type-settings) | - | Project settings, including tempo, scale selection, and MIDI input settings. |
| `unknown_0` | `0xb1..0xbf` | 15 | bytes | `size`: `15` | Preserved bytes between the Project settings record and Mixer settings. The preceding two unknown bytes belong to the Project settings record.  |
| `mixer` | `0xc0..0xdf` | 32 | [mixer_effects_6_6_2::mixer](song/mixer_effects.md#type-mixer) | - |  |
| `grooves` | `0xe0..0x2df` | 512 | [sequencing_6_5_0::grooves](../6.5.0/song/sequencing.md#type-grooves) | `repeat`: `32` via `entries` |  |
| `rows` | `0x2e0..0xadf` | 2048 | [sequencing_6_5_0::rows](../6.5.0/song/sequencing.md#type-rows) | `repeat`: `256` via `entries` |  |
| `phrases` | `0xae0..0x9a4f` | 36720 | [sequencing_6_5_0::phrases](../6.5.0/song/sequencing.md#type-phrases) | `repeat`: `255` via `entries` |  |
| `chains` | `0x9a50..0xba2f` | 8160 | [sequencing_6_5_0::chains](../6.5.0/song/sequencing.md#type-chains) | `repeat`: `255` via `entries` |  |
| `tables` | `0xba30..0x13a2f` | 32768 | [tables](#type-tables) | `repeat`: `256` via `entries` | Song table storage. Tables 0x00 through 0x7f correspond to Instruments 0x00 through 0x7f by index.  |
| `instruments` | `0x13a30..0x1a5af` | 27520 | [instruments](#type-instruments) | `repeat`: `128` via `entries` |  |
| `effects_and_scope` | `0x1a5b0..0x1a5cc` | 29 | [mixer_effects_6_6_2::effects_and_scope](song/mixer_effects.md#type-effects_and_scope) | - |  |
| `unknown_1` | `0x1a5cd..0x1a5ef` | 35 | bytes | `size`: `35` | Preserved bytes between Effects/Mix &amp; Limiter Scope storage and the MIDI Mapping table.  |
| `midi_mappings` | `0x1a5f0..0x1a96f` | 896 | [midi_mapping_6_5_0::mappings](../6.5.0/song/midi_mapping.md#type-mappings) | `repeat`: `128` via `entries` |  |
| `bookmarks` | `0x1a970..0x1aa6f` | 256 | [bookmarks](#type-bookmarks) | `repeat`: `256` via `entries` |  |
| `scales` | `0x1aa70..0x1ad4f` | 736 | [scales](#type-scales) | `repeat`: `16` via `entries` |  |
| `eqs` | `0x1ad50..0x1b697` | 2376 | [eqs](#type-eqs) | - | Instrument and global effect EQ settings. |
| `unknown_2` | `0x1b698..0x1b6b7` | 32 | bytes | `size`: `32` | Preserved 32-byte region present in both 6.5.0 and 6.6.2 Songs. |
| `row_bookmark_colors` | `0x1b6b8..0x1b7b7` | 256 | [row_bookmark_colors](#type-row_bookmark_colors) | `repeat`: `256` via `entries` | Added in 6.6.2 at absolute offset 0x1b6c6. One color code per Song row, independent of chain-cell bookmark bitmasks.  |

## Type: eqs

`eqs`

Contiguous bank of 128 Instrument EQs followed by four global EQs.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `instrument` | `0x00..0x8ff` | 2304 | [eq_6_5_0::settings](../6.5.0/song/eq.md#type-settings) | `repeat`: `expr`; `repeat-expr`: `128` | One EQ for each of the 128 Song Instruments. |
| `mix` | `0x900..0x911` | 18 | [eq_6_5_0::settings](../6.5.0/song/eq.md#type-settings) | - | Master Mix EQ. |
| `mod_fx` | `0x912..0x923` | 18 | [eq_6_5_0::settings](../6.5.0/song/eq.md#type-settings) | - | ModFX EQ. |
| `delay` | `0x924..0x935` | 18 | [eq_6_5_0::settings](../6.5.0/song/eq.md#type-settings) | - | Delay EQ. |
| `reverb` | `0x936..0x947` | 18 | [eq_6_5_0::settings](../6.5.0/song/eq.md#type-settings) | - | Reverb EQ. |

## Type: row_bookmark_colors

`row_bookmark_colors`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0xff` | 256 | [row_bookmark_color](#type-row_bookmark_color) | `repeat`: `expr`; `repeat-expr`: `256` |  |

## Type: row_bookmark_color

`row_bookmark_color`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `color` | `0x00` | 1 | `u1`; [row_bookmark_color_value](#enum-row_bookmark_color_value) | - |  |

## Type: bookmarks

`bookmarks`

Song View chain-cell bookmarks, with one bitmask byte per Song row.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0xff` | 256 | [bookmark_row](#type-bookmark_row) | `repeat`: `expr`; `repeat-expr`: `256` |  |

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

## Type: directory

`directory`

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
Instruments 0x00 through 0x7f by matching index.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x7fff` | 32768 | [table_6_0_1](../6.0.1/instrument/table.md#layout) | `repeat`: `expr`; `repeat-expr`: `256` |  |

## Type: instruments

`instruments`

Song instrument storage at absolute offsets 0x13a3e..0x1a5bd. The region
contains 128 fixed 215-byte instrument records using the same structure as
the instrument portion of a standalone Instrument file.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x6b7f` | 27520 | [instrument_6_0_2::data](../6.0.2/instrument.md#type-data) | `repeat`: `expr`; `repeat-expr`: `128` |  |

## Type: scales

`scales`

Sixteen embedded Scale body records without standalone Scale file headers.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x2df` | 736 | [scale_4_0_1](../4.0.1/scale.md#layout) | `repeat`: `expr`; `repeat-expr`: `16` |  |

## Enum: row_bookmark_color_value

`row_bookmark_color_value`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `unselected` |  |  |
| `0x01` | `text_empty` | TEXT:EMPTY |  |
| `0x02` | `text_info` | TEXT:INFO |  |
| `0x03` | `text_default` | TEXT:DEFAULT |  |
| `0x04` | `text_value` | TEXT:VALUE |  |
| `0x05` | `text_titles` | TEXT:TITLES |  |
| `0x06` | `play_markers` | PLAY MARKERS |  |
| `0x07` | `cursor` | CURSOR |  |
| `0x08` | `selection` | SELECTION |  |
| `0x09` | `scope_slider` | SCOPE/SLIDER |  |
| `0x0a` | `meter_low` | METER LOW |  |
| `0x0b` | `meter_mid` | METER MID |  |
| `0x0c` | `meter_peak` | METER PEAK |  |
| `0x11` | `text_empty_arrows` | TEXT:EMPTY &gt;&lt; |  |
| `0x12` | `text_info_arrows` | TEXT:INFO &gt;&lt; |  |
| `0x13` | `text_default_arrows` | TEXT:DEFAULT &gt;&lt; |  |
| `0x14` | `text_value_arrows` | TEXT:VALUE &gt;&lt; |  |
| `0x15` | `text_titles_arrows` | TEXT:TITLES &gt;&lt; |  |
| `0x16` | `play_markers_arrows` | PLAY MARKER &gt;&lt; |  |
| `0x17` | `cursor_arrows` | CURSOR &gt;&lt; |  |
| `0x18` | `selection_arrows` | SELECTION &gt;&lt; |  |
| `0x19` | `scope_slider_arrows` | SCOPE/SLIDER &gt;&lt; |  |
| `0x1a` | `meter_low_arrows` | METER LOW &gt;&lt; |  |
| `0x1b` | `meter_mid_arrows` | METER MID &gt;&lt; |  |
| `0x1c` | `meter_peak_arrows` | METER PEAK &gt;&lt; |  |
