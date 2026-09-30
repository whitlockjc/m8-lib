# instrument_6_0_2

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/6.0.2/instrument.ksy](../../../schemas/file-versions/6.0.2/instrument.ksy).

Byte order: `le`.

Instrument body for file schema version 6.0.2, containing an instrument
record and its table. Hypersynth includes a waveform shape setting.


File schema version: `6.0.2`.

## Imports

- [modulation_6_0_1](../6.0.1/instrument/modulation.md)
- [parameters_6_0_1](../6.0.1/instrument/parameters.md)
- [table_6_0_1](../6.0.1/instrument/table.md)
- [wavsynth_6_0_1](../6.0.1/instrument/wavsynth.md)
- [macrosynth_6_0_1](../6.0.1/instrument/macrosynth.md)
- [sampler_6_0_1](../6.0.1/instrument/sampler.md)
- [midi_out_6_0_1](../6.0.1/instrument/midi_out.md)
- [fm_synth_6_0_1](../6.0.1/instrument/fm_synth.md)
- [hypersynth_6_0_1](../6.0.1/instrument/hypersynth.md)
- [external_6_0_1](../6.0.1/instrument/external.md)
- [none_6_0_1](../6.0.1/instrument/none.md)
- [hypersynth_6_0_2](instrument/hypersynth.md)

## Contents

