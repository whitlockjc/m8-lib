# scale_4_0_1

[Documentation index](../../README.md)

Source: [schemas/file-versions/4.0.1/scale.ksy](../../../schemas/file-versions/4.0.1/scale.ksy).

Byte order: `le`.

Scale body with an enabled-note bitmask, 12 interval offsets, a fixed-size
name, and a tuning offset.


File schema version: `4.0.1`.

## Contents

- [Layout](#layout)
- [interval](#type-interval)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `enabled_notes` | `0x00..0x01` | 2 | `u2` | - | Bitmask selecting the enabled intervals. |
| `intervals` | `0x02..0x19` | 24 | [interval](#type-interval) | `repeat`: `expr`; `repeat-expr`: `12` | Twelve interval offsets in Scale View order. |
| `name` | `0x1a..0x29` | 16 | bytes | `size`: `16` | Fixed-size byte range for the scale name. Padding bytes are preserved as stored.  |
| `tuning_offset` | `0x2a..0x2d` | 4 | `f4` | - | Tuning offset in Hz from A440, stored as a 32-bit float. A 440.00 Hz tuning stores 0.0.  |

## Type: interval

`interval`

Signed interval offset stored as hundredths of a semitone.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `offset` | `0x00..0x01` | 2 | `s2` | - | Signed interval offset in hundredths of a semitone. |
