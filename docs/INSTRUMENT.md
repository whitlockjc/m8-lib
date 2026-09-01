# Instrument

Human-readable schema reference for M8 Instrument files.

This document starts with the `NONE` instrument. Other instrument types will
replace currently unknown ranges as fixture evidence is collected.

## Schema

| Name | Value |
| --- | --- |
| File type | Instrument |
| File extension | `.m8i` |
| M8 file schema version | `6.0.1` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/6.0.1/instrument.ksy` |
| Total file size | 357 bytes |
| Header size | 14 bytes |
| Body size | 343 bytes |

## Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x00..0x0d` | 14 | [M8 File Header](FILE_HEADER.md) |
| `instrumentType` | `0x0e` | 1 | [Instrument Type](#instrument-type) |
| `name` | `0x0f..0x1a` | 12 | [Fixed String](#fixed-string) |
| `unknownBody` | `0x1b..0x164` | 330 | unknown bytes |

### Instrument Type

The instrument type is stored as one unsigned byte. The `NONE` fixture verifies
the stored value for the M8 `NONE` instrument type.

| Name | Stored Value |
| --- | --- |
| `none` | `0xff` |

Additional instrument types will be added only after fixture evidence verifies
their stored values.

### Fixed String

The instrument name is stored in a fixed 12-byte range.

The verified `NONE_DEFAULT.m8i` fixture stores `NONE_DEFAULT`, which fills all
12 bytes. Padding behavior for shorter instrument names is not yet verified.

## Unknown Ranges

| Name | Offset / Range | Size | Status |
| --- | --- | ---: | --- |
| `unknownBody` | `0x1b..0x164` | 330 | Preserved until future instrument fixtures map this region |

The `NONE` instrument cannot be meaningfully edited beyond its name, so this
single fixture is intentionally insufficient to identify shared instrument
fields, modulator regions, or type-specific parameter regions. Those bytes will
be replaced with named fields as other instrument fixtures provide evidence.

## Notes

- Standalone Instrument files and instruments embedded in Song files are
  expected to share the same in-memory representation. This should be verified
  when Song instrument regions are mapped.
- Enumerated values should document both stored representation and UI label.
  The current verified enum is `none = 0xff`.

## Evidence

| Name | Path |
| --- | --- |
| Baseline fixture | `fixtures/6.5.x/instruments/NONE_DEFAULT.m8i` |
| Verification command | `npm run verify` |

The `NONE_DEFAULT.m8i` fixture verifies the file header, instrument type byte,
and 12-byte name location. The remaining body bytes are explicitly preserved as
unknown.
