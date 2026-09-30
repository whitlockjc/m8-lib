# fm_synth_6_0_1

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/fm_synth.ksy](../../../../schemas/file-versions/6.0.1/instrument/fm_synth.ksy).

Byte order: `le`.

FM Synth specific parameters.

File schema version: `6.0.1`.

## Contents

- [Layout](#layout)
- [instrument_params](#type-instrument_params)
- [operator_shapes](#type-operator_shapes)
- [operator_ratios](#type-operator_ratios)
- [operator_ratio](#type-operator_ratio)
- [operator_level_feedbacks](#type-operator_level_feedbacks)
- [operator_level_feedback](#type-operator_level_feedback)
- [operator_mod_slots](#type-operator_mod_slots)
- [mod_values](#type-mod_values)
- [algorithm (enum)](#enum-algorithm)
- [operator_shape (enum)](#enum-operator_shape)
- [operator_mod_slot (enum)](#enum-operator_mod_slot)
- [destination (enum)](#enum-destination)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

## Type: instrument_params

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `algo` | `0x00` | 1 | `u1`; [algorithm](#enum-algorithm) | - |  |
| `operator_shapes` | `0x01..0x04` | 4 | [operator_shapes](#type-operator_shapes) | - |  |
| `operator_ratios` | `0x05..0x0c` | 8 | [operator_ratios](#type-operator_ratios) | - |  |
| `operator_levels` | `0x0d..0x14` | 8 | [operator_level_feedbacks](#type-operator_level_feedbacks) | - |  |
| `operator_mod_a` | `0x15..0x18` | 4 | [operator_mod_slots](#type-operator_mod_slots) | - |  |
| `operator_mod_b` | `0x19..0x1c` | 4 | [operator_mod_slots](#type-operator_mod_slots) | - |  |
| `mods` | `0x1d..0x20` | 4 | [mod_values](#type-mod_values) | - |  |

## Type: operator_shapes

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00` | 1 | `u1`; [operator_shape](#enum-operator_shape) | - |  |
| `operator_2` | `0x01` | 1 | `u1`; [operator_shape](#enum-operator_shape) | - |  |
| `operator_3` | `0x02` | 1 | `u1`; [operator_shape](#enum-operator_shape) | - |  |
| `operator_4` | `0x03` | 1 | `u1`; [operator_shape](#enum-operator_shape) | - |  |

## Type: operator_ratios

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00..0x01` | 2 | [operator_ratio](#type-operator_ratio) | - |  |
| `operator_2` | `0x02..0x03` | 2 | [operator_ratio](#type-operator_ratio) | - |  |
| `operator_3` | `0x04..0x05` | 2 | [operator_ratio](#type-operator_ratio) | - |  |
| `operator_4` | `0x06..0x07` | 2 | [operator_ratio](#type-operator_ratio) | - |  |

## Type: operator_ratio

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `ratio` | `0x00` | 1 | `u1` | - |  |
| `ratio_fine` | `0x01` | 1 | `u1` | - |  |

## Type: operator_level_feedbacks

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00..0x01` | 2 | [operator_level_feedback](#type-operator_level_feedback) | - |  |
| `operator_2` | `0x02..0x03` | 2 | [operator_level_feedback](#type-operator_level_feedback) | - |  |
| `operator_3` | `0x04..0x05` | 2 | [operator_level_feedback](#type-operator_level_feedback) | - |  |
| `operator_4` | `0x06..0x07` | 2 | [operator_level_feedback](#type-operator_level_feedback) | - |  |

## Type: operator_level_feedback

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `level` | `0x00` | 1 | `u1` | - |  |
| `feedback` | `0x01` | 1 | `u1` | - |  |

## Type: operator_mod_slots

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `operator_1` | `0x00` | 1 | `u1`; [operator_mod_slot](#enum-operator_mod_slot) | - |  |
| `operator_2` | `0x01` | 1 | `u1`; [operator_mod_slot](#enum-operator_mod_slot) | - |  |
| `operator_3` | `0x02` | 1 | `u1`; [operator_mod_slot](#enum-operator_mod_slot) | - |  |
| `operator_4` | `0x03` | 1 | `u1`; [operator_mod_slot](#enum-operator_mod_slot) | - |  |

## Type: mod_values

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `mod_1` | `0x00` | 1 | `u1` | - |  |
| `mod_2` | `0x01` | 1 | `u1` | - |  |
| `mod_3` | `0x02` | 1 | `u1` | - |  |
| `mod_4` | `0x03` | 1 | `u1` | - |  |

## Enum: algorithm

`algorithm`

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

## Enum: operator_shape

`operator_shape`

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

## Enum: operator_mod_slot

`operator_mod_slot`

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

## Enum: destination

`destination`

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
