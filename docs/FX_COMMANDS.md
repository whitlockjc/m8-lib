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
| Sequencer | Sequencer FX Commands | Labels documented below; byte values need fixture evidence |
| Mixer & Effects | Mixer & Effects Commands | Labels documented below; byte values need fixture evidence |
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

Command labels below come from the M8 6.5.2 manual. Stored byte values are not
canonical until fixture evidence verifies them.

### Sequencer

| Label | Meaning |
| --- | --- |
| `ARP` | Arpeggio |
| `ARC` | Arpeggio config |
| `CHA` | Chance |
| `DEL` | Delay |
| `GRV` | Groove |
| `GGR` | Global groove |
| `HOP` | Position hop |
| `INS` | Trigger or change instrument |
| `KIL` | Kill note |
| `RND` | Randomize previous FX command |
| `RNL` | Randomize command to the left |
| `RET` | Retrig |
| `REP` | Repeat |
| `RTO` | Repeat boundary |
| `RMX` | Remix |
| `NTH` | Conditional trigger |
| `PSL` | Pitch slide |
| `PBN` | Pitch bend |
| `PVB` | Vibrato |
| `PVX` | Extreme vibrato |
| `SCA` | Track scale |
| `SCG` | Global scale |
| `SNG` | Song hop |
| `SED` | Random seed |
| `TBL` | Instrument table |
| `THO` | Table hop |
| `TIC` | Table tick |
| `TBX` | Aux table |
| `TPO` | Tempo |
| `TSP` | Global song transpose |
| `NXT` | Trigger instrument on next track |
| `OFF` | Note off |
| `MTT` | Micro-time |

### Mixer & Effects

| Label | Meaning |
| --- | --- |
| `EQM` | Main song EQ assignment |
| `EQI` | Current instrument EQ assignment |
| `VMV` | Main volume |
| `VMX` | ModFX volume |
| `VDE` | Delay volume |
| `VRE` | Reverb volume |
| `VT1`..`VT8` | Track volume |
| `DJC` | DJ filter cutoff |
| `DJR` | DJ filter resonance |
| `DJT` | DJ filter type |
| `IVO` | Line input volume |
| `IMX` | Line input ModFX send |
| `IDE` | Line input delay send |
| `IRV` | Line input reverb send |
| `IV2` | Second line input volume |
| `IM2` | Second line input ModFX send |
| `ID2` | Second line input delay send |
| `IR2` | Second line input reverb send |
| `USB` | USB input volume |
| `XMT` | ModFX type and phase |
| `XMM` | ModFX modulation depth |
| `XMF` | ModFX modulation frequency |
| `XMW` | ModFX stereo width |
| `XMR` | ModFX to reverb mix |
| `XDT` | Delay time |
| `XDF` | Delay feedback |
| `XDW` | Delay stereo width |
| `XDR` | Delay to reverb mix |
| `XRS` | Reverb room size |
| `XRD` | Reverb decay |
| `XRM` | Reverb modulation depth |
| `XRF` | Reverb modulation frequency |
| `XRW` | Reverb stereo width |
| `XRZ` | Reverb freeze |

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

## Verification Plan

Future fixtures should verify command-family availability and stored byte values
separately from the structural FX slot layout:

| Research Target | Goal |
| --- | --- |
| Sequencer commands | Map labels, byte values, and amount semantics |
| Mixer & Effects commands | Map labels, byte values, and amount semantics |
| Current Instrument commands | Finish command coverage for the active instrument's common and instrument-specific commands |
| Instrument Mods commands | Map labels, byte values, and amount semantics per target modulator type |
| Phrase FX slots | Verify which command families are available in song phrases |
| Instrument table FX slots | Verify which command families are available inside instrument tables |
| NONE instrument table | Map command byte values available when the active instrument is NONE |
| Version boundaries | Check command values after firmware releases that mention new or changed FX commands |

## Sources

- Dirtywave M8 Operation Manual v6.5.2, Appendix sections "Relative and
  Absolute FX Commands", "Sequencer FX Commands", "Mixer & Effects Commands",
  and "Instrument FX Commands":
  <https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699>
