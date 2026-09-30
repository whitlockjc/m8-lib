# external_6_0_1

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/external.ksy](../../../../schemas/file-versions/6.0.1/instrument/external.ksy).

Byte order: `le`.

External specific parameters.

File schema version: `6.0.1`.

## Imports

- [parameters_6_0_1](parameters.md)

## Contents

- [Layout](#layout)
- [instrument_params](#type-instrument_params)
- [input (enum)](#enum-input)
- [port (enum)](#enum-port)
- [destination (enum)](#enum-destination)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

## Type: instrument_params

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `input` | `0x00` | 1 | `u1`; [input](#enum-input) | - |  |
| `port` | `0x01` | 1 | `u1`; [port](#enum-port) | - |  |
| `channel` | `0x02` | 1 | `u1` | - | MIDI channel, displayed in decimal; channel 16 is stored as 0x10.  |
| `bank` | `0x03` | 1 | `u1` | - | MIDI bank, displayed in decimal; bank 127 is stored as 0x7f.  |
| `program_change` | `0x04` | 1 | `u1` | - | Program change, displayed in decimal; program 126 is stored as 0x7e.  |
| `custom_ccs` | `0x05..0x0c` | 8 | [parameters_6_0_1::custom_cc](parameters.md#type-custom_cc) | `repeat`: `expr`; `repeat-expr`: `4` | Four configurable MIDI controller number and value pairs. |

## Enum: input

`input`

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

## Enum: port

`port`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `none` | NONE |  |
| `0x01` | `midi_usb` | MIDI+USB |  |
| `0x02` | `midi` | MIDI |  |
| `0x03` | `usb` | USB |  |

## Enum: destination

`destination`

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
