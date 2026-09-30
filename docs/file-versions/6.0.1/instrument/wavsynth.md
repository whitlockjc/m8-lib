# instrument_wavsynth_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/wavsynth.ksy](../../../../schemas/file-versions/6.0.1/instrument/wavsynth.ksy).

Byte order: `le`.

Wavsynth specific parameters.

File schema version: `6.0.1`.

## Contents

- [Layout](#layout)
- [instrument_params](#type-instrument_params)
- [shape (enum)](#enum-shape)
- [destination (enum)](#enum-destination)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

Root record.



## Type: instrument_params

`instrument_params`



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `shape` | `0x00` | 1 | `u1`; [shape](#enum-shape) | - |  |
| `size` | `0x01` | 1 | `u1` | - |  |
| `mult` | `0x02` | 1 | `u1` | - |  |
| `warp` | `0x03` | 1 | `u1` | - |  |
| `scan` | `0x04` | 1 | `u1` | - |  |

## Enum: shape

`shape`

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

## Enum: destination

`destination`

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
