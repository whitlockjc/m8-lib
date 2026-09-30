# song_mixer_effects_6_6_2

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.6.2/song/mixer_effects.ksy](../../../../schemas/file-versions/6.6.2/song/mixer_effects.ksy).

Byte order: `le`.

Mixer, Effects Settings, and Mix & Limiter Scope layouts for Song file
schema version 6.6.2. The Song body determines their positions.


File schema version: `6.6.2`.

## Contents

- [Layout](#layout)
- [mixer_settings](#type-mixer_settings)
- [effects_and_scope_settings](#type-effects_and_scope_settings)
- [mod_fx_settings](#type-mod_fx_settings)
- [delay_settings](#type-delay_settings)
- [reverb_settings](#type-reverb_settings)
- [mix_limiter_scope_settings](#type-mix_limiter_scope_settings)
- [mixer_sends](#type-mixer_sends)
- [mod_fx_type (enum)](#enum-mod_fx_type)
- [dj_filter_type (enum)](#enum-dj_filter_type)

## Layout

Root record.



## Type: mixer_settings

`mixer_settings`

Mixer and Mix & Limiter Scope storage. Offsets are relative to absolute
file offset 0x00ce.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `mix` | `0x00` | 1 | `u1` | - | Master mix volume. |
| `limiter` | `0x01` | 1 | `u1` | - | Master limiter amount. |
| `track_volumes` | `0x02..0x09` | 8 | `u1` | `repeat`: `expr`; `repeat-expr`: `8` | Volume for each of the eight tracks. |
| `sends` | `0x0a..0x0c` | 3 | [mixer_sends](#type-mixer_sends) | - | Master sends to ModFX, Delay, and Reverb. |
| `analog_input_volume` | `0x0d` | 1 | `u1` | - | Analog input volume. |
| `analog_dual_mono_input_volume` | `0x0e` | 1 | `u1` | - | Default fixture stores 0xff. The M8 UI displays this as unset until dual mono input is enabled.  |
| `usb_input_volume` | `0x0f` | 1 | `u1` | - | USB input volume. |
| `analog_input_sends` | `0x10..0x12` | 3 | [mixer_sends](#type-mixer_sends) | - | Analog input effect sends. |
| `analog_dual_mono_input_sends` | `0x13..0x15` | 3 | [mixer_sends](#type-mixer_sends) | - | Second analog mono input effect sends. |
| `usb_input_sends` | `0x16..0x18` | 3 | [mixer_sends](#type-mixer_sends) | - | USB input effect sends. |
| `dj_filter` | `0x19` | 1 | `u1` | - | DJ filter setting. |
| `dj_filter_resonance` | `0x1a` | 1 | `u1` | - | DJ filter resonance. |
| `dj_filter_type` | `0x1b` | 1 | `u1`; [dj_filter_type](#enum-dj_filter_type) | - | DJ filter type. |
| `limiter_attack` | `0x1c` | 1 | `u1` | - | Limiter attack setting. |
| `limiter_release` | `0x1d` | 1 | `u1` | - | Limiter release setting. |
| `soft_clip` | `0x1e` | 1 | `u1` | - | Observed values: 0x00 means OFF, 0x01 means ON.  |
| `ott` | `0x1f` | 1 | `u1` | - | OTT amount. |

## Type: effects_and_scope_settings

`effects_and_scope_settings`

Shared storage region for the Effects Settings and Mix & Limiter Scope
views. Offsets are relative to absolute file offset 0x1a5be in 6.5.x and
6.6.x fixtures. Storage order does not fully match the UI grouping; the Mod FX
type byte is stored after the Mix & Limiter Scope OTT detail bytes.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `unknown_0` | `0x00..0x02` | 3 | bytes | `size`: `3` | Preserved bytes before the mapped Mod FX parameter bytes. |
| `mod_fx` | `0x03..0x06` | 4 | [mod_fx_settings](#type-mod_fx_settings) | - |  |
| `unknown_1` | `0x07..0x0b` | 5 | bytes | `size`: `5` | Preserved bytes between Mod FX and Delay parameters. Historical &lt;https://github.com/whitlockjc/m8-js&gt; reference code treats part of this region as delay filter storage.  |
| `delay` | `0x0c..0x10` | 5 | [delay_settings](#type-delay_settings) | - |  |
| `unknown_2` | `0x11..0x13` | 3 | bytes | `size`: `3` | Preserved bytes between Delay and Reverb parameters. Historical &lt;https://github.com/whitlockjc/m8-js&gt; reference code treats part of this region as reverb filter storage.  |
| `reverb` | `0x14..0x19` | 6 | [reverb_settings](#type-reverb_settings) | - |  |
| `mix_limiter_scope` | `0x1a..0x1b` | 2 | [mix_limiter_scope_settings](#type-mix_limiter_scope_settings) | - |  |
| `mod_fx_type` | `0x1c` | 1 | `u1`; [mod_fx_type](#enum-mod_fx_type) | - | ModFX type selected in Effects Settings. |

## Type: mod_fx_settings

`mod_fx_settings`

Mod FX parameter storage from the Effects Settings View. The Mod FX type
byte is stored later in the shared Effects/Mix & Limiter Scope region.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `depth` | `0x00` | 1 | `u1` | - | ModFX depth. |
| `frequency` | `0x01` | 1 | `u1` | - | ModFX frequency. |
| `width` | `0x02` | 1 | `u1` | - | ModFX stereo width. |
| `reverb_send` | `0x03` | 1 | `u1` | - | ModFX send to Reverb. |

## Type: delay_settings

`delay_settings`

Delay parameter storage from the Effects Settings View.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `time_left` | `0x00` | 1 | `u1` | - | Left Delay time. |
| `time_right` | `0x01` | 1 | `u1` | - | Right Delay time. |
| `feedback` | `0x02` | 1 | `u1` | - | Delay feedback. |
| `width` | `0x03` | 1 | `u1` | - | Delay stereo width. |
| `reverb_send` | `0x04` | 1 | `u1` | - | Delay send to Reverb. |

## Type: reverb_settings

`reverb_settings`

Reverb parameter storage from the Effects Settings View.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `room_size` | `0x00` | 1 | `u1` | - | Reverb room size. |
| `decay` | `0x01` | 1 | `u1` | - | Reverb decay. |
| `depth` | `0x02` | 1 | `u1` | - | Reverb depth. |
| `frequency` | `0x03` | 1 | `u1` | - | Reverb frequency. |
| `width` | `0x04` | 1 | `u1` | - | Reverb stereo width. |
| `shimmer` | `0x05` | 1 | `u1` | - | Reverb shimmer. |

## Type: mix_limiter_scope_settings

`mix_limiter_scope_settings`

Mix & Limiter Scope storage for OTT detail controls from the Mix &
Limiter Scope View. Offsets are relative to absolute file offset
0x1a5d8 in 6.5.x fixtures.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `ott_time` | `0x00` | 1 | `u1` | - | OTT time. |
| `ott_color` | `0x01` | 1 | `u1` | - | OTT color. |

## Type: mixer_sends

`mixer_sends`

Effect send levels for ModFX, Delay, and Reverb.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `mod_fx` | `0x00` | 1 | `u1` | - | ModFX send level. |
| `delay` | `0x01` | 1 | `u1` | - | Delay send level. |
| `reverb` | `0x02` | 1 | `u1` | - | Reverb send level. |

## Enum: mod_fx_type

`mod_fx_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `chorus` | CHORUS |  |
| `0x01` | `phaser` | PHASER |  |
| `0x02` | `flanger` | FLANGER |  |
| `0x03` | `comb` | COMB |  |

## Enum: dj_filter_type

`dj_filter_type`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `lowpass_highpass` | LOWPASS:HIGHPASS |  |
| `0x01` | `lowpass_bandstop` | LOWPASS:BANDSTOP |  |
| `0x02` | `bandpass_highpass` | BANDPASS:HIGHPASS |  |
