# Song

Human-readable schema reference for M8 Song files.

This document starts with fields mapped from the Project, MIDI Settings, Song
View, Bookmarks, Chain View, Mixer, Effects Settings, Mix & Limiter Scope, Mix
EQ, ModFX EQ, Delay EQ, Reverb EQ, and MIDI Mapping pages. Most of the Song
body remains preserved as unknown bytes until additional Song fixtures map those
regions.

## Schema

| Name | Value |
| --- | --- |
| File type | Song |
| File extension | `.m8s` |
| M8 file schema version | `6.5.0` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/6.5.0/song.ksy` |
| Total file size | 112326 bytes |
| Header size | 14 bytes |
| Body size | 112312 bytes |

## Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x0000..0x000d` | 14 | [M8 File Header](FILE_HEADER.md) |
| `unknownBeforeProject` | `0x000e..0x008d` | 128 | unknown bytes |
| `project` | `0x008e..0x00be` | 49 | [Project Settings](#project-settings) |
| `unknownBetweenProjectAndMixer` | `0x00bf..0x00cd` | 15 | unknown bytes |
| `mixer` | `0x00ce..0x00ed` | 32 | [Mixer](#mixer) |
| `unknownBetweenMixerAndRows` | `0x00ee..0x02ed` | 512 | unknown bytes |
| `rows` | `0x02ee..0x0aed` | 2048 | [Song Rows](#song-rows) |
| `unknownBetweenRowsAndChains` | `0x0aee..0x9a5d` | 36720 | unknown bytes |
| `chains` | `0x9a5e..0xba5d` | 8192 | [Chains](#chains) |
| `unknownBetweenChainsAndEffectsAndScope` | `0xba5e..0x1a5bd` | 60256 | unknown bytes |
| `effectsAndScope` | `0x1a5be..0x1a5da` | 29 | [Effects & Scope Storage](#effects--scope-storage) |
| `unknownBetweenEffectsAndScopeAndMidiMappings` | `0x1a5db..0x1a5fd` | 35 | unknown bytes |
| `midiMappings` | `0x1a5fe..0x1a97d` | 896 | [MIDI Mappings](#midi-mappings) |
| `bookmarks` | `0x1a97e..0x1aa7d` | 256 | [Bookmarks](#bookmarks) |
| `unknownBetweenBookmarksAndMixEq` | `0x1aa7e..0x1b65d` | 3040 | unknown bytes |
| `mixEq` | `0x1b65e..0x1b66f` | 18 | [Mix EQ](#mix-eq) |
| `modFxEq` | `0x1b670..0x1b681` | 18 | [ModFX EQ](#modfx-eq) |
| `delayEq` | `0x1b682..0x1b693` | 18 | [Delay EQ](#delay-eq) |
| `reverbEq` | `0x1b694..0x1b6a5` | 18 | [Reverb EQ](#reverb-eq) |
| `unknownAfterReverbEq` | `0x1b6a6..0x1b6c5` | 32 | unknown bytes |

### Project Settings

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `transpose` | `0x008e` | 1 | `u1` |
| `tempo` | `0x008f..0x0092` | 4 | `f4` |
| `liveQuantize` | `0x0093` | 1 | [Live Quantize](#live-quantize) |
| `name` | `0x0094..0x009f` | 12 | [Fixed String](#fixed-string) |
| `midiSettings` | `0x00a0..0x00ba` | 27 | [MIDI Settings](#midi-settings) |
| `scale` | `0x00bb` | 1 | `u1` |
| `groove` | `0x00bc` | 1 | `u1` |
| `unknownTrailingState` | `0x00bd..0x00be` | 2 | unknown bytes |

### Live Quantize

The Project page displays `CHAIN LEN` for `0x00`. Values from `0x01` through
`0xff` display as step counts.

| Stored Value | Label |
| --- | --- |
| `0x00` | `CHAIN LEN` |
| `0x01..0xff` | `STEPS` |

### Fixed String

The Project name is stored in a fixed 12-byte range. The visible string may use
only part of the range, and padding bytes must be preserved.

The verified fixture pair shows:

| Fixture | Stored Value |
| --- | --- |
| `DEFAULT.m8s` | `DEFAULT` followed by five `0x00` bytes |
| `PROJECT.m8s` | `PROJECT` followed by five `0x00` bytes |
| `MIDI_SETTING.m8s` | `MIDI_SETTING` with no padding bytes |
| `MIDI_MAPPING.m8s` | `MIDI_MAPPING` with no padding bytes |
| `BOOKMARKS.m8s` | `BOOKMARKS` followed by three `0x00` bytes |
| `CHAINS.m8s` | `CHAINS` followed by six `0x00` bytes |
| `EFFECTS.m8s` | `EFFECTS` followed by five `0x00` bytes |
| `MODFX_EQ.m8s` | `MODFX_EQ` followed by four `0x00` bytes |
| `DELAY_EQ.m8s` | `DELAY_EQ` followed by four `0x00` bytes |
| `REVERB_EQ.m8s` | `REVERB_EQ` followed by three `0x00` bytes |
| `SONG_ROWS.m8s` | `SONG_ROWS` followed by three `0x00` bytes |
| `MIXER.m8s` | `MIXER` followed by seven `0x00` bytes |
| `MIX_EQ.m8s` | `MIX_EQ` followed by six `0x00` bytes |
| `MIX_SCOPE.m8s` | `MIX_SCOPE` followed by three `0x00` bytes |
| `LIMIT_SCOPE.m8s` | `LIMIT_SCOPE` followed by one `0x00` byte |

### Song Rows

The Song View stores 256 rows. Each row stores one chain index for each of the
8 tracks. The `SONG_ROWS.m8s` fixture verifies the first and last rows of the
contiguous row table.

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `entries[0..255]` | `0x02ee..0x0aed` | 2048 | [Song Row](#song-row) |

### Song Row

Offsets are relative to the start of a Song row.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `track1` | `+0x00` | 1 | `u1` |
| `track2` | `+0x01` | 1 | `u1` |
| `track3` | `+0x02` | 1 | `u1` |
| `track4` | `+0x03` | 1 | `u1` |
| `track5` | `+0x04` | 1 | `u1` |
| `track6` | `+0x05` | 1 | `u1` |
| `track7` | `+0x06` | 1 | `u1` |
| `track8` | `+0x07` | 1 | `u1` |

The default row value for each track is `0xff`, which the M8 UI displays as
unset. Other observed values are chain indexes.

### Bookmarks

The Song View stores one bookmark bitmask byte for each of the 256 Song rows.
Bits `0..7` correspond to tracks `1..8`.

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `entries[0..255]` | `0x1a97e..0x1aa7d` | 256 | [Bookmark Row](#bookmark-row) |

### Bookmark Row

Offsets are relative to the start of a Bookmark row.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `trackMask` | `+0x00` | 1 | `u1` |

| Bit | Field | Track |
| ---: | --- | --- |
| `0` | `track1` | `1` |
| `1` | `track2` | `2` |
| `2` | `track3` | `3` |
| `3` | `track4` | `4` |
| `4` | `track5` | `5` |
| `5` | `track6` | `6` |
| `6` | `track7` | `7` |
| `7` | `track8` | `8` |

The `BOOKMARKS.m8s` fixture verifies:

| Row | Stored Value | Bookmarked Tracks |
| --- | --- | --- |
| `0x00` | `0xaa` | `2,4,6,8` |
| `0x01` | `0x55` | `1,3,5,7` |
| `0xfe` | `0x55` | `1,3,5,7` |
| `0xff` | `0xaa` | `2,4,6,8` |

### Chains

The Chain View stores 256 chains. Each chain stores 16 rows. Each row stores a
phrase index and a transpose byte.

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `entries[0..255]` | `0x9a5e..0xba5d` | 8192 | [Chain](#chain) |

### Chain

Offsets are relative to the start of a Chain.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `rows[0..15]` | `+0x00..+0x1f` | 32 | [Chain Row](#chain-row) |

### Chain Row

Offsets are relative to the start of a Chain row.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `phrase` | `+0x00` | 1 | `u1` |
| `transpose` | `+0x01` | 1 | `u1` |

The default `phrase` value is `0xff`, which the M8 UI displays as unset. The
default `transpose` value is `0x00`.

The `CHAINS.m8s` fixture verifies:

| Chain | Offset / Range | Stored Rows |
| --- | --- | --- |
| `0x00` | `0x9a5e..0x9a7d` | phrase `0x00..0x0f`, transpose `0xff..0xf0` |
| `0xfe` | `0xba1e..0xba3d` | phrase `0xfe..0xef`, transpose `0x01..0x10` |

The observed distance between chain `0x00` and chain `0xfe` is `0x1fc0` bytes,
which verifies a `0x20` byte chain stride. The full `0x9a5e..0xba5d` table range
follows from 256 chains at 32 bytes per chain.

### MIDI Settings

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `syncSettings` | `0x00a0..0x00a3` | 4 | [MIDI Sync Settings](#midi-sync-settings) |
| `recordNoteChannel` | `0x00a4` | 1 | `u1` |
| `recordVelocity` | `0x00a5` | 1 | [Boolean](#boolean) |
| `recordDelayKill` | `0x00a6` | 1 | [Record Delay/Kill](#record-delaykill) |
| `controlMapChannel` | `0x00a7` | 1 | [Control Map Channel](#control-map-channel) |
| `songRowCueChannel` | `0x00a8` | 1 | `u1` |
| `trackMidiInputChannels` | `0x00a9..0x00b0` | 8 | `u1[8]` |
| `trackMidiInputInstruments` | `0x00b1..0x00b8` | 8 | `u1[8]` |
| `programChange` | `0x00b9` | 1 | [Boolean](#boolean) |
| `mode` | `0x00ba` | 1 | [MIDI Input Mode](#midi-input-mode) |

### MIDI Sync Settings

The MIDI Settings fixture changed Sync In from `OFF` to `CLK+TRANSP+SPP` and
Sync Out from `OFF` to `TRANSPORT+SPP`. The corresponding byte block changed
from `00 00 00 00` to `01 02 00 02`.

Sync In and Sync Out are each stored as a clock-enabled byte followed by a
transport mode byte. The M8 UI combines those two stored values into one label.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `syncInClock` | `+0x00` | 1 | [Boolean](#boolean) |
| `syncInTransport` | `+0x01` | 1 | [MIDI Sync Transport](#midi-sync-transport) |
| `syncOutClock` | `+0x02` | 1 | [Boolean](#boolean) |
| `syncOutTransport` | `+0x03` | 1 | [MIDI Sync Transport](#midi-sync-transport) |

Documented UI labels:

| Clock | Transport | UI Label |
| --- | --- | --- |
| `0x00` | `0x00` | `OFF` |
| `0x01` | `0x00` | `CLOCK` |
| `0x00` | `0x01` | `TRANSPORT` |
| `0x01` | `0x01` | `CLOCK+TRANSP.` |
| `0x00` | `0x02` | `TRANSPORT+SPP` |
| `0x01` | `0x02` | `CLK+TRANSP+SPP` |

### MIDI Sync Transport

| Stored Value | Label |
| --- | --- |
| `0x00` | `OFF` |
| `0x01` | `TRANSPORT` |
| `0x02` | `TRANSPORT+SPP` |

### Boolean

| Stored Value | Label |
| --- | --- |
| `0x00` | `OFF` |
| `0x01` | `ON` |

### Record Delay/Kill

| Stored Value | Label |
| --- | --- |
| `0x00` | `NONE` |
| `0x01` | `NOTE OFF` |
| `0x02` | `DELAY` |
| `0x03` | `BOTH` |

### Control Map Channel

| Stored Value | Label |
| --- | --- |
| `0x00` | `OFF` |
| `0x01..0x10` | `01..16` |
| `0x11` | `ALL` |

### Track MIDI Input

The M8 manual describes Track MIDI Input as per-track `CHAN` and `INST#`
settings for each of the 8 tracks. The Song file stores those values in two
adjacent 8-byte arrays.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `channels[0..7]` | `0x00a9..0x00b0` | 8 | `u1[8]` |
| `instruments[0..7]` | `0x00b1..0x00b8` | 8 | `u1[8]` |

The `instrument` value is a reference to an instrument index/number.

### MIDI Input Mode

| Stored Value | Label |
| --- | --- |
| `0x00` | `MONO` |
| `0x01` | `LEGATO` |
| `0x02` | `POLY` |

### Mixer

Offsets are absolute file offsets.

The Mixer storage starts at `0x00ce`. The storage order does not match the
visual order of the M8 Mixer page: `mix` and `limiter` are first, followed by
track volumes, send levels, input levels, `djFilter`, DJ filter detail,
limiter detail, `softClip`, and `ott`.

The Mix & Limiter Scope View reuses this storage for `mix`, `limiter`,
`djFilter`, `djFilterResonance`, `djFilterType`, `limiterAttack`,
`limiterRelease`, `softClip`, and `ott`.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `mix` | `0x00ce` | 1 | `u1` |
| `limiter` | `0x00cf` | 1 | `u1` |
| `tracks` | `0x00d0..0x00d7` | 8 | `u1[8]` |
| `sends` | `0x00d8..0x00da` | 3 | [Mixer Sends](#mixer-sends) |
| `analogInput.volume` | `0x00db` | 1 | `u1` |
| `analogDualMonoInput.volume` | `0x00dc` | 1 | `u1` |
| `usbInput.volume` | `0x00dd` | 1 | `u1` |
| `analogInput.sends` | `0x00de..0x00e0` | 3 | [Mixer Sends](#mixer-sends) |
| `analogDualMonoInput.sends` | `0x00e1..0x00e3` | 3 | [Mixer Sends](#mixer-sends) |
| `usbInput.sends` | `0x00e4..0x00e6` | 3 | [Mixer Sends](#mixer-sends) |
| `djFilter` | `0x00e7` | 1 | `u1` |
| `djFilterResonance` | `0x00e8` | 1 | `u1` |
| `djFilterType` | `0x00e9` | 1 | [DJ Filter Type](#dj-filter-type) |
| `limiterAttack` | `0x00ea` | 1 | `u1` |
| `limiterRelease` | `0x00eb` | 1 | `u1` |
| `softClip` | `0x00ec` | 1 | [Boolean](#boolean) |
| `ott` | `0x00ed` | 1 | `u1` |

The default fixture stores `0xff` for `analogDualMonoInput.volume`. The M8 UI
displays this as unset until dual mono input is enabled.

### Mixer Sends

Offsets are relative to the start of a Mixer send group.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `modFx` | `+0x00` | 1 | `u1` |
| `delay` | `+0x01` | 1 | `u1` |
| `reverb` | `+0x02` | 1 | `u1` |

### DJ Filter Type

The Mix & Limiter Scope fixtures verify `0x02` for `BANDPASS:HIGHPASS`.
Historical <https://github.com/whitlockjc/m8-js> reference code labels the
remaining values as shown below.

| Stored Value | Label |
| --- | --- |
| `0x00` | `LOWPASS:HIGHPASS` |
| `0x01` | `LOWPASS:BANDSTOP` |
| `0x02` | `BANDPASS:HIGHPASS` |

### Effects & Scope Storage

Offsets are absolute file offsets.

The Effects Settings and Mix & Limiter Scope detail bytes share one contiguous
storage region. The storage order does not fully match the UI grouping:
`modFx.type` is stored after the Mix & Limiter Scope `ottTime` and `ottColor`
bytes.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknownBeforeModFx` | `0x1a5be..0x1a5c0` | 3 | unknown bytes |
| `effects.modFx` | `0x1a5c1..0x1a5c4` | 4 | [Mod FX Settings](#mod-fx-settings) |
| `unknownBetweenModFxAndDelay` | `0x1a5c5..0x1a5c9` | 5 | unknown bytes |
| `effects.delay` | `0x1a5ca..0x1a5ce` | 5 | [Delay Settings](#delay-settings) |
| `unknownBetweenDelayAndReverb` | `0x1a5cf..0x1a5d1` | 3 | unknown bytes |
| `effects.reverb` | `0x1a5d2..0x1a5d7` | 6 | [Reverb Settings](#reverb-settings) |
| `mixLimiterScope` | `0x1a5d8..0x1a5d9` | 2 | [Mix & Limiter Scope](#mix--limiter-scope) |
| `effects.modFx.type` | `0x1a5da` | 1 | [Mod FX Type](#mod-fx-type) |

### Effects Settings

The Effects Settings fields are stored inside
[Effects & Scope Storage](#effects--scope-storage).

### Mod FX Settings

Offsets are absolute file offsets. `modFx.type` is stored separately at
`0x1a5da`.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `depth` | `0x1a5c1` | 1 | `u1` |
| `frequency` | `0x1a5c2` | 1 | `u1` |
| `width` | `0x1a5c3` | 1 | `u1` |
| `reverbSend` | `0x1a5c4` | 1 | `u1` |

### Mod FX Type

| Stored Value | Label |
| --- | --- |
| `0x00` | `CHORUS` |
| `0x01` | `PHASER` |
| `0x02` | `FLANGER` |

### Delay Settings

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `time.left` | `0x1a5ca` | 1 | `u1` |
| `time.right` | `0x1a5cb` | 1 | `u1` |
| `feedback` | `0x1a5cc` | 1 | `u1` |
| `width` | `0x1a5cd` | 1 | `u1` |
| `reverbSend` | `0x1a5ce` | 1 | `u1` |

### Reverb Settings

Offsets are absolute file offsets. The fixture verifies that `shimmer` is
stored after `width`.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `roomSize` | `0x1a5d2` | 1 | `u1` |
| `decay` | `0x1a5d3` | 1 | `u1` |
| `depth` | `0x1a5d4` | 1 | `u1` |
| `frequency` | `0x1a5d5` | 1 | `u1` |
| `width` | `0x1a5d6` | 1 | `u1` |
| `shimmer` | `0x1a5d7` | 1 | `u1` |

### Mix & Limiter Scope

Offsets are absolute file offsets.

The Mix & Limiter Scope View stores most observed controls in the Mixer block.
The `ottTime` and `ottColor` detail bytes are stored inside
[Effects & Scope Storage](#effects--scope-storage). The `MIX_SCOPE.m8s` and
`LIMIT_SCOPE.m8s` fixtures both verify these offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `ottTime` | `0x1a5d8` | 1 | `u1` |
| `ottColor` | `0x1a5d9` | 1 | `u1` |

### Mix EQ

Offsets are absolute file offsets.

The Mix EQ page is the master EQ navigated to from the Mixer page. It stores
three adjacent 6-byte band records using the common [EQ Band](#eq-band)
layout.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `lowBand` | `0x1b65e..0x1b663` | 6 | [EQ Band](#eq-band) |
| `midBand` | `0x1b664..0x1b669` | 6 | [EQ Band](#eq-band) |
| `highBand` | `0x1b66a..0x1b66f` | 6 | [EQ Band](#eq-band) |

### ModFX EQ

Offsets are absolute file offsets.

The ModFX EQ page stores three adjacent 6-byte band records using the common
[EQ Band](#eq-band) layout.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `lowBand` | `0x1b670..0x1b675` | 6 | [EQ Band](#eq-band) |
| `midBand` | `0x1b676..0x1b67b` | 6 | [EQ Band](#eq-band) |
| `highBand` | `0x1b67c..0x1b681` | 6 | [EQ Band](#eq-band) |

### Delay EQ

Offsets are absolute file offsets.

The Delay EQ page stores three adjacent 6-byte band records using the common
[EQ Band](#eq-band) layout.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `lowBand` | `0x1b682..0x1b687` | 6 | [EQ Band](#eq-band) |
| `midBand` | `0x1b688..0x1b68d` | 6 | [EQ Band](#eq-band) |
| `highBand` | `0x1b68e..0x1b693` | 6 | [EQ Band](#eq-band) |

### Reverb EQ

Offsets are absolute file offsets.

The Reverb EQ page stores three adjacent 6-byte band records using the common
[EQ Band](#eq-band) layout.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `lowBand` | `0x1b694..0x1b699` | 6 | [EQ Band](#eq-band) |
| `midBand` | `0x1b69a..0x1b69f` | 6 | [EQ Band](#eq-band) |
| `highBand` | `0x1b6a0..0x1b6a5` | 6 | [EQ Band](#eq-band) |

### EQ Band

Offsets are relative to the start of an EQ band.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `typeAndMode` | `+0x00` | 1 | [EQ Type/Mode](#eq-typemode) |
| `frequency` | `+0x01..+0x02` | 2 | `u2le` |
| `gain` | `+0x03..+0x04` | 2 | `i2le` |
| `q` | `+0x05` | 1 | `u1` |

`gain` is stored as signed hundredths. For example, `-40.00` is stored as
`-4000`, `10.50` is stored as `1050`, and `40.00` is stored as `4000`.

### EQ Type/Mode

The band filter type and mode are packed into one byte:

| Bits | Meaning |
| --- | --- |
| `0..4` | [EQ Filter Type](#eq-filter-type) |
| `5..7` | [EQ Filter Mode](#eq-filter-mode) |

Verified packed values:

| Field | Stored Value | Type | Mode |
| --- | --- | --- | --- |
| `mixEq.lowBand` default | `0x01` | `LOWSHELF` | `STEREO` |
| `mixEq.lowBand` modified | `0x20` | `LOWCUT` | `MID` |
| `mixEq.midBand` default | `0x02` | `BELL` | `STEREO` |
| `mixEq.midBand` modified | `0x63` | `BANDPASS` | `LEFT` |
| `mixEq.highBand` default | `0x04` | `HI.SHELF` | `STEREO` |
| `mixEq.highBand` modified | `0x86` | `ALLPASS` | `RIGHT` |
| `modFxEq.lowBand` default | `0x00` | `LOWCUT` | `STEREO` |
| `modFxEq.lowBand` modified | `0x41` | `LOWSHELF` | `SIDE` |
| `modFxEq.midBand` default | `0x02` | `BELL` | `STEREO` |
| `modFxEq.midBand` modified | `0x23` | `BANDPASS` | `MID` |
| `modFxEq.highBand` default | `0x04` | `HI.SHELF` | `STEREO` |
| `modFxEq.highBand` modified | `0x85` | `HI.CUT` | `RIGHT` |
| `delayEq.lowBand` default | `0x00` | `LOWCUT` | `STEREO` |
| `delayEq.lowBand` modified | `0x22` | `BELL` | `MID` |
| `delayEq.midBand` default | `0x02` | `BELL` | `STEREO` |
| `delayEq.midBand` modified | `0x61` | `LOWSHELF` | `LEFT` |
| `delayEq.highBand` default | `0x05` | `HI.CUT` | `STEREO` |
| `delayEq.highBand` modified | `0x24` | `HI.SHELF` | `MID` |
| `reverbEq.lowBand` default | `0x00` | `LOWCUT` | `STEREO` |
| `reverbEq.lowBand` modified | `0x22` | `BELL` | `MID` |
| `reverbEq.midBand` default | `0x02` | `BELL` | `STEREO` |
| `reverbEq.midBand` modified | `0x44` | `HI.SHELF` | `SIDE` |
| `reverbEq.highBand` default | `0x05` | `HI.CUT` | `STEREO` |
| `reverbEq.highBand` modified | `0x66` | `ALLPASS` | `LEFT` |

### EQ Filter Type

| Stored Value | Label |
| --- | --- |
| `0x00` | `LOWCUT` |
| `0x01` | `LOWSHELF` |
| `0x02` | `BELL` |
| `0x03` | `BANDPASS` |
| `0x04` | `HI.SHELF` |
| `0x05` | `HI.CUT` |
| `0x06` | `ALLPASS` |

### EQ Filter Mode

| Stored Value | Label |
| --- | --- |
| `0x00` | `STEREO` |
| `0x01` | `MID` |
| `0x02` | `SIDE` |
| `0x03` | `LEFT` |
| `0x04` | `RIGHT` |

### MIDI Mappings

Offsets are absolute file offsets.

The M8 supports 128 MIDI Mapping records. The 6.5.x `MIDI_MAPPING.m8s`
fixture verifies that records start at `0x1a5fe` and that each record is 7
bytes. The table location, record count, record size, and byte order are
considered mapped for 6.5.x.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `entries[0..127]` | `0x1a5fe..0x1a97d` | 896 | [MIDI Mapping](#midi-mapping) |

### MIDI Mapping

Offsets are relative to the start of a MIDI Mapping record.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `channel` | `+0x00` | 1 | `u1` |
| `controlNumber` | `+0x01` | 1 | [MIDI Mapping Control Number](#midi-mapping-control-number) |
| `destinationType` | `+0x02` | 1 | [MIDI Mapping Destination Type](#midi-mapping-destination-type) |
| `destinationIndex` | `+0x03` | 1 | `u1` |
| `destinationParameter` | `+0x04` | 1 | `u1` |
| `minimumValue` | `+0x05` | 1 | `u1` |
| `maximumValue` | `+0x06` | 1 | `u1` |

Verified populated records:

| Index | Offset / Range | Stored Bytes | UI Label |
| --- | --- | --- | --- |
| `0x00` | `0x1a5fe..0x1a604` | `01 00 05 00 04 10 ff` | `I:00:SIZE` |
| `0x01` | `0x1a605..0x1a60b` | `02 7f 0d 00 00 20 fe` | `M:00:MIX VOL` |
| `0x02` | `0x1a60c..0x1a612` | `03 80 19 80 07 30 fd` | `Q:MX:MID Q` |
| `0x03` | `0x1a613..0x1a619` | `04 81 0b 00 09 40 fc` | `X:09:REV SIZE` |

The default Song fixture and unused records in `MIDI_MAPPING.m8s` store empty
mapping records as seven `0x00` bytes.

### MIDI Mapping Control Number

Observed control-number values:

| Stored Value | Label |
| --- | --- |
| `0x00` | `000` |
| `0x7f` | `127` |
| `0x80` | `T:X` |
| `0x81` | `T:Y` |

### MIDI Mapping Destination Type

The raw destination type byte is preserved. The destination label can be
derived from observed UI labels. Destination index and parameter labels are
destination-specific and will be expanded when the Mixer, EQ, and Effects pages
are mapped.

| Stored Value | Label |
| --- | --- |
| `0x05` | `I` |
| `0x0b` | `X` |
| `0x0d` | `M` |
| `0x19` | `Q` |

## Notes

- `tempo` is verified as a 32-bit little-endian float. The fixture changed the
  UI value from `120.00` to `121.99`; the stored float changed from `120.0` to
  approximately `121.98999786376953`.
- `scale` is a stored byte value that selects one of the Scales embedded in the
  Song file. The UI label comes from the referenced embedded Scale name, which
  will be mapped later.
- The active MIDI Settings block is verified at `0x00a0..0x00ba`.
- The Song rows table is verified at `0x02ee..0x0aed`. The fixture modifies row
  `0x00` and row `0xff`, which verifies the table boundaries as 256 eight-byte
  rows.
- The Bookmarks table is verified at `0x1a97e..0x1aa7d`. The fixture modifies
  rows `0x00`, `0x01`, `0xfe`, and `0xff`, which verifies the table boundaries
  as 256 one-byte row bitmasks.
- The Chains table is modeled at `0x9a5e..0xba5d`. The fixture verifies chain
  `0x00`, chain `0xfe`, and the `0x20` byte chain stride. The final table range
  is inferred from the M8's 256-chain structure and the verified row/entry
  sizes.
- The Mixer block is verified at `0x00ce..0x00ed`.
- The Effects Settings fields are verified in the shared Effects & Scope
  storage region at `0x1a5c1..0x1a5da`.
- The Mix & Limiter Scope OTT detail block is verified at
  `0x1a5d8..0x1a5d9`.
- The Mix EQ block is verified at `0x1b65e..0x1b66f`.
- The ModFX EQ block is verified at `0x1b670..0x1b681`.
- The `MODFX_EQ.m8s` fixture stores `modFxEq.lowBand.frequency` as `137`
  despite the test note listing `127`. The schema and manifest follow the byte
  evidence in the fixture.
- The Delay EQ block is verified at `0x1b682..0x1b693`.
- The `DELAY_EQ.m8s` fixture verifies `delayEq.highBand.typeAndMode` as
  `0x05 -> 0x24`, which maps to `HI.CUT/STEREO -> HI.SHELF/MID`.
- The Reverb EQ block is verified at `0x1b694..0x1b6a5`.
- The `MIX_SCOPE.m8s` fixture changed `zoom` from `-30DB` to `-1DB`, but no Song
  byte is named for it. A temporary zoom-only fixture changed
  `project.unknownTrailingState` while leaving mapped Mixer, Mix & Limiter
  Scope, and Mix EQ bytes unchanged. The `LIMIT_SCOPE.m8s` fixture left zoom at
  its `-30DB` default and still changed `project.unknownTrailingState`. The
  zoom setting may be stored as global UI state rather than Song data.
- The MIDI Mapping table is verified at `0x1a5fe..0x1a97d`.
- The `MIDI_MAPPING.m8s` fixture required a chain and Wavsynth instrument so
  the M8 UI could create an instrument-parameter mapping. Changed bytes for
  that setup are ignored by the MIDI Mapping manifest until chain and embedded
  instrument regions are mapped directly.
- The refreshed `MIDI_MAPPING.m8s` fixture stores the reverb/effects mapping in
  record `0x03` as `04 81 0b 00 09 40 fc`, verifying the `T:Y` control number,
  range bytes, and `X:09:REV SIZE` destination.
- MIDI Mapping destination parameter labels for Mixer, Mix EQ, and Effects are
  not fully modeled yet. The raw seven-byte record layout is verified
  independently of those labels.
- Effect-adjacent gaps at `0x1a5be..0x1a5c0`, `0x1a5c5..0x1a5c9`, and
  `0x1a5cf..0x1a5d1` are preserved. Historical
  <https://github.com/whitlockjc/m8-js> reference code suggests some of these
  bytes may contain Delay or Reverb filter storage, but that is not
  fixture-verified for 6.5.x yet.
- `unknownBeforeProject` changed in the fixture diff, but those changes were
  not mapped to Project UI fields. This region is preserved until targeted Song
  fixtures identify whether it contains save/path state, project state, or other
  fields.
- `unknownTrailingState` changed in the fixture diff but does not yet have a
  Project UI meaning. It is preserved and should be revisited with additional
  Project or Song fixtures.

## Evidence

| Name | Path |
| --- | --- |
| Baseline fixture | `fixtures/6.5.x/songs/DEFAULT.m8s` |
| Project fixture | `fixtures/6.5.x/songs/PROJECT.m8s` |
| Project manifest | `fixtures/6.5.x/songs/PROJECT.yaml` |
| MIDI Settings fixture | `fixtures/6.5.x/songs/MIDI_SETTING.m8s` |
| MIDI Settings manifest | `fixtures/6.5.x/songs/MIDI_SETTING.yaml` |
| Song Rows fixture | `fixtures/6.5.x/songs/SONG_ROWS.m8s` |
| Song Rows manifest | `fixtures/6.5.x/songs/SONG_ROWS.yaml` |
| Bookmarks fixture | `fixtures/6.5.x/songs/BOOKMARKS.m8s` |
| Bookmarks manifest | `fixtures/6.5.x/songs/BOOKMARKS.yaml` |
| Chains fixture | `fixtures/6.5.x/songs/CHAINS.m8s` |
| Chains manifest | `fixtures/6.5.x/songs/CHAINS.yaml` |
| Mixer fixture | `fixtures/6.5.x/songs/MIXER.m8s` |
| Mixer manifest | `fixtures/6.5.x/songs/MIXER.yaml` |
| Effects Settings fixture | `fixtures/6.5.x/songs/EFFECTS.m8s` |
| Effects Settings manifest | `fixtures/6.5.x/songs/EFFECTS.yaml` |
| Mix & Limiter Scope fixture (`MIX_SCOPE`) | `fixtures/6.5.x/songs/MIX_SCOPE.m8s` |
| Mix & Limiter Scope manifest (`MIX_SCOPE`) | `fixtures/6.5.x/songs/MIX_SCOPE.yaml` |
| Mix & Limiter Scope fixture (`LIMIT_SCOPE`) | `fixtures/6.5.x/songs/LIMIT_SCOPE.m8s` |
| Mix & Limiter Scope manifest (`LIMIT_SCOPE`) | `fixtures/6.5.x/songs/LIMIT_SCOPE.yaml` |
| Mix EQ fixture | `fixtures/6.5.x/songs/MIX_EQ.m8s` |
| Mix EQ manifest | `fixtures/6.5.x/songs/MIX_EQ.yaml` |
| ModFX EQ fixture | `fixtures/6.5.x/songs/MODFX_EQ.m8s` |
| ModFX EQ manifest | `fixtures/6.5.x/songs/MODFX_EQ.yaml` |
| Delay EQ fixture | `fixtures/6.5.x/songs/DELAY_EQ.m8s` |
| Delay EQ manifest | `fixtures/6.5.x/songs/DELAY_EQ.yaml` |
| Reverb EQ fixture | `fixtures/6.5.x/songs/REVERB_EQ.m8s` |
| Reverb EQ manifest | `fixtures/6.5.x/songs/REVERB_EQ.yaml` |
| MIDI Mapping fixture | `fixtures/6.5.x/songs/MIDI_MAPPING.m8s` |
| MIDI Mapping manifest | `fixtures/6.5.x/songs/MIDI_MAPPING.yaml` |
| Manual | <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699> |
| Verification command | `npm run verify` |

The manifest-driven mapper matched the Project, MIDI Settings, Song View,
Bookmarks, Chain View, Mixer, Effects Settings, Mix & Limiter Scope, Mix EQ,
ModFX EQ, Delay EQ, Reverb EQ, and MIDI Mapping field changes exactly. It also
accounts for fixture-changed bytes in explicitly ignored unknown ranges so page
field mapping can be verified without assigning unsupported meanings to
save/setup/state bytes.
