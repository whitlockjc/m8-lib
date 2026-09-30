# macrosynth_6_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/macrosynth.ksy](../../../../schemas/file-versions/6.0.1/instrument/macrosynth.ksy).

Byte order: `le`.

Macrosynth specific parameters.

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
| `timbre` | `0x01` | 1 | `u1` | - |  |
| `color` | `0x02` | 1 | `u1` | - |  |
| `degrade` | `0x03` | 1 | `u1` | - |  |
| `redux` | `0x04` | 1 | `u1` | - |  |

## Enum: shape

`shape`

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

## Enum: destination

`destination`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `off` | OFF |  |
| `0x01` | `volume` | VOLUME |  |
| `0x02` | `pitch` | PITCH |  |
| `0x03` | `timbre` | TIMBRE |  |
| `0x04` | `color` | COLOR |  |
| `0x05` | `degrade` | DEGRADE |  |
| `0x06` | `redux` | REDUX |  |
| `0x07` | `cutoff` | CUTOFF |  |
| `0x08` | `resonance` | RES |  |
| `0x09` | `amp` | AMP |  |
| `0x0a` | `pan` | PAN |  |
| `0x0b` | `mod_amount` | MOD AMT |  |
| `0x0c` | `mod_rate` | MOD RATE |  |
| `0x0d` | `mod_both` | MOD BOTH |  |
| `0x0e` | `mod_binv` | MOD BINV |  |
