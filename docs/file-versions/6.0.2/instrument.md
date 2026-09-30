# instrument_6_0_2

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.0.2/instrument.ksy](../../../schemas/file-versions/6.0.2/instrument.ksy).

Byte order: `le`.

Instrument body for file schema version 6.0.2, containing an instrument
record and its table. Hypersynth includes a waveform shape setting.


File schema version: `6.0.2`.

## Imports

- [instrument_modulation_6_0_1](../6.0.1/instrument/modulation.md)
- [instrument_parameters_6_0_1](../6.0.1/instrument/parameters.md)
- [instrument_table_6_0_1](../6.0.1/instrument/table.md)

## Contents

- [Layout](#layout)
- [data](#type-data)
- [general_instrument_settings](#type-general_instrument_settings)
- [unused_body_before_eq](#type-unused_body_before_eq)
- [wavsynth_body_before_eq](#type-wavsynth_body_before_eq)
- [macrosynth_body_before_eq](#type-macrosynth_body_before_eq)
- [sampler_body_before_eq](#type-sampler_body_before_eq)
- [midi_out_body_before_eq](#type-midi_out_body_before_eq)
- [fm_synth_body_before_eq](#type-fm_synth_body_before_eq)
- [hypersynth_body_before_eq](#type-hypersynth_body_before_eq)
- [external_body_before_eq](#type-external_body_before_eq)
- [standard_data_tail](#type-standard_data_tail)
- [none_data_tail](#type-none_data_tail)
- [sampler_data_tail](#type-sampler_data_tail)
- [sample_path_region](#type-sample_path_region)
- [hypersynth_data_tail](#type-hypersynth_data_tail)
- [hypersynth_chord](#type-hypersynth_chord)
- [instrument_modulators](#type-instrument_modulators)
- [wavsynth_modulation_destination (enum)](#enum-wavsynth_modulation_destination)
- [macrosynth_modulation_destination (enum)](#enum-macrosynth_modulation_destination)
- [sampler_modulation_destination (enum)](#enum-sampler_modulation_destination)
- [midi_out_modulation_destination (enum)](#enum-midi_out_modulation_destination)
- [fm_synth_modulation_destination (enum)](#enum-fm_synth_modulation_destination)
- [hypersynth_modulation_destination (enum)](#enum-hypersynth_modulation_destination)
- [external_modulation_destination (enum)](#enum-external_modulation_destination)
- [instrument_type (enum)](#enum-instrument_type)
- [hypersynth_shape (enum)](#enum-hypersynth_shape)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `instrument` | `0x00..0xd6` | 215 | [data](#type-data) | - |  |
| `table` | `0xd7..0x156` | 128 | [instrument_table_6_0_1](../6.0.1/instrument/table.md#layout) | `repeat`: `16` via `rows` |  |

## Type: data

`data`

Fixed 215-byte instrument record. This record is stored directly in Song
files; standalone Instrument files append one 128-byte instrument table.
The EQ assignment follows the type-specific region.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `general_settings` | `0x00..0x0e` | 15 | [general_instrument_settings](#type-general_instrument_settings) | - |  |
| `body_before_eq` | `0x0f..0x3d` | 47 | switch on `general_settings.type`: `instrument_type::wavsynth`: [wavsynth_body_before_eq](#type-wavsynth_body_before_eq); `instrument_type::macrosynth`: [macrosynth_body_before_eq](#type-macrosynth_body_before_eq); `instrument_type::sampler`: [sampler_body_before_eq](#type-sampler_body_before_eq); `instrument_type::midi_out`: [midi_out_body_before_eq](#type-midi_out_body_before_eq); `instrument_type::fm_synth`: [fm_synth_body_before_eq](#type-fm_synth_body_before_eq); `instrument_type::hypersynth`: [hypersynth_body_before_eq](#type-hypersynth_body_before_eq); `instrument_type::external`: [external_body_before_eq](#type-external_body_before_eq); `instrument_type::none`: [unused_body_before_eq](#type-unused_body_before_eq) | - | Instrument-specific body before the common EQ field. |
| `eq` | `0x3e` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --, 0x7f displays as 7F.  |
| `tail` | `0x3f..0xd6` | 152 | switch on `general_settings.type`: `instrument_type::sampler`: [sampler_data_tail](#type-sampler_data_tail); `instrument_type::hypersynth`: [hypersynth_data_tail](#type-hypersynth_data_tail); `instrument_type::midi_out`: [standard_data_tail](#type-standard_data_tail); `instrument_type::wavsynth`: [standard_data_tail](#type-standard_data_tail); `instrument_type::macrosynth`: [standard_data_tail](#type-standard_data_tail); `instrument_type::fm_synth`: [standard_data_tail](#type-standard_data_tail); `instrument_type::external`: [standard_data_tail](#type-standard_data_tail); `instrument_type::none`: [none_data_tail](#type-none_data_tail) | - | Instrument-specific tail after the common EQ field. |

## Type: general_instrument_settings

`general_instrument_settings`

General Instrument Settings prefix. The EQ assignment is stored separately.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type` | `0x00` | 1 | `u1`; [instrument_type](#enum-instrument_type) | - |  |
| `name` | `0x01..0x0c` | 12 | bytes | `size`: `12` | Fixed-size byte range for the instrument name. Padding bytes are preserved as stored.  |
| `transpose` | `0x0d` | 1 | `u1` | - | Common instrument transpose setting. 0x01 means ON; 0x00 means OFF.  |
| `table_tic` | `0x0e` | 1 | `u1` | - | Common instrument table TIC setting. |

## Type: unused_body_before_eq

`unused_body_before_eq`

Preserved bytes between the common instrument prefix and common EQ field
for NONE.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown` | `0x00..0x2e` | 47 | bytes | `size`: `47` |  |

## Type: wavsynth_body_before_eq

`wavsynth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [instrument_parameters_6_0_1::wavsynth_params](../6.0.1/instrument/parameters.md#type-wavsynth_params) | - |  |
| `filter` | `0x08..0x0a` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0b..0x0d` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0e..0x11` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |

## Type: macrosynth_body_before_eq

`macrosynth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [instrument_parameters_6_0_1::macrosynth_params](../6.0.1/instrument/parameters.md#type-macrosynth_params) | - |  |
| `filter` | `0x08..0x0a` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0b..0x0d` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0e..0x11` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |

## Type: sampler_body_before_eq

`sampler_body_before_eq`

Sampler-specific controls are stored here; the selected sample_path is
another Sampler-specific parameter stored in sampler_data_tail.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x01` | 2 | bytes | `size`: `2` |  |
| `controls` | `0x02..0x08` | 7 | [instrument_parameters_6_0_1::sampler_controls](../6.0.1/instrument/parameters.md#type-sampler_controls) | - |  |
| `filter` | `0x09..0x0b` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0c..0x0e` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0f..0x12` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x13..0x2e` | 28 | bytes | `size`: `28` |  |

## Type: midi_out_body_before_eq

`midi_out_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `params` | `0x00..0x1c` | 29 | [instrument_parameters_6_0_1::midi_out_params](../6.0.1/instrument/parameters.md#type-midi_out_params) | - |  |
| `unknown` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |

## Type: fm_synth_body_before_eq

`fm_synth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x23` | 33 | [instrument_parameters_6_0_1::fm_synth_params](../6.0.1/instrument/parameters.md#type-fm_synth_params) | - |  |
| `filter` | `0x24..0x26` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x27..0x29` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x2a..0x2d` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x2e` | 1 | bytes | `size`: `1` |  |

## Type: hypersynth_body_before_eq

`hypersynth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0e` | 12 | [instrument_parameters_6_0_1::hypersynth_params](../6.0.1/instrument/parameters.md#type-hypersynth_params) | - |  |
| `filter` | `0x0f..0x11` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x12..0x14` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x15..0x18` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x19..0x1b` | 3 | bytes | `size`: `3` |  |
| `shape` | `0x1c` | 1 | `u1`; [hypersynth_shape](#enum-hypersynth_shape) | - | Hypersynth waveform shape. |
| `unknown_2` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |

## Type: external_body_before_eq

`external_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0f` | 13 | [instrument_parameters_6_0_1::external_params](../6.0.1/instrument/parameters.md#type-external_params) | - |  |
| `filter` | `0x10..0x12` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x13..0x15` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x16..0x19` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x1a..0x2e` | 21 | bytes | `size`: `21` |  |

## Type: standard_data_tail

`standard_data_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [instrument_modulators](#type-instrument_modulators) | `repeat`: `4` via `slots` |  |
| `unknown` | `0x18..0x97` | 128 | bytes | `size`: `128` |  |

## Type: none_data_tail

`none_data_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown` | `0x00..0x97` | 152 | bytes | `size`: `152` |  |

## Type: sampler_data_tail

`sampler_data_tail`

Stores shared modulators followed by the Sampler-specific sample_path.
The path and sampler_controls belong to the same instrument-specific
configuration despite their noncontiguous storage.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [instrument_modulators](#type-instrument_modulators) | `repeat`: `4` via `slots` |  |
| `sample_path` | `0x18..0x97` | 128 | [sample_path_region](#type-sample_path_region) | `size`: `128` | Selected sample path in a fixed 128-byte field, following the same null-terminated path and preserved trailing-byte convention as the Song directory. The full sample path must be under 128 characters.  |

## Type: sample_path_region

`sample_path_region`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `path` | `0x00 onward` | variable | `strz` | `encoding`: `ASCII` |  |
| `trailing` | `dynamic` | variable | bytes | `size`: `_io.size - _io.pos` | Remaining path-field bytes after the terminator; preserve stored bytes. |

## Type: hypersynth_data_tail

`hypersynth_data_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [instrument_modulators](#type-instrument_modulators) | `repeat`: `4` via `slots` |  |
| `chords` | `0x18..0x87` | 112 | [hypersynth_chord](#type-hypersynth_chord) | `repeat`: `expr`; `repeat-expr`: `16` |  |
| `unknown` | `0x88..0x97` | 16 | bytes | `size`: `16` |  |

## Type: hypersynth_chord

`hypersynth_chord`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `enabled_notes` | `0x00` | 1 | `u1` | - | Bitmask for six chord notes. Bits 0 through 5 indicate whether each corresponding note is enabled.  |
| `notes` | `0x01..0x06` | 6 | [instrument_parameters_6_0_1::hypersynth_chord_notes](../6.0.1/instrument/parameters.md#type-hypersynth_chord_notes) | - |  |

## Type: instrument_modulators

`instrument_modulators`

Shared Common Modulation Settings block. Four six-byte slots occupy
standalone offsets 0x4d..0x64 in all seven editable instrument types.
slots[0] is M8 modulation slot 1. NONE preserves the corresponding
bytes as unknown, without assigning modulation semantics.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `slots` | `0x00..0x17` | 24 | [instrument_modulation_6_0_1::modulation_slot](../6.0.1/instrument/modulation.md#type-modulation_slot) | `repeat`: `expr`; `repeat-expr`: `4` |  |

## Enum: wavsynth_modulation_destination

`wavsynth_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `pitch` | PITCH |  |
| `0x03` | `size` | SIZE |  |
| `0x04` | `mult` | MULT |  |
| `0x05` | `warp` | WARP |  |
| `0x06` | `scan` | SCAN |  |
| `0x07` | `cutoff` | CUTOFF |  |
| `0x08` | `resonance` | RES |  |
| `0x09` | `amp` | AMP |  |
| `0x0a` | `pan` | PAN |  |
| `0x0b` | `mod_amount` | MOD AMT |  |
| `0x0c` | `mod_rate` | MOD RATE |  |
| `0x0d` | `mod_both` | MOD BOTH |  |
| `0x0e` | `mod_binv` | MOD BINV |  |

## Enum: macrosynth_modulation_destination

`macrosynth_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `pitch` | PITCH |  |
| `0x03` | `timbre` | TIMBRE |  |
| `0x04` | `color` | COLOR |  |
| `0x05` | `degrade` | DEGRADE |  |
| `0x06` | `redux` | REDUX |  |
| `0x07` | `cutoff` | CUTOFF |  |
| `0x08` | `resonance` | RES |  |
| `0x09` | `amp` | AMP |  |
| `0x0a` | `pan` | PAN |  |
| `0x0b` | `mod_amount` | MOD AMT |  |
| `0x0c` | `mod_rate` | MOD RATE |  |
| `0x0d` | `mod_both` | MOD BOTH |  |
| `0x0e` | `mod_binv` | MOD BINV |  |

## Enum: sampler_modulation_destination

`sampler_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `pitch` | PITCH |  |
| `0x03` | `loop_start` | LOOP ST |  |
| `0x04` | `length` | LENGTH |  |
| `0x05` | `degrade` | DEGRADE |  |
| `0x06` | `cutoff` | CUTOFF |  |
| `0x07` | `resonance` | RES |  |
| `0x08` | `amp` | AMP |  |
| `0x09` | `pan` | PAN |  |
| `0x0a` | `mod_amount` | MOD AMT |  |
| `0x0b` | `mod_rate` | MOD RATE |  |
| `0x0c` | `mod_both` | MOD BOTH |  |
| `0x0d` | `mod_binv` | MOD BINV |  |

## Enum: midi_out_modulation_destination

`midi_out_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `cc_a` | CCA |  |
| `0x02` | `cc_b` | CCB |  |
| `0x03` | `cc_c` | CCC |  |
| `0x04` | `cc_d` | CCD |  |
| `0x05` | `cc_e` | CCE |  |
| `0x06` | `cc_f` | CCF |  |
| `0x07` | `cc_g` | CCG |  |
| `0x08` | `cc_h` | CCH |  |
| `0x09` | `cc_i` | CCI |  |
| `0x0a` | `cc_j` | CCJ |  |
| `0x0b` | `mod_amount` | MOD AMT |  |
| `0x0c` | `mod_rate` | MOD RATE |  |
| `0x0d` | `mod_both` | MOD BOTH |  |
| `0x0e` | `mod_binv` | MOD BINV |  |

## Enum: fm_synth_modulation_destination

`fm_synth_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `pitch` | PITCH |  |
| `0x03` | `mod_1` | MOD 1 |  |
| `0x04` | `mod_2` | MOD 2 |  |
| `0x05` | `mod_3` | MOD 3 |  |
| `0x06` | `mod_4` | MOD 4 |  |
| `0x07` | `cutoff` | CUTOFF |  |
| `0x08` | `resonance` | RES |  |
| `0x09` | `amp` | AMP |  |
| `0x0a` | `pan` | PAN |  |
| `0x0b` | `mod_amount` | MOD AMT |  |
| `0x0c` | `mod_rate` | MOD RATE |  |
| `0x0d` | `mod_both` | MOD BOTH |  |
| `0x0e` | `mod_binv` | MOD BINV |  |

## Enum: hypersynth_modulation_destination

`hypersynth_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `pitch` | PITCH |  |
| `0x03` | `shift` | SHIFT |  |
| `0x04` | `swarm` | SWARM |  |
| `0x05` | `width` | WIDTH |  |
| `0x06` | `subosc` | SUBOSC |  |
| `0x07` | `cutoff` | CUTOFF |  |
| `0x08` | `resonance` | RES |  |
| `0x09` | `amp` | AMP |  |
| `0x0a` | `pan` | PAN |  |
| `0x0b` | `mod_amount` | MOD AMT |  |
| `0x0c` | `mod_rate` | MOD RATE |  |
| `0x0d` | `mod_both` | MOD BOTH |  |
| `0x0e` | `mod_binv` | MOD BINV |  |

## Enum: external_modulation_destination

`external_modulation_destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `cutoff` | CUTOFF |  |
| `0x03` | `resonance` | RES |  |
| `0x04` | `amp` | AMP |  |
| `0x05` | `pan` | PAN |  |
| `0x06` | `cc_a` | CCA |  |
| `0x07` | `cc_b` | CCB |  |
| `0x08` | `cc_c` | CCC |  |
| `0x09` | `cc_d` | CCD |  |
| `0x0a` | `mod_amount` | MOD AMT |  |
| `0x0b` | `mod_rate` | MOD RATE |  |
| `0x0c` | `mod_both` | MOD BOTH |  |
| `0x0d` | `mod_binv` | MOD BINV |  |

## Enum: instrument_type

`instrument_type`

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

## Enum: hypersynth_shape

`hypersynth_shape`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `saw` | SAW |  |
| `0x01` | `soft_saw` | SOFT SAW |  |
| `0x02` | `dark_saw` | DARK SAW |  |
| `0x03` | `square_soft` | SQUARE SOFT |  |
| `0x04` | `triangle` | TRIANGLE |  |
| `0x05` | `sine` | SINE |  |
| `0x06` | `sine_3x` | SINE 3X |  |
| `0x07` | `sine_fb` | SINE FB |  |
| `0x08` | `sine_fold` | SINE FOLD |  |
| `0x09` | `sine_ring` | SINE RING |  |
| `0x0a` | `sine_half` | SINE HALF |  |
| `0x0b` | `sine_organ` | SINE ORGAN |  |
