# Scale

Historical 6.5.x research reference, retained to preserve fixture evidence and
interpretation. Tables here are research snapshots, not the maintained schema
reference. Use the [generated firmware reference](6.5.x.md) for current
field layouts, types, and enum catalogs.


Human-readable schema reference for M8 Scale files.

## Schema

| Name | Value |
| --- | --- |
| File type | Scale |
| File extension | `.m8n` |
| M8 file schema version | `4.0.1` |
| Verified firmware range | `6.5.x` |
| Verified firmware | `6.5.2C` |
| Kaitai schema | `schemas/file-versions/4.0.1/scale.ksy` |
| Total file size | 60 bytes |
| Header size | 14 bytes |
| Body size | 46 bytes |

## Layout

Offsets are absolute file offsets.

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| M8 File Header | `0x00..0x0d` | 14 | [M8 File Header](RESEARCH_FILE_HEADER.md) |
| `enabledNotes` | `0x0e..0x0f` | 2 | [Enabled Notes](#enabled-notes) |
| `intervals` | `0x10..0x27` | 24 | [Interval](#interval) `[12]` |
| `name` | `0x28..0x37` | 16 | [Fixed String](#fixed-string) |
| `tuningOffset` | `0x38..0x3b` | 4 | `f4` |

### Enabled Notes

`enabledNotes` is a 16-bit little-endian bitmask. Bits 0 through 11 correspond
to the 12 scale intervals. A set bit means the interval is enabled.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `enabledNotes` | `+0x00..+0x01` | 2 | `u2le` |

### Interval

Offsets are relative to the start of each `Interval`.

| Name | Relative Offset | Size | Type |
| --- | --- | ---: | --- |
| `offset` | `+0x00..+0x01` | 2 | `i2le` |

`offset` is stored as hundredths of a semitone. For example, the UI value
`23.99` is stored as `2399`, and `-20.19` is stored as `-2019`.

### Fixed String

The scale name is stored in a fixed 16-byte range. The visible string may use
only part of the range, and padding bytes must be preserved.

The verified fixtures show different padding bytes:

| Fixture | Stored Value |
| --- | --- |
| `CHROMATIC_DEFAULT.m8n` | `CHROMATIC` followed by seven `0xff` bytes |
| `MODIFIED.m8n` | `MODIFIED` followed by eight `0x00` bytes |

### Tuning Offset

The Scale Editor tuning value is stored in the Scale file. The verified fixture
changed the UI value from `440.00` to `439.97`; the stored value changed from
`0.0` to approximately `-0.03` as a 32-bit little-endian float.

The storage location and type are verified:

| Name | Offset / Range | Size | Type |
| --- | --- | ---: | --- |
| `tuningOffset` | `0x38..0x3b` | 4 | `f4` |

Processing observations from the M8 UI:

| Name | Value |
| --- | --- |
| Default UI value | `440.00` |
| Minimum UI value | `420.00` |
| Maximum UI value | `460.00` |
| Stored default value | `0.0` |

The stored value appears to be an offset from `440.00` Hz, the standard A440
tuning reference, not the absolute tuning value.

### Scale Key

The Scale Editor key is displayed on the Scale Editor UI screen, but it is not
stored in standalone Scale files. In Song files, the Project Scale selector and
Scale View key are represented by the Project settings byte at `0x00bb`. The
high nibble stores the key index, and the low nibble stores the embedded Scale
index.

The `SCALES.m8s` fixture changed the key from `C` to `E` and changed that byte
from `0x00` to `0x40`. The `KEY_ONLY.m8s` fixture changed only the key from
`C` to `G` and changed that byte from `0x00` to `0x70`.

The key labels are:

| Key Value | Label |
| --- | --- |
| `0x0` | `C` |
| `0x1` | `C#` |
| `0x2` | `D` |
| `0x3` | `D#` |
| `0x4` | `E` |
| `0x5` | `F` |
| `0x6` | `F#` |
| `0x7` | `G` |
| `0x8` | `G#` |
| `0x9` | `A` |
| `0xa` | `A#` |
| `0xb` | `B` |

The key is stored in the high nibble of the Song byte in the observed fixtures.
`E` stores key value `0x4`, and `G` stores key value `0x7`, matching chromatic
label order. Project page Scale selection is represented by the low nibble of
the same Song byte and is not stored in standalone Scale files.

The M8 UI presents key and scale together, but they are separate stored
concepts: key is a key index, Project Scale selection is a scale index into the
Song's embedded scales, and each embedded scale is a Scale schema body record.

## Notes

- Scale key is displayed on the Scale Editor UI screen but is stored in the
  Song, not in the Scale file. See [Scale Key](#scale-key).
- Project Scale selection is also shown alongside Scale editing, but it is a
  separate Song value: an index into the Song's embedded Scale records.
- Scale tuning is displayed on the Scale Editor UI screen and stored in the
  Scale file as `tuningOffset`.
- Scale strings use fixed-size storage. Padding bytes are part of the stored
  value and should be preserved.

## Evidence

| Name | Path |
| --- | --- |
| Baseline fixture | `fixtures/6.5.x/scales/CHROMATIC_DEFAULT.m8n` |
| Modified fixture | `fixtures/6.5.x/scales/MODIFIED.m8n` |
| Manifest | `fixtures/6.5.x/scales/MODIFIED.yaml` |
| Verification command | `npm run verify` |

The manifest-driven mapper matched all 45 changed body bytes exactly and
reported zero unaccounted changed bytes.
