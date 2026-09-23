# 6.5.x Schema Review

Review of the 6.5.x schema organization and remaining ownership changes. The
[M8 6.5.2 manual](https://cdn.shopify.com/s/files/1/0455/0485/6229/files/m8_operation_manual_v20260421.pdf?v=1776791699)
provides the user-facing grouping; fixtures establish stored offsets, sizes,
and applicability. The schema sequence describes raw storage order, while
reusable schema types and the documented object model should follow verified
M8 concepts.

Conventions for the schema refactor:

- Kaitai 0.11 requires snake_case field and type identifiers. Use snake_case
  in schemas and schema-facing documentation. Generated bindings may apply
  language-specific naming conventions, but those do not rename schema fields.
- Represent repeated fixed-count values as arrays (`fx[0..2]`,
  `tracks[0..7]`, and similar), preserving storage order. Document that array
  index zero corresponds to the M8 UI's first slot or Track 1.
- Share a raw Kaitai type when the byte layout is the same. Keep contextual
  limits on valid values and UI labels separate; an instrument-specific enum
  must not imply a different modulation slot layout.

## Instrument Mapping

Offsets below are absolute offsets in standalone `.m8i` files. In Songs, the
same 215-byte Instrument record starts at `0x13a3e + 215 * index`, without the
standalone 14-byte header. See [Instrument](INSTRUMENT.md) for field-level
layouts and [Song](SONG.md) for embedded record boundaries.

| Manual concept | Verified storage and evidence | Applicability / exception | Proposed owner |
| --- | --- | --- | --- |
| General Instrument Settings: type, name, transpose, table TIC, EQ | `0x0e..0x1c` contiguous prefix plus `0x4c` EQ; `*_DEFAULT.m8i` and `*_PARAMS.m8i` | Same field offsets for every instrument type; NONE does not expose all settings for editing | `general_instrument_settings` type for the prefix; EQ assignment remains separate in storage and references a Song bank |
| Instrument-specific parameters | Type-dependent region within `0x1d..0x4b`; `*_PARAMS.m8i` | Distinct layouts; Sampler's `0x1f` meaning depends on play mode | Per-type parameter structures |
| Multi-mode Filter Parameters | Three-byte `filter` group, present at type-dependent offsets; `*_PARAMS.m8i` | Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, External; WAV-only filter labels remain contextual; MIDI Out and NONE do not expose this group | Shared filter structure, contextual enum labels |
| Amplifier Settings | Three-byte `amp` group immediately after filter; `*_PARAMS.m8i` | Same six types; MIDI Out and NONE do not expose it | Shared amplifier structure |
| Mixer Parameters | Four-byte `mixer` group immediately after amp; `*_PARAMS.m8i` | Same six types; MIDI Out and NONE do not expose it | Shared instrument mixer structure; distinct from Song mixer |
| Common Modulation Settings | Four six-byte slots at `0x4d..0x64`; `*_MODS_A/B.m8i` | Verified for seven editable types, including MIDI Out; NONE's corresponding bytes remain unclassified | Shared modulation block and slot |
| Modulation type parameters | Four bytes per slot after packed type/destination and amount; `*_MODS_A/B.m8i` | Six distinct type-dependent layouts | Modulation-type structures |
| Modulation destination labels | Low nibble of each slot's first byte; `*_MODS_A/B.m8i` | Values are instrument-specific; do not use one universal destination enum | Contextual label tables |
| Instrument-specific tail | `0x65..0xe4`; Sampler path and Hypersynth chord fixtures | Sampler path and Hypersynth chords verified; other bytes preserved, not declared unused | Per-type tail structures |
| Instrument Table | 16 eight-byte rows at `0xe5..0x164`; `*_TABLE.m8i` | All types, including NONE; in Songs, Tables occupy a separate 256-entry array | Shared table and row structures |

The common filter, amplifier, and instrument mixer structures already exist in
`instrument.ksy`. The main work here is file ownership and clearer
documentation, not rediscovering those bytes. Exact type-dependent offsets and
evidence distinctions remain in [Instrument](INSTRUMENT.md).

## Cross-File Mapping

| Concept | Verified layout | Current duplication / boundary | Proposed treatment |
| --- | --- | --- | --- |
| Instrument record | 215 bytes | Song already imports `instrument_data` | Keep import; test standalone and embedded decoding |
| Instrument Table | 128 bytes | Song already imports `instrument_table` | Keep import; retain different placement and table counts |
| FX slot | Command byte followed by argument byte | Both locations now import `common/fx_slot.ksy` with raw `command` and `value` bytes | Keep command labels contextual |
| FX command labels | Shared Sequencer and Mixer/Effects families plus instrument-specific commands | Phrase command enum and seven instrument table enums are maintained separately | Establish a canonical context-aware command catalog before generating labels/docs; do not flatten collisions |
| Scale body | 46 bytes | Song now imports the standalone `scale_4_0_1` body | Keep one body definition and verify both placements |
| EQ settings | Three adjacent six-byte bands, 18 bytes | Song already reuses `eq_settings` for 128 Instrument banks and four effect/master EQs | Keep shared type; document bank selection separately |
| Fixed strings | Fixed byte ranges with field-specific length and observed terminator/fill behavior | Names and paths have different sizes and padding evidence | Keep sizes and raw bytes explicit; share documentation rules, not one parser prematurely |
| Header | 14 bytes | Already imported by the 6.5.x entry schema | Keep shared header; add version-dispatch validation separately |

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
        parameters.ksy         # per-type params; filter, amp, mixer structures
        modulation.ksy         # slot and type-dependent parameter structures
        table.ksy              # table and row structures
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

## Migration Order And Checks

1. Done: add parsed-field assertions for representative standalone Instrument
   and Song fixtures, including shared FX slots, Song rows, embedded Scales,
   and modulation slots. The suite also checks fixture byte differences and
   compiles Kaitai; it does not yet validate Markdown layout tables against
   the schema.
2. Pilot `instrument/modulation.ksy`: move the four-slot and six modulation
   parameter layouts without renaming fields or changing their parsed values.
   Verify both modulation fixtures for every supported instrument type.
3. Move instrument parameters and table layouts only after the pilot confirms
   import behavior and generated parser shape. Keep type-specific exceptions
   visible in `instrument.ksy`.
4. Done: share the raw FX slot and imported Scale body, covered by standalone
   and Song fixtures. The raw FX argument is named `value`; the Instrument
   Table UI may call it an amount.
5. Split Song by storage ownership, preserving its existing entry type and
   ordering. Then build schema-derived layout and enum checks for the Markdown
   references, leaving evidence and interpretation as authored prose.

No schema or documentation should mark preserved bytes as unused merely because
all current fixtures leave them unchanged.
