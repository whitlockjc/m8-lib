# AGENTS.md

Guidance for AI agents working in this workspace.

## Workspace Purpose

This workspace exists to make durable, language-agnostic M8 file tooling
possible.

Major intentions:

- Research M8 file structures.
- Document M8 file structures in a durable schema format.
- Generate human-readable file-structure documentation from the schema format
  so there is not a second source of truth.
- Use a schema format that is both human-readable and computer-parseable.
- Enable language-specific implementations to use the schemas for low-level
  readers, writers, and validation. Generating or maintaining those
  implementations is optional and not yet a settled responsibility of this
  repository.

## Source Of Truth

Prefer evidence in this order:

1. M8 files generated from a known firmware version.
2. Screenshots showing the exact M8 UI state for those files.
3. Official Dirtywave manuals and changelogs.
4. Inferences made from byte diffs or behavior.

When documenting a fact, distinguish observed evidence from interpretation.
Unknown or unverified details should stay explicit.

## Reference Material

The existing `m8-js` GitHub repository
<https://github.com/whitlockjc/m8-js> can be used as reference material for
prior discoveries, known offsets, fixture examples, and API experiments.

Do not treat `m8-js` as authoritative. Any information taken from it should be
validated against firmware-versioned fixtures before it becomes schema
documentation.

## Working Principles

- Prefer byte evidence over assumptions.
- Keep schemas language-agnostic.
- Keep generated language bindings separate from canonical schema definitions.
- Preserve the difference between observed facts, inferred meaning, open
  questions, and proposed API design.
- Document unknown, reserved, and unverified byte ranges instead of hiding them.
- Favor small, reviewable changes.
- Avoid designing ergonomic language APIs before the low-level schema model is
  understood.

## Research Workflow

M8 file schemas are not publicly documented. Research should be fixture-driven.
All research artifacts must be associated with the M8 firmware version that
created or displayed them.

For each M8 file type, UI page, and meaningful setting:

1. Record the M8 firmware version.
2. Create a baseline M8 file.
3. Capture a screenshot of the relevant baseline M8 screen.
4. Create a modified M8 file with one deliberate change where practical.
5. Capture a screenshot of the modified M8 screen.
6. Diff the binary files.
7. Record changed byte ranges.
8. Map byte ranges to UI-visible fields when evidence supports it.
9. Mark unproven interpretations as inferred.

Avoid broad fixture changes when a single-field change is possible.

## Artifact Layout

Use these top-level directories as the project grows:

- `docs/`: design notes, research notes, generated human-readable schema
  documentation, and process documentation. Use version names or version ranges
  in document names or contents when a note is version-specific.
- `schemas/`: canonical language-agnostic schemas. Organize schemas by M8
  `{MAJOR}.{MINOR}.x` version range, then by file type. Use a more specific
  patch or letter version only when fixture evidence proves the patch changes
  stored file structure.
- `fixtures/`: version-specific sample M8 files, screenshots, and fixture
  metadata.
- `tools/`: research, diffing, validation, and code-generation tooling.

Only create a directory when there is concrete content for it.

Suggested schema layout:

```txt
schemas/
  6.6.x.ksy
  common/
    file_header.ksy
  versions/
    6.6.x/
      instrument.ksy
      scale.ksy
      song.ksy
      theme.ksy
```

Suggested fixture layout:

```txt
fixtures/
  6.6.x/
    fixture-set.yaml
    instruments/
      baseline/
      changes/
      screenshots/
    scales/
      baseline/
      changes/
      screenshots/
    songs/
      baseline/
      changes/
      screenshots/
    themes/
      baseline/
      changes/
      screenshots/
```

Use fixture metadata to connect binary files, screenshots, firmware versions,
UI locations, and intentional changes.

Fixture directories should use the schema range, such as `6.6.x`. Fixture
metadata must record the exact M8 firmware patch or letter release used to
create or last refresh the files, such as `6.6.2A`.

## Schema Documentation

Every byte range should eventually be classified as one of:

- `field`: known stored data with documented meaning.
- `reserved`: known unused or stable bytes.
- `unknown`: bytes whose purpose is not known.
- `padding`: alignment or fill bytes.
- `derived`: stored data derived from another field.
- `versioned`: data whose layout or meaning depends on M8 version.

Schema documentation should include enough evidence references for another
agent or maintainer to reproduce the conclusion.

## Generated Code

Generated language bindings should not become the canonical source of truth.
Schemas and fixture evidence are canonical.

Language-specific implementations should live outside this repository unless the
user decides otherwise. For example, this repository can remain `m8-lib`, while
generated or hand-polished bindings may live in repositories such as `m8-go` or
`m8-js`.

If generated files are ever committed here, document:

- the generator command,
- the schema version or input files,
- whether generated files should be edited by hand.

## Verification

Schema work should be verified with tools and fixtures, preferably without
requiring generated language-specific libraries.

This repository should eventually provide scripts or tools that run a full
schema-verification suite.

Verification should eventually prove:

- known fixture files can be decoded by schema-level tooling,
- decoded fields match documented expectations,
- unknown regions are preserved,
- generated human-readable documentation is consistent with the canonical
  schemas,
- schema changes are validated against fixture metadata,
- write support, when added to schema-level tooling, can round-trip unchanged
  fixtures byte-for-byte.

If verification cannot be run, state why.

## Editing Rules

- Check the existing files before editing.
- Keep edits scoped to the requested task.
- Do not commit unless explicitly asked.
- Do not delete fixtures, screenshots, schemas, or research notes unless the
  user explicitly asks.
- If a change depends on an assumption, document the assumption or ask for
  clarification.

## Current Status

This project is in the planning stage. Start with `docs/DESIGN.md`.
