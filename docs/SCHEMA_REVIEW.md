# 6.5.x Schema Review

Review of the 6.5.x schema organization and remaining ownership changes. The
[M8 6.5.2 manual](https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699)
provides the user-facing grouping; fixtures establish stored offsets, sizes,
and applicability. The schema sequence describes raw storage order, while
reusable schema types and the documented object model should follow verified
M8 concepts.

## Instrument Concepts

Offsets below are absolute offsets in standalone `.m8i` files. In Songs, the
same 215-byte Instrument record starts at `0x13a3e + 215 * index`, without the
standalone 14-byte header. See [Instrument](INSTRUMENT.md) for field-level
layouts and [Song](SONG.md) for embedded record boundaries.

### General Instrument Settings

| Item | Verified storage | Proposal | Status |
| --- | --- | --- | --- |
| `type`, `name`, `transpose`, `table_tic` | Contiguous `0x0e..0x1c`; same offsets for every type | Group as `general_settings` of type `general_instrument_settings`. Use `type` for the field and `instrument_type` for its enum. | Done |
| `eq` | `0x4c`; assignment to a separate Song EQ bank | Keep in raw storage order after `body_before_eq`; document it with General Instrument Settings without relocating or duplicating its byte. | Done |
| Applicability | NONE stores the same prefix but does not expose every setting for editing | Distinguish stored fields from UI editability. | Done |

