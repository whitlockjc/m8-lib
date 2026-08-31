# M8 File Header

Human-readable schema reference for the shared M8 file header.

## Schema

| Name | Value |
| --- | --- |
| Kaitai schema | `schemas/common/file_header.ksy` |
| Size | 14 bytes |
| Endianness | Little-endian |
| Applies to | Instruments, Scales, Songs, Themes |

## Layout

Offsets are relative to the start of the file.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `magic` | `0x00..0x08` | 9 | ASCII bytes |
| `reserved_0` | `0x09` | 1 | `u1` |
| `schemaVersion` | `0x0a..0x0b` | 2 | packed version |
| `reserved_1` | `0x0c` | 1 | `u1` |
| `fileKind` | `0x0d` | 1 | `FileKind` |

### Magic

| Name | Value |
| --- | --- |
| Expected bytes | `M8VERSION` |

### Schema Version

The schema version is packed into three four-bit nibbles.

| Name | Bits | Value |
| --- | --- | --- |
| `major` | `0x0f00` | `(schemaVersion >> 8) & 0x0f` |
| `minor` | `0x00f0` | `(schemaVersion >> 4) & 0x0f` |
| `patch` | `0x000f` | `schemaVersion & 0x0f` |

The encoded version appears to describe the persisted file schema version, not
necessarily the M8 firmware version used to create the file.

### FileKind

| Name | Value |
| --- | --- |
| `song` | `0x00` |
| `instrument` | `0x10` |
| `theme` | `0x20` |
| `scale` | `0x30` |
