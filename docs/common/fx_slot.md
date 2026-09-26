# fx_slot

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../README.md)

Source: [schemas/common/fx_slot.ksy](../../schemas/common/fx_slot.ksy).

Byte order: `le`.

Two-byte FX slot used by Phrase steps and Instrument Table rows. Command
availability and labels depend on the surrounding context and are not part
of this raw storage type.


## Contents

- [Layout](fx_slot.md#layout)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `command` | `0x00` | 1 | `u1` | - | Observed 0xff displays as unset. |
| `value` | `0x01` | 1 | `u1` | - |  |