Evidence: `*_DEFAULT.m8i`, `*_PARAMS.m8i`, and [Instrument](INSTRUMENT.md#general-instrument-settings).

### Instrument-Specific Parameters

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Wavsynth, Macrosynth, FM Synth | Distinct `*_params` types at type-dependent offsets within `0x1d..0x4b` | Keep distinct types and field names; their layouts and meanings differ. | Done |
| Sampler configuration | Seven control bytes at `0x1f..0x25`; `sample_path` occupies `0x65..0xe4` | Treat `sampler_controls` and `sample_path` together as Sampler's instrument-specific configuration, while preserving both physical locations. One raw `mode_value` means detune, steps, or BPM according to `play_mode`. The manual requires a path under 128 characters; `SAM_PARAMS.m8i` shows 17 ASCII bytes, a null terminator, and 110 zero bytes. | Done |
| MIDI Out and External | Distinct parameter layouts; custom CC entries are each `cc` followed by `value` | Keep distinct parameter layouts and counts; reuse one `custom_cc` entry type for both. | Done |
| Hypersynth | `current_chord` in `hypersynth_params`; persistent 16-chord table in the tail | Keep both locations distinct. Document the observed relationship without treating them as one stored field. | Done |
| NONE | `0x1d..0x4b` is preserved without editable parameters | Keep bytes explicit and unclassified; do not invent a NONE parameter model. | Done |

Evidence: `*_PARAMS.m8i`, the [M8 manual](https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699), and [Instrument](INSTRUMENT.md#instrument-specific-parameters). Near-limit and non-ASCII sample paths are untested; none of these changes alters offsets, byte order, or enum values.

### Multi-Mode Filter Parameters

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Filter group | Three adjacent bytes at type-dependent offsets for Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External | Keep shared `filter_params` with `type`, `cutoff`, and `resonance`; verify each placement with parsed fixtures. | Done |
| Filter labels | Wavsynth has additional WAV-only modes | Keep `type` raw and `filter_type` as a label catalog; `0x08..0x0b` apply only to Wavsynth. | Done |
| MIDI Out and NONE | UI does not expose this group | Preserve their bytes without assigning editable filter semantics. | Done |

Evidence: `*_PARAMS.m8i` and [Instrument](INSTRUMENT.md#multi-mode-filter-parameters).

### Amplifier Settings

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Amplifier group | Three adjacent bytes immediately after the filter for the same six editable types | Keep shared `amp_params` (`amp`, `limit`, `pan`) at each type-dependent offset; verify every placement with parsed fixtures. | Done |
| MIDI Out and NONE | UI does not expose amplifier settings | Preserve their bytes without asserting amplifier semantics. | Done |

Evidence: `*_PARAMS.m8i` and [Instrument](INSTRUMENT.md#amplifier-settings).

### Mixer Parameters

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Instrument mixer | Four adjacent bytes immediately after the amplifier for the same six editable types | Keep shared `mixer_params` (`dry`, `mod_fx`, `delay`, `reverb`) at each type-dependent offset and verify every placement. Distinguish it from the Song's master Mixer. | Done |
| MIDI Out and NONE | UI does not expose instrument mixer settings | Preserve their bytes without asserting mixer semantics. | Done |

Evidence: `*_PARAMS.m8i` and [Instrument](INSTRUMENT.md#mixer-parameters).

### Common Modulation Settings

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Modulation block | Four six-byte slots at `0x4d..0x64`, verified for seven editable types including MIDI Out | Keep shared `instrument_modulators` and `modulation_slot` types; `slots[0]` is the M8's first modulation slot. | Done |
| NONE | Corresponding bytes remain unclassified | Preserve them without assigning editable modulation semantics. | Done |

Evidence: `*_MODS_A.m8i`, `*_MODS_B.m8i`, and [Instrument](INSTRUMENT.md#instrument-modulation).

The shared slot, six payload layouts, and their general enums now live in
`schemas/file-versions/6.0.1/instrument/modulation.ksy`. Instrument-specific
destination label catalogs remain in `instrument.ksy`. This source split does
not change the stored layout or parsed field values.

### Modulation Type Parameters

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Slot payload | Four bytes after packed type/destination and amount; interpretation depends on one of six modulation types | Keep six type-dependent payload layouts within the shared slot. Verify all six against A/B fixtures for all seven editable instrument types. | Done |
| Type-specific names | A byte may represent different controls for different modulation types | Name fields only within the selected payload type. Preserve unproven fourth bytes as `unknown`, not `unused`. | Done |

Evidence: `*_MODS_A.m8i`, `*_MODS_B.m8i`, and [Instrument](INSTRUMENT.md#modulation-parameters).

### Modulation Destination Labels

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Destination | Low nibble of each slot's first byte | Keep one raw `destination` in shared `modulation_slot`; interpret it using `general_settings.type`. | Done |
| Valid labels | Depend on instrument type; the same value can name different controls | Keep seven contextual enum catalogs without creating separate slot layouts. Verify `MOD AMT` through `MOD BINV` mappings in each A/B fixture. Other numeric label mappings remain unverified by individual fixtures. | Done |

Evidence: `*_MODS_A.m8i` and `*_MODS_B.m8i` verify selected high values;
the [M8 6.5.2 manual](https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699)
defines DEST as the parameter being modulated but does not enumerate every
instrument-specific numeric mapping. See [Instrument](INSTRUMENT.md#enums) for
the contextual catalogs and per-fixture evidence boundaries.

### Instrument-Specific Tail

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Tail region | `0x4d..0xe4`; editable types have modulators at `0x4d..0x64` | Keep type-dependent tail selection in the instrument record. Verify each fixture's parsed tail and the Table boundary at `0xe5`. | Done |
| Sampler and Hypersynth | Sample path at `0x65..0xe4`; 16 seven-byte chords at `0x65..0xd4` | Keep their distinct tail structures; keep Hypersynth's persistent chords separate from `current_chord`. Verify first and last chord values. | Done |
| Other regions | Unknown bytes are unchanged within each type's available fixtures; MIDI Out and External share a chord-like default pattern | Preserve unknown bytes without assigning chord semantics or calling them unused or reserved. | Done |

Evidence: all 6.5.x instrument fixtures, parsed-fixture tail checks, and [Instrument](INSTRUMENT.md#tail). A stable pattern does not prove a field's meaning. Sampler's fixed 128-byte path uses the same null-terminated, trailing-byte-preserving representation as the Song directory.

The [M8 6.5.2 manual](https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699) describes no additional editable Instrument View parameter beyond the mapped general, type-specific, modulation, filter, amplifier, and mixer settings. Its Sample Editor section places loop points and slice markers in the WAV file. Historical [m8-js parsing](https://github.com/whitlockjc/m8-js/blob/main/index.js) treats the Sampler path as 127 string bytes plus one skipped byte in a 128-byte field and skips that field for other instrument types; this agrees with the field boundary, but does not establish meanings for their preserved bytes.

### Instrument Table

| Item | Verified storage | Agreed treatment | Status |
| --- | --- | --- | --- |
| Standalone table | Sixteen eight-byte rows at `0xe5..0x164`; available for all types, including NONE | Keep shared table and row types. The three FX slots use the shared raw `fx_slot` type. Verify every parsed row in each standalone fixture. | Done |
| Song placement | Song has a separate 256-entry Table array; the first 128 correspond to Instruments | Reuse the row/table layout, but keep Song placement and table count separate. Verify all 256 parsed tables and boundary fixture values. | Done |
| FX commands | Available labels depend on context and current instrument | Keep raw command/value storage shared; document contextual command labels separately. | Done |

Evidence: `*_TABLE.m8i`, `TABLES.m8s`, parsed-fixture checks, [Instrument](INSTRUMENT.md#instrument-table), and [FX Commands](FX_COMMANDS.md#storage). These checks establish raw layout, not universal availability of every FX command.

## Cross-File Mapping

| Concept | Verified layout | Current boundary | Agreed treatment | Status |
| --- | --- | --- | --- | --- |
| Instrument record | 215 bytes | Song imports `instrument_data` | Keep one definition; compare embedded Wavsynth and Hypersynth records to standalone defaults, accounting for the Song's unset names. | Done |
| Instrument Table | 128 bytes | Standalone Instrument and Song import `instrument/table.ksy`; Song stores 256 separately | Keep one row/table layout with file-specific placement and counts. | Done |
| FX slot | Command byte followed by argument byte | Phrase and Table import `common/fx_slot.ksy` | Keep raw storage shared; interpret command labels by context. | Done |
| FX command labels | Shared families plus instrument-specific commands | Phrase and seven instrument catalogs remain separate | Keep context-aware catalogs; avoid flattening collisions. Revisit a canonical catalog when generating labels and documentation. | Review |
| Scale body | 46 bytes | Song imports the standalone `scale_4_0_1` body | Keep one body definition; compare the default embedded Chromatic Scale to its standalone file. | Done |
| EQ settings | Three adjacent six-byte bands, 18 bytes | Song reuses `eq_settings` for 128 Instrument banks and four effect/master EQs | Keep shared type; document bank selection separately. | Done |
| Fixed strings | Field-specific length and terminator/fill behavior | Names differ; Sampler path and Song directory share a 128-byte path-field pattern | Keep raw sizes explicit and preserve post-terminator bytes. Share a type only when fixture evidence and maintenance justify it. | Done |
| Header | 14 bytes | 6.5.x entry imports one shared header | Keep the header shared; validate file-kind-specific schema versions before decoding. | Review |

## Proposed File Tree

Keep existing entry points stable so tools still compile `schemas/6.5.x.ksy`.
Imported modules below are proposed ownership boundaries, not an assertion
that every manual heading warrants its own Kaitai file.

```txt
schemas/
  6.5.x.ksy
  common/
    file_header.ksy
    fx_slot.ksy                 # shared raw two-byte layout
  file-versions/
    4.0.1/
      scale.ksy
    6.0.1/
      instrument.ksy           # standalone body entry; keeps instrument_data
      instrument/
        parameters.ksy         # done: per-type params; filter, amp, mixer structures
        modulation.ksy         # done: slot, payloads, and general modulation enums
        table.ksy              # done: table, row, and contextual command catalogs
    6.5.0/
      song.ksy                 # Song body entry and placement
      song/
        eq.ksy                 # shared EQ settings and bands within Song
        sequencing.ksy         # rows, phrases, chains, bookmarks, grooves
        project.ksy            # Project and MIDI settings
        mixer_effects.ksy      # Mixer, effects, and scope
        midi_mapping.ksy       # MIDI Mapping records
    1.0.2/
      theme.ksy
```

Do not move a type solely to shorten a file. In particular, `common/` should
hold only layouts shared by verified contexts. If future version evidence
changes one of those layouts, introduce a versioned replacement without
rewriting earlier schemas. Instrument-specific FX enums and destination labels
must stay contextual even when their raw storage is shared.

## Review Order And Checks

1. General Instrument Settings, Instrument-Specific Parameters, Multi-mode
   Filter Parameters, Amplifier Settings, Mixer Parameters, Common Modulation Settings, Modulation Type Parameters, Modulation Destination Labels, Instrument-Specific Tail, and Instrument Table are done. Continue with the cross-file mapping and schema organization review.
2. After those conceptual reviews, split large Kaitai files where a verified
   ownership boundary makes the source easier to maintain. Preserve entry
   types, field names, offsets, and parsed values. The Instrument modulation
   parameters, modulation, and table boundaries are split and fixture-verified; review other proposed
   boundaries individually.
3. Extend parsed-field assertions as each area changes. Current verification
   checks fixture byte differences, compiles Kaitai, and parses representative
   Instrument and Song fixtures; it does not yet validate Markdown tables
   against schema definitions.
4. Build schema-derived layout and enum checks for Markdown references after
   the schema organization settles. Leave evidence and interpretation as
   authored prose.

No schema or documentation should mark preserved bytes as unused merely because
all current fixtures leave them unchanged.
