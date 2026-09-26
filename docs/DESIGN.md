# m8-lib Design

This document is the starting point for a fresh, language-agnostic approach to
Dirtywave M8 file schemas.

This is a rough draft. It is expected to change as fixture-based research
reveals how M8 files are actually structured.

Firmware-specific documentation targets and the process for adding 6.6.x are
defined in [Documentation Generation](DOCUMENTATION_GENERATION.md). Existing
6.5.x references remain stable; new targets get separate firmware entry pages
and reuse component documents according to their schema imports. Generated
Markdown mirrors the schema paths directly beneath `docs/`.

## Goal

Create canonical M8 file schemas that are human-readable, computer-parseable,
and suitable for verification tooling.

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

Some M8 UI settings may not be stored in the file type whose screen exposes
them. When fixture evidence shows that a visible setting is absent from the
expected file, track it as an open research item until it is mapped to another
file type, Project/Song data, or device/global storage outside portable M8
files.

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

Use one top-level Kaitai entry schema per verified M8 firmware
`{MAJOR}.{MINOR}.x` range. The entry schema should document the exact firmware
release it was last synchronized with, read the common M8 file header, identify
the file kind, and dispatch to the appropriate file body schema for that file's
header schema version.

Top-level entry schemas live directly under `schemas/`:

```txt
schemas/
  6.5.x.ksy
```

Shared schemas that are stable across versions live under `schemas/common/`:

```txt
schemas/
  common/
    file_header.ksy
```

File-schema-version component schemas live under
`schemas/file-versions/<file-version>/`:

```txt
schemas/
  file-versions/
    6.0.1/
      instrument.ksy
    6.5.0/
      song.ksy
    4.0.1/
      scale.ksy
    1.0.2/
      theme.ksy
```

The top-level entry schema imports shared common schemas and file-version
component schemas. This provides one obvious schema file for tools to use for a
firmware range while keeping large file-type definitions focused and
reviewable.

Patch and letter firmware releases should normally be treated as verification
events for the firmware `{MAJOR}.{MINOR}.x` entry schema, not as new entry
schema targets. When a new patch release is available, update the fixtures to
the latest patch or letter release for that minor version and run verification.
If verification passes, the same `{MAJOR}.{MINOR}.x` entry schema remains
current.

If patch-level fixture evidence proves that a patch or letter release changes
stored file structure, create a more specific schema for that release and
document why the normal `{MAJOR}.{MINOR}.x` convention was not sufficient.

Version/range and latest aliases may be added as thin entry schemas:

```txt
schemas/
  LATEST.ksy
  6.5.x.ksy
  6.6.x.ksy
```

Firmware `{MAJOR}.{MINOR}.x` entry schemas are canonical when they are backed by
fixtures from the latest available patch or letter release for that minor
version. `LATEST.ksy` may point at the latest supported firmware
`{MAJOR}.{MINOR}.x` entry schema.

Use Dirtywave's firmware label in filenames and directories when practical, such
as `6.5.x`. Kaitai `meta.id` values can use normalized identifiers where
needed, such as `file_6_5_x`.

## Version Strategy

Distinguish firmware versions from file header schema versions:

- Firmware version identifies the M8 release used to create, save, or display a
  fixture.
- File header schema version is the version encoded inside an M8 file header.
  It appears to identify the persisted schema for that file type and may be
  older than the firmware that produced the file.

M8 schema changes usually become the new norm until a later firmware release
changes the same structure again. Model firmware compatibility at the
`{MAJOR}.{MINOR}.x` level by default, but key reusable component schemas by the
file header schema version they describe.

Changelog entries help identify likely schema boundaries but do not prove binary
layout by themselves. Treat these as research targets:

- Major releases have often introduced likely schema changes.
- Minor releases can introduce likely schema changes.
- Patch and letter releases are treated as fixture refresh and verification
  events unless fixture evidence proves a stored file schema change.

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

When a change affects stored file data, create or update the component schema
for the file header schema version where the change appears. Later firmware
entry schemas can reuse that component until another fixture-proven change
requires a new one.

The initial target is `6.5.x` because it is currently practical to generate
fixtures from M8 headless. Use `6.6.x` as the first follow-on line to validate
schema reuse and version-specific overrides once suitable fixtures are
available.

