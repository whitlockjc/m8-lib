# instrument_hypersynth_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/hypersynth.ksy](../../../../schemas/file-versions/6.0.1/instrument/hypersynth.ksy).

Byte order: `le`.

Hypersynth specific parameters.

File schema version: `6.0.1`.

## Contents

- [Layout](#layout)
- [instrument_params](#type-instrument_params)
- [current_chord](#type-current_chord)
- [chord_notes](#type-chord_notes)
- [chord](#type-chord)
- [destination (enum)](#enum-destination)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

Root record.



## Type: instrument_params

`instrument_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `current_chord` | `0x00..0x06` | 7 | [current_chord](#type-current_chord) | - | Currently selected chord and its notes. These bytes mirror the selected entry in the separately stored Hypersynth chord table.  |
| `scale` | `0x07` | 1 | `u1` | - |  |
| `shift` | `0x08` | 1 | `u1` | - |  |
| `swarm` | `0x09` | 1 | `u1` | - |  |
| `width` | `0x0a` | 1 | `u1` | - |  |
| `subosc` | `0x0b` | 1 | `u1` | - |  |

## Type: current_chord

`current_chord`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `index` | `0x00` | 1 | `u1` | - |  |
| `notes` | `0x01..0x06` | 6 | [chord_notes](#type-chord_notes) | - |  |

## Type: chord_notes

`chord_notes`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `note_1` | `0x00` | 1 | `u1` | - |  |
| `note_2` | `0x01` | 1 | `u1` | - |  |
| `note_3` | `0x02` | 1 | `u1` | - |  |
| `note_4` | `0x03` | 1 | `u1` | - |  |
| `note_5` | `0x04` | 1 | `u1` | - |  |
| `note_6` | `0x05` | 1 | `u1` | - |  |

## Type: chord

`chord`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `enabled_notes` | `0x00` | 1 | `u1` | - | Bitmask for six chord notes; bits 0 through 5 indicate enabled notes. |
| `notes` | `0x01..0x06` | 6 | [chord_notes](#type-chord_notes) | - |  |

## Enum: destination

`destination`

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
