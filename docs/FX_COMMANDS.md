# FX Commands

This document describes how M8 FX commands should be organized while the stored
byte values are being researched.

## Scope

The M8 file schemas store FX commands as raw command/value pairs. The command
byte identifies the command label, and the value byte stores the command
argument.

The M8 UI organizes FX command semantics into these families:

| Family | Manual Section | Current Status |
| --- | --- | --- |
| Sequencer | Sequencer FX Commands | Labels and byte values verified by `PHRASES.m8s` |
| Mixer & Effects | Mixer & Effects Commands | Labels and byte values verified by `PHRASES.m8s` |
| Current Instrument | Instrument FX Commands and active instrument parameters | Some byte values verified by instrument table fixtures |
| Instrument Mods | Instrument FX Commands | Labels depend on the target modulator type; byte values need fixture evidence |

Do not treat non-instrument command families as instrument-agnostic. Availability
and runtime behavior are contextual. A command may be valid in phrase FX slots,
instrument table FX slots, or both, and some commands have different behavior
depending on where they are used.

## Storage

Verified instrument tables store each FX slot as two adjacent bytes:

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `command` | `+0x00` | 1 | raw command byte |
| `amount` | `+0x01` | 1 | raw command amount |

Observed unset value:

| Label | Stored Value |
| --- | --- |
| `--` | `0xff` |

This raw storage shape should remain separate from command-family semantics. A
reader can expose raw bytes first, then layer contextual decoding on top once the
available command families are known for the surrounding location and
instrument.

## Command Families

Sequencer and Mixer/Effects command byte values below are verified by the
`PHRASES.m8s` fixture. Current Instrument command byte values are verified by
instrument table fixtures and documented with the corresponding instrument
schemas.

### Sequencer

| Stored Value | Label | Meaning |
| --- | --- | --- |
| `0x00` | `ARP` | Arpeggio |
| `0x45` | `ARC` | Arpeggio config |
| `0x01` | `CHA` | Chance |
| `0x02` | `DEL` | Delay |
| `0x03` | `GRV` | Groove |
| `0x46` | `GGR` | Global groove |
| `0x04` | `HOP` | Position hop |
| `0x43` | `INS` | Trigger or change instrument |
| `0x05` | `KIL` | Kill note |
| `0x06` | `RND` | Randomize previous FX command |
| `0x07` | `RNL` | Randomize command to the left |
| `0x08` | `RET` | Retrig |
| `0x09` | `REP` | Repeat |
| `0x44` | `RTO` | Repeat boundary |
| `0x0a` | `RMX` | Remix |
| `0x0b` | `NTH` | Conditional trigger |
| `0x0c` | `PSL` | Pitch slide |
| `0x0d` | `PBN` | Pitch bend |
| `0x0e` | `PVB` | Vibrato |
| `0x0f` | `PVX` | Extreme vibrato |
| `0x10` | `SCA` | Track scale |
| `0x11` | `SCG` | Global scale |
| `0x13` | `SNG` | Song hop |
| `0x12` | `SED` | Random seed |
| `0x14` | `TBL` | Instrument table |
| `0x15` | `THO` | Table hop |
| `0x16` | `TIC` | Table tick |
| `0x17` | `TBX` | Aux table |
| `0x18` | `TPO` | Tempo |
| `0x19` | `TSP` | Global song transpose |
| `0x47` | `NXT` | Trigger instrument on next track |
| `0x1a` | `OFF` | Note off |
| `0x4d` | `MTT` | Micro-time |

### Mixer & Effects

| Stored Value | Label | Meaning |
| --- | --- | --- |
| `0x41` | `EQM` | Main song EQ assignment |
| `0x42` | `EQI` | Current instrument EQ assignment |
| `0x1b` | `VMV` | Main volume |
| `0x2a` | `VMX` | ModFX volume |
| `0x2b` | `VDE` | Delay volume |
| `0x2c` | `VRE` | Reverb volume |
| `0x2d` | `VT1` | Track 1 volume |
| `0x2e` | `VT2` | Track 2 volume |
| `0x2f` | `VT3` | Track 3 volume |
| `0x30` | `VT4` | Track 4 volume |
| `0x31` | `VT5` | Track 5 volume |
| `0x32` | `VT6` | Track 6 volume |
| `0x33` | `VT7` | Track 7 volume |
| `0x34` | `VT8` | Track 8 volume |
| `0x35` | `DJC` | DJ filter cutoff |
| `0x3f` | `DJR` | DJ filter resonance |
| `0x40` | `DJT` | DJ filter type |
| `0x36` | `VIN` | Line input volume |
| `0x37` | `IMX` | Line input ModFX send |
| `0x38` | `IDE` | Line input delay send |
| `0x39` | `IRE` | Line input reverb send |
| `0x3a` | `VI2` | Second line input volume |
| `0x3b` | `IM2` | Second line input ModFX send |
| `0x3c` | `ID2` | Second line input delay send |
| `0x3d` | `IR2` | Second line input reverb send |
| `0x3e` | `USB` | USB input volume |
| `0x49` | `XMT` | ModFX type and phase |
| `0x1c` | `XMM` | ModFX modulation depth |
| `0x1d` | `XMF` | ModFX modulation frequency |
| `0x1e` | `XMW` | ModFX stereo width |
| `0x1f` | `XMR` | ModFX to reverb mix |
| `0x20` | `XDT` | Delay time |
| `0x21` | `XDF` | Delay feedback |
| `0x22` | `XDW` | Delay stereo width |
| `0x23` | `XDR` | Delay to reverb mix |
| `0x24` | `XRS` | Reverb room size |
| `0x25` | `XRD` | Reverb decay |
| `0x26` | `XRM` | Reverb modulation depth |
| `0x27` | `XRF` | Reverb modulation frequency |
| `0x28` | `XRW` | Reverb stereo width |
| `0x48` | `XRH` | Reverb highpass |
| `0x29` | `XRZ` | Reverb freeze |
| `0x4a` | `OTT` | OTT amount |
| `0x4b` | `OTC` | OTT color |
| `0x4c` | `OTI` | OTT time |

