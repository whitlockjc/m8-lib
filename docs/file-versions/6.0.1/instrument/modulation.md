# instrument_modulation_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/modulation.ksy](../../../../schemas/file-versions/6.0.1/instrument/modulation.ksy).

Byte order: `le`.

Shared modulation slot storage for M8 Instrument file schema 6.0.1.
Destination labels remain contextual to the enclosing instrument type.


File schema version: `6.0.1`.

## Contents

- [Layout](#layout)
- [slot](#type-slot)
- [ahd_env_params](#type-ahd_env_params)
- [adsr_env_params](#type-adsr_env_params)
- [drum_env_params](#type-drum_env_params)
- [lfo_params](#type-lfo_params)
- [trig_env_params](#type-trig_env_params)
- [tracking_params](#type-tracking_params)
- [type (enum)](#enum-type)
- [tracking_source (enum)](#enum-tracking_source)
- [lfo_oscillator (enum)](#enum-lfo_oscillator)
- [lfo_trigger (enum)](#enum-lfo_trigger)

## Layout

Root record.



## Type: slot

`slot`

Shared six-byte modulation slot: one packed type/destination byte, one
amount byte, and four type-dependent parameter bytes. The first two
bytes are Common Modulation Settings; params selects one of six
modulation-type-specific structures. The slot layout is independent of
the instrument-specific destination labels.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `type_and_destination` | `0x00` | 1 | `u1` | - | Packed byte: high nibble stores modulation type, low nibble stores destination. Destination labels are instrument-specific.  |
| `amount` | `0x01` | 1 | `u1` | - | Modulation amount. |
| `params` | `0x02..0x05` | 4 | switch on `modulation_type`: `type::ahd_env`: [ahd_env_params](#type-ahd_env_params); `type::adsr_env`: [adsr_env_params](#type-adsr_env_params); `type::drum_env`: [drum_env_params](#type-drum_env_params); `type::lfo`: [lfo_params](#type-lfo_params); `type::trig_env`: [trig_env_params](#type-trig_env_params); `type::tracking`: [tracking_params](#type-tracking_params) | - | Four-byte payload interpreted according to the modulation type. |

### Instances

Value expressions do not consume bytes. Positioned instances read the specified location.

| Name | Type | Expression / Position / Rules | Description |
| --- | --- | --- | --- |
| `modulation_type` | derived; [type](#enum-type) | `value`: `type_and_destination >> 4` |  |
| `destination` | derived | `value`: `type_and_destination & 0x0f` | Raw destination nibble shared by all modulation slots. Interpret it using the enclosing instrument type and its corresponding one of seven modulation destination enums in instrument.ksy. No single enum is valid for every instrument.  |

## Type: ahd_env_params

`ahd_env_params`

AHD ENV payload; fourth byte is preserved with unknown purpose.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `attack` | `0x00` | 1 | `u1` | - | Attack setting. |
| `hold` | `0x01` | 1 | `u1` | - | Hold setting. |
| `decay` | `0x02` | 1 | `u1` | - | Decay setting. |
| `unknown` | `0x03` | 1 | `u1` | - |  |

## Type: adsr_env_params

`adsr_env_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `attack` | `0x00` | 1 | `u1` | - |  |
| `decay` | `0x01` | 1 | `u1` | - |  |
| `sustain` | `0x02` | 1 | `u1` | - |  |
| `release` | `0x03` | 1 | `u1` | - |  |

## Type: drum_env_params

`drum_env_params`

DRUM ENV payload; fourth byte is preserved with unknown purpose.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `peak` | `0x00` | 1 | `u1` | - |  |
| `body` | `0x01` | 1 | `u1` | - |  |
| `decay` | `0x02` | 1 | `u1` | - |  |
| `unknown` | `0x03` | 1 | `u1` | - |  |

## Type: lfo_params

`lfo_params`

LFO payload; fourth byte is preserved with unknown purpose.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `oscillator` | `0x00` | 1 | `u1`; [lfo_oscillator](#enum-lfo_oscillator) | - |  |
| `trigger` | `0x01` | 1 | `u1`; [lfo_trigger](#enum-lfo_trigger) | - |  |
| `frequency` | `0x02` | 1 | `u1` | - |  |
| `unknown` | `0x03` | 1 | `u1` | - |  |

## Type: trig_env_params

`trig_env_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `attack` | `0x00` | 1 | `u1` | - |  |
| `hold` | `0x01` | 1 | `u1` | - |  |
| `decay` | `0x02` | 1 | `u1` | - |  |
| `source` | `0x03` | 1 | `u1` | - |  |

## Type: tracking_params

`tracking_params`

TRACKING payload; fourth byte is preserved with unknown purpose.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `source` | `0x00` | 1 | `u1`; [tracking_source](#enum-tracking_source) | - |  |
| `lowest_value` | `0x01` | 1 | `u1` | - |  |
| `highest_value` | `0x02` | 1 | `u1` | - |  |
| `unknown` | `0x03` | 1 | `u1` | - |  |

## Enum: type

`type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `ahd_env` | AHD ENV |  |
| `0x01` | `adsr_env` | ADSR ENV |  |
| `0x02` | `drum_env` | DRUM ENV |  |
| `0x03` | `lfo` | LFO |  |
| `0x04` | `trig_env` | TRIG ENV |  |
| `0x05` | `tracking` | TRACKING |  |

## Enum: tracking_source

`tracking_source`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `note` | NOTE |  |
| `0x01` | `velocity` | VELOCITY |  |
| `0x02` | `velocity_take` | VEL.TAKE |  |

## Enum: lfo_oscillator

`lfo_oscillator`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `triangle` | TRI |  |
| `0x01` | `sine` | SIN |  |
| `0x02` | `ramp_down` | RAMP DN |  |
| `0x03` | `ramp_up` | RAMP UP |  |
| `0x04` | `exp_down` | EXP DN |  |
| `0x05` | `exp_up` | EXP UP |  |
| `0x06` | `square_down` | SQU DN |  |
| `0x07` | `square_up` | SQU UP |  |
| `0x08` | `random` | RANDOM |  |
| `0x09` | `drunk` | DRUNK |  |
| `0x0a` | `triangle_t` | TRI T |  |
| `0x0b` | `sine_t` | SIN T |  |
| `0x0c` | `ramp_down_t` | RAMPDN T |  |
| `0x0d` | `ramp_up_t` | RAMPUP T |  |
| `0x0e` | `exp_down_t` | EXP DN T |  |
| `0x0f` | `exp_up_t` | EXP UP T |  |
| `0x10` | `square_down_t` | SQU DN T |  |
| `0x11` | `square_up_t` | SQU UP T |  |
| `0x12` | `random_t` | RAND T |  |
| `0x13` | `drunk_t` | DRUNK T |  |

## Enum: lfo_trigger

`lfo_trigger`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `free` | FREE |  |
| `0x01` | `retrig` | RETRIG |  |
| `0x02` | `hold` | HOLD |  |
| `0x03` | `once` | ONCE |  |
