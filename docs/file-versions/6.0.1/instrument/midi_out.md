# instrument_midi_out_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/midi_out.ksy](../../../../schemas/file-versions/6.0.1/instrument/midi_out.ksy).

Byte order: `le`.

MIDI Out specific parameters.

File schema version: `6.0.1`.

## Imports

- [instrument_parameters_6_0_1](parameters.md)

## Contents

- [Layout](#layout)
- [instrument_params](#type-instrument_params)
- [port (enum)](#enum-port)
- [destination (enum)](#enum-destination)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

Root record.



## Type: instrument_params

`instrument_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `port` | `0x00` | 1 | `u1`; [port](#enum-port) | - |  |
| `channel` | `0x01` | 1 | `u1` | - | MIDI channel, displayed in decimal; channel 16 is stored as 0x10.  |
| `bank` | `0x02` | 1 | `u1` | - | MIDI bank, displayed in decimal; bank 127 is stored as 0x7f.  |
| `unknown_0` | `0x03..0x04` | 2 | bytes | `size`: `2` |  |
| `program_change` | `0x05` | 1 | `u1` | - | Program change, displayed in decimal; program 126 is stored as 0x7e.  |
| `unknown_1` | `0x06..0x08` | 3 | bytes | `size`: `3` |  |
| `custom_ccs` | `0x09..0x1c` | 20 | [instrument_parameters_6_0_1::custom_cc](parameters.md#type-custom_cc) | `repeat`: `expr`; `repeat-expr`: `10` | Ten configurable MIDI controller number and value pairs. |

## Enum: port

`port`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `midi_usb` | MIDI+USB |  |
| `0x01` | `midi` | MIDI |  |
| `0x02` | `usb` | USB |  |
| `0x03` | `internal` | INTERNAL |  |

## Enum: destination

`destination`

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
