# song_6_5_0

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.5.0/song.ksy](../../../schemas/file-versions/6.5.0/song.ksy).

Byte order: `le`.

Song body for file schema version 6.5.0, containing project settings,
sequencing, instruments, tables, scales, MIDI mappings, and mixer and effects
settings.

File schema version: `6.5.0`.

## Imports

- [instrument_6_0_1](../6.0.1/instrument.md)
- [table_6_0_1](../6.0.1/instrument/table.md)
- [scale_4_0_1](../4.0.1/scale.md)
- [fx_slot](../../common/fx_slot.md)
- [eq_6_5_0](song/eq.md)
- [sequencing_6_5_0](song/sequencing.md)
- [project_6_5_0](song/project.md)
- [mixer_effects_6_5_0](song/mixer_effects.md)
- [midi_mapping_6_5_0](song/midi_mapping.md)

## Contents

- [Layout](#layout)
- [directory](#type-directory)
- [bookmark_row](#type-bookmark_row)
- [eqs](#type-eqs)

## Layout

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `directory` | `0x00..0x7f` | 128 | [directory](#type-directory) | `size`: `128` | Fixed 128-byte directory field. The null-terminated path is followed by the remaining reserved bytes in this field. Post-terminator bytes vary between saves and must be preserved verbatim, not assumed to be zero-filled padding.  |
| `project_settings` | `0x80..0xb0` | 49 | [project_6_5_0::settings](song/project.md#type-settings) | - | Project settings, including tempo, scale selection, and MIDI input settings. |
| `unknown_0` | `0xb1..0xbf` | 15 | bytes | `size`: `15` | Preserved bytes between the Project settings record and Mixer settings. The preceding two unknown bytes belong to the Project settings record.  |
| `mixer` | `0xc0..0xdf` | 32 | [mixer_effects_6_5_0::mixer](song/mixer_effects.md#type-mixer) | - |  |
| `grooves` | `0xe0..0x2df` | 512 | [sequencing_6_5_0::groove](song/sequencing.md#type-groove) | `repeat`: `expr`; `repeat-expr`: `32` | Thirty-two groove definitions. |
| `rows` | `0x2e0..0xadf` | 2048 | [sequencing_6_5_0::row](song/sequencing.md#type-row) | `repeat`: `expr`; `repeat-expr`: `256` | Song rows indexed 0x00 through 0xff. |
| `phrases` | `0xae0..0x9a4f` | 36720 | [sequencing_6_5_0::phrase](song/sequencing.md#type-phrase) | `repeat`: `expr`; `repeat-expr`: `255` | Phrases indexed 0x00 through 0xfe; 0xff is an unset reference. |
| `chains` | `0x9a50..0xba2f` | 8160 | [sequencing_6_5_0::chain](song/sequencing.md#type-chain) | `repeat`: `expr`; `repeat-expr`: `255` | Chains indexed 0x00 through 0xfe; 0xff is an unset reference. |
| `tables` | `0xba30..0x13a2f` | 32768 | [table_6_0_1](../6.0.1/instrument/table.md#layout) | `repeat`: `expr`; `repeat-expr`: `256` | Song table storage. Tables 0x00 through 0x7f correspond to Instruments 0x00 through 0x7f by index.  |
| `instruments` | `0x13a30..0x1a5af` | 27520 | [instrument_6_0_1::data](../6.0.1/instrument.md#type-data) | `repeat`: `expr`; `repeat-expr`: `128` | Song instrument records using the standalone Instrument data layout. |
| `effects_and_scope` | `0x1a5b0..0x1a5cc` | 29 | [mixer_effects_6_5_0::effects_and_scope](song/mixer_effects.md#type-effects_and_scope) | - |  |
| `unknown_1` | `0x1a5cd..0x1a5ef` | 35 | bytes | `size`: `35` | Preserved bytes between Effects/Mix &amp; Limiter Scope storage and the MIDI Mapping table.  |
| `midi_mappings` | `0x1a5f0..0x1a96f` | 896 | [midi_mapping_6_5_0::mapping](song/midi_mapping.md#type-mapping) | `repeat`: `expr`; `repeat-expr`: `128` | Up to 128 MIDI control mappings. |
| `bookmarks` | `0x1a970..0x1aa6f` | 256 | [bookmark_row](#type-bookmark_row) | `repeat`: `expr`; `repeat-expr`: `256` | One chain-cell bookmark bitmask per Song row. |
| `scales` | `0x1aa70..0x1ad4f` | 736 | [scale_4_0_1](../4.0.1/scale.md#layout) | `repeat`: `expr`; `repeat-expr`: `16` | Sixteen embedded Scale records without standalone file headers. |
| `eqs` | `0x1ad50..0x1b697` | 2376 | [eqs](#type-eqs) | - | Instrument and global effect EQ settings. |
| `unknown_2` | `0x1b698 onward` | variable | bytes | `size-eos`: `true` |  |

## Type: directory

Fixed 128-byte Song directory field, including reserved post-terminator space.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `path` | `0x00 onward` | variable | `strz` | `encoding`: `ASCII` |  |
| `trailing` | `dynamic` | variable | bytes | `size`: `_io.size - _io.pos` | Reserved directory-field capacity after the path terminator; preserve stored bytes. |

## Type: bookmark_row

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

## Type: eqs

Contiguous bank of 128 Instrument EQs followed by four global EQs.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `instrument` | `0x00..0x8ff` | 2304 | [eq_6_5_0::settings](song/eq.md#type-settings) | `repeat`: `expr`; `repeat-expr`: `128` | One EQ for each of the 128 Song Instruments. |
| `mix` | `0x900..0x911` | 18 | [eq_6_5_0::settings](song/eq.md#type-settings) | - | Master Mix EQ. |
| `mod_fx` | `0x912..0x923` | 18 | [eq_6_5_0::settings](song/eq.md#type-settings) | - | ModFX EQ. |
| `delay` | `0x924..0x935` | 18 | [eq_6_5_0::settings](song/eq.md#type-settings) | - | Delay EQ. |
| `reverb` | `0x936..0x947` | 18 | [eq_6_5_0::settings](song/eq.md#type-settings) | - | Reverb EQ. |
