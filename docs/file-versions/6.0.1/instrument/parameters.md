# parameters_6_0_1

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/parameters.ksy](../../../../schemas/file-versions/6.0.1/instrument/parameters.ksy).

Byte order: `le`.

Shared instrument filter, amplifier, mixer, and custom CC layouts.

File schema version: `6.0.1`.

## Contents

- [Layout](#layout)
- [custom_cc](#type-custom_cc)
- [filter_params](#type-filter_params)
- [amp_params](#type-amp_params)
- [mixer_params](#type-mixer_params)
- [filter_type (enum)](#enum-filter_type)
- [limit_type (enum)](#enum-limit_type)

## Layout

Root record.



## Type: custom_cc

`custom_cc`

Two-byte custom CC entry shared by MIDI Out and External.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `cc` | `0x00` | 1 | `u1` | - | Displayed as decimal in the M8 UI. |
| `value` | `0x01` | 1 | `u1` | - | Configured controller value. |

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
| `limit` | `0x01` | 1 | `u1`; [limit_type](#enum-limit_type) | - |  |
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
