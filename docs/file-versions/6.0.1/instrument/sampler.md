# sampler_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/sampler.ksy](../../../../schemas/file-versions/6.0.1/instrument/sampler.ksy).

Byte order: `le`.

Sampler specific parameters.

File schema version: `6.0.1`.

## Contents

- [Layout](#layout)
- [instrument_params](#type-instrument_params)
- [sample_path](#type-sample_path)
- [play_mode (enum)](#enum-play_mode)
- [destination (enum)](#enum-destination)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

Root record.



## Type: instrument_params

`instrument_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `mode_value` | `0x00` | 1 | `u1` | - | Displayed as detune, steps, or BPM according to play_mode. |
| `play_mode` | `0x01` | 1 | `u1`; [play_mode](#enum-play_mode) | - | Sampler playback mode. |
| `slice` | `0x02` | 1 | `u1` | - | Sampler slice selection. |
| `start` | `0x03` | 1 | `u1` | - | Sample start setting. |
| `loop_start` | `0x04` | 1 | `u1` | - | Sample loop start setting. |
| `length` | `0x05` | 1 | `u1` | - | Sample length setting. |
| `degrade` | `0x06` | 1 | `u1` | - | Sampler degrade setting. |

## Type: sample_path

`sample_path`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `path` | `0x00 onward` | variable | `strz` | `encoding`: `ASCII` |  |
| `trailing` | `dynamic` | variable | bytes | `size`: `_io.size - _io.pos` | Remaining path-field bytes after the terminator; preserve stored bytes. |

## Enum: play_mode

`play_mode`

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

## Enum: destination

`destination`

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
