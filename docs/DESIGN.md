# m8-lib Design

This document is the starting point for a fresh, language-agnostic approach to
Dirtywave M8 file schemas.

This is a rough draft. It is expected to change as fixture-based research
reveals how M8 files are actually structured.

## Goal

Create canonical M8 file schemas that are human-readable,
computer-parseable, and suitable for verification tooling.

The project should support:

- researching M8 file structures,
- documenting observed binary schemas,
- tracking version-specific changes,
- generating human-readable documentation from canonical schemas,
- validating schemas against firmware-versioned fixtures,
- enabling language-specific implementations to use the schemas for low-level
  readers, writers, and validation.

## Non-Goals For The Initial Phase

- Reimplementing the old <https://github.com/whitlockjc/m8-js> API.
- Designing ergonomic user APIs before the schema model is understood.
- Supporting old M8 versions before the current file formats are understood.
- Guessing schema details without fixture evidence.

## File Types

M8 currently has four top-level file types:

- Instruments
- Scales
- Songs
- Themes

The schema system should represent each file type independently while sharing
common primitives where appropriate.

## Schema Format

Use Kaitai Struct (`.ksy`) as the canonical schema format for now.

Kaitai is a good fit for the raw M8 file structures because it is
human-readable, computer-parseable, open source, binary-oriented, and supports
reusable imported types. This project does not currently require Kaitai to
generate production readers or writers for language-specific implementations.
Kaitai-generated parsers may still be useful for schema verification tools.

Kaitai schemas should describe the physical binary layout of M8 files. Fixture
metadata, screenshots, research notes, confidence levels, and broader design
discussion should live beside the schemas in `fixtures/` and `docs/`, not inside
Kaitai files.

Use one top-level Kaitai entry schema per verified M8 firmware version or
version range. The entry schema should read the common M8 file header, identify
the file kind, and dispatch to the appropriate file body schema.

Top-level entry schemas live directly under `schemas/`:

```txt
schemas/
  6.6.2A.ksy
```

Shared schemas that are stable across versions live under `schemas/common/`:

```txt
schemas/
  common/
    file_header.ksy
```

Version-specific component schemas live under
`schemas/versions/<version-or-range>/`:

```txt
schemas/
  versions/
    6.6.2A/
      instrument.ksy
      scale.ksy
      song.ksy
      theme.ksy
```

The top-level entry schema imports shared common schemas and version-specific
component schemas. This provides one obvious schema file for tools to use while
keeping large file-type definitions focused and reviewable.

Use exact firmware versions until fixture evidence proves that a schema applies
to a broader version range. For example, start with `6.6.2A`; promote to
`6.6.x` only when fixtures show the relevant structures are stable across that
range.

Version/range and latest aliases may be added as thin entry schemas:

```txt
schemas/
  LATEST.ksy
  6.6.x.ksy
  6.6.2A.ksy
```

Exact firmware schemas are canonical because they can be tied directly to
fixtures. Alias schemas should only point at a specific exact schema or a proven
version range. They should not hide uncertainty.

Use Dirtywave's firmware label in filenames and directories when practical, such
as `6.6.2A`. Kaitai `meta.id` values can use normalized identifiers where
needed, such as `file_6_6_2a`.

## Version Strategy

M8 schema changes usually become the new norm until a later firmware release
changes the same structure again. Model this with exact schemas first, then
promote exact schemas into ranges only after fixture evidence supports the
range.

Changelog entries help identify likely schema boundaries but do not prove binary
layout by themselves. Treat these as research targets:

- Major releases have often introduced likely schema changes.
- Minor releases can introduce likely schema changes.
- Patch and letter releases are often fixes, but can still affect saved files
  and must not be assumed schema-equivalent without fixtures.

Examples of likely schema boundaries from the changelog:

- `3.0.0`: added Hypersynth and External instruments and replaced envelopes/LFOs
  with configurable modulation slots.
- `3.1.0`: added MIDIOUT `PIT` and `VOL` FX commands.
- `3.2.0`: increased Sampler slice support to 128 markers and added modulation
  of modulators.
- `4.0.0`: added EQ structures, changed Wavsynth shapes, added scale tuning,
  and added several FX commands.
- `5.0.0`: saved EQ settings with instruments and expanded EQ slot support.
- `6.0.0`: added theme HSV editing support and multiple new FX/settings.
- `6.2.0`: replaced Chorus with ModFX and added Reverb Shimmer.
- `6.5.0`: added `MTT` and groove PPQN.
- `6.6.0`: added ModFX Comb and Hypersynth `SHAPE`.

When a change affects stored file data, create or update the version-specific
component schema where the change first appears. Later exact schemas can reuse
that component until another fixture-proven change requires a new one.

For the first milestone, start with a shared header schema and a `6.6.2A` entry
schema. The header schema should identify the M8 file version and file type.

## Research Plan

Research should start with current M8 6.6.x files.

For each file type, collect:

- a default file,
- one or more files with isolated changes,
- screenshots of the corresponding M8 screens,
- notes explaining exactly what changed in the UI.

The first research objective is to map visible M8 UI fields to byte ranges.

The first implementation objective is to define and verify the common M8 file
header. All M8 file types share this header, and the file type byte determines
whether the body is an instrument, scale, song, or theme.

## Schema Documentation Model

Every byte range should eventually be classified as one of:

- `field`: known stored data with a documented meaning,
- `reserved`: known unused or stable bytes,
- `unknown`: bytes whose purpose is not yet known,
- `padding`: alignment or fill bytes,
- `derived`: stored data derived from another field,
- `versioned`: data whose layout or meaning depends on M8 version.

Schema documentation should distinguish:

- observed facts,
- inferred meanings,
- open questions,
- references to fixture evidence.

## Kaitai Schema Requirements

The Kaitai schemas should be able to describe:

- file header and file kind,
- version constraints,
- primitive numeric types,
- fixed-length strings,
- arrays and nested structures,
- enums and display labels,
- bit fields and packed values,
- offsets and sequential layout,
- default values,
- unknown or preserved regions,
- validation rules,
- documentation metadata supported by Kaitai.

## Language-Specific Implementations

Language-specific implementations are a possible downstream use of the schemas,
but they are not a settled responsibility of this repository.

Potential downstream outputs:

- low-level readers,
- low-level writers,
- type definitions,
- enum tables,
- fixture tests,
- schema documentation.

Idiomatic language APIs should be designed after the low-level schema
representation is stable enough to support them.

## Deferred Decisions

These decisions do not need to block the initial draft or the first header
schema milestone. They should be resolved through research and small prototypes.

- How fixture evidence should be referenced from schemas.
- How screenshots and UI labels should be organized.
- Which schema-derived verification artifacts should be committed versus rebuilt
  on demand.
