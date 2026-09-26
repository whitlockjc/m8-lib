# scale_4_0_1

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../../README.md)

Source: [schemas/file-versions/4.0.1/scale.ksy](../../../schemas/file-versions/4.0.1/scale.ksy).

Byte order: `le`.

Body schema for scale files with header schema version 4.0.1.

Verified against M8 6.5.2C scale fixtures. The body contains an enabled-note
bitmask, 12 interval offsets, a fixed-size name byte range, and a tuning
offset. No unaccounted bytes remain in the verified fixture pair.


File schema version: `4.0.1`.

## Contents

- [Layout](scale.md#layout)
- [interval](scale.md#type-interval)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `enabled_notes` | `0x00..0x01` | 2 | `u2` | - |  |
| `intervals` | `0x02..0x19` | 24 | [interval](scale.md#type-interval) | `repeat`: `expr`; `repeat-expr`: `12` |  |
| `name` | `0x1a..0x29` | 16 | bytes | `size`: `16` | Fixed-size byte range for the scale name. Padding bytes are preserved as stored.  |
| `tuning_offset` | `0x2a..0x2d` | 4 | `f4` | - | Verified 32-bit float storage for Scale Editor tuning. The M8 UI defaults to 440.00 Hz and stores 0.0 here. A UI change from 440.00 to 439.97 stored approximately -0.03, so this appears to be an offset from the standard A440 tuning reference rather than an absolute tuning value.  |

## Type: interval

`interval`

Signed interval offset stored as hundredths of a semitone.


Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `offset` | `0x00..0x01` | 2 | `s2` | - |  |
