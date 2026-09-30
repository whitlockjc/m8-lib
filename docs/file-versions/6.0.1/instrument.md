# instrument_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.0.1/instrument.ksy](../../../schemas/file-versions/6.0.1/instrument.ksy).

Byte order: `le`.

Instrument body for file schema version 6.0.1, containing an instrument
record and its table.


File schema version: `6.0.1`.

## Imports

- [instrument_modulation_6_0_1](instrument/modulation.md)
- [instrument_parameters_6_0_1](instrument/parameters.md)
- [instrument_table_6_0_1](instrument/table.md)
- [instrument_wavsynth_6_0_1](instrument/wavsynth.md)
- [instrument_macrosynth_6_0_1](instrument/macrosynth.md)
- [instrument_sampler_6_0_1](instrument/sampler.md)
- [instrument_midi_out_6_0_1](instrument/midi_out.md)
- [instrument_fm_synth_6_0_1](instrument/fm_synth.md)
- [instrument_hypersynth_6_0_1](instrument/hypersynth.md)
- [instrument_external_6_0_1](instrument/external.md)
- [instrument_none_6_0_1](instrument/none.md)

## Contents

- [Layout](#layout)
- [data](#type-data)
- [general_settings](#type-general_settings)
- [unused_params](#type-unused_params)
- [wavsynth_params](#type-wavsynth_params)
- [macrosynth_params](#type-macrosynth_params)
- [sampler_params](#type-sampler_params)
- [midi_out_params](#type-midi_out_params)
- [fm_synth_params](#type-fm_synth_params)
- [hypersynth_params](#type-hypersynth_params)
- [external_params](#type-external_params)
- [standard_tail](#type-standard_tail)
- [none_tail](#type-none_tail)
- [sampler_tail](#type-sampler_tail)
- [hypersynth_tail](#type-hypersynth_tail)
- [modulators](#type-modulators)
- [type (enum)](#enum-type)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `instrument` | `0x00..0xd6` | 215 | [data](#type-data) | - |  |
| `table` | `0xd7..0x156` | 128 | [instrument_table_6_0_1](instrument/table.md#layout) | `repeat`: `16` via `rows` |  |

## Type: data

`data`

Fixed 215-byte instrument record. This record is stored directly in Song
files; standalone Instrument files append one 128-byte instrument table.
The EQ assignment follows the type-specific region.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `general_settings` | `0x00..0x0e` | 15 | [general_settings](#type-general_settings) | - |  |
| `params` | `0x0f..0x3d` | 47 | switch on `general_settings.type`: `type::wavsynth`: [wavsynth_params](#type-wavsynth_params); `type::macrosynth`: [macrosynth_params](#type-macrosynth_params); `type::sampler`: [sampler_params](#type-sampler_params); `type::midi_out`: [midi_out_params](#type-midi_out_params); `type::fm_synth`: [fm_synth_params](#type-fm_synth_params); `type::hypersynth`: [hypersynth_params](#type-hypersynth_params); `type::external`: [external_params](#type-external_params); `type::none`: [unused_params](#type-unused_params) | - | Instrument settings before the common EQ field. |
| `eq` | `0x3e` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --, 0x7f displays as 7F.  |
| `tail` | `0x3f..0xd6` | 152 | switch on `general_settings.type`: `type::sampler`: [sampler_tail](#type-sampler_tail); `type::hypersynth`: [hypersynth_tail](#type-hypersynth_tail); `type::midi_out`: [standard_tail](#type-standard_tail); `type::wavsynth`: [standard_tail](#type-standard_tail); `type::macrosynth`: [standard_tail](#type-standard_tail); `type::fm_synth`: [standard_tail](#type-standard_tail); `type::external`: [standard_tail](#type-standard_tail); `type::none`: [none_tail](#type-none_tail) | - | Instrument-specific tail after the common EQ field. |

## Type: general_settings

`general_settings`

General Instrument Settings prefix. The EQ assignment is stored separately.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type` | `0x00` | 1 | `u1`; [type](#enum-type) | - |  |
| `name` | `0x01..0x0c` | 12 | bytes | `size`: `12` | Fixed-size byte range for the instrument name. Padding bytes are preserved as stored.  |
| `transpose` | `0x0d` | 1 | `u1` | - | Common instrument transpose setting. 0x01 means ON; 0x00 means OFF.  |
| `table_tic` | `0x0e` | 1 | `u1` | - | Common instrument table TIC setting. |

## Type: unused_params

`unused_params`

Preserved bytes between the common instrument prefix and common EQ field
for NONE.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown` | `0x00..0x2e` | 47 | bytes | `size`: `47` |  |

## Type: wavsynth_params

`wavsynth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [instrument_wavsynth_6_0_1::instrument_params](instrument/wavsynth.md#type-instrument_params) | - |  |
| `filter` | `0x08..0x0a` | 3 | [instrument_parameters_6_0_1::filter_params](instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0b..0x0d` | 3 | [instrument_parameters_6_0_1::amp_params](instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0e..0x11` | 4 | [instrument_parameters_6_0_1::mixer_params](instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |

## Type: macrosynth_params

`macrosynth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [instrument_macrosynth_6_0_1::instrument_params](instrument/macrosynth.md#type-instrument_params) | - |  |
| `filter` | `0x08..0x0a` | 3 | [instrument_parameters_6_0_1::filter_params](instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0b..0x0d` | 3 | [instrument_parameters_6_0_1::amp_params](instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0e..0x11` | 4 | [instrument_parameters_6_0_1::mixer_params](instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |

## Type: sampler_params

`sampler_params`

Sampler-specific controls are stored here; the selected sample_path is
another Sampler-specific parameter stored in sampler_tail.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x01` | 2 | bytes | `size`: `2` |  |
| `controls` | `0x02..0x08` | 7 | [instrument_sampler_6_0_1::instrument_params](instrument/sampler.md#type-instrument_params) | - |  |
| `filter` | `0x09..0x0b` | 3 | [instrument_parameters_6_0_1::filter_params](instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0c..0x0e` | 3 | [instrument_parameters_6_0_1::amp_params](instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0f..0x12` | 4 | [instrument_parameters_6_0_1::mixer_params](instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x13..0x2e` | 28 | bytes | `size`: `28` |  |

## Type: midi_out_params

`midi_out_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `params` | `0x00..0x1c` | 29 | [instrument_midi_out_6_0_1::instrument_params](instrument/midi_out.md#type-instrument_params) | - |  |
| `unknown` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |

## Type: fm_synth_params

`fm_synth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x23` | 33 | [instrument_fm_synth_6_0_1::instrument_params](instrument/fm_synth.md#type-instrument_params) | - |  |
| `filter` | `0x24..0x26` | 3 | [instrument_parameters_6_0_1::filter_params](instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x27..0x29` | 3 | [instrument_parameters_6_0_1::amp_params](instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x2a..0x2d` | 4 | [instrument_parameters_6_0_1::mixer_params](instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x2e` | 1 | bytes | `size`: `1` |  |

## Type: hypersynth_params

`hypersynth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0e` | 12 | [instrument_hypersynth_6_0_1::instrument_params](instrument/hypersynth.md#type-instrument_params) | - |  |
| `filter` | `0x0f..0x11` | 3 | [instrument_parameters_6_0_1::filter_params](instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x12..0x14` | 3 | [instrument_parameters_6_0_1::amp_params](instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x15..0x18` | 4 | [instrument_parameters_6_0_1::mixer_params](instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x19..0x2e` | 22 | bytes | `size`: `22` |  |

## Type: external_params

`external_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0f` | 13 | [instrument_external_6_0_1::instrument_params](instrument/external.md#type-instrument_params) | - |  |
| `filter` | `0x10..0x12` | 3 | [instrument_parameters_6_0_1::filter_params](instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x13..0x15` | 3 | [instrument_parameters_6_0_1::amp_params](instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x16..0x19` | 4 | [instrument_parameters_6_0_1::mixer_params](instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x1a..0x2e` | 21 | bytes | `size`: `21` |  |

## Type: standard_tail

`standard_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `unknown` | `0x18..0x97` | 128 | bytes | `size`: `128` |  |

## Type: none_tail

`none_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown` | `0x00..0x97` | 152 | bytes | `size`: `152` |  |

## Type: sampler_tail

`sampler_tail`

Stores shared modulators followed by the Sampler-specific sample_path.
The path and instrument_params belong to the same instrument-specific
configuration despite their noncontiguous storage.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `sample_path` | `0x18..0x97` | 128 | [instrument_sampler_6_0_1::sample_path](instrument/sampler.md#type-sample_path) | `size`: `128` | Selected sample path in a fixed 128-byte field, following the same null-terminated path and preserved trailing-byte convention as the Song directory. The full sample path must be under 128 characters.  |

## Type: hypersynth_tail

`hypersynth_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `chords` | `0x18..0x87` | 112 | [instrument_hypersynth_6_0_1::chord](instrument/hypersynth.md#type-chord) | `repeat`: `expr`; `repeat-expr`: `16` |  |
| `unknown` | `0x88..0x97` | 16 | bytes | `size`: `16` |  |

## Type: modulators

`modulators`

Shared Common Modulation Settings block. Four six-byte slots occupy
standalone offsets 0x4d..0x64 in all seven editable instrument types.
slots[0] is M8 modulation slot 1. NONE preserves the corresponding
bytes as unknown, without assigning modulation semantics.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `slots` | `0x00..0x17` | 24 | [instrument_modulation_6_0_1::slot](instrument/modulation.md#type-slot) | `repeat`: `expr`; `repeat-expr`: `4` |  |

## Enum: type

`type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `wavsynth` | Wavsynth |  |
| `0x01` | `macrosynth` | Macrosynth |  |
| `0x02` | `sampler` | Sampler |  |
| `0x03` | `midi_out` | MIDI Out |  |
| `0x04` | `fm_synth` | FM Synth |  |
| `0x05` | `hypersynth` | Hypersynth |  |
| `0x06` | `external` | External |  |
| `0xff` | `none` | NONE |  |