For the first milestone, start with a shared header schema and a `6.5.x` entry
schema. The header schema should identify the M8 file header schema version and
file type.

## Research Plan

Research should start with current M8 6.5.x files, using the latest available
6.5 patch or letter release for fixtures.

For each file type, collect:

- a default file,
- one or more files with isolated changes,
- screenshots of the corresponding M8 screens,
- notes explaining exactly what changed in the UI.

Fixture filenames should be descriptive enough that their role can be inferred
from the schema range, file-type directory, and filename. For fixture files
representing a named resource, prefer `{TYPE}_{PURPOSE}` names, such as
`NONE_DEFAULT.m8i` or `CHROMATIC_DEFAULT.m8n`. Add separate fixture metadata
only when filenames and directory structure are not enough to document
relationships, exact firmware provenance, UI location, or intentional changes.
Fixture metadata should let tools discover offsets from byte evidence by
default. Explicit offset hints are acceptable when duplicate byte transitions
make a field ambiguous and another fixture or schema finding already
disambiguates the location.
Fixture metadata may also identify ignored ranges when bytes change for reasons
that are outside the fixture's intentional UI changes. Ignored ranges must be
documented as preserved unknown/state bytes and tracked for later research, not
treated as known fields.

The first research objective is to map visible M8 UI fields to byte ranges.

The first implementation objective is to define and verify the common M8 file
header. All M8 file types share this header, and the file type byte determines
whether the body is an instrument, scale, song, or theme.

Research should proceed file type by file type until the 6.5.x portable file
set is structurally mapped. Instrument is considered structurally complete for
the current fixture evidence: remaining FX command-family coverage and semantic
classification of preserved bytes should not block Song research.

M8 strings should be modeled as fixed-size byte ranges. The UI-visible text may
use only part of the range. Padding bytes and maximum stored length should be
documented from fixture evidence for each string field.

Enumerated fields should document the stored byte value and the UI label. The
stored value must come from fixture evidence before it is treated as schema
truth. UI labels can come from official Dirtywave documentation or fixture UI
evidence, and should be kept separate from the byte-level storage claim.
Kaitai enums should use verbose enum entries with `id` for the Kaitai-safe
identifier and `-label` for the raw M8 UI label.

Research findings that are not yet schema fields should be tracked in
`docs/RESEARCH_BACKLOG.md`. This includes settings observed in the UI but not
found in the expected file type.

Known finding:

- Theme RGB/HSV editing mode is not stored in any M8 file. Theme files should
  be modeled as color triples plus any other fixture-proven fields; editing
  mode is outside the file schemas.

## Post-Song Schema Review

Defer broad schema reorganization until after the Song file is structurally
mapped. Song is expected to expose the final reuse boundaries because it embeds
or references many structures that also appear in standalone files.

The manual-aligned schema split is implemented. The generated
[6.5.x reference](6.5.x.md) follows those reusable component boundaries.

After Song research, review the schemas and documentation for shared components:

- Instrument body and embedded Song instrument storage,
- instrument table row and FX slot storage,
- phrase row and FX slot storage,
- FX command-family metadata,
- fixed strings,
- scale/key references,
- EQ structures,
- mixer/effects structures,
- preserved unknown/reserved byte regions.

Only promote a component to a shared schema when fixture evidence shows a real
common binary layout. Until then, prefer local duplication over premature
abstraction that might hide context-specific behavior.

## Schema Documentation Model

Every byte range should eventually be classified as one of:

- `field`: known stored data with a documented meaning,
- `state`: persisted UI or editor state,
- `cache`: duplicated stored data that should match another field,
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

Working observation:

- M8 files appear to be memory dumps that can mix durable data definitions with
  persisted UI/editor state and cached duplicate data. Do not assume every
  stored byte is primary resource data.
- Example: Hypersynth stores a persistent 16-entry chord table, but also stores
  the current/edit chord in the parameter region. The current/edit chord should
  match the corresponding chord table entry, but both byte ranges exist in the
  file and should be represented by the raw schema.
- Example: historical reference material names some early instrument bytes as
  volume, pitch, and fine tune, but current fixture evidence is not sufficient
  to classify those bytes. Preserve them as unknown until targeted fixtures
  prove whether they are musical data, UI/editor state, cached values, or
  instrument-specific storage.

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
