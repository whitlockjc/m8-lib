# fx_slot

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../README.md)

Source: [schemas/common/fx_slot.ksy](../../schemas/common/fx_slot.ksy).

Byte order: `le`.

Two-byte FX slot used by Phrase steps and Instrument Table rows. Command
bytes and argument bytes have the same storage in both places. The M8 UI
groups commands under Sequencer, Mixer & Effects, Current Instrument, and
Instrument Mods. Current Instrument commands depend on the active instrument;
Instrument Mods labels also depend on the selected modulation type. These
groups describe contextual labels and availability, not distinct byte layouts.
Sequencer and Mixer & Effects byte values are verified in the 6.5.x Phrase
fixture, and selected Current Instrument values in Instrument Table fixtures.
Instrument Mods command values still need fixture evidence.


## Contents

- [Layout](#layout)

FX command values: [FX command reference](fx_commands.md).

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `command` | `0x00` | 1 | `u1` | - | Raw command byte; 0xff displays as unset. Interpret using the surrounding context and command group. |
| `value` | `0x01` | 1 | `u1` | - | Raw command argument; the Instrument Table UI may call this an amount. |
