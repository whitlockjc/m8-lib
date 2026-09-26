# Instrument

Historical 6.5.x research reference, retained to preserve fixture evidence and
interpretation. Tables here are research snapshots, not the maintained schema
reference. Use the [generated firmware reference](../6.5.x.md) for current
field layouts, types, and enum catalogs.


Human-readable schema reference for M8 Instrument files.

This document describes the structurally complete 6.5.x Instrument file schema.
Structurally complete means the file container, verified instrument body
variants, modulation storage, table storage, and preserved unknown/reserved
regions are represented. FX command-family coverage and semantic
classification of preserved bytes are tracked separately.

## Schema

| Name | Value |
| --- | --- |
| File type | Instrument |
| File extension | `.m8i` |
| M8 file schema version | `6.0.1` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/6.0.1/instrument.ksy` |
| Parameter definitions | [`schemas/file-versions/6.0.1/instrument/parameters.ksy`](../../schemas/file-versions/6.0.1/instrument/parameters.ksy) |
| Structural status | Complete for 6.5.x fixture evidence |
| Total file size | 357 bytes |
| Header size | 14 bytes |
| Body size | 343 bytes |

## Completion Status

The 6.5.x Instrument schema is considered structurally complete for the current
fixture set.

Completed structural coverage:

- the shared M8 file header and file size,
- the common instrument prefix,
- every known 6.5.x instrument type body,
- common filter, amplification, mixer, modulation, and table storage,
- Sampler sample path storage,
- Hypersynth chord table storage,
- NONE instrument table storage,
- preserved unknown/reserved regions needed for byte-level fidelity.

Remaining work is semantic rather than container-structural:

- finish FX command-family labels, byte values, availability, and amount
  semantics in [FX Commands](RESEARCH_FX_COMMANDS.md),
- classify preserved bytes as `field`, `state`, `cache`, `reserved`,
  `padding`, or `unknown` when targeted fixtures provide evidence.

## Common Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x00..0x0d` | 14 | [M8 File Header](RESEARCH_FILE_HEADER.md) |
| `instrument_data` | `0x0e..0xe4` | 215 | instrument record |
| `general_settings` | `0x0e..0x1c` | 15 | [General Instrument Settings](#general-instrument-settings) |
| `general_settings.type` | `0x0e` | 1 | [Instrument Type](#instrument-type) |
| `name` | `0x0f..0x1a` | 12 | [Fixed String](#fixed-strings) |
| `transpose` | `0x1b` | 1 | `u1` |
| `table_tic` | `0x1c` | 1 | `u1` |
| `body_before_eq` | `0x1d..0x4b` | 47 | [Body Before EQ](#body-before-eq) |
| `eq` | `0x4c` | 1 | `u1` |
| `tail` | `0x4d..0xe4` | 152 | [Tail](#tail) |
| `table` | `0xe5..0x164` | 128 | [Instrument Table](#instrument-table) |

The `body_before_eq` layout depends on `general_settings.type`. For `none`, this range
is preserved but not documented as meaningful fields, because the M8 UI does
not expose editable `NONE` instrument parameters.

`INSTRUMENTS.m8s` verifies that Song files reuse `instrument_data` exactly. Its
embedded Wavsynth and Hypersynth records match the first 215 body bytes of
`WAV_DEFAULT.m8i` and `HYP_DEFAULT.m8i`, respectively, except that the embedded
12-byte names are unset (`0xff`). Song Tables are stored separately from the
128 embedded Instrument records.

### General Instrument Settings

The M8 manual groups `type`, `name`, `transpose`, `table_tic`, and
`eq` as General Instrument Settings. All Instrument types store these fields at
the same offsets in the 215-byte record. The first four form the
`general_settings` prefix; `eq` is stored separately at `0x4c` after the
type-specific body. NONE does not expose all of these settings for editing.

The `eq` value selects an EQ bank. The 128 bank definitions are stored
separately in a [Song](RESEARCH_SONG.md#instrument-eqs); the Instrument record stores
the assignment, not the EQ's three-band definition.

### Instrument Type

The instrument type is stored as one unsigned byte.

| Name | Stored Value |
| --- | --- |
| `wavsynth` | `0x00` |
| `macrosynth` | `0x01` |
| `sampler` | `0x02` |
| `midiOut` | `0x03` |
| `fmSynth` | `0x04` |
| `hypersynth` | `0x05` |
| `external` | `0x06` |
| `none` | `0xff` |

Additional instrument types will be added only after fixture evidence verifies
their stored values.

### Fixed Strings

M8 strings are stored in fixed-size byte ranges.

The instrument name is stored in a fixed 12-byte range.

The verified fixtures show both full and padded values:

| Fixture | Stored Value |
| --- | --- |
| `NONE_DEFAULT.m8i` | `NONE_DEFAULT`, filling all 12 bytes |
| `NONE_TABLE.m8i` | `NONE_TABLE` followed by two `0x00` bytes |
| `WAV_DEFAULT.m8i` | `WAV_DEFAULT` followed by one `0x00` byte |
| `WAV_PARAMS.m8i` | `WAV_PARAMS` followed by two `0x00` bytes |
| `WAV_MODS_A.m8i` | `WAV_MODS_A` followed by two `0x00` bytes |
| `WAV_MODS_B.m8i` | `WAV_MODS_B` followed by two `0x00` bytes |
| `WAV_TABLE.m8i` | `WAV_TABLE` followed by three `0x00` bytes |
| `MAC_DEFAULT.m8i` | `MAC_DEFAULT` followed by one `0x00` byte |
| `MAC_PARAMS.m8i` | `MAC_PARAMS` followed by two `0x00` bytes |
| `MAC_MODS_A.m8i` | `MAC_MODS_A` followed by two `0x00` bytes |
| `MAC_MODS_B.m8i` | `MAC_MODS_B` followed by two `0x00` bytes |
| `MAC_TABLE.m8i` | `MAC_TABLE` followed by three `0x00` bytes |
| `SAM_DEFAULT.m8i` | `SAM_DEFAULT` followed by one `0x00` byte |
| `SAM_PARAMS.m8i` | `SAM_PARAMS` followed by two `0x00` bytes |
| `SAM_MODS_A.m8i` | `SAM_MODS_A` followed by two `0x00` bytes |
| `SAM_MODS_B.m8i` | `SAM_MODS_B` followed by two `0x00` bytes |
| `SAM_TABLE.m8i` | `SAM_TABLE` followed by three `0x00` bytes |
| `SAMS_PARAMS.m8i` | `SAMS_PARAMS` followed by one `0x00` byte |
| `SAMB_PARAMS.m8i` | `SAMB_PARAMS` followed by one `0x00` byte |
| `MID_DEFAULT.m8i` | `MID_DEFAULT` followed by one `0x00` byte |
| `MID_PARAMS.m8i` | `MID_PARAMS` followed by two `0x00` bytes |
| `MID_MODS_A.m8i` | `MID_MODS_A` followed by two `0x00` bytes |
| `MID_MODS_B.m8i` | `MID_MODS_B` followed by two `0x00` bytes |
| `MID_TABLE.m8i` | `MID_TABLE` followed by three `0x00` bytes |
| `FM_DEFAULT.m8i` | `FM_DEFAULT` followed by two `0x00` bytes |
| `FM_PARAMS.m8i` | `FM_PARAMS` followed by three `0x00` bytes |
| `FM_MODS_A.m8i` | `FM_MODS_A` followed by three `0x00` bytes |
| `FM_MODS_B.m8i` | `FM_MODS_B` followed by three `0x00` bytes |
| `FM_TABLE.m8i` | `FM_TABLE` followed by four `0x00` bytes |
| `HYP_DEFAULT.m8i` | `HYP_DEFAULT` followed by one `0x00` byte |
| `HYP_PARAMS.m8i` | `HYP_PARAMS` followed by two `0x00` bytes |
| `HYP_MODS_A.m8i` | `HYP_MODS_A` followed by two `0x00` bytes |
| `HYP_MODS_B.m8i` | `HYP_MODS_B` followed by two `0x00` bytes |
| `HYP_TABLE.m8i` | `HYP_TABLE` followed by three `0x00` bytes |
| `EXT_DEFAULT.m8i` | `EXT_DEFAULT` followed by one `0x00` byte |
| `EXT_PARAMS.m8i` | `EXT_PARAMS` followed by two `0x00` bytes |
| `EXT_MODS_A.m8i` | `EXT_MODS_A` followed by two `0x00` bytes |
| `EXT_MODS_B.m8i` | `EXT_MODS_B` followed by two `0x00` bytes |
| `EXT_TABLE.m8i` | `EXT_TABLE` followed by three `0x00` bytes |

## Body Before EQ

The bytes between the common prefix and the common `eq` field are interpreted by
`general_settings.type`.

| Instrument Type | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `wavsynth` | `0x1d..0x4b` | 47 | [Wavsynth/Macrosynth Body Before EQ](#wavsynthmacrosynth-body-before-eq) |
| `macrosynth` | `0x1d..0x4b` | 47 | [Wavsynth/Macrosynth Body Before EQ](#wavsynthmacrosynth-body-before-eq) |
| `sampler` | `0x1d..0x4b` | 47 | [Sampler Body Before EQ](#sampler-body-before-eq) |
| `midiOut` | `0x1d..0x4b` | 47 | [MIDI Out Body Before EQ](#midi-out-body-before-eq) |
| `fmSynth` | `0x1d..0x4b` | 47 | [FM Synth Body Before EQ](#fm-synth-body-before-eq) |
| `hypersynth` | `0x1d..0x4b` | 47 | [Hypersynth Body Before EQ](#hypersynth-body-before-eq) |
| `external` | `0x1d..0x4b` | 47 | [External Body Before EQ](#external-body-before-eq) |
| `none` | `0x1d..0x4b` | 47 | preserved bytes |

### Wavsynth/Macrosynth Body Before EQ

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1e` | 2 | unknown bytes |
| `unknownBeforeParams` | `0x1f` | 1 | unknown byte |
| `instrumentParams` | `0x20..0x24` | 5 | [Instrument-Specific Parameters](#instrument-specific-parameters) |
| `filter` | `0x25..0x27` | 3 | [Multi-mode Filter Parameters](#multi-mode-filter-parameters) |
| `amp` | `0x28..0x2a` | 3 | [Amplifier Settings](#amplifier-settings) |
| `mixer` | `0x2b..0x2e` | 4 | [Mixer Parameters](#mixer-parameters) |
| `unknownBeforeEq` | `0x2f..0x4b` | 29 | unknown bytes |

### Sampler Body Before EQ

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1e` | 2 | unknown bytes |
| `controls` | `0x1f..0x25` | 7 | [Sampler Parameters](#sampler-parameters) |
| `filter` | `0x26..0x28` | 3 | [Multi-mode Filter Parameters](#multi-mode-filter-parameters) |
| `amp` | `0x29..0x2b` | 3 | [Amplifier Settings](#amplifier-settings) |
| `mixer` | `0x2c..0x2f` | 4 | [Mixer Parameters](#mixer-parameters) |
| `unknownBeforeEq` | `0x30..0x4b` | 28 | unknown bytes |

### MIDI Out Body Before EQ

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `params` | `0x1d..0x39` | 29 | [MIDI Out Parameters](#midi-out-parameters) |
| `unknownBeforeEq` | `0x3a..0x4b` | 18 | unknown bytes |

MIDI Out does not expose Filter, Amplification, or Mixer parameter groups in the
M8 UI. The current fixture evidence maps its visible params and preserves
`0x3a..0x4b` as unknown bytes.

### FM Synth Body Before EQ

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1e` | 2 | unknown bytes |
| `unknownBeforeParams` | `0x1f` | 1 | unknown byte |
| `instrumentParams` | `0x20..0x40` | 33 | [FM Synth Parameters](#fm-synth-parameters) |
| `filter` | `0x41..0x43` | 3 | [Multi-mode Filter Parameters](#multi-mode-filter-parameters) |
| `amp` | `0x44..0x46` | 3 | [Amplifier Settings](#amplifier-settings) |
| `mixer` | `0x47..0x4a` | 4 | [Mixer Parameters](#mixer-parameters) |
| `unknownBeforeEq` | `0x4b` | 1 | unknown byte |

### Hypersynth Body Before EQ

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1e` | 2 | unknown bytes |
| `unknownBeforeParams` | `0x1f` | 1 | unknown byte |
| `instrumentParams` | `0x20..0x2b` | 12 | [Hypersynth Parameters](#hypersynth-parameters) |
| `filter` | `0x2c..0x2e` | 3 | [Multi-mode Filter Parameters](#multi-mode-filter-parameters) |
| `amp` | `0x2f..0x31` | 3 | [Amplifier Settings](#amplifier-settings) |
| `mixer` | `0x32..0x35` | 4 | [Mixer Parameters](#mixer-parameters) |
| `unknownBeforeEq` | `0x36..0x4b` | 22 | unknown bytes |

### External Body Before EQ

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1e` | 2 | unknown bytes |
| `unknownBeforeParams` | `0x1f` | 1 | unknown byte |
| `instrumentParams` | `0x20..0x2c` | 13 | [External Parameters](#external-parameters) |
| `filter` | `0x2d..0x2f` | 3 | [Multi-mode Filter Parameters](#multi-mode-filter-parameters) |
| `amp` | `0x30..0x32` | 3 | [Amplifier Settings](#amplifier-settings) |
| `mixer` | `0x33..0x36` | 4 | [Mixer Parameters](#mixer-parameters) |
| `unknownBeforeEq` | `0x37..0x4b` | 21 | unknown bytes |

### Sampler Mode Value

The byte at `0x1f` is displayed according to `playMode`.

| Play Mode Range | Display Name |
| --- | --- |
| `0x00..0x08` | `detune` |
| `0x09..0x0b` | `steps` |
| `0x0c..0x0e` | `bpm` |

## Instrument-Specific Parameters

Instrument-specific parameter storage depends on `general_settings.type`. Wavsynth and
Macrosynth use a compact five-byte parameter block at `0x20..0x24`. MIDI Out
uses a 29-byte parameter block at `0x1d..0x39`. FM Synth uses a larger 33-byte
block at `0x20..0x40`. Hypersynth uses a 12-byte block at `0x20..0x2b`.
External uses a 13-byte parameter block at `0x20..0x2c`. Sampler's
instrument-specific configuration spans two locations: seven control bytes at
`0x1f..0x25` and the selected sample path at `0x65..0xe4`.

| Instrument Type | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `wavsynth` | `0x20..0x24` | 5 | [Wavsynth Parameters](#wavsynth-parameters) |
| `macrosynth` | `0x20..0x24` | 5 | [Macrosynth Parameters](#macrosynth-parameters) |
| `sampler` | `0x1f..0x25`, `0x65..0xe4` | 7 + 128 | [Sampler Parameters](#sampler-parameters) |
| `midiOut` | `0x1d..0x39` | 29 | [MIDI Out Parameters](#midi-out-parameters) |
| `fmSynth` | `0x20..0x40` | 33 | [FM Synth Parameters](#fm-synth-parameters) |
| `hypersynth` | `0x20..0x2b` | 12 | [Hypersynth Parameters](#hypersynth-parameters) |
| `external` | `0x20..0x2c` | 13 | [External Parameters](#external-parameters) |

### Sampler Parameters

These fields make up one Sampler-specific configuration, but the file stores
them in two places. `controls` is parsed by `sampler_body_before_eq`; the
selected `sample_path` is parsed by `sampler_data_tail` after the modulators.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `controls.mode_value` | `0x1f` | 1 | [Sampler Mode Value](#sampler-mode-value) |
| `controls.play_mode` | `0x20` | 1 | [Sampler Play Mode](#sampler-play-mode) |
| `controls.slice` | `0x21` | 1 | `u1` |
| `controls.start` | `0x22` | 1 | `u1` |
| `controls.loop_start` | `0x23` | 1 | `u1` |
| `controls.length` | `0x24` | 1 | `u1` |
| `controls.degrade` | `0x25` | 1 | `u1` |
| `sample_path` | `0x65..0xe4` | 128 | selected sample path; [Sampler Tail](#sampler-tail) |

`mode_value` is one stored byte. The M8 UI labels it detune, steps, or BPM
according to `play_mode`; these are not three separate stored fields.

`SAM_PARAMS.m8i` stores `/Samples/Kick.wav` as 17 ASCII bytes at `0x65`,
followed by a null terminator and 110 zero bytes. Like the Song directory, the
path is a null-terminated string inside a fixed 128-byte field; trailing bytes
are preserved. The region runs through `0xe4`, immediately before the
Instrument Table. The [M8 manual](https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699)
requires the entire sample path to be under 128 characters.

### Wavsynth Parameters

Offsets are relative to the start of `instrumentParams` when
`general_settings.type = wavsynth`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `shape` | `+0x00` | 1 | [Wavsynth Shape](#wavsynth-shape) |
| `size` | `+0x01` | 1 | `u1` |
| `mult` | `+0x02` | 1 | `u1` |
| `warp` | `+0x03` | 1 | `u1` |
| `scan` | `+0x04` | 1 | `u1` |

### Macrosynth Parameters

Offsets are relative to the start of `instrumentParams` when
`general_settings.type = macrosynth`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `shape` | `+0x00` | 1 | [Macrosynth Shape](#macrosynth-shape) |
| `timbre` | `+0x01` | 1 | `u1` |
| `color` | `+0x02` | 1 | `u1` |
| `degrade` | `+0x03` | 1 | `u1` |
| `redux` | `+0x04` | 1 | `u1` |

### MIDI Out Parameters

Offsets are relative to the start of `instrumentParams` when
`general_settings.type = midi_out`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `port` | `+0x00` | 1 | [MIDI Out Port](#midi-out-port) |
| `channel` | `+0x01` | 1 | `u1` |
| `bank` | `+0x02` | 1 | `u1` |
| `unknownBeforeProgramChange` | `+0x03..+0x04` | 2 | unknown bytes |
| `programChange` | `+0x05` | 1 | `u1` |
| `unknownBeforeCustomCcs` | `+0x06..+0x08` | 3 | unknown bytes |
| `custom_ccs` | `+0x09..+0x1c` | 20 | [Custom CC Entry](#custom-cc-entry) (10 entries) |

The M8 UI displays `channel`, `bank`, `programChange`, and custom CC numbers as
decimal values. The fixture verifies that those display values are stored as
their byte equivalents: channel `16` is `0x10`, bank `127` is `0x7f`, program
change `126` is `0x7e`, CC `125` is `0x7d`, and CC `123` is `0x7b`.

#### Custom CC Entry

MIDI Out and External use the same `custom_cc` two-byte entry. MIDI Out stores
ten entries (`CCA` through `CCJ`); External stores four (`CCA` through `CCD`).

Offsets are relative to the start of a custom CC entry.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `cc` | `+0x00` | 1 | `u1` |
| `value` | `+0x01` | 1 | `u1` |

The entry offset is:

```txt
customCcOffset = 0x26 + (index * 2)
```

For MIDI Out, `CCA` is index `0` and `CCJ` is index `9`.

### External Parameters

Offsets are relative to the start of `instrumentParams` when
`general_settings.type = external`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `input` | `+0x00` | 1 | [External Input](#external-input) |
| `port` | `+0x01` | 1 | [External Port](#external-port) |
| `channel` | `+0x02` | 1 | `u1` |
| `bank` | `+0x03` | 1 | `u1` |
| `programChange` | `+0x04` | 1 | `u1` |
| `custom_ccs` | `+0x05..+0x0c` | 8 | [Custom CC Entry](#custom-cc-entry) (4 entries) |

The M8 UI displays `channel`, `bank`, `programChange`, and custom CC numbers as
decimal values. The fixture verifies that those display values are stored as
their byte equivalents: channel `16` is `0x10`, bank `127` is `0x7f`, program
change `126` is `0x7e`, CC `125` is `0x7d`, and CC `123` is `0x7b`.

The entry offset is:

```txt
customCcOffset = 0x25 + (index * 2)
```

`CCA` is index `0` and `CCD` is index `3`.

### FM Synth Parameters

Offsets are relative to the start of `instrumentParams` when
`general_settings.type = fm_synth`.

The raw file stores operator data in grouped columns, not as four complete
operator structs. A higher-level API can still expose this as `operators[0..3]`
after decoding.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `algo` | `+0x00` | 1 | [FM Synth Algorithm](#fm-synth-algorithm) |
| `operatorShapes` | `+0x01..+0x04` | 4 | [FM Synth Operator Shape](#fm-synth-operator-shape) |
| `operatorRatios` | `+0x05..+0x0c` | 8 | [FM Synth Operator Ratio](#fm-synth-operator-ratio) |
| `operatorLevels` | `+0x0d..+0x14` | 8 | [FM Synth Operator Level/Feedback](#fm-synth-operator-levelfeedback) |
| `operatorModA` | `+0x15..+0x18` | 4 | [FM Synth Operator Mod Slot](#fm-synth-operator-mod-slot) |
| `operatorModB` | `+0x19..+0x1c` | 4 | [FM Synth Operator Mod Slot](#fm-synth-operator-mod-slot) |
| `mods` | `+0x1d..+0x20` | 4 | `u1[4]` |

#### FM Synth Operator Shape Storage

Offsets are relative to the start of `operatorShapes`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `operator1` | `+0x00` | 1 | [FM Synth Operator Shape](#fm-synth-operator-shape) |
| `operator2` | `+0x01` | 1 | [FM Synth Operator Shape](#fm-synth-operator-shape) |
| `operator3` | `+0x02` | 1 | [FM Synth Operator Shape](#fm-synth-operator-shape) |
| `operator4` | `+0x03` | 1 | [FM Synth Operator Shape](#fm-synth-operator-shape) |

#### FM Synth Operator Ratio

Each operator ratio is stored as two adjacent bytes.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `ratio` | `+0x00` | 1 | `u1` |
| `ratioFine` | `+0x01` | 1 | `u1` |

The `FM_PARAMS.m8i` fixture shows ratio display values are stored as decimal
byte values. For example, display value `99` is stored as `0x63`.

#### FM Synth Operator Level/Feedback

Each operator level/feedback pair is stored as two adjacent bytes.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `level` | `+0x00` | 1 | `u1` |
| `feedback` | `+0x01` | 1 | `u1` |

### Hypersynth Parameters

Offsets are relative to the start of `instrumentParams` when
`general_settings.type = hypersynth`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `current_chord` | `+0x00..+0x06` | 7 | [Hypersynth Current Chord](#hypersynth-current-chord) |
| `scale` | `+0x07` | 1 | `u1` |
| `shift` | `+0x08` | 1 | `u1` |
| `swarm` | `+0x09` | 1 | `u1` |
| `width` | `+0x0a` | 1 | `u1` |
| `subosc` | `+0x0b` | 1 | `u1` |

The `current_chord` bytes represent the current/edit chord state. The
persistent 16-chord table is stored separately in the Hypersynth tail. In
`HYP_PARAMS.m8i`, the current note bytes match the table entry selected by
`current_chord.index`; the two regions remain distinct stored data.

#### Hypersynth Current Chord

Offsets are relative to the start of `currentChord`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `index` | `+0x00` | 1 | `u1` |
| `notes` | `+0x01..+0x06` | 6 | [Hypersynth Chord Notes](#hypersynth-chord-notes) |

The `HYP_PARAMS.m8i` fixture verifies `index = 0x0c` when chord `0C` is
selected.

#### Hypersynth Chord Notes

Offsets are relative to the start of a six-note chord value range.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `note1` | `+0x00` | 1 | `u1` |
| `note2` | `+0x01` | 1 | `u1` |
| `note3` | `+0x02` | 1 | `u1` |
| `note4` | `+0x03` | 1 | `u1` |
| `note5` | `+0x04` | 1 | `u1` |
| `note6` | `+0x05` | 1 | `u1` |

## Common Parameter Groups

The following parameter group layouts are reused across verified instruments,
although absolute offsets can differ by instrument body layout.

### Multi-Mode Filter Parameters

The M8 manual groups `type`, `cutoff`, and `resonance` as Multi-mode Filter
Parameters. They use the same three-byte `filter_params` layout in Wavsynth,
Macrosynth, Sampler, FM Synth, Hypersynth, and External, at the offsets shown
in each instrument body above. MIDI Out and NONE do not expose this group; the
schema does not assign filter semantics to their preserved bytes.

Offsets are relative to the start of `filter`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `type` | `+0x00` | 1 | [Filter Type](#filter-type) |
| `cutoff` | `+0x01` | 1 | `u1` |
| `resonance` | `+0x02` | 1 | `u1` |

`type` remains a raw byte in the shared layout. The [Filter Type](#filter-type)
catalog preserves UI labels, but `0x08..0x0b` are valid only for Wavsynth;
the other five filter-capable instruments use `0x00..0x07`.

### Amplifier Settings

The M8 manual groups `amp`, `limit`, and `pan` as Amplifier Settings. All six
filter-capable instruments store them in the same three-byte `amp_params`
layout, immediately after their filter group. MIDI Out and NONE do not expose
this group; their preserved bytes are not assigned amplifier semantics.

Offsets are relative to the start of `amp`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `amp` | `+0x00` | 1 | `u1` |
| `limit` | `+0x01` | 1 | [Limit Type](#limit-type) |
| `pan` | `+0x02` | 1 | `u1` |

### Mixer Parameters

The M8 manual groups `dry`, `mod_fx`, `delay`, and `reverb` as instrument Mixer
Parameters. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External
use the same four-byte `mixer_params` layout immediately after their Amplifier
Settings, at the type-dependent offsets shown above. This is not the Song's
master [Mixer](RESEARCH_SONG.md#mixer). MIDI Out and NONE do not expose this group;
their preserved bytes are not assigned instrument mixer semantics.

Offsets are relative to the start of `mixer`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `dry` | `+0x00` | 1 | `u1` |
| `mod_fx` | `+0x01` | 1 | `u1` |
| `delay` | `+0x02` | 1 | `u1` |
| `reverb` | `+0x03` | 1 | `u1` |

## Tail

The 152-byte tail is the final portion of `instrument_data`, and its layout
depends on `general_settings.type`. Verified editable instruments start with a shared
24-byte modulation block. The standalone Instrument Table follows the tail at
`0xe5`; Song files store the same 215-byte `instrument_data` records and keep
their Tables in a separate region.

### Standard Tail

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `modulators` | `0x4d..0x64` | 24 | [Instrument Modulation](#instrument-modulation) |
| `unknown_after_modulators` | `0x65..0xe4` | 128 | unknown bytes |

### NONE Tail

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `unknown` | `0x4d..0xe4` | 152 | unknown bytes |

### Sampler Tail

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `modulators` | `0x4d..0x64` | 24 | [Instrument Modulation](#instrument-modulation) |
| `sample_path` | `0x65..0xe4` | 128 | [Sample Path Region](#sample-path-region) |

`SAM_PARAMS.m8i` verifies that `/Samples/Kick.wav` occupies the first 17 bytes,
followed by a null terminator and 110 zero bytes. The 128-byte storage region
is bounded by the Table at `0xe5`; the M8 manual requires the entire path to
be under 128 characters.

#### Sample Path Region

This uses the same fixed-field layout as the Song directory. Offsets are
relative to `0x65`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `path` | `+0x00` | Variable, including terminator | Null-terminated ASCII string |
| `trailing` | After terminator | Remaining bytes through `0xe4` | Preserved raw bytes |

### Hypersynth Tail

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `modulators` | `0x4d..0x64` | 24 | [Instrument Modulation](#instrument-modulation) |
| `chords` | `0x65..0xd4` | 112 | [Hypersynth Chord](#hypersynth-chord) |
| `unknown_after_chords` | `0xd5..0xe4` | 16 | unknown bytes |

The `HYP_PARAMS.m8i` fixture verifies chord `0` begins at `0x65` and chord
`15` begins at `0xce`. This implies 16 chord entries of 7 bytes each.
The 16 bytes following the chord table remain unknown. The separately stored
`current_chord` matches its selected table entry in this fixture; they are not
one field in the raw schema.

#### Hypersynth Chord

Offsets are relative to the start of a chord entry.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `enabledNotes` | `+0x00` | 1 | bit mask |
| `notes` | `+0x01..+0x06` | 6 | [Hypersynth Chord Notes](#hypersynth-chord-notes) |

`enabledNotes` appears to be a bit mask for six chord notes. Chord `0` changed
from `0xff` to `0xfe` when `note1` was unset. Chord `15` changed from `0xff`
to `0xdf` when `note6` was unset.

## Instrument Modulation

Instrument modulation is stored as four six-byte slots at `0x4d..0x64`.
`WAV_MODS_A.m8i` verifies the slot storage for `TRACKING`, `TRIG ENV`,
`AHD ENV`, and `ADSR ENV`. `WAV_MODS_B.m8i` verifies the slot storage for
`LFO` and `DRUM ENV`. `MAC_MODS_A.m8i`, `MAC_MODS_B.m8i`, `SAM_MODS_A.m8i`,
`SAM_MODS_B.m8i`, `MID_MODS_A.m8i`, `MID_MODS_B.m8i`, `FM_MODS_A.m8i`,
`FM_MODS_B.m8i`, `HYP_MODS_A.m8i`, `HYP_MODS_B.m8i`, `EXT_MODS_A.m8i`, and
`EXT_MODS_B.m8i` verify the same storage layout for Macrosynth, Sampler, MIDI
Out, FM Synth, Hypersynth, and External.

This is the shared Common Modulation Settings structure for those seven
editable instrument types. The slot and its type-dependent payloads are
defined in [modulation.ksy](../../schemas/file-versions/6.0.1/instrument/modulation.ksy);
instrument-specific destination labels stay in the parent Instrument schema.
`slots[0]` corresponds to the M8 UI's first modulation slot, and `slots[3]`
to its fourth. NONE's bytes at `0x4d..0x64`
remain preserved as unknown; the UI does not expose modulation settings for
NONE. Modulation-type payloads and instrument-specific destination labels are
covered separately below.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `slots` | `+0x00..+0x17` | 24 | [Modulation Slot](#modulation-slot) |

The slot offset is:

```txt
slot_offset = 0x4d + (index * 6)
```

### Modulation Slot

Offsets are relative to the start of a modulation slot.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `typeAndDestination` | `+0x00` | 1 | packed byte |
| `amount` | `+0x01` | 1 | `u1` |
| `params` | `+0x02..+0x05` | 4 | type-dependent params |

`typeAndDestination` packs modulation type in the high nibble and destination
in the low nibble:

```txt
type = typeAndDestination >> 4
destination = typeAndDestination & 0x0f
```

`destination` is a raw nibble, not a universal enum. Interpret it using both
`general_settings.type` and the appropriate [instrument-specific catalog](#wavsynth-modulation-destination)
below. For example, `0x03` is `SIZE` for Wavsynth, `TIMBRE` for Macrosynth,
and `CCC` for MIDI Out. The shared `modulation_slot` schema and byte offsets
do not change with the instrument type.

The M8 manual describes DEST as the parameter being modulated but does not
list every catalog's numeric mapping. The following fixture evidence covers
selected values; other catalog entries are documented UI labels whose numeric
mappings remain to be individually fixture-verified.

`WAV_MODS_A.m8i` verifies Wavsynth
destinations `MOD BINV = 0x0e`, `MOD BOTH = 0x0d`, `MOD RATE = 0x0c`, and
`MOD AMT = 0x0b`. `MAC_MODS_A.m8i` verifies those same high modulation
destination values for Macrosynth. `SAM_MODS_A.m8i` verifies Sampler
destinations `MOD BINV = 0x0d`, `MOD BOTH = 0x0c`, `MOD RATE = 0x0b`, and
`MOD AMT = 0x0a`. `SAM_MODS_B.m8i` also verifies Sampler destinations
`MOD BINV = 0x0d` and `MOD BOTH = 0x0c`. `MID_MODS_A.m8i` verifies MIDI Out
destinations `MOD BINV = 0x0e`, `MOD BOTH = 0x0d`, `MOD RATE = 0x0c`, and
`MOD AMT = 0x0b`. `MID_MODS_B.m8i` also verifies MIDI Out destinations
`MOD BINV = 0x0e` and `MOD BOTH = 0x0d`. `FM_MODS_A.m8i` verifies FM Synth
destinations `MOD BINV = 0x0e`, `MOD BOTH = 0x0d`, `MOD RATE = 0x0c`, and
`MOD AMT = 0x0b`. `FM_MODS_B.m8i` also verifies FM Synth destinations
`MOD BINV = 0x0e` and `MOD BOTH = 0x0d`. `HYP_MODS_A.m8i` verifies
Hypersynth destinations `MOD BINV = 0x0e`, `MOD BOTH = 0x0d`,
`MOD RATE = 0x0c`, and `MOD AMT = 0x0b`. `HYP_MODS_B.m8i` also verifies
Hypersynth destinations `MOD BINV = 0x0e` and `MOD BOTH = 0x0d`.
`EXT_MODS_A.m8i` verifies External destinations `MOD BINV = 0x0d`,
`MOD BOTH = 0x0c`, `MOD RATE = 0x0b`, and `MOD AMT = 0x0a`.
`EXT_MODS_B.m8i` also verifies External destinations `MOD BINV = 0x0d` and
`MOD BOTH = 0x0c`.

### Modulation Parameters

The first two bytes of every slot are the shared Common Modulation Settings:
`type_and_destination` and `amount`. The selected modulation type determines
the names and meaning of the remaining four `params` bytes. Each row below is
one Kaitai payload type reused by all seven editable instrument types.
Offsets are relative to `params` (slot offset `+0x02`). Every listed field is
one byte.

| Modulation Type | Schema Type | `+0x00` | `+0x01` | `+0x02` | `+0x03` |
| --- | --- | --- | --- | --- | --- |
| AHD ENV | `modulation_ahd_env_params` | `attack` | `hold` | `decay` | `unknown` |
| ADSR ENV | `modulation_adsr_env_params` | `attack` | `decay` | `sustain` | `release` |
| DRUM ENV | `modulation_drum_env_params` | `peak` | `body` | `decay` | `unknown` |
| LFO | `modulation_lfo_params` | [oscillator](#modulation-lfo-oscillator) | [trigger](#modulation-lfo-trigger) | `frequency` | `unknown` |
| TRIG ENV | `modulation_trig_env_params` | `attack` | `hold` | `decay` | [source](#modulation-trigger-source) |
| TRACKING | `modulation_tracking_params` | [source](#modulation-tracking-source) | `lowest_value` | `highest_value` | `unknown` |

`unknown` preserves the fourth byte for AHD ENV, DRUM ENV, LFO, and TRACKING.
The current fixtures do not establish that those bytes are unused. The
`*_MODS_A.m8i` fixtures cover AHD ENV, ADSR ENV, TRIG ENV, and TRACKING;
`*_MODS_B.m8i` covers LFO and DRUM ENV.

## Instrument Table

The Wavsynth, Macrosynth, Sampler, MIDI Out, FM Synth, Hypersynth, External,
and NONE instrument tables are stored as 16 eight-byte rows at `0xe5..0x164`.
Row labels are displayed as hexadecimal values `0..F` in the M8 UI.
The shared row layout and contextual command catalogs are defined in
[table.ksy](../../schemas/file-versions/6.0.1/instrument/table.ksy).

The row offset is:

```txt
rowOffset = 0xe5 + (index * 8)
```

### Instrument Table Row

Offsets are relative to the start of a table row.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `transpose` | `+0x00` | 1 | `u1` |
| `volume` | `+0x01` | 1 | `u1` |
| `fx[0..2]` | `+0x02..+0x07` | 6 | [FX Slot](RESEARCH_FX_COMMANDS.md#storage) `[3]` |

The `WAV_TABLE.m8i`, `MAC_TABLE.m8i`, `SAM_TABLE.m8i`, `MID_TABLE.m8i`,
`FM_TABLE.m8i`, `HYP_TABLE.m8i`, `EXT_TABLE.m8i`, and `NONE_TABLE.m8i`
fixtures verify every `transpose` and `volume` byte across all 16 table rows.
They verify all three FX slots for rows `0..5` where fixture values were
provided, then leave the remaining FX slots at their baseline values.
`NONE_TABLE.m8i` leaves every FX slot unset, so it verifies the FX slot layout
but not the available command-family values for NONE tables.

Each slot uses the shared two-byte [FX Slot](RESEARCH_FX_COMMANDS.md#storage) layout.
Its second byte is named `value` in the raw schema; the M8 table UI may call
that value an amount. Command labels and availability depend on the active
instrument and command family. See [FX Commands](RESEARCH_FX_COMMANDS.md) for the
contextual model and verification plan.
Parsed-fixture checks compare every row and FX slot of every standalone
Instrument fixture with the corresponding raw bytes.

## Enums

### Modulation Type

Values `0x00`, `0x01`, `0x04`, and `0x05` are verified by the
`WAV_MODS_A.m8i` fixture. Values `0x02` and `0x03` are verified by the
`WAV_MODS_B.m8i` fixture.

| Name | Stored Value |
| --- | --- |
| `AHD ENV` | `0x00` |
| `ADSR ENV` | `0x01` |
| `DRUM ENV` | `0x02` |
| `LFO` | `0x03` |
| `TRIG ENV` | `0x04` |
| `TRACKING` | `0x05` |

### Wavsynth Modulation Destination

Wavsynth destination values `0x0b..0x0e` are verified by `WAV_MODS_A.m8i`.
`WAV_MODS_B.m8i` also verifies `0x0d` and `0x0e`. The remaining numeric
label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `VOLUME` | `0x01` |
| `PITCH` | `0x02` |
| `SIZE` | `0x03` |
| `MULT` | `0x04` |
| `WARP` | `0x05` |
| `SCAN` | `0x06` |
| `CUTOFF` | `0x07` |
| `RES` | `0x08` |
| `AMP` | `0x09` |
| `PAN` | `0x0a` |
| `MOD AMT` | `0x0b` |
| `MOD RATE` | `0x0c` |
| `MOD BOTH` | `0x0d` |
| `MOD BINV` | `0x0e` |

### Macrosynth Modulation Destination

Macrosynth destination values `0x0b..0x0e` are verified by
`MAC_MODS_A.m8i`. `MAC_MODS_B.m8i` also verifies `0x0d` and `0x0e`. The
remaining numeric label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `VOLUME` | `0x01` |
| `PITCH` | `0x02` |
| `TIMBRE` | `0x03` |
| `COLOR` | `0x04` |
| `DEGRADE` | `0x05` |
| `REDUX` | `0x06` |
| `CUTOFF` | `0x07` |
| `RES` | `0x08` |
| `AMP` | `0x09` |
| `PAN` | `0x0a` |
| `MOD AMT` | `0x0b` |
| `MOD RATE` | `0x0c` |
| `MOD BOTH` | `0x0d` |
| `MOD BINV` | `0x0e` |

### Sampler Modulation Destination

Sampler destination values `0x0a..0x0d` are verified by `SAM_MODS_A.m8i`.
`SAM_MODS_B.m8i` also verifies `0x0c` and `0x0d`. The remaining numeric
label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `VOLUME` | `0x01` |
| `PITCH` | `0x02` |
| `LOOP ST` | `0x03` |
| `LENGTH` | `0x04` |
| `DEGRADE` | `0x05` |
| `CUTOFF` | `0x06` |
| `RES` | `0x07` |
| `AMP` | `0x08` |
| `PAN` | `0x09` |
| `MOD AMT` | `0x0a` |
| `MOD RATE` | `0x0b` |
| `MOD BOTH` | `0x0c` |
| `MOD BINV` | `0x0d` |

### MIDI Out Modulation Destination

MIDI Out destination values `0x0b..0x0e` are verified by `MID_MODS_A.m8i`.
`MID_MODS_B.m8i` also verifies `0x0d` and `0x0e`. The remaining numeric
label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `CCA` | `0x01` |
| `CCB` | `0x02` |
| `CCC` | `0x03` |
| `CCD` | `0x04` |
| `CCE` | `0x05` |
| `CCF` | `0x06` |
| `CCG` | `0x07` |
| `CCH` | `0x08` |
| `CCI` | `0x09` |
| `CCJ` | `0x0a` |
| `MOD AMT` | `0x0b` |
| `MOD RATE` | `0x0c` |
| `MOD BOTH` | `0x0d` |
| `MOD BINV` | `0x0e` |

### FM Synth Modulation Destination

FM Synth destination values `0x0b..0x0e` are verified by `FM_MODS_A.m8i`.
`FM_MODS_B.m8i` also verifies `0x0d` and `0x0e`. The remaining numeric
label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `VOLUME` | `0x01` |
| `PITCH` | `0x02` |
| `MOD 1` | `0x03` |
| `MOD 2` | `0x04` |
| `MOD 3` | `0x05` |
| `MOD 4` | `0x06` |
| `CUTOFF` | `0x07` |
| `RES` | `0x08` |
| `AMP` | `0x09` |
| `PAN` | `0x0a` |
| `MOD AMT` | `0x0b` |
| `MOD RATE` | `0x0c` |
| `MOD BOTH` | `0x0d` |
| `MOD BINV` | `0x0e` |

### Hypersynth Modulation Destination

Hypersynth destination values `0x0b..0x0e` are verified by `HYP_MODS_A.m8i`.
`HYP_MODS_B.m8i` also verifies `0x0d` and `0x0e`. The remaining numeric
label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `VOLUME` | `0x01` |
| `PITCH` | `0x02` |
| `SHIFT` | `0x03` |
| `SWARM` | `0x04` |
| `WIDTH` | `0x05` |
| `SUBOSC` | `0x06` |
| `CUTOFF` | `0x07` |
| `RES` | `0x08` |
| `AMP` | `0x09` |
| `PAN` | `0x0a` |
| `MOD AMT` | `0x0b` |
| `MOD RATE` | `0x0c` |
| `MOD BOTH` | `0x0d` |
| `MOD BINV` | `0x0e` |

### External Modulation Destination

External destination values `0x0a..0x0d` are verified by `EXT_MODS_A.m8i`.
`EXT_MODS_B.m8i` also verifies `0x0c` and `0x0d`. The remaining numeric
label mappings have not been individually fixture-verified.

| Name | Stored Value |
| --- | --- |
| `OFF` | `0x00` |
| `VOLUME` | `0x01` |
| `CUTOFF` | `0x02` |
| `RES` | `0x03` |
| `AMP` | `0x04` |
| `PAN` | `0x05` |
| `CCA` | `0x06` |
| `CCB` | `0x07` |
| `CCC` | `0x08` |
| `CCD` | `0x09` |
| `MOD AMT` | `0x0a` |
| `MOD RATE` | `0x0b` |
| `MOD BOTH` | `0x0c` |
| `MOD BINV` | `0x0d` |

### Modulation LFO Oscillator

Oscillator value `0x13` is verified by `WAV_MODS_B.m8i`, `MAC_MODS_B.m8i`,
`SAM_MODS_B.m8i`, `MID_MODS_B.m8i`, `FM_MODS_B.m8i`, and `HYP_MODS_B.m8i`.
`EXT_MODS_B.m8i` also verifies `0x13`. Other labels are from the M8 6.5.2
manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `TRI` | `0x00` |
| `SIN` | `0x01` |
| `RAMP DN` | `0x02` |
| `RAMP UP` | `0x03` |
| `EXP DN` | `0x04` |
| `EXP UP` | `0x05` |
| `SQU DN` | `0x06` |
| `SQU UP` | `0x07` |
| `RANDOM` | `0x08` |
| `DRUNK` | `0x09` |
| `TRI T` | `0x0a` |
| `SIN T` | `0x0b` |
| `RAMPDN T` | `0x0c` |
| `RAMPUP T` | `0x0d` |
| `EXP DN T` | `0x0e` |
| `EXP UP T` | `0x0f` |
| `SQU DN T` | `0x10` |
| `SQU UP T` | `0x11` |
| `RAND T` | `0x12` |
| `DRUNK T` | `0x13` |

### Modulation LFO Trigger

Trigger value `0x03` is verified by `WAV_MODS_B.m8i`, `MAC_MODS_B.m8i`,
`SAM_MODS_B.m8i`, `MID_MODS_B.m8i`, `FM_MODS_B.m8i`, and `HYP_MODS_B.m8i`.
`EXT_MODS_B.m8i` also verifies `0x03`. Other labels are from the M8 6.5.2
manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `FREE` | `0x00` |
| `RETRIG` | `0x01` |
| `HOLD` | `0x02` |
| `ONCE` | `0x03` |

### Modulation Tracking Source

Source value `0x02` is verified by `WAV_MODS_A.m8i`. Other labels are from the
M8 6.5.2 manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `NOTE` | `0x00` |
| `VELOCITY` | `0x01` |
| `VEL.TAKE` | `0x02` |

### Modulation Trigger Source

The trigger source byte can refer to an instrument or track. `WAV_MODS_A.m8i`
verifies `TRACK 8 = 0x87`.

| Range | Meaning |
| --- | --- |
| `0x00..0x7f` | Instrument reference |
| `0x80..0x87` | Track reference, where `track = value - 0x7f` |

### Wavsynth Table FX Command

The `WAV_TABLE.m8i` fixture verifies the following Wavsynth table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md). `SNC` and `ERR`
are non-contiguous with the surrounding verified command range.

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `FIN` | `0x82` |
| `OSC` | `0x83` |
| `SIZ` | `0x84` |
| `MUL` | `0x85` |
| `WRP` | `0x86` |
| `SCN` | `0x87` |
| `FIL` | `0x88` |
| `CUT` | `0x89` |
| `RES` | `0x8a` |
| `AMP` | `0x8b` |
| `LIM` | `0x8c` |
| `PAN` | `0x8d` |
| `DRY` | `0x8e` |
| `SMX` | `0x8f` |
| `SDL` | `0x90` |
| `SRV` | `0x91` |
| `SNC` | `0xa6` |
| `ERR` | `0xa7` |
| `--` | `0xff` |

### Macrosynth Table FX Command

The `MAC_TABLE.m8i` fixture verifies the following Macrosynth table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md). `TRG` and `ERR`
are non-contiguous with the surrounding verified command range.

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `FIN` | `0x82` |
| `OSC` | `0x83` |
| `TBR` | `0x84` |
| `COL` | `0x85` |
| `DEG` | `0x86` |
| `RED` | `0x87` |
| `FIL` | `0x88` |
| `CUT` | `0x89` |
| `RES` | `0x8a` |
| `AMP` | `0x8b` |
| `LIM` | `0x8c` |
| `PAN` | `0x8d` |
| `DRY` | `0x8e` |
| `SMX` | `0x8f` |
| `SDL` | `0x90` |
| `SRV` | `0x91` |
| `TRG` | `0xa6` |
| `ERR` | `0xa7` |
| `--` | `0xff` |

### Sampler Table FX Command

The `SAM_TABLE.m8i` fixture verifies the following Sampler table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md). `SLI` and `ERR`
are non-contiguous with the surrounding verified command range.

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `FIN` | `0x82` |
| `PLY` | `0x83` |
| `STA` | `0x84` |
| `LOP` | `0x85` |
| `LEN` | `0x86` |
| `DEG` | `0x87` |
| `FLT` | `0x88` |
| `CUT` | `0x89` |
| `RES` | `0x8a` |
| `AMP` | `0x8b` |
| `LIM` | `0x8c` |
| `PAN` | `0x8d` |
| `DRY` | `0x8e` |
| `SMX` | `0x8f` |
| `SDL` | `0x90` |
| `SRV` | `0x91` |
| `SLI` | `0xa6` |
| `ERR` | `0xa7` |
| `--` | `0xff` |

### FM Synth Table FX Command

The `FM_TABLE.m8i` fixture verifies the following FM Synth table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md). `SNC` and `ERR`
are non-contiguous with the surrounding verified command range.

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `FIN` | `0x82` |
| `ALG` | `0x83` |
| `FM1` | `0x84` |
| `FM2` | `0x85` |
| `FM3` | `0x86` |
| `FM4` | `0x87` |
| `FIL` | `0x88` |
| `CUT` | `0x89` |
| `RES` | `0x8a` |
| `AMP` | `0x8b` |
| `LIM` | `0x8c` |
| `PAN` | `0x8d` |
| `DRY` | `0x8e` |
| `SMX` | `0x8f` |
| `SDL` | `0x90` |
| `SRV` | `0x91` |
| `SNC` | `0xa6` |
| `ERR` | `0xa7` |
| `--` | `0xff` |

### MIDI Out Table FX Command

The `MID_TABLE.m8i` fixture verifies the following MIDI Out table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md).

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `MPG` | `0x82` |
| `MPB` | `0x83` |
| `ADD` | `0x84` |
| `CHD` | `0x85` |
| `CCA` | `0x86` |
| `CCB` | `0x87` |
| `CCC` | `0x88` |
| `CCD` | `0x89` |
| `CCE` | `0x8a` |
| `CCF` | `0x8b` |
| `CCG` | `0x8c` |
| `CCH` | `0x8d` |
| `CCI` | `0x8e` |
| `CCJ` | `0x8f` |
| `--` | `0xff` |

### Hypersynth Table FX Command

The `HYP_TABLE.m8i` fixture verifies the following Hypersynth table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md). `SNC` and `ERR`
are non-contiguous with the surrounding verified command range.

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `FIN` | `0x82` |
| `CRD` | `0x83` |
| `CVO` | `0x84` |
| `SWM` | `0x85` |
| `WID` | `0x86` |
| `SUB` | `0x87` |
| `FIL` | `0x88` |
| `CUT` | `0x89` |
| `RES` | `0x8a` |
| `AMP` | `0x8b` |
| `LIM` | `0x8c` |
| `PAN` | `0x8d` |
| `DRY` | `0x8e` |
| `SMX` | `0x8f` |
| `SDL` | `0x90` |
| `SRV` | `0x91` |
| `SNC` | `0xa6` |
| `ERR` | `0xa7` |
| `--` | `0xff` |

### External Table FX Command

The `EXT_TABLE.m8i` fixture verifies the following External table command
values. This fixture focuses on instrument table command storage and does not
exhaustively cover every [FX command family](RESEARCH_FX_COMMANDS.md). `ADD` and `CHD`
are non-contiguous with the surrounding verified command range.

| Name | Stored Value |
| --- | --- |
| `VOL` | `0x80` |
| `PIT` | `0x81` |
| `MPB` | `0x82` |
| `MPG` | `0x83` |
| `CCA` | `0x84` |
| `CCB` | `0x85` |
| `CCC` | `0x86` |
| `CCD` | `0x87` |
| `FIL` | `0x88` |
| `CUT` | `0x89` |
| `RES` | `0x8a` |
| `AMP` | `0x8b` |
| `LIM` | `0x8c` |
| `PAN` | `0x8d` |
| `DRY` | `0x8e` |
| `SMX` | `0x8f` |
| `SDL` | `0x90` |
| `SRV` | `0x91` |
| `ADD` | `0xa6` |
| `CHD` | `0xa7` |
| `--` | `0xff` |

### NONE Table FX Command

The `NONE_TABLE.m8i` fixture leaves every table FX command unset. This verifies
that the NONE table uses the standard FX slot layout, but it does not identify
available command values from any [FX command family](RESEARCH_FX_COMMANDS.md).

| Name | Stored Value |
| --- | --- |
| `--` | `0xff` |

### Filter Type

| Name | Stored Value | Scope |
| --- | --- | --- |
| `OFF` | `0x00` | All filter-capable instruments |
| `LOWPASS` | `0x01` | All filter-capable instruments |
| `HIGHPAS` | `0x02` | All filter-capable instruments |
| `BANDPAS` | `0x03` | All filter-capable instruments |
| `BANDSTP` | `0x04` | All filter-capable instruments |
| `LP > HP` | `0x05` | All filter-capable instruments |
| `ZDF LP` | `0x06` | All filter-capable instruments |
| `ZDF HP` | `0x07` | All filter-capable instruments |
| `WAV LP` | `0x08` | Wavsynth only |
| `WAV HP` | `0x09` | Wavsynth only |
| `WAV BP` | `0x0a` | Wavsynth only |
| `WAV BS` | `0x0b` | Wavsynth only |

### Limit Type

| Name | Stored Value |
| --- | --- |
| `CLIP` | `0x00` |
| `SIN` | `0x01` |
| `FOLD` | `0x02` |
| `WRAP` | `0x03` |
| `POST` | `0x04` |
| `POST:AD` | `0x05` |
| `POST:W1` | `0x06` |
| `POST:W2` | `0x07` |
| `POST:W3` | `0x08` |

### MIDI Out Port

Port values `0x00` and `0x03` are verified by the MIDI Out fixtures. Other
labels are from the M8 6.5.2 manual and <https://github.com/whitlockjc/m8-js>
reference material until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `MIDI+USB` | `0x00` |
| `MIDI` | `0x01` |
| `USB` | `0x02` |
| `INTERNAL` | `0x03` |

### External Input

Input values `0x00` and `0x08` are verified by the External fixtures. Other
labels are from the M8 6.5.2 manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `LINE-IN STEREO` | `0x00` |
| `LINE-IN LEFT` | `0x01` |
| `LINE-IN RIGHT` | `0x02` |
| `USB STEREO` | `0x03` |
| `USB LEFT` | `0x04` |
| `USB RIGHT` | `0x05` |
| `ALL STEREO` | `0x06` |
| `ALL LEFT` | `0x07` |
| `ALL RIGHT` | `0x08` |

### External Port

Port values `0x01` and `0x03` are verified by the External fixtures. Other
labels are from the M8 6.5.2 manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `NONE` | `0x00` |
| `MIDI+USB` | `0x01` |
| `MIDI` | `0x02` |
| `USB` | `0x03` |

### FM Synth Algorithm

Algorithms `0x00` and `0x0b` are verified by the FM Synth fixtures. Other
labels are from the M8 6.5.2 manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `A>B>C>D` | `0x00` |
| `[A+B]>C>D` | `0x01` |
| `[A>B+C]>D` | `0x02` |
| `[A>B+A>C]>D` | `0x03` |
| `[A+B+C]>D` | `0x04` |
| `[A>B>C]+D` | `0x05` |
| `[A>B>C]+[A>B>D]` | `0x06` |
| `[A>B]+[C>D]` | `0x07` |
| `[A>B]+[A>C]+[A>D]` | `0x08` |
| `[A>B]+[A>C]+D` | `0x09` |
| `[A>B]+C+D` | `0x0a` |
| `A+B+C+D` | `0x0b` |

### FM Synth Operator Shape

Shapes `0x00`, `0x01`, `0x0f`, `0x10`, and `0x4c` are verified by the FM Synth
fixtures. The fixture shows `CLK` stored as `0x0f`, `W09` stored as `0x10`,
and `W45` stored as `0x4c`.

The `W09..W45` labels correspond to the Wavsynth wave table index labels
`0x09..0x45`. Their stored FM values are offset by `+0x07`: `W09` is stored as
`0x10`, and `W45` is stored as `0x4c`. Intermediate `W` labels are inferred to
follow the same contiguous mapping until fixture evidence contradicts it.

| Name | Stored Value |
| --- | --- |
| `SIN` | `0x00` |
| `SW2` | `0x01` |
| `SW3` | `0x02` |
| `SW4` | `0x03` |
| `SW5` | `0x04` |
| `SW6` | `0x05` |
| `TRI` | `0x06` |
| `SAW` | `0x07` |
| `SQU` | `0x08` |
| `PUL` | `0x09` |
| `IMP` | `0x0a` |
| `NOI` | `0x0b` |
| `NLP` | `0x0c` |
| `NHP` | `0x0d` |
| `NBP` | `0x0e` |
| `CLK` | `0x0f` |
| `W09..W45` | `0x10..0x4c` |

### FM Synth Operator Mod Slot

Mod slot values `0x00`, `0x01..0x04`, and `0x0d..0x10` are verified by the FM
Synth fixtures. Other non-zero labels are inferred from the same storage
pattern.

| Name | Stored Value |
| --- | --- |
| `--` | `0x00` |
| `1>LEV` | `0x01` |
| `2>LEV` | `0x02` |
| `3>LEV` | `0x03` |
| `4>LEV` | `0x04` |
| `1>RAT` | `0x05` |
| `2>RAT` | `0x06` |
| `3>RAT` | `0x07` |
| `4>RAT` | `0x08` |
| `1>PIT` | `0x09` |
| `2>PIT` | `0x0a` |
| `3>PIT` | `0x0b` |
| `4>PIT` | `0x0c` |
| `1>FBK` | `0x0d` |
| `2>FBK` | `0x0e` |
| `3>FBK` | `0x0f` |
| `4>FBK` | `0x10` |

### Sampler Play Mode

Play modes `0x08`, `0x0b`, and `0x0e` are verified by Sampler fixtures. Other
labels are from the M8 6.5.2 manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `FWD` | `0x00` |
| `REV` | `0x01` |
| `FWDLOOP` | `0x02` |
| `REVLOOP` | `0x03` |
| `FWD PP` | `0x04` |
| `REV PP` | `0x05` |
| `OSC` | `0x06` |
| `OSC REV` | `0x07` |
| `OSC PP` | `0x08` |
| `REPITCH` | `0x09` |
| `REP.REV` | `0x0a` |
| `REP.PP` | `0x0b` |
| `REP.BPM` | `0x0c` |
| `BPM.REV` | `0x0d` |
| `BPM.PP` | `0x0e` |

### Wavsynth Shape

Shape `0x45` is verified by the `WAV_PARAMS.m8i` fixture. Other labels are from
the M8 6.5.2 manual and <https://github.com/whitlockjc/m8-js> reference
material until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `PULSE 12%` | `0x00` |
| `PULSE 25%` | `0x01` |
| `PULSE 50%` | `0x02` |
| `PULSE 75%` | `0x03` |
| `SAW` | `0x04` |
| `TRIANGLE` | `0x05` |
| `SINE` | `0x06` |
| `NOISE PITCHED` | `0x07` |
| `NOISE` | `0x08` |
| `OSC:CRUSH` | `0x09` |
| `OSC:FOLDING` | `0x0a` |
| `OSC:FREQ` | `0x0b` |
| `OSC:FUZZY` | `0x0c` |
| `OSC:GHOST` | `0x0d` |
| `OSC:GRAPHIC` | `0x0e` |
| `OSC:LFOPLAY` | `0x0f` |
| `OSC:LIQUID` | `0x10` |
| `OSC:MORPHING` | `0x11` |
| `OSC:MYSTIC` | `0x12` |
| `OSC:STICKY` | `0x13` |
| `OSC:TIDAL` | `0x14` |
| `OSC:TIDY` | `0x15` |
| `OSC:TUBE` | `0x16` |
| `OSC:UMBRELLA` | `0x17` |
| `OSC:UNWIND` | `0x18` |
| `OSC:VIRAL` | `0x19` |
| `OSC:WAVES` | `0x1a` |
| `BNK:DRIP` | `0x1b` |
| `BNK:FROGGY` | `0x1c` |
| `BNK:INSONIC` | `0x1d` |
| `BNK:RADIUS` | `0x1e` |
| `BNK:SCRATCH` | `0x1f` |
| `BNK:SMOOTH` | `0x20` |
| `BNK:WOBBLE` | `0x21` |
| `HRM:ASYMMTRY` | `0x22` |
| `HRM:BLEEN` | `0x23` |
| `HRM:FRACTAL` | `0x24` |
| `HRM:GENTLE` | `0x25` |
| `HRM:HARMONIC` | `0x26` |
| `HRM:HYPNOTIC` | `0x27` |
| `HRM:ITERATIV` | `0x28` |
| `HRM:MICROWAV` | `0x29` |
| `HRM:PLAITS01` | `0x2a` |
| `HRM:PLAITS02` | `0x2b` |
| `HRM:RISEFALL` | `0x2c` |
| `HRM:TONAL` | `0x2d` |
| `HRM:TWINE` | `0x2e` |
| `EFX:ALIEN` | `0x2f` |
| `EFX:CYBERNET` | `0x30` |
| `EFX:DISORDR` | `0x31` |
| `EFX:FORMANT` | `0x32` |
| `EFX:HYPER` | `0x33` |
| `EFX:JAGGED` | `0x34` |
| `EFX:MIXED` | `0x35` |
| `EFX:MULTIPLY` | `0x36` |
| `EFX:NOWHERE` | `0x37` |
| `EFX:PINBALL` | `0x38` |
| `EFX:RINGS` | `0x39` |
| `EFX:SHIMMER` | `0x3a` |
| `EFX:SPECTRAL` | `0x3b` |
| `EFX:SPOOKY` | `0x3c` |
| `EFX:TRANSFRM` | `0x3d` |
| `EFX:TWISTED` | `0x3e` |
| `EFX:VOCAL` | `0x3f` |
| `EFX:WASHED` | `0x40` |
| `EFX:WONDER` | `0x41` |
| `EFX:WOWEE` | `0x42` |
| `EFX:ZAP` | `0x43` |
| `VOX:BRAIDS` | `0x44` |
| `VOX:VOXSYNTH` | `0x45` |

### Macrosynth Shape

Shape `0x2f` is verified by the `MAC_PARAMS.m8i` fixture. Other labels are from
the M8 6.5.2 manual until future fixtures select those values.

| Name | Stored Value |
| --- | --- |
| `CSAW` | `0x00` |
| `MORPH` | `0x01` |
| `SAW SQUARE` | `0x02` |
| `SINE TRIANGLE` | `0x03` |
| `BUZZ` | `0x04` |
| `SQUARE SUB` | `0x05` |
| `SAW SUB` | `0x06` |
| `SQUARE SYNC` | `0x07` |
| `SAW SYNC` | `0x08` |
| `TRIPLE SAW` | `0x09` |
| `TRIPLE SQUARE` | `0x0a` |
| `TRIPLE TRIANGLE` | `0x0b` |
| `TRIPLE SIN` | `0x0c` |
| `TRIPLE RNG` | `0x0d` |
| `SAW SWARM` | `0x0e` |
| `SAW COMB` | `0x0f` |
| `TOY` | `0x10` |
| `DIGITAL FILTER LP` | `0x11` |
| `DIGITAL FILTER PK` | `0x12` |
| `DIGITAL FILTER BP` | `0x13` |
| `DIGITAL FILTER HP` | `0x14` |
| `VOSIM` | `0x15` |
| `VOWEL` | `0x16` |
| `VOWEL FOF` | `0x17` |
| `HARMONICS` | `0x18` |
| `FM` | `0x19` |
| `FEEDBACK FM` | `0x1a` |
| `CHAOTIC FEEDBACK FM` | `0x1b` |
| `PLUCKED` | `0x1c` |
| `BOWED` | `0x1d` |
| `BLOWN` | `0x1e` |
| `FLUTED` | `0x1f` |
| `STRUCK BELL` | `0x20` |
| `STRUCK DRUM` | `0x21` |
| `KICK` | `0x22` |
| `CYMBAL` | `0x23` |
| `SNARE` | `0x24` |
| `WAVETABLES` | `0x25` |
| `WAVE MAP` | `0x26` |
| `WAV LINE` | `0x27` |
| `WAV PARAPHONIC` | `0x28` |
| `FILTERED NOISE` | `0x29` |
| `TWIN PEAKS NOISE` | `0x2a` |
| `CLOCKED NOISE` | `0x2b` |
| `GRANULAR CLOUD` | `0x2c` |
| `PARTICLE NOISE` | `0x2d` |
| `DIGITAL MOD` | `0x2e` |
| `MORSE NOISE` | `0x2f` |

## Unknown Ranges

| Name | Offset / Range | Size | Status |
| --- | --- | ---: | --- |
| `unknownCommon0` | `0x1d..0x1e` | 2 | Preserved for Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External until future fixtures map this common region |
| `wavsynth.unknownBeforeParams` | `0x1f` | 1 | Preserved until future fixtures map this byte |
| `macrosynth.unknownBeforeParams` | `0x1f` | 1 | Preserved until future fixtures map this byte |
| `midiOut.unknownBeforeProgramChange` | `0x20..0x21` | 2 | Preserved until future fixtures map this region |
| `midiOut.unknownBeforeCustomCcs` | `0x23..0x25` | 3 | Preserved until future fixtures map this region |
| `midiOut.unknownBeforeEq` | `0x3a..0x4b` | 18 | Preserved until future fixtures map this region |
| `fmSynth.unknownBeforeParams` | `0x1f` | 1 | Preserved until future fixtures map this byte |
| `fmSynth.unknownBeforeEq` | `0x4b` | 1 | Preserved until future fixtures map this byte |
| `hypersynth.unknownBeforeParams` | `0x1f` | 1 | Preserved until future fixtures map this byte |
| `hypersynth.unknownBeforeEq` | `0x36..0x4b` | 22 | Preserved until future fixtures map this region |
| `hypersynth.unknownAfterChords` | `0xd5..0xe4` | 16 | Preserved until future fixtures map this region |
| `external.unknownBeforeParams` | `0x1f` | 1 | Preserved until future fixtures map this byte |
| `external.unknownBeforeEq` | `0x37..0x4b` | 21 | Preserved until future fixtures map this region |
| `none.body_before_eq` | `0x1d..0x4b` | 47 | Preserved for `none` but not modeled as editable parameters |
| `unknownBeforeEq` | `0x2f..0x4b` | 29 | Preserved for Wavsynth/Macrosynth until future fixtures map this region |
| `sampler.unknownBeforeEq` | `0x30..0x4b` | 28 | Preserved until future fixtures map this region |
| `unknownAfterModulators` | `0x65..0xe4` | 128 | Preserved for Wavsynth, Macrosynth, MIDI Out, FM Synth, and External until future fixtures map this region |
| `sampler.sample_path` | `0x65..0xe4` | 128 | Selected sample path; manual limit is under 128 characters; short fixture shows zero padding |
| `none.unknown` | `0x4d..0xe4` | 152 | Preserved for `none` until future fixtures map this region |

The `NONE` instrument does not expose editable instrument parameters or
modulators, but it can store an editable table. `NONE_DEFAULT.m8i` verifies the
`none` instrument type value, the fixed name location, and preservation of
unknown body bytes. `NONE_TABLE.m8i` verifies the table location and row layout.

### Unknown Region Defaults (6.5.x)

The following comparison uses the 6.5.2C default fixtures. Across each type's
available default, params, mods, and table fixtures, no byte classified as
unknown for that type changes. This establishes stability under the tested
edits, not that the bytes are unused or constant in every valid file.

| Offset / Range | Observed default values |
| --- | --- |
| `0x1d..0x1e` | `00 00` for Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External. MIDI Out uses these offsets for known parameters. |
| `0x1f` | `80` for Wavsynth, Macrosynth, FM Synth, and Hypersynth; `00` for External. Sampler uses this offset for its mode-dependent value, and MIDI Out uses it for `bank`. |
| `0x65..0xe4` | All `00` for Wavsynth, Macrosynth, FM Synth, and NONE. MIDI Out and External have identical repeating defaults that also match Hypersynth's default chord bytes at `0x65..0xd4` and its trailing bytes at `0xd5..0xe4`. Sampler uses this range for `sample_path`. |

The unknown ranges before `eq` begin at different offsets for different
instrument types. A same-offset comparison there may compare an unknown byte in
one type with a known parameter in another. Matching tail bytes likewise do
not establish that MIDI Out or External uses Hypersynth chords.
Parsed-fixture verification checks every available instrument fixture's tail
against its raw byte range, including all 16 Hypersynth chord entries and the
`0xe5` Instrument Table boundary. The unchanged unknown bytes are evidence of
the tested fixtures only, not proof of reserved or unused storage.

## Notes

- `INSTRUMENTS.m8s` verifies that standalone Instrument files and instruments
  embedded in Song files share the same 215-byte `instrument_data`
  representation. Standalone files append one 128-byte Table, while Songs
  store Tables in a separate region.
- Enumerated values should document both stored representation and UI label.
  Verified instrument type values are `wavsynth = 0x00`,
  `macrosynth = 0x01`, `sampler = 0x02`, `midiOut = 0x03`,
  `fmSynth = 0x04`, `hypersynth = 0x05`, `external = 0x06`, and
  `none = 0xff`.
- `transpose` is modeled as part of the common instrument layout at `0x1b`.
  Verified values are `ON = 0x01` and `OFF = 0x00`.
- `eq` is modeled as part of the common instrument layout at `0x4c`. Verified
  display values are `-- = 0x80` and `7F = 0x7f`.
- Sampler `modeValue` is stored at `0x1f`. It displays as `detune`, `steps`,
  or `bpm` depending on `playMode`.
- `SAMB_PARAMS.m8i` does not change `transpose`; its manifest only records the
  byte changes present in the fixture.
- `FM_PARAMS.m8i` directly verifies `filter.type` at `0x41` and `amp.limit`
  at `0x45`, as well as FM Synth EQ assignment at `0x4c`.
- `MID_PARAMS.m8i` does not change `eq`; the M8 UI does not expose an EQ
  assignment control for MIDI Out. Common EQ assignment remains verified by the
  Wavsynth, Macrosynth, Sampler, FM Synth, and External fixtures.
- MIDI Out does not expose Filter, Amplification, or Mixer parameter groups in
  the M8 UI. Older <https://github.com/whitlockjc/m8-js> reference code reads
  shared groups after the MIDI Out custom CC table, but the 6.5.x MIDI Out
  fixture places `CCJ` at `0x38..0x39`, where that older offset model would
  read filter values. This schema follows the fixture evidence and preserves
  `0x3a..0x4b` as unknown.
- `HYP_PARAMS.m8i` verifies common EQ assignment at `0x4c`.
- `HYP_PARAMS.m8i` verifies `0x20` as `currentChord.index` by storing `0x0c`
  when chord `0C` is selected.
- `EXT_PARAMS.m8i` verifies that External uses the shared filter, amplification,
  mixer, and EQ layouts after its 13-byte parameter block.
- `WAV_MODS_A.m8i` verifies the common modulation slot width, offset, packed
  type/destination byte, and parameter layouts for `TRACKING`, `TRIG ENV`,
  `AHD ENV`, and `ADSR ENV`. When a slot changes type, the original bytes are
  still interpreted according to the old type; the manifest names those payload
  byte positions according to the new type layout being verified.
- `WAV_MODS_B.m8i` verifies the parameter layouts for `LFO` and `DRUM ENV`.
- `WAV_TABLE.m8i` verifies that the Wavsynth instrument table starts at
  `0xe5`, contains 16 rows, and uses an eight-byte row layout.
- `NONE_TABLE.m8i` verifies that the NONE instrument table starts at `0xe5`,
  contains 16 rows, and uses the same eight-byte row layout for transpose,
  volume, and FX slots. Its FX slots remain unset, so command-family values
  still need dedicated fixture coverage.
- `MAC_MODS_A.m8i` verifies that Macrosynth uses the common modulation slot
  width, offset, packed type/destination byte, and parameter layouts for
  `TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV`.
- `MAC_MODS_B.m8i` verifies that Macrosynth uses the common modulation
  parameter layouts for `LFO` and `DRUM ENV`.
- `MAC_TABLE.m8i` verifies that the Macrosynth instrument table starts at
  `0xe5`, contains 16 rows, and uses the same eight-byte row layout as
  Wavsynth.
- `SAM_MODS_A.m8i` verifies that Sampler uses the common modulation slot
  width, offset, packed type/destination byte, and parameter layouts for
  `TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV`.
- `SAM_MODS_B.m8i` verifies that Sampler uses the common modulation parameter
  layouts for `LFO` and `DRUM ENV`.
- `SAM_TABLE.m8i` verifies that the Sampler instrument table starts at `0xe5`,
  contains 16 rows, and uses the same eight-byte row layout as Wavsynth and
  Macrosynth. In Sampler files, this places the table immediately after the
  128-byte `sample_path` region.
- `MID_MODS_A.m8i` verifies that MIDI Out uses the common modulation slot
  width, offset, packed type/destination byte, and parameter layouts for
  `TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV`.
- `MID_MODS_B.m8i` verifies that MIDI Out uses the common modulation parameter
  layouts for `LFO` and `DRUM ENV`.
- `MID_TABLE.m8i` verifies that the MIDI Out instrument table starts at
  `0xe5`, contains 16 rows, and uses the same eight-byte row layout as
  Wavsynth, Macrosynth, Sampler, FM Synth, and Hypersynth.
- `FM_MODS_A.m8i` verifies that FM Synth uses the common modulation slot width,
  offset, packed type/destination byte, and parameter layouts for `TRACKING`,
  `TRIG ENV`, `AHD ENV`, and `ADSR ENV`.
- `FM_MODS_B.m8i` verifies that FM Synth uses the common modulation parameter
  layouts for `LFO` and `DRUM ENV`.
- `FM_TABLE.m8i` verifies that the FM Synth instrument table starts at `0xe5`,
  contains 16 rows, and uses the same eight-byte row layout as Wavsynth,
  Macrosynth, and Sampler.
- `HYP_MODS_A.m8i` verifies that Hypersynth uses the common modulation slot
  width, offset, packed type/destination byte, and parameter layouts for
  `TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV`.
- `HYP_MODS_B.m8i` verifies that Hypersynth uses the common modulation
  parameter layouts for `LFO` and `DRUM ENV`.
- `HYP_TABLE.m8i` verifies that the Hypersynth instrument table starts at
  `0xe5`, contains 16 rows, and uses the same eight-byte row layout as
  Wavsynth, Macrosynth, Sampler, and FM Synth. In Hypersynth files, this places
  the table after the 16-entry `chords` table and a 16-byte preserved gap.
- `EXT_MODS_A.m8i` verifies that External uses the common modulation slot
  width, offset, packed type/destination byte, and parameter layouts for
  `TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV`.
- `EXT_MODS_B.m8i` verifies that External uses the common modulation parameter
  layouts for `LFO` and `DRUM ENV`.
- `EXT_TABLE.m8i` verifies that the External instrument table starts at
  `0xe5`, contains 16 rows, and uses the same eight-byte row layout as
  Wavsynth, Macrosynth, Sampler, MIDI Out, FM Synth, and Hypersynth.
- Instrument files appear to include both durable instrument definitions and
  persisted UI/editor state. Hypersynth is the clearest verified example so far:
  `currentChord` is stored in the parameter region, while the persistent
  16-entry `chords` table is stored in the tail. Historical reference material
  names some early instrument bytes as volume, pitch, and fine tune, but this
  schema keeps those regions unknown until fixture evidence verifies their
  meaning.

## Evidence

| Name | Path |
| --- | --- |
| NONE fixture | `fixtures/6.5.x/instruments/NONE_DEFAULT.m8i` |
| NONE table fixture | `fixtures/6.5.x/instruments/NONE_TABLE.m8i` |
| NONE table manifest | `fixtures/6.5.x/instruments/NONE_TABLE.yaml` |
| Wavsynth baseline fixture | `fixtures/6.5.x/instruments/WAV_DEFAULT.m8i` |
| Wavsynth params fixture | `fixtures/6.5.x/instruments/WAV_PARAMS.m8i` |
| Wavsynth params manifest | `fixtures/6.5.x/instruments/WAV_PARAMS.yaml` |
| Wavsynth MODS fixture | `fixtures/6.5.x/instruments/WAV_MODS_A.m8i` |
| Wavsynth MODS manifest | `fixtures/6.5.x/instruments/WAV_MODS_A.yaml` |
| Wavsynth MODS B fixture | `fixtures/6.5.x/instruments/WAV_MODS_B.m8i` |
| Wavsynth MODS B manifest | `fixtures/6.5.x/instruments/WAV_MODS_B.yaml` |
| Wavsynth table fixture | `fixtures/6.5.x/instruments/WAV_TABLE.m8i` |
| Wavsynth table manifest | `fixtures/6.5.x/instruments/WAV_TABLE.yaml` |
| Macrosynth baseline fixture | `fixtures/6.5.x/instruments/MAC_DEFAULT.m8i` |
| Macrosynth params fixture | `fixtures/6.5.x/instruments/MAC_PARAMS.m8i` |
| Macrosynth params manifest | `fixtures/6.5.x/instruments/MAC_PARAMS.yaml` |
| Macrosynth MODS fixture | `fixtures/6.5.x/instruments/MAC_MODS_A.m8i` |
| Macrosynth MODS manifest | `fixtures/6.5.x/instruments/MAC_MODS_A.yaml` |
| Macrosynth MODS B fixture | `fixtures/6.5.x/instruments/MAC_MODS_B.m8i` |
| Macrosynth MODS B manifest | `fixtures/6.5.x/instruments/MAC_MODS_B.yaml` |
| Macrosynth table fixture | `fixtures/6.5.x/instruments/MAC_TABLE.m8i` |
| Macrosynth table manifest | `fixtures/6.5.x/instruments/MAC_TABLE.yaml` |
| Sampler baseline fixture | `fixtures/6.5.x/instruments/SAM_DEFAULT.m8i` |
| Sampler params fixture | `fixtures/6.5.x/instruments/SAM_PARAMS.m8i` |
| Sampler params manifest | `fixtures/6.5.x/instruments/SAM_PARAMS.yaml` |
| Sampler MODS fixture | `fixtures/6.5.x/instruments/SAM_MODS_A.m8i` |
| Sampler MODS manifest | `fixtures/6.5.x/instruments/SAM_MODS_A.yaml` |
| Sampler MODS B fixture | `fixtures/6.5.x/instruments/SAM_MODS_B.m8i` |
| Sampler MODS B manifest | `fixtures/6.5.x/instruments/SAM_MODS_B.yaml` |
| Sampler table fixture | `fixtures/6.5.x/instruments/SAM_TABLE.m8i` |
| Sampler table manifest | `fixtures/6.5.x/instruments/SAM_TABLE.yaml` |
| Sampler steps fixture | `fixtures/6.5.x/instruments/SAMS_PARAMS.m8i` |
| Sampler steps manifest | `fixtures/6.5.x/instruments/SAMS_PARAMS.yaml` |
| Sampler BPM fixture | `fixtures/6.5.x/instruments/SAMB_PARAMS.m8i` |
| Sampler BPM manifest | `fixtures/6.5.x/instruments/SAMB_PARAMS.yaml` |
| MIDI Out baseline fixture | `fixtures/6.5.x/instruments/MID_DEFAULT.m8i` |
| MIDI Out params fixture | `fixtures/6.5.x/instruments/MID_PARAMS.m8i` |
| MIDI Out params manifest | `fixtures/6.5.x/instruments/MID_PARAMS.yaml` |
| MIDI Out MODS fixture | `fixtures/6.5.x/instruments/MID_MODS_A.m8i` |
| MIDI Out MODS manifest | `fixtures/6.5.x/instruments/MID_MODS_A.yaml` |
| MIDI Out MODS B fixture | `fixtures/6.5.x/instruments/MID_MODS_B.m8i` |
| MIDI Out MODS B manifest | `fixtures/6.5.x/instruments/MID_MODS_B.yaml` |
| MIDI Out table fixture | `fixtures/6.5.x/instruments/MID_TABLE.m8i` |
| MIDI Out table manifest | `fixtures/6.5.x/instruments/MID_TABLE.yaml` |
| FM Synth baseline fixture | `fixtures/6.5.x/instruments/FM_DEFAULT.m8i` |
| FM Synth params fixture | `fixtures/6.5.x/instruments/FM_PARAMS.m8i` |
| FM Synth params manifest | `fixtures/6.5.x/instruments/FM_PARAMS.yaml` |
| FM Synth MODS fixture | `fixtures/6.5.x/instruments/FM_MODS_A.m8i` |
| FM Synth MODS manifest | `fixtures/6.5.x/instruments/FM_MODS_A.yaml` |
| FM Synth MODS B fixture | `fixtures/6.5.x/instruments/FM_MODS_B.m8i` |
| FM Synth MODS B manifest | `fixtures/6.5.x/instruments/FM_MODS_B.yaml` |
| FM Synth table fixture | `fixtures/6.5.x/instruments/FM_TABLE.m8i` |
| FM Synth table manifest | `fixtures/6.5.x/instruments/FM_TABLE.yaml` |
| Hypersynth baseline fixture | `fixtures/6.5.x/instruments/HYP_DEFAULT.m8i` |
| Hypersynth params fixture | `fixtures/6.5.x/instruments/HYP_PARAMS.m8i` |
| Hypersynth params manifest | `fixtures/6.5.x/instruments/HYP_PARAMS.yaml` |
| Hypersynth MODS fixture | `fixtures/6.5.x/instruments/HYP_MODS_A.m8i` |
| Hypersynth MODS manifest | `fixtures/6.5.x/instruments/HYP_MODS_A.yaml` |
| Hypersynth MODS B fixture | `fixtures/6.5.x/instruments/HYP_MODS_B.m8i` |
| Hypersynth MODS B manifest | `fixtures/6.5.x/instruments/HYP_MODS_B.yaml` |
| Hypersynth table fixture | `fixtures/6.5.x/instruments/HYP_TABLE.m8i` |
| Hypersynth table manifest | `fixtures/6.5.x/instruments/HYP_TABLE.yaml` |
| External baseline fixture | `fixtures/6.5.x/instruments/EXT_DEFAULT.m8i` |
| External params fixture | `fixtures/6.5.x/instruments/EXT_PARAMS.m8i` |
| External params manifest | `fixtures/6.5.x/instruments/EXT_PARAMS.yaml` |
| External MODS fixture | `fixtures/6.5.x/instruments/EXT_MODS_A.m8i` |
| External MODS manifest | `fixtures/6.5.x/instruments/EXT_MODS_A.yaml` |
| External MODS B fixture | `fixtures/6.5.x/instruments/EXT_MODS_B.m8i` |
| External MODS B manifest | `fixtures/6.5.x/instruments/EXT_MODS_B.yaml` |
| External table fixture | `fixtures/6.5.x/instruments/EXT_TABLE.m8i` |
| External table manifest | `fixtures/6.5.x/instruments/EXT_TABLE.yaml` |
| Verification command | `npm run verify` |
| M8 manual | <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699>, version 6.5.2, 04/21/2026 |
| Reference material | <https://github.com/whitlockjc/m8-js> |

The `NONE_DEFAULT.m8i` fixture verifies the file header, instrument type byte,
and 12-byte name location.

The `NONE_TABLE.m8i` fixture verifies the NONE instrument table at
`0xe5..0x164` as 16 eight-byte rows after a preserved `0x4d..0xe4` pre-table
region. Each row stores `transpose`, `volume`, and three two-byte FX slots.
Every FX slot remains unset in this fixture, so it verifies FX slot placement
but not command-family values. The manifest-driven mapper matched all 39 changed
bytes exactly and reported zero unaccounted changed bytes.

The `WAV_PARAMS.m8i` fixture verifies common transpose/table TIC values,
Wavsynth params, filter params, amp params, mixer params, and common EQ
assignment. The manifest-driven mapper matched all 24 changed bytes exactly and
reported zero unaccounted changed bytes.

The `WAV_MODS_A.m8i` fixture verifies the common instrument modulation block
at `0x4d..0x64` using Wavsynth as the carrier instrument. It verifies
`TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The
manifest-driven mapper matched all 29 changed bytes exactly and reported zero
unaccounted changed bytes.

The `WAV_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block. The manifest-driven mapper matched all
17 changed bytes exactly and reported zero unaccounted changed bytes.

The `WAV_TABLE.m8i` fixture verifies the Wavsynth instrument table at
`0xe5..0x164` as 16 eight-byte rows. Each row stores `transpose`, `volume`, and
three two-byte FX slots. The manifest-driven mapper matched all 79 changed
bytes exactly and reported zero unaccounted changed bytes.

The `MAC_PARAMS.m8i` fixture verifies common transpose/table TIC values,
Macrosynth params, filter params, amp params, mixer params, and common EQ
assignment. The manifest-driven mapper matched all 24 changed bytes exactly and
reported zero unaccounted changed bytes.

The `MAC_MODS_A.m8i` fixture verifies the common instrument modulation block
at `0x4d..0x64` using Macrosynth as the carrier instrument. It verifies
`TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The
manifest-driven mapper matched all 29 changed bytes exactly and reported zero
unaccounted changed bytes.

The `MAC_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block using Macrosynth as the carrier
instrument. The manifest-driven mapper matched all 17 changed bytes exactly
and reported zero unaccounted changed bytes.

The `MAC_TABLE.m8i` fixture verifies the Macrosynth instrument table at
`0xe5..0x164` as 16 eight-byte rows. Each row stores `transpose`, `volume`, and
three two-byte FX slots. The manifest-driven mapper matched all 79 changed
bytes exactly and reported zero unaccounted changed bytes.

The `SAM_PARAMS.m8i`, `SAMS_PARAMS.m8i`, and `SAMB_PARAMS.m8i` fixtures verify
Sampler params, play-mode-dependent `modeValue`, shifted filter/amp/mixer
offsets, common EQ assignment, and sample path storage. The manifest-driven
mapper reported zero unaccounted changed bytes for all three fixtures:
`SAM_PARAMS.m8i` matched 43 changed bytes, `SAMS_PARAMS.m8i` matched 45 changed
bytes, and `SAMB_PARAMS.m8i` matched 44 changed bytes.

The `SAM_MODS_A.m8i` fixture verifies the common instrument modulation block
at `0x4d..0x64` using Sampler as the carrier instrument. It verifies
`TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The
manifest-driven mapper matched all 29 changed bytes exactly and reported zero
unaccounted changed bytes.

The `SAM_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block using Sampler as the carrier instrument.
The manifest-driven mapper matched all 17 changed bytes exactly and reported
zero unaccounted changed bytes.

The `SAM_TABLE.m8i` fixture verifies the Sampler instrument table at
`0xe5..0x164` as 16 eight-byte rows immediately after `sample_path`. Each row
stores `transpose`, `volume`, and three two-byte FX slots. The manifest-driven
mapper matched all 79 changed bytes exactly and reported zero unaccounted
changed bytes.

The `MID_PARAMS.m8i` fixture verifies common transpose/table TIC values, MIDI
Out port, channel, bank, program change, and custom CC table storage. The
manifest-driven mapper matched all 16 changed bytes exactly and reported zero
unaccounted changed bytes.

The `MID_MODS_A.m8i` fixture verifies the common instrument modulation block at
`0x4d..0x64` using MIDI Out as the carrier instrument. It verifies `TRACKING`,
`TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The manifest-driven mapper
matched all 29 changed bytes exactly and reported zero unaccounted changed
bytes.

The `MID_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block using MIDI Out as the carrier instrument.
The manifest-driven mapper matched all 17 changed bytes exactly and reported
zero unaccounted changed bytes.

The `MID_TABLE.m8i` fixture verifies the MIDI Out instrument table at
`0xe5..0x164` as 16 eight-byte rows. Each row stores `transpose`, `volume`, and
three two-byte FX slots. The manifest-driven mapper matched all 71 changed
bytes exactly and reported zero unaccounted changed bytes.

The `FM_PARAMS.m8i` fixture verifies common transpose/table TIC values, FM Synth
params, filter type/cutoff/resonance, amp/limit/pan values, mixer params, and
common EQ assignment. The manifest-driven mapper matched all 52 changed bytes
exactly and reported zero unaccounted changed bytes.

The `FM_MODS_A.m8i` fixture verifies the common instrument modulation block at
`0x4d..0x64` using FM Synth as the carrier instrument. It verifies `TRACKING`,
`TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The manifest-driven mapper
matched all 29 changed bytes exactly and reported zero unaccounted changed
bytes.

The `FM_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block using FM Synth as the carrier
instrument. The manifest-driven mapper matched all 17 changed bytes exactly
and reported zero unaccounted changed bytes.

The `FM_TABLE.m8i` fixture verifies the FM Synth instrument table at
`0xe5..0x164` as 16 eight-byte rows. Each row stores `transpose`, `volume`, and
three two-byte FX slots. The manifest-driven mapper matched all 79 changed
bytes exactly and reported zero unaccounted changed bytes.

The `HYP_PARAMS.m8i` fixture verifies common transpose/table TIC values,
Hypersynth params, filter params, amp params, mixer params, common EQ
assignment, and the Hypersynth chord table boundary. The manifest-driven mapper
matched all 37 changed bytes
exactly and reported zero unaccounted changed bytes.

The `HYP_MODS_A.m8i` fixture verifies the common instrument modulation block at
`0x4d..0x64` using Hypersynth as the carrier instrument. It verifies
`TRACKING`, `TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The
manifest-driven mapper matched all 29 changed bytes exactly and reported zero
unaccounted changed bytes.

The `HYP_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block using Hypersynth as the carrier
instrument. The manifest-driven mapper matched all 17 changed bytes exactly
and reported zero unaccounted changed bytes.

The `HYP_TABLE.m8i` fixture verifies the Hypersynth instrument table at
`0xe5..0x164` as 16 eight-byte rows after the 16-entry `chords` table and a
16-byte preserved gap. Each row stores `transpose`, `volume`, and three
two-byte FX slots. The manifest-driven mapper matched all 79 changed bytes
exactly and reported zero unaccounted changed bytes.

The `EXT_PARAMS.m8i` fixture verifies common transpose/table TIC values,
External params, filter params, amp params, mixer params, and common EQ
assignment. The manifest-driven mapper matched all 28 changed bytes exactly and
reported zero unaccounted changed bytes.

The `EXT_MODS_A.m8i` fixture verifies the common instrument modulation block at
`0x4d..0x64` using External as the carrier instrument. It verifies `TRACKING`,
`TRIG ENV`, `AHD ENV`, and `ADSR ENV` slot storage. The manifest-driven mapper
matched all 29 changed bytes exactly and reported zero unaccounted changed
bytes.

The `EXT_MODS_B.m8i` fixture verifies `LFO` and `DRUM ENV` slot storage within
the common instrument modulation block using External as the carrier
instrument. The manifest-driven mapper matched all 17 changed bytes exactly
and reported zero unaccounted changed bytes.

The `EXT_TABLE.m8i` fixture verifies the External instrument table at
`0xe5..0x164` as 16 eight-byte rows. Each row stores `transpose`, `volume`, and
three two-byte FX slots. The manifest-driven mapper matched all 79 changed
bytes exactly and reported zero unaccounted changed bytes.