- [Layout](#layout)
- [data](#type-data)
- [general_settings](#type-general_settings)
- [none_body](#type-none_body)
- [wavsynth_body](#type-wavsynth_body)
- [macrosynth_body](#type-macrosynth_body)
- [sampler_body](#type-sampler_body)
- [midi_out_body](#type-midi_out_body)
- [fm_synth_body](#type-fm_synth_body)
- [hypersynth_body](#type-hypersynth_body)
- [external_body](#type-external_body)
- [modulators](#type-modulators)
- [type (enum)](#enum-type)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `instrument` | `0x00..0xd6` | 215 | [data](#type-data) | - |  |
| `table` | `0xd7..0x156` | 128 | [table_6_0_1](../6.0.1/instrument/table.md#layout) | `repeat`: `16` via `rows` |  |

## Type: data

`data`

Fixed 215-byte instrument record. This record is stored directly in Song
files; standalone Instrument files append one 128-byte instrument table.
The EQ assignment follows the type-specific region.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `general_settings` | `0x00..0x0e` | 15 | [general_settings](#type-general_settings) | - |  |
| `body` | `0x0f..0xd6` | 200 | switch on `general_settings.type`: `type::wavsynth`: [wavsynth_body](#type-wavsynth_body); `type::macrosynth`: [macrosynth_body](#type-macrosynth_body); `type::sampler`: [sampler_body](#type-sampler_body); `type::midi_out`: [midi_out_body](#type-midi_out_body); `type::fm_synth`: [fm_synth_body](#type-fm_synth_body); `type::hypersynth`: [hypersynth_body](#type-hypersynth_body); `type::external`: [external_body](#type-external_body); `type::none`: [none_body](#type-none_body) | - | Instrument body selected by type. |

## Type: general_settings

`general_settings`

General Instrument Settings prefix. The EQ assignment follows in the body.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type` | `0x00` | 1 | `u1`; [type](#enum-type) | - |  |
| `name` | `0x01..0x0c` | 12 | bytes | `size`: `12` | Fixed-size byte range for the instrument name. Padding bytes are preserved as stored.  |
| `transpose` | `0x0d` | 1 | `u1` | - | Common instrument transpose setting. 0x01 means ON; 0x00 means OFF.  |
| `table_tic` | `0x0e` | 1 | `u1` | - | Common instrument table TIC setting. |

## Type: none_body

`none_body`

Preserved bytes between the common instrument prefix and common EQ field
for NONE.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x2e` | 47 | bytes | `size`: `47` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `unknown_1` | `0x30..0xc7` | 152 | bytes | `size`: `152` |  |

## Type: wavsynth_body

`wavsynth_body`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [wavsynth_6_0_1::instrument_params](../6.0.1/instrument/wavsynth.md#type-instrument_params) | - |  |
| `filter` | `0x08..0x0a` | 3 | [parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0b..0x0d` | 3 | [parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0e..0x11` | 4 | [parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `unknown_2` | `0x48..0xc7` | 128 | bytes | `size`: `128` |  |

## Type: macrosynth_body

`macrosynth_body`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x07` | 5 | [macrosynth_6_0_1::instrument_params](../6.0.1/instrument/macrosynth.md#type-instrument_params) | - |  |
| `filter` | `0x08..0x0a` | 3 | [parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0b..0x0d` | 3 | [parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0e..0x11` | 4 | [parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x12..0x2e` | 29 | bytes | `size`: `29` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `unknown_2` | `0x48..0xc7` | 128 | bytes | `size`: `128` |  |

## Type: sampler_body

`sampler_body`

Sampler-specific controls are stored here; the selected sample_path is
another Sampler-specific parameter stored later in this body.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x01` | 2 | bytes | `size`: `2` |  |
| `params` | `0x02..0x08` | 7 | [sampler_6_0_1::instrument_params](../6.0.1/instrument/sampler.md#type-instrument_params) | - |  |
| `filter` | `0x09..0x0b` | 3 | [parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x0c..0x0e` | 3 | [parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x0f..0x12` | 4 | [parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x13..0x2e` | 28 | bytes | `size`: `28` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `sample_path` | `0x48..0xc7` | 128 | [sampler_6_0_1::sample_path](../6.0.1/instrument/sampler.md#type-sample_path) | `size`: `128` | Selected sample path in a fixed 128-byte field, following the same null-terminated path and preserved trailing-byte convention as the Song directory. The full sample path must be under 128 characters.  |

## Type: midi_out_body

`midi_out_body`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `params` | `0x00..0x1c` | 29 | [midi_out_6_0_1::instrument_params](../6.0.1/instrument/midi_out.md#type-instrument_params) | - |  |
| `unknown_0` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `unknown_1` | `0x48..0xc7` | 128 | bytes | `size`: `128` |  |

## Type: fm_synth_body

`fm_synth_body`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x23` | 33 | [fm_synth_6_0_1::instrument_params](../6.0.1/instrument/fm_synth.md#type-instrument_params) | - |  |
| `filter` | `0x24..0x26` | 3 | [parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x27..0x29` | 3 | [parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x2a..0x2d` | 4 | [parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x2e` | 1 | bytes | `size`: `1` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `unknown_2` | `0x48..0xc7` | 128 | bytes | `size`: `128` |  |

## Type: hypersynth_body

`hypersynth_body`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0e` | 12 | [hypersynth_6_0_1::instrument_params](../6.0.1/instrument/hypersynth.md#type-instrument_params) | - |  |
| `filter` | `0x0f..0x11` | 3 | [parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x12..0x14` | 3 | [parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x15..0x18` | 4 | [parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x19..0x1b` | 3 | bytes | `size`: `3` |  |
| `shape` | `0x1c` | 1 | `u1`; [shape](instrument/hypersynth.md#enum-shape) | - | Hypersynth waveform shape. |
| `unknown_2` | `0x1d..0x2e` | 18 | bytes | `size`: `18` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `chords` | `0x48..0xb7` | 112 | [hypersynth_6_0_1::chord](../6.0.1/instrument/hypersynth.md#type-chord) | `repeat`: `expr`; `repeat-expr`: `16` |  |
| `unknown_3` | `0xb8..0xc7` | 16 | bytes | `size`: `16` |  |

## Type: external_body

`external_body`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` |  |
| `params` | `0x03..0x0f` | 13 | [external_6_0_1::instrument_params](../6.0.1/instrument/external.md#type-instrument_params) | - |  |
| `filter` | `0x10..0x12` | 3 | [parameters_6_0_1::filter_params](../6.0.1/instrument/parameters.md#type-filter_params) | - |  |
| `amp` | `0x13..0x15` | 3 | [parameters_6_0_1::amp_params](../6.0.1/instrument/parameters.md#type-amp_params) | - |  |
| `mixer` | `0x16..0x19` | 4 | [parameters_6_0_1::mixer_params](../6.0.1/instrument/parameters.md#type-mixer_params) | - |  |
| `unknown_1` | `0x1a..0x2e` | 21 | bytes | `size`: `21` |  |
| `eq` | `0x2f` | 1 | `u1` | - | Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F. |
| `modulators` | `0x30..0x47` | 24 | [modulators](#type-modulators) | `repeat`: `4` via `slots` |  |
| `unknown_2` | `0x48..0xc7` | 128 | bytes | `size`: `128` |  |

## Type: modulators

`modulators`

Shared Common Modulation Settings block. Four six-byte slots occupy
standalone offsets 0x4d..0x64 in all seven editable instrument types.
slots[0] is M8 modulation slot 1. NONE preserves the corresponding
bytes as unknown, without assigning modulation semantics.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `slots` | `0x00..0x17` | 24 | [modulation_6_0_1::slot](../6.0.1/instrument/modulation.md#type-slot) | `repeat`: `expr`; `repeat-expr`: `4` |  |

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
