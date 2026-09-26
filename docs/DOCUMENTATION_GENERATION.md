# Documentation Generation

## Layout

Generated references mirror `schemas/` directly: every reachable `.ksy` has
a corresponding `.md` under `docs/`. Start with [6.5.x](6.5.x.md), which records
firmware provenance, links to the four file schemas, and shows absolute file
offsets. Component pages under `common/` and `file-versions/` use relative
record offsets. Type, enum, import, and source links follow schema ownership.
Shared component pages are generated once, independent of firmware provenance;
their schema descriptions may still cite firmware-specific research evidence.

Design, workflow, and research documents stay directly under `docs/`.
The `RESEARCH_*.md` files retain the prior hand-written references as historical
6.5.x evidence and interpretation. Their tables are snapshots, not maintained
schema definitions; use generated references for current structural facts.
`SCHEMA_REVIEW.md` has been removed; its completed review is not a maintained
project artifact.

## Generation

Run `npm run docs:generate` for all registered targets, or
`npm run docs:generate -- --firmware 6.5.x` for one. `npm run docs:check` verifies
every output without writing. `npm run verify` additionally checks generated
cross-links, generation tests, and the existing fixture suite.

All reference pages are generated in full, including nested types, repeated
fields, switch cases, enum values and original labels, schema descriptions,
validation/storage attributes, and calculated instances. Edit Kaitai to change
these facts, then regenerate. Do not edit generated Markdown.

Unknown lengths stay variable. In particular, Song's `size-eos` remainder is
not converted to a fixed size just because current fixtures have a fixed length.
Null-terminated strings keep their dynamic inner positions while their outer
fixed-capacity fields retain schema-defined sizes. Instances with value
expressions consume no storage. No new storage semantics are inferred during
documentation generation.

`tools/doc-targets.json` contains the entry schema, exact
verified firmware, and research links. It does not duplicate component version
dispatch, fields, or enum catalogs. All selected targets render before writes
begin. Conflicting content for a shared output fails instead of overwriting it.
An unknown target fails rather than silently using the latest schema.
Full checks detect obsolete component pages without deleting them. Developer
documents at the top level are not treated as generated outputs.

## Adding 6.6.x

1. Collect fixtures under `fixtures/6.6.x/` with exact firmware provenance.
   Inspect file-header versions separately from firmware versions.
2. Add `schemas/6.6.x.ksy`, importing unchanged components where verified.
   New file-header versions get new `file-versions/<version>/` components.
3. If storage or enum meanings change without a header-version change, retain
   the earlier schema and add a variant beneath
   `file-versions/<header-version>/firmware/<firmware-range>/`. The entry schema
   selects the variant. Do not silently modify the older shared definition.
4. Register the entry schema and verified release. Generation creates
   `docs/6.6.x.md`; unchanged imports link to the existing shared documentation.
   Changed components receive pages matching their new schema paths. Generate
   and check all targets together to verify shared output consistency.
5. Extend header inspection, compiler selection, and parsed-fixture tests for
   the new firmware. Those fixture tools currently target 6.5.x; generated docs
   alone do not establish firmware support. Run both fixture suites before
   claiming compatibility.

Patch/letter releases normally refresh fixtures and provenance within a line.
If evidence shows incompatible layouts inside one line, introduce explicit
compatibility targets and extend selection rather than claiming one schema
covers both. Matching header versions alone do not prove unchanged semantics.
