# Song

Human-readable schema reference for M8 Song files.

This document starts with fields mapped from the Project, MIDI Settings, Mixer,
Mix EQ, and MIDI Mapping pages. Most of the Song body remains preserved as
unknown bytes until additional Song fixtures map those regions.

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
| `unknownBetweenMixerAndMidiMappings` | `0x00ee..0x1a5fd` | 107792 | unknown bytes |
| `midiMappings` | `0x1a5fe..0x1a97d` | 896 | [MIDI Mappings](#midi-mappings) |
| `unknownBetweenMidiMappingsAndMixEq` | `0x1a97e..0x1b65d` | 3296 | unknown bytes |
| `mixEq` | `0x1b65e..0x1b66f` | 18 | [Mix EQ](#mix-eq) |
| `unknownAfterMixEq` | `0x1b670..0x1b6c5` | 86 | unknown bytes |

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
| `MIXER.m8s` | `MIXER` followed by seven `0x00` bytes |
| `MIX_EQ.m8s` | `MIX_EQ` followed by six `0x00` bytes |

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

The Mixer page storage starts at `0x00ce`. The storage order does not match the
visual order of the M8 Mixer page: `mix` and `limiter` are first, followed by
track volumes, send levels, input levels, `djFilter`, preserved bytes, and
`ott`.

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
| `unknownBeforeOtt` | `0x00e8..0x00ec` | 5 | unknown bytes |
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

### Mix EQ

Offsets are absolute file offsets.

The Mix EQ page is the master EQ navigated to from the Mixer page. It stores
three adjacent 6-byte band records.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `lowBand` | `0x1b65e..0x1b663` | 6 | [Mix EQ Band](#mix-eq-band) |
| `midBand` | `0x1b664..0x1b669` | 6 | [Mix EQ Band](#mix-eq-band) |
| `highBand` | `0x1b66a..0x1b66f` | 6 | [Mix EQ Band](#mix-eq-band) |

### Mix EQ Band

Offsets are relative to the start of a Mix EQ band.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `typeAndMode` | `+0x00` | 1 | [Mix EQ Type/Mode](#mix-eq-typemode) |
| `frequency` | `+0x01..+0x02` | 2 | `u2le` |
| `gain` | `+0x03..+0x04` | 2 | `i2le` |
| `q` | `+0x05` | 1 | `u1` |

`gain` is stored as signed hundredths. For example, `-40.00` is stored as
`-4000`, `10.50` is stored as `1050`, and `40.00` is stored as `4000`.

### Mix EQ Type/Mode

The band filter type and mode are packed into one byte:

| Bits | Meaning |
| --- | --- |
| `0..4` | [Mix EQ Filter Type](#mix-eq-filter-type) |
| `5..7` | [Mix EQ Filter Mode](#mix-eq-filter-mode) |

Verified packed values:

| Band | Stored Value | Type | Mode |
| --- | --- | --- | --- |
| `lowBand` default | `0x01` | `LOWSHELF` | `STEREO` |
| `lowBand` modified | `0x20` | `LOWCUT` | `MID` |
| `midBand` default | `0x02` | `BELL` | `STEREO` |
| `midBand` modified | `0x63` | `BANDPASS` | `LEFT` |
| `highBand` default | `0x04` | `HI.SHELF` | `STEREO` |
| `highBand` modified | `0x86` | `ALLPASS` | `RIGHT` |

### Mix EQ Filter Type

| Stored Value | Label |
| --- | --- |
| `0x00` | `LOWCUT` |
| `0x01` | `LOWSHELF` |
| `0x02` | `BELL` |
| `0x03` | `BANDPASS` |
| `0x04` | `HI.SHELF` |
| `0x05` | `HI.CUT` |
| `0x06` | `ALLPASS` |

### Mix EQ Filter Mode

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
- The Mixer block is verified at `0x00ce..0x00ed`.
- The Mix EQ block is verified at `0x1b65e..0x1b66f`.
- `unknownBeforeOtt` is preserved. Historical
  <https://github.com/whitlockjc/m8-js> reference code treats the first two
  bytes in this region as DJ filter resonance/type for 3.x and newer, but the
  current Mixer fixture did not change them.
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
| Mixer fixture | `fixtures/6.5.x/songs/MIXER.m8s` |
| Mixer manifest | `fixtures/6.5.x/songs/MIXER.yaml` |
| Mix EQ fixture | `fixtures/6.5.x/songs/MIX_EQ.m8s` |
| Mix EQ manifest | `fixtures/6.5.x/songs/MIX_EQ.yaml` |
| MIDI Mapping fixture | `fixtures/6.5.x/songs/MIDI_MAPPING.m8s` |
| MIDI Mapping manifest | `fixtures/6.5.x/songs/MIDI_MAPPING.yaml` |
| Manual | <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699> |
| Verification command | `npm run verify` |

The manifest-driven mapper matched the Project, MIDI Settings, Mixer, Mix EQ,
and MIDI Mapping field changes exactly. It also accounts for fixture-changed
bytes in explicitly ignored unknown ranges so page field mapping can be verified
without assigning unsupported meanings to save/setup/state bytes.
