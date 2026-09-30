# instrument_6_0_2

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.0.2/instrument.ksy](../../../schemas/file-versions/6.0.2/instrument.ksy).

Byte order: `le`.

Body schema for instrument files with header schema version 6.0.2.

The 6.6.3C HYP_SHAPE fixture identifies a new Hypersynth Shape byte at
absolute offset 0x39. Other fields reuse the 6.0.1 component layouts
provisionally; their complete semantic compatibility is not yet established.

All eight fresh 6.6.3C standalone Instrument baselines parse at the expected
size and offsets. Earlier parameter, modulator, and table mappings are reused
from 6.5.x but have not all been retested with controlled 6.6.x edits.
Unknown ranges remain preserved.


File schema version: `6.0.2`.

## Imports

- [instrument_modulation_6_0_1](../6.0.1/instrument/modulation.md)
- [instrument_parameters_6_0_1](../6.0.1/instrument/parameters.md)
- [instrument_table_6_0_1](../6.0.1/instrument/table.md)

## Contents

- [Layout](#layout)
- [instrument_data](#type-instrument_data)
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
| `instrument` | `0x00..0xd6` | 215 | [instrument_data](#type-instrument_data) | - | Fixed 215-byte instrument record. This record is stored directly in Song files; standalone Instrument files append one 128-byte instrument table. The M8 manual groups general_settings and eq as General Instrument Settings. EQ is stored after the type-specific region, so it remains a separate field in the raw storage sequence.  |
| `table` | `0xd7..0x156` | 128 | [instrument_table_6_0_1](../6.0.1/instrument/table.md#layout) | `repeat`: `16` via `rows` | Sixteen eight-byte Instrument Table rows for file schema 6.0.1. Standalone Instruments append one table; Songs store 256 tables separately. FX slots can use the M8 UI's Sequencer, Mixer &amp; Effects, Current Instrument, and Instrument Mods command groups. The FX command reference generated from the schemas documents verified Current Instrument command subsets by type; it is not a complete catalog of commands available in a table. Instrument Mods labels depend on the selected modulation type and still need fixture evidence.  |

## Type: instrument_data

`instrument_data`

Fixed 215-byte instrument record. This record is stored directly in Song
files; standalone Instrument files append one 128-byte instrument table.
The M8 manual groups general_settings and eq as General Instrument
Settings. EQ is stored after the type-specific region, so it remains a
separate field in the raw storage sequence.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `general_settings` | `0x00..0x0e` | 15 | [general_instrument_settings](#type-general_instrument_settings) | - | Contiguous General Instrument Settings prefix. The M8 manual also groups the noncontiguous eq assignment with these settings.  |
| `body_before_eq` | `0x0f..0x3d` | 47 | switch on `general_settings.type`: `instrument_type::wavsynth`: [wavsynth_body_before_eq](#type-wavsynth_body_before_eq); `instrument_type::macrosynth`: [macrosynth_body_before_eq](#type-macrosynth_body_before_eq); `instrument_type::sampler`: [sampler_body_before_eq](#type-sampler_body_before_eq); `instrument_type::midi_out`: [midi_out_body_before_eq](#type-midi_out_body_before_eq); `instrument_type::fm_synth`: [fm_synth_body_before_eq](#type-fm_synth_body_before_eq); `instrument_type::hypersynth`: [hypersynth_body_before_eq](#type-hypersynth_body_before_eq); `instrument_type::external`: [external_body_before_eq](#type-external_body_before_eq); `instrument_type::none`: [unused_body_before_eq](#type-unused_body_before_eq) | - | Instrument-specific body before the common EQ field. |
| `eq` | `0x3e` | 1 | `u1` | - | Common instrument EQ assignment. Observed values: 0x80 displays as --, 0x7f displays as 7F.  |
| `tail` | `0x3f..0xd6` | 152 | switch on `general_settings.type`: `instrument_type::sampler`: [sampler_data_tail](#type-sampler_data_tail); `instrument_type::hypersynth`: [hypersynth_data_tail](#type-hypersynth_data_tail); `instrument_type::midi_out`: [standard_data_tail](#type-standard_data_tail); `instrument_type::wavsynth`: [standard_data_tail](#type-standard_data_tail); `instrument_type::macrosynth`: [standard_data_tail](#type-standard_data_tail); `instrument_type::fm_synth`: [standard_data_tail](#type-standard_data_tail); `instrument_type::external`: [standard_data_tail](#type-standard_data_tail); `instrument_type::none`: [none_data_tail](#type-none_data_tail) | - | Instrument-specific tail after the common EQ field. |

## Type: general_instrument_settings

`general_instrument_settings`

Contiguous General Instrument Settings prefix. The M8 manual also groups
the noncontiguous eq assignment with these settings.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type` | `0x00` | 1 | `u1`; [instrument_type](#enum-instrument_type) | - |  |
| `name` | `0x01..0x0c` | 12 | bytes | `size`: `12` | Fixed-size byte range for the instrument name. Padding bytes are preserved as stored.  |
| `transpose` | `0x0d` | 1 | `u1` | - | Common instrument transpose setting. Observed values: 0x01 means ON, 0x00 means OFF.  |
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
| `params` | `0x03..0x07` | 5 | [instrument_parameters_6_0_1::wavsynth_params](../6.0.1/instrument/parameters.md#type-wavsynth_params) | - | Wavsynth-specific synthesis parameters. |
| `filter` | `0x08..0x0a` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - | Shared three-byte Multi-mode Filter Parameters layout. The type byte is raw because valid labels depend on the instrument: filter_type lists 0x00..0x07 for all filter-capable instruments and 0x08..0x0b for Wavsynth only. MIDI Out and NONE do not expose this group.  |
| `amp` | `0x0b..0x0d` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - | Shared three-byte Amplifier Settings layout: amp, limit, and pan. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. MIDI Out and NONE do not.  |
| `mixer` | `0x0e..0x11` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - | Shared four-byte instrument Mixer Parameters layout: dry, mod_fx, delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. It is distinct from the Song's master Mixer; MIDI Out and NONE do not expose it.  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |

## Type: macrosynth_body_before_eq

`macrosynth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [instrument_parameters_6_0_1::macrosynth_params](../6.0.1/instrument/parameters.md#type-macrosynth_params) | - | Macrosynth-specific synthesis parameters. |
| `filter` | `0x08..0x0a` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - | Shared three-byte Multi-mode Filter Parameters layout. The type byte is raw because valid labels depend on the instrument: filter_type lists 0x00..0x07 for all filter-capable instruments and 0x08..0x0b for Wavsynth only. MIDI Out and NONE do not expose this group.  |
| `amp` | `0x0b..0x0d` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - | Shared three-byte Amplifier Settings layout: amp, limit, and pan. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. MIDI Out and NONE do not.  |
| `mixer` | `0x0e..0x11` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - | Shared four-byte instrument Mixer Parameters layout: dry, mod_fx, delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. It is distinct from the Song's master Mixer; MIDI Out and NONE do not expose it.  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |

## Type: sampler_body_before_eq

`sampler_body_before_eq`

Sampler-specific controls are stored here; the selected sample_path is
another Sampler-specific parameter stored in sampler_data_tail.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x01` | 2 | bytes | `size`: `2` |  |
| `controls` | `0x02..0x08` | 7 | [instrument_parameters_6_0_1::sampler_controls](../6.0.1/instrument/parameters.md#type-sampler_controls) | - | Contiguous Sampler-specific controls. These and the selected sample_path in sampler_data_tail together form the Sampler's instrument-specific configuration. The raw mode_value byte is displayed as detune, steps, or BPM according to play_mode.  |
| `filter` | `0x09..0x0b` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - | Shared three-byte Multi-mode Filter Parameters layout. The type byte is raw because valid labels depend on the instrument: filter_type lists 0x00..0x07 for all filter-capable instruments and 0x08..0x0b for Wavsynth only. MIDI Out and NONE do not expose this group.  |
| `amp` | `0x0c..0x0e` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - | Shared three-byte Amplifier Settings layout: amp, limit, and pan. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. MIDI Out and NONE do not.  |
| `mixer` | `0x0f..0x12` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - | Shared four-byte instrument Mixer Parameters layout: dry, mod_fx, delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. It is distinct from the Song's master Mixer; MIDI Out and NONE do not expose it.  |
| `unknown_1` | `0x13..0x2e` | 28 | bytes | `size`: `28` |  |

## Type: midi_out_body_before_eq

`midi_out_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `params` | `0x00..0x1c` | 29 | [instrument_parameters_6_0_1::midi_out_params](../6.0.1/instrument/parameters.md#type-midi_out_params) | - | MIDI Out port, channel, program, and custom CC settings. |
| `unknown` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |

## Type: fm_synth_body_before_eq

`fm_synth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x23` | 33 | [instrument_parameters_6_0_1::fm_synth_params](../6.0.1/instrument/parameters.md#type-fm_synth_params) | - | FM algorithm, four operators, and modulation values. |
| `filter` | `0x24..0x26` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - | Type, cutoff, and resonance offsets are verified by FM_PARAMS.  |
| `amp` | `0x27..0x29` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - | Amp, limit, and pan offsets are verified by FM_PARAMS.  |
| `mixer` | `0x2a..0x2d` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - | Shared four-byte instrument Mixer Parameters layout: dry, mod_fx, delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. It is distinct from the Song's master Mixer; MIDI Out and NONE do not expose it.  |
| `unknown_1` | `0x2e` | 1 | bytes | `size`: `1` |  |

## Type: hypersynth_body_before_eq

`hypersynth_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0e` | 12 | [instrument_parameters_6_0_1::hypersynth_params](../6.0.1/instrument/parameters.md#type-hypersynth_params) | - | Hypersynth chord state and synthesis settings. |
| `filter` | `0x0f..0x11` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - | Shared three-byte Multi-mode Filter Parameters layout. The type byte is raw because valid labels depend on the instrument: filter_type lists 0x00..0x07 for all filter-capable instruments and 0x08..0x0b for Wavsynth only. MIDI Out and NONE do not expose this group.  |
| `amp` | `0x12..0x14` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - | Shared three-byte Amplifier Settings layout: amp, limit, and pan. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. MIDI Out and NONE do not.  |
| `mixer` | `0x15..0x18` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - | Shared four-byte instrument Mixer Parameters layout: dry, mod_fx, delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. It is distinct from the Song's master Mixer; MIDI Out and NONE do not expose it.  |
| `unknown_1` | `0x19..0x1b` | 3 | bytes | `size`: `3` |  |
| `shape` | `0x1c` | 1 | `u1`; [hypersynth_shape](#enum-hypersynth_shape) | - | Hypersynth Shape. HYP_DEFAULT and HYP_SHAPE verify 0x00 and 0x0b at standalone file offset 0x39. Intermediate labels are supplied from the 6.6.x UI, not individually fixture-tested.  |
| `unknown_2` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |

## Type: external_body_before_eq

`external_body_before_eq`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0f` | 13 | [instrument_parameters_6_0_1::external_params](../6.0.1/instrument/parameters.md#type-external_params) | - | External input and MIDI output settings. |
| `filter` | `0x10..0x12` | 3 | [instrument_parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - | Shared three-byte Multi-mode Filter Parameters layout. The type byte is raw because valid labels depend on the instrument: filter_type lists 0x00..0x07 for all filter-capable instruments and 0x08..0x0b for Wavsynth only. MIDI Out and NONE do not expose this group.  |
| `amp` | `0x13..0x15` | 3 | [instrument_parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - | Shared three-byte Amplifier Settings layout: amp, limit, and pan. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. MIDI Out and NONE do not.  |
| `mixer` | `0x16..0x19` | 4 | [instrument_parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - | Shared four-byte instrument Mixer Parameters layout: dry, mod_fx, delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose this group at type-dependent offsets. It is distinct from the Song's master Mixer; MIDI Out and NONE do not expose it.  |
| `unknown_1` | `0x1a..0x2e` | 21 | bytes | `size`: `21` |  |

## Type: standard_data_tail

`standard_data_tail`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `modulators` | `0x00..0x17` | 24 | [instrument_modulators](#type-instrument_modulators) | `repeat`: `4` via `slots` | Shared Common Modulation Settings block. Four six-byte slots occupy standalone offsets 0x4d..0x64 in all seven editable instrument types. slots[0] is M8 modulation slot 1. NONE preserves the corresponding bytes as unknown, without assigning modulation semantics.  |
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
| `modulators` | `0x00..0x17` | 24 | [instrument_modulators](#type-instrument_modulators) | `repeat`: `4` via `slots` | Shared Common Modulation Settings block. Four six-byte slots occupy standalone offsets 0x4d..0x64 in all seven editable instrument types. slots[0] is M8 modulation slot 1. NONE preserves the corresponding bytes as unknown, without assigning modulation semantics.  |
| `sample_path` | `0x18..0x97` | 128 | [sample_path_region](#type-sample_path_region) | `size`: `128` | Selected sample path in a fixed 128-byte field, following the same null-terminated path and preserved trailing-byte convention as the Song directory. SAM_PARAMS stores /Samples/Kick.wav at offset 0x65. The M8 manual requires the entire path to be under 128 characters.  |

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
| `modulators` | `0x00..0x17` | 24 | [instrument_modulators](#type-instrument_modulators) | `repeat`: `4` via `slots` | Shared Common Modulation Settings block. Four six-byte slots occupy standalone offsets 0x4d..0x64 in all seven editable instrument types. slots[0] is M8 modulation slot 1. NONE preserves the corresponding bytes as unknown, without assigning modulation semantics.  |
| `chords` | `0x18..0x87` | 112 | [hypersynth_chord](#type-hypersynth_chord) | `repeat`: `expr`; `repeat-expr`: `16` |  |
| `unknown` | `0x88..0x97` | 16 | bytes | `size`: `16` |  |

## Type: hypersynth_chord

`hypersynth_chord`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `enabled_notes` | `0x00` | 1 | `u1` | - | Observed as a bit mask for six chord notes. Chord 0 changed from 0xff to 0xfe when note 1 was unset. Chord 15 changed from 0xff to 0xdf when note 6 was unset.  |
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
| `slots` | `0x00..0x17` | 24 | [instrument_modulation_6_0_1::modulation_slot](../6.0.1/instrument/modulation.md#type-modulation_slot) | `repeat`: `expr`; `repeat-expr`: `4` | Shared six-byte modulation slot: one packed type/destination byte, one amount byte, and four type-dependent parameter bytes. The first two bytes are Common Modulation Settings; params selects one of six modulation-type-specific structures. The slot layout is independent of the instrument-specific destination labels.  |

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
