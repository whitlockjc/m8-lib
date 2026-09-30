# fx_slot

[Documentation index](../README.md)

Source: [schemas/common/fx_slot.ksy](../../schemas/common/fx_slot.ksy).

Byte order: `le`.

Two-byte FX slot used by Phrase steps and Instrument Table rows. Command
and argument bytes have the same layout in both places. The command label
depends on its group, active instrument, and modulation type.

## Contents

- [Layout](#layout)

FX command values: [FX command reference](fx_commands.md).

## Layout

Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `command` | `0x00` | 1 | `u1` | - | Raw command byte; 0xff displays as unset. Interpret using the surrounding context and command group. |
| `value` | `0x01` | 1 | `u1` | - | Raw command argument; the Instrument Table UI may call this an amount. |
