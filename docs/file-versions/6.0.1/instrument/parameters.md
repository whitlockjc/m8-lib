# instrument_parameters_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/parameters.ksy](../../../../schemas/file-versions/6.0.1/instrument/parameters.ksy).

Byte order: `le`.

Instrument-specific parameter types and shared filter, amplifier, and
mixer layouts for instrument file schema version 6.0.1.


File schema version: `6.0.1`.

## Contents

- [Layout](parameters.md#layout)
- [sampler_controls](parameters.md#type-sampler_controls)
- [wavsynth_params](parameters.md#type-wavsynth_params)
- [macrosynth_params](parameters.md#type-macrosynth_params)
- [midi_out_params](parameters.md#type-midi_out_params)
- [custom_cc](parameters.md#type-custom_cc)
- [external_params](parameters.md#type-external_params)
- [fm_synth_params](parameters.md#type-fm_synth_params)
- [hypersynth_params](parameters.md#type-hypersynth_params)
- [hypersynth_current_chord](parameters.md#type-hypersynth_current_chord)
- [hypersynth_chord_notes](parameters.md#type-hypersynth_chord_notes)
- [fm_synth_operator_shapes](parameters.md#type-fm_synth_operator_shapes)
- [fm_synth_operator_ratios](parameters.md#type-fm_synth_operator_ratios)
- [fm_synth_operator_ratio](parameters.md#type-fm_synth_operator_ratio)
- [fm_synth_operator_level_feedbacks](parameters.md#type-fm_synth_operator_level_feedbacks)
- [fm_synth_operator_level_feedback](parameters.md#type-fm_synth_operator_level_feedback)
- [fm_synth_operator_mod_slots](parameters.md#type-fm_synth_operator_mod_slots)
- [fm_synth_mod_values](parameters.md#type-fm_synth_mod_values)
- [filter_params](parameters.md#type-filter_params)
- [amp_params](parameters.md#type-amp_params)
- [mixer_params](parameters.md#type-mixer_params)
- [midi_out_port (enum)](parameters.md#enum-midi_out_port)
- [external_input (enum)](parameters.md#enum-external_input)
- [external_port (enum)](parameters.md#enum-external_port)
- [filter_type (enum)](parameters.md#enum-filter_type)
- [limit_type (enum)](parameters.md#enum-limit_type)
- [fm_synth_algo (enum)](parameters.md#enum-fm_synth_algo)
- [fm_synth_operator_shape (enum)](parameters.md#enum-fm_synth_operator_shape)
- [fm_synth_operator_mod_slot (enum)](parameters.md#enum-fm_synth_operator_mod_slot)
- [wavsynth_shape (enum)](parameters.md#enum-wavsynth_shape)
- [macrosynth_shape (enum)](parameters.md#enum-macrosynth_shape)
- [sampler_play_mode (enum)](parameters.md#enum-sampler_play_mode)

## Layout

Root record.



## Type: sampler_controls

`sampler_controls`

Contiguous Sampler-specific controls. These and the selected sample_path
in sampler_data_tail together form the Sampler's instrument-specific
configuration. The raw mode_value byte is displayed as detune, steps, or
BPM according to play_mode.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `mode_value` | `0x00` | 1 | `u1` | - |  |
| `play_mode` | `0x01` | 1 | `u1`; [sampler_play_mode](parameters.md#enum-sampler_play_mode) | - |  |
| `slice` | `0x02` | 1 | `u1` | - |  |
| `start` | `0x03` | 1 | `u1` | - |  |
| `loop_start` | `0x04` | 1 | `u1` | - |  |
| `length` | `0x05` | 1 | `u1` | - |  |
| `degrade` | `0x06` | 1 | `u1` | - |  |

## Type: wavsynth_params

`wavsynth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `shape` | `0x00` | 1 | `u1`; [wavsynth_shape](parameters.md#enum-wavsynth_shape) | - |  |
| `size` | `0x01` | 1 | `u1` | - |  |
| `mult` | `0x02` | 1 | `u1` | - |  |
| `warp` | `0x03` | 1 | `u1` | - |  |
| `scan` | `0x04` | 1 | `u1` | - |  |

## Type: macrosynth_params

`macrosynth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `shape` | `0x00` | 1 | `u1`; [macrosynth_shape](parameters.md#enum-macrosynth_shape) | - |  |
| `timbre` | `0x01` | 1 | `u1` | - |  |
| `color` | `0x02` | 1 | `u1` | - |  |
| `degrade` | `0x03` | 1 | `u1` | - |  |
| `redux` | `0x04` | 1 | `u1` | - |  |

## Type: midi_out_params

`midi_out_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `port` | `0x00` | 1 | `u1`; [midi_out_port](parameters.md#enum-midi_out_port) | - |  |
| `channel` | `0x01` | 1 | `u1` | - | Displayed as decimal in the M8 UI. The MID_PARAMS fixture verifies displayed channel 16 is stored as 0x10.  |
| `bank` | `0x02` | 1 | `u1` | - | Displayed as decimal in the M8 UI. The MID_PARAMS fixture verifies displayed bank 127 is stored as 0x7f.  |
| `unknown_before_program_change` | `0x03..0x04` | 2 | bytes | `size`: `2` |  |
| `program_change` | `0x05` | 1 | `u1` | - | Displayed as decimal in the M8 UI. The MID_PARAMS fixture verifies displayed program change 126 is stored as 0x7e.  |
| `unknown_before_custom_ccs` | `0x06..0x08` | 3 | bytes | `size`: `3` |  |
| `custom_ccs` | `0x09..0x1c` | 20 | [custom_cc](parameters.md#type-custom_cc) | `repeat`: `expr`; `repeat-expr`: `10` |  |

## Type: custom_cc

`custom_cc`

Two-byte custom CC entry shared by MIDI Out and External.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `cc` | `0x00` | 1 | `u1` | - | Displayed as decimal in the M8 UI. |
| `value` | `0x01` | 1 | `u1` | - |  |

## Type: external_params

`external_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `input` | `0x00` | 1 | `u1`; [external_input](parameters.md#enum-external_input) | - |  |
| `port` | `0x01` | 1 | `u1`; [external_port](parameters.md#enum-external_port) | - |  |
| `channel` | `0x02` | 1 | `u1` | - | Displayed as decimal in the M8 UI. The EXT_PARAMS fixture verifies displayed channel 16 is stored as 0x10.  |
| `bank` | `0x03` | 1 | `u1` | - | Displayed as decimal in the M8 UI. The EXT_PARAMS fixture verifies displayed bank 127 is stored as 0x7f.  |
| `program_change` | `0x04` | 1 | `u1` | - | Displayed as decimal in the M8 UI. The EXT_PARAMS fixture verifies displayed program change 126 is stored as 0x7e.  |
| `custom_ccs` | `0x05..0x0c` | 8 | [custom_cc](parameters.md#type-custom_cc) | `repeat`: `expr`; `repeat-expr`: `4` |  |

## Type: fm_synth_params

`fm_synth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `algo` | `0x00` | 1 | `u1`; [fm_synth_algo](parameters.md#enum-fm_synth_algo) | - |  |
| `operator_shapes` | `0x01..0x04` | 4 | [fm_synth_operator_shapes](parameters.md#type-fm_synth_operator_shapes) | - |  |
| `operator_ratios` | `0x05..0x0c` | 8 | [fm_synth_operator_ratios](parameters.md#type-fm_synth_operator_ratios) | - |  |
| `operator_levels` | `0x0d..0x14` | 8 | [fm_synth_operator_level_feedbacks](parameters.md#type-fm_synth_operator_level_feedbacks) | - |  |
| `operator_mod_a` | `0x15..0x18` | 4 | [fm_synth_operator_mod_slots](parameters.md#type-fm_synth_operator_mod_slots) | - |  |
| `operator_mod_b` | `0x19..0x1c` | 4 | [fm_synth_operator_mod_slots](parameters.md#type-fm_synth_operator_mod_slots) | - |  |
| `mods` | `0x1d..0x20` | 4 | [fm_synth_mod_values](parameters.md#type-fm_synth_mod_values) | - |  |

## Type: hypersynth_params

`hypersynth_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `current_chord` | `0x00..0x06` | 7 | [hypersynth_current_chord](parameters.md#type-hypersynth_current_chord) | - | Current/edit chord state. The HYP_PARAMS fixture verifies index 0x0c when chord 0C is selected. The note bytes are a memory representation of the current chord; in HYP_PARAMS they match the entry selected in the persistent Hypersynth tail chord table. Both byte regions remain separately stored.  |
| `scale` | `0x07` | 1 | `u1` | - |  |
| `shift` | `0x08` | 1 | `u1` | - |  |
| `swarm` | `0x09` | 1 | `u1` | - |  |
| `width` | `0x0a` | 1 | `u1` | - |  |
| `subosc` | `0x0b` | 1 | `u1` | - |  |

## Type: hypersynth_current_chord

`hypersynth_current_chord`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `index` | `0x00` | 1 | `u1` | - |  |
| `notes` | `0x01..0x06` | 6 | [hypersynth_chord_notes](parameters.md#type-hypersynth_chord_notes) | - |  |

## Type: hypersynth_chord_notes

`hypersynth_chord_notes`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `note_1` | `0x00` | 1 | `u1` | - |  |
| `note_2` | `0x01` | 1 | `u1` | - |  |
| `note_3` | `0x02` | 1 | `u1` | - |  |
| `note_4` | `0x03` | 1 | `u1` | - |  |
| `note_5` | `0x04` | 1 | `u1` | - |  |
| `note_6` | `0x05` | 1 | `u1` | - |  |

## Type: fm_synth_operator_shapes

`fm_synth_operator_shapes`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00` | 1 | `u1`; [fm_synth_operator_shape](parameters.md#enum-fm_synth_operator_shape) | - |  |
| `operator_2` | `0x01` | 1 | `u1`; [fm_synth_operator_shape](parameters.md#enum-fm_synth_operator_shape) | - |  |
| `operator_3` | `0x02` | 1 | `u1`; [fm_synth_operator_shape](parameters.md#enum-fm_synth_operator_shape) | - |  |
| `operator_4` | `0x03` | 1 | `u1`; [fm_synth_operator_shape](parameters.md#enum-fm_synth_operator_shape) | - |  |

## Type: fm_synth_operator_ratios

`fm_synth_operator_ratios`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00..0x01` | 2 | [fm_synth_operator_ratio](parameters.md#type-fm_synth_operator_ratio) | - |  |
| `operator_2` | `0x02..0x03` | 2 | [fm_synth_operator_ratio](parameters.md#type-fm_synth_operator_ratio) | - |  |
| `operator_3` | `0x04..0x05` | 2 | [fm_synth_operator_ratio](parameters.md#type-fm_synth_operator_ratio) | - |  |
| `operator_4` | `0x06..0x07` | 2 | [fm_synth_operator_ratio](parameters.md#type-fm_synth_operator_ratio) | - |  |

## Type: fm_synth_operator_ratio

`fm_synth_operator_ratio`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `ratio` | `0x00` | 1 | `u1` | - |  |
| `ratio_fine` | `0x01` | 1 | `u1` | - |  |

## Type: fm_synth_operator_level_feedbacks

`fm_synth_operator_level_feedbacks`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00..0x01` | 2 | [fm_synth_operator_level_feedback](parameters.md#type-fm_synth_operator_level_feedback) | - |  |
| `operator_2` | `0x02..0x03` | 2 | [fm_synth_operator_level_feedback](parameters.md#type-fm_synth_operator_level_feedback) | - |  |
| `operator_3` | `0x04..0x05` | 2 | [fm_synth_operator_level_feedback](parameters.md#type-fm_synth_operator_level_feedback) | - |  |
| `operator_4` | `0x06..0x07` | 2 | [fm_synth_operator_level_feedback](parameters.md#type-fm_synth_operator_level_feedback) | - |  |

## Type: fm_synth_operator_level_feedback

`fm_synth_operator_level_feedback`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `level` | `0x00` | 1 | `u1` | - |  |
| `feedback` | `0x01` | 1 | `u1` | - |  |

## Type: fm_synth_operator_mod_slots

`fm_synth_operator_mod_slots`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00` | 1 | `u1`; [fm_synth_operator_mod_slot](parameters.md#enum-fm_synth_operator_mod_slot) | - |  |
| `operator_2` | `0x01` | 1 | `u1`; [fm_synth_operator_mod_slot](parameters.md#enum-fm_synth_operator_mod_slot) | - |  |
| `operator_3` | `0x02` | 1 | `u1`; [fm_synth_operator_mod_slot](parameters.md#enum-fm_synth_operator_mod_slot) | - |  |
| `operator_4` | `0x03` | 1 | `u1`; [fm_synth_operator_mod_slot](parameters.md#enum-fm_synth_operator_mod_slot) | - |  |

## Type: fm_synth_mod_values

`fm_synth_mod_values`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `mod_1` | `0x00` | 1 | `u1` | - |  |
| `mod_2` | `0x01` | 1 | `u1` | - |  |
| `mod_3` | `0x02` | 1 | `u1` | - |  |
| `mod_4` | `0x03` | 1 | `u1` | - |  |

## Type: filter_params

`filter_params`

Shared three-byte Multi-mode Filter Parameters layout. The type byte is
raw because valid labels depend on the instrument: filter_type lists
0x00..0x07 for all filter-capable instruments and 0x08..0x0b for
Wavsynth only. MIDI Out and NONE do not expose this group.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type` | `0x00` | 1 | `u1` | - |  |
| `cutoff` | `0x01` | 1 | `u1` | - |  |
| `resonance` | `0x02` | 1 | `u1` | - |  |

## Type: amp_params

`amp_params`

Shared three-byte Amplifier Settings layout: amp, limit, and pan.
Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose
this group at type-dependent offsets. MIDI Out and NONE do not.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `amp` | `0x00` | 1 | `u1` | - |  |
| `limit` | `0x01` | 1 | `u1`; [limit_type](parameters.md#enum-limit_type) | - |  |
| `pan` | `0x02` | 1 | `u1` | - |  |

## Type: mixer_params

`mixer_params`

Shared four-byte instrument Mixer Parameters layout: dry, mod_fx,
delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth,
and External expose this group at type-dependent offsets. It is distinct
from the Song's master Mixer; MIDI Out and NONE do not expose it.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `dry` | `0x00` | 1 | `u1` | - |  |
| `mod_fx` | `0x01` | 1 | `u1` | - |  |
| `delay` | `0x02` | 1 | `u1` | - |  |
| `reverb` | `0x03` | 1 | `u1` | - |  |

## Enum: midi_out_port

`midi_out_port`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `midi_usb` | MIDI+USB |  |
| `0x01` | `midi` | MIDI |  |
| `0x02` | `usb` | USB |  |
| `0x03` | `internal` | INTERNAL |  |

## Enum: external_input

`external_input`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `line_in_stereo` | LINE-IN STEREO |  |
| `0x01` | `line_in_left` | LINE-IN LEFT |  |
| `0x02` | `line_in_right` | LINE-IN RIGHT |  |
| `0x03` | `usb_stereo` | USB STEREO |  |
| `0x04` | `usb_left` | USB LEFT |  |
| `0x05` | `usb_right` | USB RIGHT |  |
| `0x06` | `all_stereo` | ALL STEREO |  |
| `0x07` | `all_left` | ALL LEFT |  |
| `0x08` | `all_right` | ALL RIGHT |  |

## Enum: external_port

`external_port`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `none` | NONE |  |
| `0x01` | `midi_usb` | MIDI+USB |  |
| `0x02` | `midi` | MIDI |  |
| `0x03` | `usb` | USB |  |

## Enum: filter_type

`filter_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `lowpass` | LOWPASS |  |
| `0x02` | `highpass` | HIGHPAS |  |
| `0x03` | `bandpass` | BANDPAS |  |
| `0x04` | `bandstop` | BANDSTP |  |
| `0x05` | `lowpass_to_highpass` | LP &gt; HP |  |
| `0x06` | `zdf_lowpass` | ZDF LP |  |
| `0x07` | `zdf_highpass` | ZDF HP |  |
| `0x08` | `wav_lowpass` | WAV LP |  |
| `0x09` | `wav_highpass` | WAV HP |  |
| `0x0a` | `wav_bandpass` | WAV BP |  |
| `0x0b` | `wav_bandstop` | WAV BS |  |

## Enum: limit_type

`limit_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `clip` | CLIP |  |
| `0x01` | `sin` | SIN |  |
| `0x02` | `fold` | FOLD |  |
| `0x03` | `wrap` | WRAP |  |
| `0x04` | `post` | POST |  |
| `0x05` | `post_ad` | POST:AD |  |
| `0x06` | `post_w1` | POST:W1 |  |
| `0x07` | `post_w2` | POST:W2 |  |
| `0x08` | `post_w3` | POST:W3 |  |

## Enum: fm_synth_algo

`fm_synth_algo`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `algorithm_00` | A&gt;B&gt;C&gt;D |  |
| `0x01` | `algorithm_01` | [A+B]&gt;C&gt;D |  |
| `0x02` | `algorithm_02` | [A&gt;B+C]&gt;D |  |
| `0x03` | `algorithm_03` | [A&gt;B+A&gt;C]&gt;D |  |
| `0x04` | `algorithm_04` | [A+B+C]&gt;D |  |
| `0x05` | `algorithm_05` | [A&gt;B&gt;C]+D |  |
| `0x06` | `algorithm_06` | [A&gt;B&gt;C]+[A&gt;B&gt;D] |  |
| `0x07` | `algorithm_07` | [A&gt;B]+[C&gt;D] |  |
| `0x08` | `algorithm_08` | [A&gt;B]+[A&gt;C]+[A&gt;D] |  |
| `0x09` | `algorithm_09` | [A&gt;B]+[A&gt;C]+D |  |
| `0x0a` | `algorithm_0a` | [A&gt;B]+C+D |  |
| `0x0b` | `algorithm_0b` | A+B+C+D |  |

## Enum: fm_synth_operator_shape

`fm_synth_operator_shape`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `sin` | SIN |  |
| `0x01` | `sw2` | SW2 |  |
| `0x02` | `sw3` | SW3 |  |
| `0x03` | `sw4` | SW4 |  |
| `0x04` | `sw5` | SW5 |  |
| `0x05` | `sw6` | SW6 |  |
| `0x06` | `tri` | TRI |  |
| `0x07` | `saw` | SAW |  |
| `0x08` | `squ` | SQU |  |
| `0x09` | `pul` | PUL |  |
| `0x0a` | `imp` | IMP |  |
| `0x0b` | `noi` | NOI |  |
| `0x0c` | `nlp` | NLP |  |
| `0x0d` | `nhp` | NHP |  |
| `0x0e` | `nbp` | NBP |  |
| `0x0f` | `clk` | CLK |  |
| `0x10` | `w09` | W09 |  |
| `0x11` | `w0a` | W0A |  |
| `0x12` | `w0b` | W0B |  |
| `0x13` | `w0c` | W0C |  |
| `0x14` | `w0d` | W0D |  |
| `0x15` | `w0e` | W0E |  |
| `0x16` | `w0f` | W0F |  |
| `0x17` | `w10` | W10 |  |
| `0x18` | `w11` | W11 |  |
| `0x19` | `w12` | W12 |  |
| `0x1a` | `w13` | W13 |  |
| `0x1b` | `w14` | W14 |  |
| `0x1c` | `w15` | W15 |  |
| `0x1d` | `w16` | W16 |  |
| `0x1e` | `w17` | W17 |  |
| `0x1f` | `w18` | W18 |  |
| `0x20` | `w19` | W19 |  |
| `0x21` | `w1a` | W1A |  |
| `0x22` | `w1b` | W1B |  |
| `0x23` | `w1c` | W1C |  |
| `0x24` | `w1d` | W1D |  |
| `0x25` | `w1e` | W1E |  |
| `0x26` | `w1f` | W1F |  |
| `0x27` | `w20` | W20 |  |
| `0x28` | `w21` | W21 |  |
| `0x29` | `w22` | W22 |  |
| `0x2a` | `w23` | W23 |  |
| `0x2b` | `w24` | W24 |  |
| `0x2c` | `w25` | W25 |  |
| `0x2d` | `w26` | W26 |  |
| `0x2e` | `w27` | W27 |  |
| `0x2f` | `w28` | W28 |  |
| `0x30` | `w29` | W29 |  |
| `0x31` | `w2a` | W2A |  |
| `0x32` | `w2b` | W2B |  |
| `0x33` | `w2c` | W2C |  |
| `0x34` | `w2d` | W2D |  |
| `0x35` | `w2e` | W2E |  |
| `0x36` | `w2f` | W2F |  |
| `0x37` | `w30` | W30 |  |
| `0x38` | `w31` | W31 |  |
| `0x39` | `w32` | W32 |  |
| `0x3a` | `w33` | W33 |  |
| `0x3b` | `w34` | W34 |  |
| `0x3c` | `w35` | W35 |  |
| `0x3d` | `w36` | W36 |  |
| `0x3e` | `w37` | W37 |  |
| `0x3f` | `w38` | W38 |  |
| `0x40` | `w39` | W39 |  |
| `0x41` | `w3a` | W3A |  |
| `0x42` | `w3b` | W3B |  |
| `0x43` | `w3c` | W3C |  |
| `0x44` | `w3d` | W3D |  |
| `0x45` | `w3e` | W3E |  |
| `0x46` | `w3f` | W3F |  |
| `0x47` | `w40` | W40 |  |
| `0x48` | `w41` | W41 |  |
| `0x49` | `w42` | W42 |  |
| `0x4a` | `w43` | W43 |  |
| `0x4b` | `w44` | W44 |  |
| `0x4c` | `w45` | W45 |  |

## Enum: fm_synth_operator_mod_slot

`fm_synth_operator_mod_slot`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `unset` | -- |  |
| `0x01` | `operator_1_level` | 1&gt;LEV |  |
| `0x02` | `operator_2_level` | 2&gt;LEV |  |
| `0x03` | `operator_3_level` | 3&gt;LEV |  |
| `0x04` | `operator_4_level` | 4&gt;LEV |  |
| `0x05` | `operator_1_ratio` | 1&gt;RAT |  |
| `0x06` | `operator_2_ratio` | 2&gt;RAT |  |
| `0x07` | `operator_3_ratio` | 3&gt;RAT |  |
| `0x08` | `operator_4_ratio` | 4&gt;RAT |  |
| `0x09` | `operator_1_pitch` | 1&gt;PIT |  |
| `0x0a` | `operator_2_pitch` | 2&gt;PIT |  |
| `0x0b` | `operator_3_pitch` | 3&gt;PIT |  |
| `0x0c` | `operator_4_pitch` | 4&gt;PIT |  |
| `0x0d` | `operator_1_feedback` | 1&gt;FBK |  |
| `0x0e` | `operator_2_feedback` | 2&gt;FBK |  |
| `0x0f` | `operator_3_feedback` | 3&gt;FBK |  |
| `0x10` | `operator_4_feedback` | 4&gt;FBK |  |

## Enum: wavsynth_shape

`wavsynth_shape`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `pulse_12_percent` | PULSE 12% |  |
| `0x01` | `pulse_25_percent` | PULSE 25% |  |
| `0x02` | `pulse_50_percent` | PULSE 50% |  |
| `0x03` | `pulse_75_percent` | PULSE 75% |  |
| `0x04` | `saw` | SAW |  |
| `0x05` | `triangle` | TRIANGLE |  |
| `0x06` | `sine` | SINE |  |
| `0x07` | `noise_pitched` | NOISE PITCHED |  |
| `0x08` | `noise` | NOISE |  |
| `0x09` | `osc_crush` | OSC:CRUSH |  |
| `0x0a` | `osc_folding` | OSC:FOLDING |  |
| `0x0b` | `osc_freq` | OSC:FREQ |  |
| `0x0c` | `osc_fuzzy` | OSC:FUZZY |  |
| `0x0d` | `osc_ghost` | OSC:GHOST |  |
| `0x0e` | `osc_graphic` | OSC:GRAPHIC |  |
| `0x0f` | `osc_lfoplay` | OSC:LFOPLAY |  |
| `0x10` | `osc_liquid` | OSC:LIQUID |  |
| `0x11` | `osc_morphing` | OSC:MORPHING |  |
| `0x12` | `osc_mystic` | OSC:MYSTIC |  |
| `0x13` | `osc_sticky` | OSC:STICKY |  |
| `0x14` | `osc_tidal` | OSC:TIDAL |  |
| `0x15` | `osc_tidy` | OSC:TIDY |  |
| `0x16` | `osc_tube` | OSC:TUBE |  |
| `0x17` | `osc_umbrella` | OSC:UMBRELLA |  |
| `0x18` | `osc_unwind` | OSC:UNWIND |  |
| `0x19` | `osc_viral` | OSC:VIRAL |  |
| `0x1a` | `osc_waves` | OSC:WAVES |  |
| `0x1b` | `bnk_drip` | BNK:DRIP |  |
| `0x1c` | `bnk_froggy` | BNK:FROGGY |  |
| `0x1d` | `bnk_insonic` | BNK:INSONIC |  |
| `0x1e` | `bnk_radius` | BNK:RADIUS |  |
| `0x1f` | `bnk_scratch` | BNK:SCRATCH |  |
| `0x20` | `bnk_smooth` | BNK:SMOOTH |  |
| `0x21` | `bnk_wobble` | BNK:WOBBLE |  |
| `0x22` | `hrm_asymmtry` | HRM:ASYMMTRY |  |
| `0x23` | `hrm_bleen` | HRM:BLEEN |  |
| `0x24` | `hrm_fractal` | HRM:FRACTAL |  |
| `0x25` | `hrm_gentle` | HRM:GENTLE |  |
| `0x26` | `hrm_harmonic` | HRM:HARMONIC |  |
| `0x27` | `hrm_hypnotic` | HRM:HYPNOTIC |  |
| `0x28` | `hrm_iterativ` | HRM:ITERATIV |  |
| `0x29` | `hrm_microwav` | HRM:MICROWAV |  |
| `0x2a` | `hrm_plaits01` | HRM:PLAITS01 |  |
| `0x2b` | `hrm_plaits02` | HRM:PLAITS02 |  |
| `0x2c` | `hrm_risefall` | HRM:RISEFALL |  |
| `0x2d` | `hrm_tonal` | HRM:TONAL |  |
| `0x2e` | `hrm_twine` | HRM:TWINE |  |
| `0x2f` | `efx_alien` | EFX:ALIEN |  |
| `0x30` | `efx_cybernet` | EFX:CYBERNET |  |
| `0x31` | `efx_disordr` | EFX:DISORDR |  |
| `0x32` | `efx_formant` | EFX:FORMANT |  |
| `0x33` | `efx_hyper` | EFX:HYPER |  |
| `0x34` | `efx_jagged` | EFX:JAGGED |  |
| `0x35` | `efx_mixed` | EFX:MIXED |  |
| `0x36` | `efx_multiply` | EFX:MULTIPLY |  |
| `0x37` | `efx_nowhere` | EFX:NOWHERE |  |
| `0x38` | `efx_pinball` | EFX:PINBALL |  |
| `0x39` | `efx_rings` | EFX:RINGS |  |
| `0x3a` | `efx_shimmer` | EFX:SHIMMER |  |
| `0x3b` | `efx_spectral` | EFX:SPECTRAL |  |
| `0x3c` | `efx_spooky` | EFX:SPOOKY |  |
| `0x3d` | `efx_transfrm` | EFX:TRANSFRM |  |
| `0x3e` | `efx_twisted` | EFX:TWISTED |  |
| `0x3f` | `efx_vocal` | EFX:VOCAL |  |
| `0x40` | `efx_washed` | EFX:WASHED |  |
| `0x41` | `efx_wonder` | EFX:WONDER |  |
| `0x42` | `efx_wowee` | EFX:WOWEE |  |
| `0x43` | `efx_zap` | EFX:ZAP |  |
| `0x44` | `vox_braids` | VOX:BRAIDS |  |
| `0x45` | `vox_voxsynth` | VOX:VOXSYNTH |  |

## Enum: macrosynth_shape

`macrosynth_shape`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `csaw` | CSAW |  |
| `0x01` | `morph` | MORPH |  |
| `0x02` | `saw_square` | SAW SQUARE |  |
| `0x03` | `sine_triangle` | SINE TRIANGLE |  |
| `0x04` | `buzz` | BUZZ |  |
| `0x05` | `square_sub` | SQUARE SUB |  |
| `0x06` | `saw_sub` | SAW SUB |  |
| `0x07` | `square_sync` | SQUARE SYNC |  |
| `0x08` | `saw_sync` | SAW SYNC |  |
| `0x09` | `triple_saw` | TRIPLE SAW |  |
| `0x0a` | `triple_square` | TRIPLE SQUARE |  |
| `0x0b` | `triple_triangle` | TRIPLE TRIANGLE |  |
| `0x0c` | `triple_sin` | TRIPLE SIN |  |
| `0x0d` | `triple_rng` | TRIPLE RNG |  |
| `0x0e` | `saw_swarm` | SAW SWARM |  |
| `0x0f` | `saw_comb` | SAW COMB |  |
| `0x10` | `toy` | TOY |  |
| `0x11` | `digital_filter_lp` | DIGITAL FILTER LP |  |
| `0x12` | `digital_filter_pk` | DIGITAL FILTER PK |  |
| `0x13` | `digital_filter_bp` | DIGITAL FILTER BP |  |
| `0x14` | `digital_filter_hp` | DIGITAL FILTER HP |  |
| `0x15` | `vosim` | VOSIM |  |
| `0x16` | `vowel` | VOWEL |  |
| `0x17` | `vowel_fof` | VOWEL FOF |  |
| `0x18` | `harmonics` | HARMONICS |  |
| `0x19` | `fm` | FM |  |
| `0x1a` | `feedback_fm` | FEEDBACK FM |  |
| `0x1b` | `chaotic_feedback_fm` | CHAOTIC FEEDBACK FM |  |
| `0x1c` | `plucked` | PLUCKED |  |
| `0x1d` | `bowed` | BOWED |  |
| `0x1e` | `blown` | BLOWN |  |
| `0x1f` | `fluted` | FLUTED |  |
| `0x20` | `struck_bell` | STRUCK BELL |  |
| `0x21` | `struck_drum` | STRUCK DRUM |  |
| `0x22` | `kick` | KICK |  |
| `0x23` | `cymbal` | CYMBAL |  |
| `0x24` | `snare` | SNARE |  |
| `0x25` | `wavetables` | WAVETABLES |  |
| `0x26` | `wave_map` | WAVE MAP |  |
| `0x27` | `wav_line` | WAV LINE |  |
| `0x28` | `wav_paraphonic` | WAV PARAPHONIC |  |
| `0x29` | `filtered_noise` | FILTERED NOISE |  |
| `0x2a` | `twin_peaks_noise` | TWIN PEAKS NOISE |  |
| `0x2b` | `clocked_noise` | CLOCKED NOISE |  |
| `0x2c` | `granular_cloud` | GRANULAR CLOUD |  |
| `0x2d` | `particle_noise` | PARTICLE NOISE |  |
| `0x2e` | `digital_mod` | DIGITAL MOD |  |
| `0x2f` | `morse_noise` | MORSE NOISE |  |

## Enum: sampler_play_mode

`sampler_play_mode`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `fwd` | FWD |  |
| `0x01` | `rev` | REV |  |
| `0x02` | `fwdloop` | FWDLOOP |  |
| `0x03` | `revloop` | REVLOOP |  |
| `0x04` | `fwd_ping_pong` | FWD PP |  |
| `0x05` | `rev_ping_pong` | REV PP |  |
| `0x06` | `osc` | OSC |  |
| `0x07` | `osc_rev` | OSC REV |  |
| `0x08` | `osc_ping_pong` | OSC PP |  |
| `0x09` | `repitch` | REPITCH |  |
| `0x0a` | `rep_rev` | REP.REV |  |
| `0x0b` | `rep_ping_pong` | REP.PP |  |
| `0x0c` | `rep_bpm` | REP.BPM |  |
| `0x0d` | `bpm_rev` | BPM.REV |  |
| `0x0e` | `bpm_ping_pong` | BPM.PP |  |
