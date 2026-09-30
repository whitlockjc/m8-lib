# table_6_0_1

[Documentation index](../../../README.md)

Source: [schemas/file-versions/6.0.1/instrument/table.ksy](../../../../schemas/file-versions/6.0.1/instrument/table.ksy).

Byte order: `le`.

Sixteen eight-byte Instrument Table rows for file schema 6.0.1.
Standalone Instruments append one table; Songs store 256 tables separately.
FX slots can use the M8 UI's Sequencer, Mixer & Effects, Current Instrument,
and Instrument Mods command groups. Command labels depend on context.


File schema version: `6.0.1`.

## Imports

- [fx_slot](../../../common/fx_slot.md)

## Contents

- [Layout](#layout)
- [row](#type-row)

FX command values: [FX command reference](../../../common/fx_commands.md).

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `rows` | `0x00..0x7f` | 128 | [row](#type-row) | `repeat`: `expr`; `repeat-expr`: `16` | Sixteen rows of transpose, volume, and three FX slots. |

## Type: row

`row`

One eight-byte instrument table row.

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `transpose` | `0x00` | 1 | `u1` | - | Row transpose value. |
| `volume` | `0x01` | 1 | `u1` | - | 0xff displays as --. |
| `fx` | `0x02..0x07` | 6 | [fx_slot](../../../common/fx_slot.md#layout) | `repeat`: `expr`; `repeat-expr`: `3` | Three shared FX slots. The UI groups commands as Sequencer, Mixer &amp; Effects, Current Instrument, and Instrument Mods. Available labels depend on the surrounding instrument and modulation type.  |
