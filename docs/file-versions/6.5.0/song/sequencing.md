# song_sequencing_6_5_0

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.5.0/song/sequencing.ksy](../../../../schemas/file-versions/6.5.0/song/sequencing.ksy).

Byte order: `le`.

Song rows, phrases, chains, and grooves for file schema
version 6.5.0. The Song body determines their positions.


File schema version: `6.5.0`.

## Imports

- [fx_slot](../../../common/fx_slot.md)

## Contents

- [Layout](sequencing.md#layout)
- [grooves](sequencing.md#type-grooves)
- [groove](sequencing.md#type-groove)
- [phrases](sequencing.md#type-phrases)
- [phrase](sequencing.md#type-phrase)
- [phrase_step](sequencing.md#type-phrase_step)
- [song_rows](sequencing.md#type-song_rows)
- [song_row](sequencing.md#type-song_row)
- [chains](sequencing.md#type-chains)
- [chain](sequencing.md#type-chain)
- [chain_row](sequencing.md#type-chain_row)
- [phrase_fx_command (enum)](sequencing.md#enum-phrase_fx_command)

## Layout

Root record.



## Type: grooves

`grooves`

Groove storage. Offsets are relative to absolute file offset 0x00ee in
6.5.x fixtures. The M8 stores 32 grooves, and each groove stores 16 one
byte step values.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x1ff` | 512 | [groove](sequencing.md#type-groove) | `repeat`: `expr`; `repeat-expr`: `32` |  |

## Type: groove

`groove`

Sixteen-byte Groove record containing one byte per step.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `steps` | `0x00..0x0f` | 16 | `u1` | `repeat`: `expr`; `repeat-expr`: `16` |  |

## Type: phrases

`phrases`

Phrase View storage. Offsets are relative to absolute file offset 0x0aee
in 6.5.x fixtures. The M8 stores phrase indexes 0x00 through 0xfe. Value
0xff is observed as an unset phrase reference rather than a stored phrase
record.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x8f6f` | 36720 | [phrase](sequencing.md#type-phrase) | `repeat`: `expr`; `repeat-expr`: `255` |  |

## Type: phrase

`phrase`

One hundred forty-four byte Phrase record containing 16 phrase steps.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `steps` | `0x00..0x8f` | 144 | [phrase_step](sequencing.md#type-phrase_step) | `repeat`: `expr`; `repeat-expr`: `16` |  |

## Type: phrase_step

`phrase_step`

Nine-byte Phrase step. 0xff is observed as unset for note, volume,
instrument, and FX command bytes. FX value bytes default to 0x00.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `note` | `0x00` | 1 | `u1` | - |  |
| `volume` | `0x01` | 1 | `u1` | - |  |
| `instrument` | `0x02` | 1 | `u1` | - |  |
| `fx` | `0x03..0x08` | 6 | [fx_slot](../../../common/fx_slot.md#layout) | `repeat`: `expr`; `repeat-expr`: `3` |  |

## Type: song_rows

`song_rows`

Song View row storage. Offsets are relative to absolute file offset
0x02ee in 6.5.x fixtures. The M8 stores 256 rows, and each row stores one
chain index per track.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x7ff` | 2048 | [song_row](sequencing.md#type-song_row) | `repeat`: `expr`; `repeat-expr`: `256` |  |

## Type: song_row

`song_row`

Eight-byte Song View row. Each byte stores the chain index assigned to a
track; tracks[0] is M8 Track 1. 0xff is observed as unset.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `tracks` | `0x00..0x07` | 8 | `u1` | `repeat`: `expr`; `repeat-expr`: `8` |  |

## Type: chains

`chains`

Chain View storage. Offsets are relative to absolute file offset 0x9a5e
in 6.5.x fixtures. The M8 stores chain indexes 0x00 through 0xfe; 0xff is
the unset reference sentinel. Each chain stores 16 rows.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x1fdf` | 8160 | [chain](sequencing.md#type-chain) | `repeat`: `expr`; `repeat-expr`: `255` |  |

## Type: chain

`chain`

Thirty-two-byte Chain View record containing 16 two-byte rows.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `rows` | `0x00..0x1f` | 32 | [chain_row](sequencing.md#type-chain_row) | `repeat`: `expr`; `repeat-expr`: `16` |  |

## Type: chain_row

`chain_row`

Chain row storage. The phrase byte stores the referenced phrase index;
0xff is observed as unset.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `phrase` | `0x00` | 1 | `u1` | - |  |
| `transpose` | `0x01` | 1 | `u1` | - |  |

## Enum: phrase_fx_command

`phrase_fx_command`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `arpeggio` | ARP |  |
| `0x01` | `chance` | CHA |  |
| `0x02` | `delay` | DEL |  |
| `0x03` | `groove` | GRV |  |
| `0x04` | `hop` | HOP |  |
| `0x05` | `kill_note` | KIL |  |
| `0x06` | `randomize` | RND |  |
| `0x07` | `randomize_left` | RNL |  |
| `0x08` | `retrig` | RET |  |
| `0x09` | `repeat` | REP |  |
| `0x0a` | `remix` | RMX |  |
| `0x0b` | `nth` | NTH |  |
| `0x0c` | `pitch_slide` | PSL |  |
| `0x0d` | `pitch_bend` | PBN |  |
| `0x0e` | `vibrato` | PVB |  |
| `0x0f` | `extreme_vibrato` | PVX |  |
| `0x10` | `track_scale` | SCA |  |
| `0x11` | `global_scale` | SCG |  |
| `0x12` | `random_seed` | SED |  |
| `0x13` | `song_hop` | SNG |  |
| `0x14` | `table` | TBL |  |
| `0x15` | `table_hop` | THO |  |
| `0x16` | `table_tick` | TIC |  |
| `0x17` | `aux_table` | TBX |  |
| `0x18` | `tempo` | TPO |  |
| `0x19` | `transpose` | TSP |  |
| `0x1a` | `note_off` | OFF |  |
| `0x1b` | `main_volume` | VMV |  |
| `0x1c` | `mod_fx_modulation_depth` | XMM |  |
| `0x1d` | `mod_fx_modulation_frequency` | XMF |  |
| `0x1e` | `mod_fx_stereo_width` | XMW |  |
| `0x1f` | `mod_fx_reverb_mix` | XMR |  |
| `0x20` | `delay_time` | XDT |  |
| `0x21` | `delay_feedback` | XDF |  |
| `0x22` | `delay_stereo_width` | XDW |  |
| `0x23` | `delay_reverb_mix` | XDR |  |
| `0x24` | `reverb_room_size` | XRS |  |
| `0x25` | `reverb_decay` | XRD |  |
| `0x26` | `reverb_modulation_depth` | XRM |  |
| `0x27` | `reverb_modulation_frequency` | XRF |  |
| `0x28` | `reverb_stereo_width` | XRW |  |
| `0x29` | `reverb_freeze` | XRZ |  |
| `0x2a` | `mod_fx_volume` | VMX |  |
| `0x2b` | `delay_volume` | VDE |  |
| `0x2c` | `reverb_volume` | VRE |  |
| `0x2d` | `track_1_volume` | VT1 |  |
| `0x2e` | `track_2_volume` | VT2 |  |
| `0x2f` | `track_3_volume` | VT3 |  |
| `0x30` | `track_4_volume` | VT4 |  |
| `0x31` | `track_5_volume` | VT5 |  |
| `0x32` | `track_6_volume` | VT6 |  |
| `0x33` | `track_7_volume` | VT7 |  |
| `0x34` | `track_8_volume` | VT8 |  |
| `0x35` | `dj_filter_cutoff` | DJC |  |
| `0x36` | `line_input_volume` | VIN |  |
| `0x37` | `line_input_mod_fx_send` | IMX |  |
| `0x38` | `line_input_delay_send` | IDE |  |
| `0x39` | `line_input_reverb_send` | IRE |  |
| `0x3a` | `second_line_input_volume` | VI2 |  |
| `0x3b` | `second_line_input_mod_fx_send` | IM2 |  |
| `0x3c` | `second_line_input_delay_send` | ID2 |  |
| `0x3d` | `second_line_input_reverb_send` | IR2 |  |
| `0x3e` | `usb_input_volume` | USB |  |
| `0x3f` | `dj_filter_resonance` | DJR |  |
| `0x40` | `dj_filter_type` | DJT |  |
| `0x41` | `main_song_eq_assignment` | EQM |  |
| `0x42` | `current_instrument_eq_assignment` | EQI |  |
| `0x43` | `instrument` | INS |  |
| `0x44` | `repeat_boundary` | RTO |  |
| `0x45` | `arpeggio_config` | ARC |  |
| `0x46` | `global_groove` | GGR |  |
| `0x47` | `next_track` | NXT |  |
| `0x48` | `reverb_highpass` | XRH |  |
| `0x49` | `mod_fx_type_and_phase` | XMT |  |
| `0x4a` | `ott` | OTT |  |
| `0x4b` | `ott_color` | OTC |  |
| `0x4c` | `ott_time` | OTI |  |
| `0x4d` | `micro_time` | MTT |  |
| `0xff` | `unset` | -- |  |