### Current Instrument

| Label | Meaning | Current Status |
| --- | --- | --- |
| `VOL` | Instrument volume offset | Verified as `0x80` in instrument table fixtures |
| `PIT` | Pitch offset | Verified as `0x81` in instrument table fixtures |
| `FIN` | Fine tune offset | Verified as `0x82` in non-MIDI instrument table fixtures |

The Current Instrument group also includes command labels that map to the active
instrument's parameters. The currently verified command subsets live in
[INSTRUMENT.md](INSTRUMENT.md):

| Instrument | Verified Table Fixture |
| --- | --- |
| NONE | `NONE_TABLE.m8i`, unset slots only |
| Wavsynth | `WAV_TABLE.m8i` |
| Macrosynth | `MAC_TABLE.m8i` |
| Sampler | `SAM_TABLE.m8i` |
| MIDI Out | `MID_TABLE.m8i` |
| FM Synth | `FM_TABLE.m8i` |
| Hypersynth | `HYP_TABLE.m8i` |
| External | `EXT_TABLE.m8i` |

### Instrument Mods

Instrument Mods command labels map to the configurable instrument modulation
slots. Unlike Current Instrument parameter commands, this is not one flat label
set. The available labels can change based on the target modulator slot and that
slot's selected modulation type.

The M8 6.5.2 manual lists these labels as research targets, but fixtures should
verify the available labels and byte values per modulator type:

| Label | Meaning | Current Status |
| --- | --- | --- |
| `EA1`, `EA2` | Envelope amount offset | Needs fixture evidence |
| `AT1`, `AT2` | Envelope attack offset | Needs fixture evidence |
| `HO1`, `HO2` | Envelope hold offset | Needs fixture evidence |
| `DE1`, `DE2` | Envelope decay offset | Needs fixture evidence |
| `ET1`, `ET2` | Envelope retrigger | Needs fixture evidence |
| `LA1`, `LA2` | LFO amount offset | Needs fixture evidence |
| `LF1`, `LF2` | LFO frequency offset | Needs fixture evidence |
| `LT1`, `LT2` | LFO retrigger | Needs fixture evidence |

Known modulator types to cover:

| Modulator Type | Storage Status | Command Status |
| --- | --- | --- |
| `AHD ENV` | Slot parameter storage verified | Command labels/values need fixture evidence |
| `ADSR ENV` | Slot parameter storage verified | Command labels/values need fixture evidence |
| `DRUM ENV` | Slot parameter storage verified | Command labels/values need fixture evidence |
| `LFO` | Slot parameter storage verified | Command labels/values need fixture evidence |
| `TRIG ENV` | Slot parameter storage verified | Command labels/values need fixture evidence |
| `TRACKING` | Slot parameter storage verified | Command labels/values need fixture evidence |

## Verification Status

Command-family availability and stored byte values are verified separately from
the structural FX slot layout:

| Research Target | Goal |
| --- | --- |
| Sequencer commands | Labels and byte values verified by `PHRASES.m8s`; amount semantics remain command-specific |
| Mixer & Effects commands | Labels and byte values verified by `PHRASES.m8s`; amount semantics remain command-specific |
| Current Instrument commands | Finish command coverage for the active instrument's common and instrument-specific commands |
| Instrument Mods commands | Map labels, byte values, and amount semantics per target modulator type |
| Phrase FX slots | Structural storage and Sequencer/Mixer & Effects command values verified by `PHRASES.m8s` |
| Song Table FX slots | Sequencer and Mixer & Effects families verified by `TABLES.m8s` |
| Standalone Instrument table FX slots | Current Instrument commands verified by instrument-specific table fixtures; other family coverage remains open |
| NONE instrument table | Map command byte values available when the active instrument is NONE |
| Version boundaries | Check command values after firmware releases that mention new or changed FX commands |

## Sources

- `fixtures/6.5.x/songs/PHRASES.m8s`
- `fixtures/6.5.x/songs/PHRASES.yaml`
- `fixtures/6.5.x/songs/TABLES.m8s`
- `fixtures/6.5.x/songs/TABLES.yaml`
- Dirtywave M8 Operation Manual v6.5.2, Appendix sections "Relative and
  Absolute FX Commands", "Sequencer FX Commands", "Mixer & Effects Commands",
  and "Instrument FX Commands":
  <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699>
