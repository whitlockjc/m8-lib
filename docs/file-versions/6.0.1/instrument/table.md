# instrument_table_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/table.ksy](../../../../schemas/file-versions/6.0.1/instrument/table.ksy).

Byte order: `le`.

Sixteen eight-byte Instrument Table rows for file schema 6.0.1.
Standalone Instruments append one table; Songs store 256 tables separately.
FX command catalogs depend on the active instrument and remain contextual.


File schema version: `6.0.1`.

## Imports

- [fx_slot](../../../common/fx_slot.md)

## Contents

- [Layout](table.md#layout)
- [table_row](table.md#type-table_row)
- [wavsynth_table_fx_command (enum)](table.md#enum-wavsynth_table_fx_command)
- [macrosynth_table_fx_command (enum)](table.md#enum-macrosynth_table_fx_command)
- [sampler_table_fx_command (enum)](table.md#enum-sampler_table_fx_command)
- [fm_synth_table_fx_command (enum)](table.md#enum-fm_synth_table_fx_command)
- [midi_out_table_fx_command (enum)](table.md#enum-midi_out_table_fx_command)
- [hypersynth_table_fx_command (enum)](table.md#enum-hypersynth_table_fx_command)
- [external_table_fx_command (enum)](table.md#enum-external_table_fx_command)
- [none_table_fx_command (enum)](table.md#enum-none_table_fx_command)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `rows` | `0x00..0x7f` | 128 | [table_row](table.md#type-table_row) | `repeat`: `expr`; `repeat-expr`: `16` |  |

## Type: table_row

`table_row`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `transpose` | `0x00` | 1 | `u1` | - |  |
| `volume` | `0x01` | 1 | `u1` | - | Observed value 0xff displays as --. |
| `fx` | `0x02..0x07` | 6 | [fx_slot](../../../common/fx_slot.md#layout) | `repeat`: `expr`; `repeat-expr`: `3` |  |

## Enum: wavsynth_table_fx_command

`wavsynth_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `fine` | FIN |  |
| `0x83` | `oscillator` | OSC |  |
| `0x84` | `size` | SIZ |  |
| `0x85` | `mult` | MUL |  |
| `0x86` | `warp` | WRP |  |
| `0x87` | `scan` | SCN |  |
| `0x88` | `filter` | FIL |  |
| `0x89` | `cutoff` | CUT |  |
| `0x8a` | `resonance` | RES |  |
| `0x8b` | `amp` | AMP |  |
| `0x8c` | `limit` | LIM |  |
| `0x8d` | `pan` | PAN |  |
| `0x8e` | `dry` | DRY |  |
| `0x8f` | `smx` | SMX |  |
| `0x90` | `send_delay` | SDL |  |
| `0x91` | `send_reverb` | SRV |  |
| `0xa6` | `snc` | SNC |  |
| `0xa7` | `err` | ERR |  |
| `0xff` | `unset` | -- |  |

## Enum: macrosynth_table_fx_command

`macrosynth_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `fine` | FIN |  |
| `0x83` | `oscillator` | OSC |  |
| `0x84` | `timbre` | TBR |  |
| `0x85` | `color` | COL |  |
| `0x86` | `degrade` | DEG |  |
| `0x87` | `redux` | RED |  |
| `0x88` | `filter` | FIL |  |
| `0x89` | `cutoff` | CUT |  |
| `0x8a` | `resonance` | RES |  |
| `0x8b` | `amp` | AMP |  |
| `0x8c` | `limit` | LIM |  |
| `0x8d` | `pan` | PAN |  |
| `0x8e` | `dry` | DRY |  |
| `0x8f` | `smx` | SMX |  |
| `0x90` | `send_delay` | SDL |  |
| `0x91` | `send_reverb` | SRV |  |
| `0xa6` | `trigger` | TRG |  |
| `0xa7` | `err` | ERR |  |
| `0xff` | `unset` | -- |  |

## Enum: sampler_table_fx_command

`sampler_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `fine` | FIN |  |
| `0x83` | `play` | PLY |  |
| `0x84` | `start` | STA |  |
| `0x85` | `loop` | LOP |  |
| `0x86` | `length` | LEN |  |
| `0x87` | `degrade` | DEG |  |
| `0x88` | `filter` | FLT |  |
| `0x89` | `cutoff` | CUT |  |
| `0x8a` | `resonance` | RES |  |
| `0x8b` | `amp` | AMP |  |
| `0x8c` | `limit` | LIM |  |
| `0x8d` | `pan` | PAN |  |
| `0x8e` | `dry` | DRY |  |
| `0x8f` | `smx` | SMX |  |
| `0x90` | `send_delay` | SDL |  |
| `0x91` | `send_reverb` | SRV |  |
| `0xa6` | `slice` | SLI |  |
| `0xa7` | `err` | ERR |  |
| `0xff` | `unset` | -- |  |

## Enum: fm_synth_table_fx_command

`fm_synth_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `fine` | FIN |  |
| `0x83` | `algorithm` | ALG |  |
| `0x84` | `fm1` | FM1 |  |
| `0x85` | `fm2` | FM2 |  |
| `0x86` | `fm3` | FM3 |  |
| `0x87` | `fm4` | FM4 |  |
| `0x88` | `filter` | FIL |  |
| `0x89` | `cutoff` | CUT |  |
| `0x8a` | `resonance` | RES |  |
| `0x8b` | `amp` | AMP |  |
| `0x8c` | `limit` | LIM |  |
| `0x8d` | `pan` | PAN |  |
| `0x8e` | `dry` | DRY |  |
| `0x8f` | `smx` | SMX |  |
| `0x90` | `send_delay` | SDL |  |
| `0x91` | `send_reverb` | SRV |  |
| `0xa6` | `snc` | SNC |  |
| `0xa7` | `err` | ERR |  |
| `0xff` | `unset` | -- |  |

## Enum: midi_out_table_fx_command

`midi_out_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `midi_program` | MPG |  |
| `0x83` | `midi_program_bank` | MPB |  |
| `0x84` | `add` | ADD |  |
| `0x85` | `chord` | CHD |  |
| `0x86` | `cc_a` | CCA |  |
| `0x87` | `cc_b` | CCB |  |
| `0x88` | `cc_c` | CCC |  |
| `0x89` | `cc_d` | CCD |  |
| `0x8a` | `cc_e` | CCE |  |
| `0x8b` | `cc_f` | CCF |  |
| `0x8c` | `cc_g` | CCG |  |
| `0x8d` | `cc_h` | CCH |  |
| `0x8e` | `cc_i` | CCI |  |
| `0x8f` | `cc_j` | CCJ |  |
| `0xff` | `unset` | -- |  |

## Enum: hypersynth_table_fx_command

`hypersynth_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `fine` | FIN |  |
| `0x83` | `chord` | CRD |  |
| `0x84` | `chord_volume` | CVO |  |
| `0x85` | `swarm` | SWM |  |
| `0x86` | `width` | WID |  |
| `0x87` | `subosc` | SUB |  |
| `0x88` | `filter` | FIL |  |
| `0x89` | `cutoff` | CUT |  |
| `0x8a` | `resonance` | RES |  |
| `0x8b` | `amp` | AMP |  |
| `0x8c` | `limit` | LIM |  |
| `0x8d` | `pan` | PAN |  |
| `0x8e` | `dry` | DRY |  |
| `0x8f` | `smx` | SMX |  |
| `0x90` | `send_delay` | SDL |  |
| `0x91` | `send_reverb` | SRV |  |
| `0xa6` | `snc` | SNC |  |
| `0xa7` | `err` | ERR |  |
| `0xff` | `unset` | -- |  |

## Enum: external_table_fx_command

`external_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x80` | `volume` | VOL |  |
| `0x81` | `pitch` | PIT |  |
| `0x82` | `midi_program_bank` | MPB |  |
| `0x83` | `midi_program` | MPG |  |
| `0x84` | `cc_a` | CCA |  |
| `0x85` | `cc_b` | CCB |  |
| `0x86` | `cc_c` | CCC |  |
| `0x87` | `cc_d` | CCD |  |
| `0x88` | `filter` | FIL |  |
| `0x89` | `cutoff` | CUT |  |
| `0x8a` | `resonance` | RES |  |
| `0x8b` | `amp` | AMP |  |
| `0x8c` | `limit` | LIM |  |
| `0x8d` | `pan` | PAN |  |
| `0x8e` | `dry` | DRY |  |
| `0x8f` | `smx` | SMX |  |
| `0x90` | `send_delay` | SDL |  |
| `0x91` | `send_reverb` | SRV |  |
| `0xa6` | `add` | ADD |  |
| `0xa7` | `chord` | CHD |  |
| `0xff` | `unset` | -- |  |

## Enum: none_table_fx_command

`none_table_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0xff` | `unset` | -- |  |
