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

- [Layout](#layout)
- [grooves](#type-grooves)
- [groove](#type-groove)
- [phrases](#type-phrases)
- [phrase](#type-phrase)
- [phrase_step](#type-phrase_step)
- [song_rows](#type-song_rows)
- [song_row](#type-song_row)
- [chains](#type-chains)
- [chain](#type-chain)
- [chain_row](#type-chain_row)

FX command values: [FX command reference](../../../fx_commands.md).

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
| `entries` | `0x00..0x1ff` | 512 | [groove](#type-groove) | `repeat`: `expr`; `repeat-expr`: `32` | Thirty-two Song groove definitions. |

## Type: groove

`groove`

Sixteen-byte Groove record containing one byte per step.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `steps` | `0x00..0x0f` | 16 | `u1` | `repeat`: `expr`; `repeat-expr`: `16` | Sixteen groove step values. |

## Type: phrases

`phrases`

Phrase View storage. Offsets are relative to absolute file offset 0x0aee
in 6.5.x fixtures. The M8 stores phrase indexes 0x00 through 0xfe. Value
0xff is observed as an unset phrase reference rather than a stored phrase
record.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x8f6f` | 36720 | [phrase](#type-phrase) | `repeat`: `expr`; `repeat-expr`: `255` | Stored phrases indexed 0x00 through 0xfe. |

## Type: phrase

`phrase`

One hundred forty-four byte Phrase record containing 16 phrase steps.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `steps` | `0x00..0x8f` | 144 | [phrase_step](#type-phrase_step) | `repeat`: `expr`; `repeat-expr`: `16` | Sixteen steps in this phrase. |

## Type: phrase_step

`phrase_step`

Nine-byte Phrase step. 0xff is observed as unset for note, volume,
instrument, and FX command bytes. FX value bytes default to 0x00.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `note` | `0x00` | 1 | `u1` | - | Note value; 0xff is unset. |
| `volume` | `0x01` | 1 | `u1` | - | Step volume; 0xff is unset. |
| `instrument` | `0x02` | 1 | `u1` | - | Instrument index; 0xff is unset. |
| `fx` | `0x03..0x08` | 6 | [fx_slot](../../../common/fx_slot.md#layout); [FX commands](../../../fx_commands.md) | `repeat`: `expr`; `repeat-expr`: `3` | Three shared FX slots. The UI groups commands as Sequencer, Mixer &amp; Effects, Current Instrument, and Instrument Mods. Available labels depend on the surrounding instrument and modulation type.  |

## Type: song_rows

`song_rows`

Song View row storage. Offsets are relative to absolute file offset
0x02ee in 6.5.x fixtures. The M8 stores 256 rows, and each row stores one
chain index per track.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x7ff` | 2048 | [song_row](#type-song_row) | `repeat`: `expr`; `repeat-expr`: `256` | Song rows indexed 0x00 through 0xff. |

## Type: song_row

`song_row`

Eight-byte Song View row. Each byte stores the chain index assigned to a
track; tracks[0] is M8 Track 1. 0xff is observed as unset.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `tracks` | `0x00..0x07` | 8 | `u1` | `repeat`: `expr`; `repeat-expr`: `8` | Chain index for each of the eight tracks; 0xff is unset. |

## Type: chains

`chains`

Chain View storage. Offsets are relative to absolute file offset 0x9a5e
in 6.5.x fixtures. The M8 stores chain indexes 0x00 through 0xfe; 0xff is
the unset reference sentinel. Each chain stores 16 rows.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `entries` | `0x00..0x1fdf` | 8160 | [chain](#type-chain) | `repeat`: `expr`; `repeat-expr`: `255` | Stored chains indexed 0x00 through 0xfe. |

## Type: chain

`chain`

Thirty-two-byte Chain View record containing 16 two-byte rows.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `rows` | `0x00..0x1f` | 32 | [chain_row](#type-chain_row) | `repeat`: `expr`; `repeat-expr`: `16` | Sixteen rows in this chain. |

## Type: chain_row

`chain_row`

Chain row storage. The phrase byte stores the referenced phrase index;
0xff is observed as unset.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `phrase` | `0x00` | 1 | `u1` | - | Referenced phrase index; 0xff is unset. |
| `transpose` | `0x01` | 1 | `u1` | - | Transpose value for the referenced phrase. |
