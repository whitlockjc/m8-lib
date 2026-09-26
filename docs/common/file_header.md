# file_header

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](../README.md)

Source: [schemas/common/file_header.ksy](../../schemas/common/file_header.ksy).

Byte order: `le`.

Common header present at the start of M8 files.

The encoded version appears to describe the persisted file schema version for
this file, not necessarily the M8 firmware version used to create it.


## Contents

- [Layout](file_header.md#layout)
- [file_kind (enum)](file_header.md#enum-file_kind)

## Layout

Root record.



Offsets are relative to the start of this record. Repeated-field sizes include all entries.

| Name | Offset / Range | Size (bytes) | Type | Storage / Validation | Description |
| --- | --- | ---: | --- | --- | --- |
| `magic` | `0x00..0x08` | 9 | bytes | `contents`: `M8VERSION` | ASCII file signature. |
| `reserved_0` | `0x09` | 1 | `u1` | `valid`: `0` |  |
| `schema_version_raw` | `0x0a..0x0b` | 2 | `u2` | - | Packed schema version as major/minor/patch nibbles. |
| `reserved_1` | `0x0c` | 1 | `u1` | `valid`: `0` |  |
| `file_kind` | `0x0d` | 1 | `u1`; [file_kind](file_header.md#enum-file_kind) | - |  |

### Instances

Value expressions do not consume bytes. Positioned instances read the specified location.

| Name | Type | Expression / Position / Rules | Description |
| --- | --- | --- | --- |
| `schema_version_major` | derived | `value`: `(schema_version_raw >> 8) & 0xf` |  |
| `schema_version_minor` | derived | `value`: `(schema_version_raw >> 4) & 0xf` |  |
| `schema_version_patch` | derived | `value`: `schema_version_raw & 0xf` |  |

## Enum: file_kind

`file_kind`

| Stored Value | Identifier | M8 Label | Description |
| --- | --- | --- | --- |
| `0x00` | `song` | Song |  |
| `0x10` | `instrument` | Instrument |  |
| `0x20` | `theme` | Theme |  |
| `0x30` | `scale` | Scale |  |
