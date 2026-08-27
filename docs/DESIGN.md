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

Schema organization is not final. Two viable options are:

- Use one Kaitai schema per M8 file type and version/range:

  ```txt
  schemas/
    6.6.x/
      instrument.ksy
      scale.ksy
      song.ksy
      theme.ksy
  ```

- Or use one top-level Kaitai schema per version/range that reads the common M8
  header and switches to the correct body schema by file kind:

  ```txt
  schemas/
    6.6.x/
      m8_file.ksy
      instrument.ksy
      scale.ksy
      song.ksy
      theme.ksy
  ```

The second approach may be useful because all M8 files share a common header and
file-kind byte. The first approach may be simpler when researching one file type
at a time. The decision should be made after a small Kaitai prototype covers the
header and at least two file types.

For the first milestone, start with a shared header schema. The header schema
should identify the M8 file version and file type, and it should be reusable by
whatever file organization is chosen later.

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

- Whether Kaitai organization should be one schema per file type or one
  top-level schema per version/range with file-kind switching.
- How fixture evidence should be referenced from schemas.
- How screenshots and UI labels should be organized.
- Which schema-derived verification artifacts should be committed versus rebuilt
  on demand.
