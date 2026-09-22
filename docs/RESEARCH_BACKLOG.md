# Research Backlog

This document tracks observed M8 behavior that needs targeted fixture evidence
before it can become schema documentation.

## Theme Color Mode

Status: resolved; outside M8 files

Observation:

- M8 6.5.x theme files store theme color values. RGB versus HSV editing mode
  is not stored in any M8 file.

Implication:

- Theme schemas should model stored color triples without a theme-level
  `mode` field unless future evidence proves otherwise.
- RGB/HSV editing mode is outside the M8 file schemas.

No M8 file fixture is needed for this setting.

## Theme Display Name

Status: open

Observation:

- M8 6.5.x theme files with header schema version 1.0.2 contain the file header
  followed by 39 color bytes.
- The theme display name is not stored in the `.m8t` file body.

Implication:

- Theme schemas should not include a `name` field unless future fixture
  evidence proves one exists in another theme file version.
- Theme display names may come from filenames or external metadata.

Needed research:

- Confirm whether the M8 UI derives theme names from `.m8t` filenames.
- Check whether any companion metadata exists outside the portable `.m8t` file.

## Scale Key And Project Scale Selector

Status: mapped

Observation:

- The Project page Scale selector and Scale View key are represented by the
  Song byte at `0x00bb`.
- The high nibble stores the key index. Current fixtures verify `C -> E`
  as `0x00 -> 0x40` and `C -> G` as `0x00 -> 0x70`.
- The low nibble stores the Project Scale selector index. The selector value is
  a `0x00..0x0f` index into the 16 embedded Song scales.
- The M8 UI presents key and scale together, but schema work should treat their
  meanings as distinct values: key index, scale index, and embedded Scale
  definition.

Implication:

- Scale schemas should not include a `key` field.
- Song schemas should model the raw Project Scale/key byte and document the
  derived key index and scale index separately.
- Project Scale selector values should be represented as indexes into the
  embedded Song scale table.

## Song Project Unknown State

Status: open

Observation:

- The 6.5.x `PROJECT.m8s` fixture maps Project page fields at `0x008e..0x00bc`.
- The same fixture also changes bytes at `0x001b..0x008d` and
  `0x00bd..0x00be` that were not part of the intended Project page changes.

Implication:

- The Song schema preserves these regions as unknown/state bytes.
- Fixture manifests may ignore changed bytes in these ranges so intentional
  Project field mapping can be verified without inventing unsupported field
  names.

Needed research:

- Create targeted Song fixtures that isolate save/path/device state from
  Project page setting changes.
- Revisit `0x00bd..0x00be` with additional Project fixtures to determine
  whether those bytes are Project state, derived data, or unrelated save state.

## Song MIDI Settings Sync Labels

Status: partially mapped

Observation:

- The 6.5.x `MIDI_SETTING.m8s` fixture changed Sync In from `OFF` to
  `CLK+TRANSP+SPP` and Sync Out from `OFF` to `TRANSPORT+SPP`.
- The Song bytes at `0x00a0..0x00a3` changed from `00 00 00 00` to
  `01 02 00 02`.
- The verified layout stores Sync In as clock byte plus transport byte, followed
  by Sync Out as clock byte plus transport byte.

Implication:

- The Song schema can model the 4-byte sync settings block as four fields.
- Not every UI label combination has direct fixture evidence yet.

Needed research:

- Create targeted Song fixtures that change only Sync In across every UI label.
- Create targeted Song fixtures that change only Sync Out across every UI label.
- Use those fixtures to verify every clock/transport label combination.

## Song MIDI Mapping Semantic Labels

Status: raw storage mapped; semantic labels deferred

Observation:

- The 6.5.x `MIDI_MAPPING.m8s` fixture verifies a 128-record MIDI Mapping table
  at `0x1a5fe..0x1a97d`, with each record stored as 7 bytes.
- The observed populated records map to the UI labels `I:00:SIZE`,
  `M:00:MIX VOL`, `Q:MX:MID Q`, and `X:09:REV SIZE`.
- Historical <https://github.com/whitlockjc/m8-js> reference code reads each
  MIDI Mapping record as channel, control number, type, instrument/index,
  parameter, minimum value, and maximum value. Current fixture evidence
  verifies the byte order but not every UI interpretation.
- The refreshed fixture verifies the reverb/effects mapping as record `0x03`
  with channel `0x04`, control `T:Y`, minimum `0x40`, and maximum `0xfc`.
- The refreshed fixture stores the EQ mapping channel as `0x03`.

Implication:

- The Song schema can model MIDI Mapping as a fixed table of raw records. The
  table location, record count, record size, and byte order are considered
  complete for the current fixture evidence.
- Destination type labels are partially understood, including `I`, `M`, `Q`,
  and `X`, but destination index/parameter interpretation remains
  destination-specific and provisional.
- Control-number labels need more evidence beyond the verified `000`, `127`,
  `T:X`, and `T:Y` values.

Needed research:

- Create fixtures that exercise additional destination types and destination
  parameter labels after Mixer, EQ, and Effects pages are mapped.
- Decide whether generated readers should expose the raw 7-byte mapping record
  directly, or add destination-specific decoded views on top of it.

## Song Table Association

Status: structure mapped; first 128 associations documented

Observation:

- The 6.5.x `INSTRUMENTS.m8s` fixture establishes a 32768-byte region at
  `0xba3e..0x13a3d`, immediately before the embedded Instrument records.
- The region contains 256 adjacent 128-byte records, each matching the Table
  structure appended to standalone Instrument files.
- All 256 records contain default Table bytes in `INSTRUMENTS.m8s`; the later
  `TABLES.m8s` fixture distinguishes boundary Table indexes.
- The Song stores 128 Instrument records but 256 Table records.
- M8 documentation establishes that Tables `0x00..0x7f` are associated by
  matching index with Instruments `0x00..0x7f`.
- The 6.5.x `TABLES.m8s` fixture modifies the first and last rows of Tables
  `0x00` and `0xff`, verifying both storage boundaries and direct access to
  the full `0x00..0xff` Table index range.

Implication:

- The Song schema can represent this region as 256 raw Instrument Table
  records without leaving an unknown gap.
- Schemas and user-facing APIs may expose the direct relationship between the
  first 128 Tables and the 128 Instruments.
- The purpose of Tables `0x80..0xff` should remain unspecified until documented
  evidence or targeted fixtures establish their semantics.

Needed research:

- Determine the semantic role of Tables `0x80..0xff` and whether they have any
  relationship to Instruments beyond the documented first 128 associations.

## Song Mix & Limiter Scope Zoom

Status: open

Observation:

- The 6.5.x `MIX_SCOPE.m8s` fixture changed Mix & Limiter Scope zoom from
  `-30DB` to `-1DB`.
- The same fixture verifies `mix`, `limiter`, `djFilter`,
  `djFilterResonance`, `djFilterType`, `limiterAttack`, `limiterRelease`,
  `softClip`, `ott`, `ottTime`, and `ottColor`.
- The fixture also changes save/state bytes before Project settings and one
  byte in `project.unknownTrailingState`.
- The 6.5.x `LIMIT_SCOPE.m8s` fixture left zoom at its default `-30DB` value
  while changing the same Mix & Limiter Scope values. It still changed
  `project.unknownTrailingState`.
- A temporary `MS_ZOOM.m8s` fixture changed only zoom from `-30DB` to `-47DB`
  while keeping Mix & Limiter Scope controls at defaults. It changed the
  Project name, save/state bytes, and `project.unknownTrailingState`, but left
  the mapped Mixer, Mix & Limiter Scope, and Mix EQ regions identical to
  `DEFAULT.m8s`.

Implication:

- The schema should not name a `zoom` field yet. Current evidence suggests
  zoom may be global UI state rather than Song data, or otherwise stored in an
  unrelated state region that has not been identified.

Needed research:

- Check whether Mix & Limiter Scope zoom persists through files outside the Song
  format, such as System state files.
- If future evidence shows zoom is stored in Song files, create multiple
  fixtures with distinct zoom values to identify the encoding.

## Song Effects Filter Bytes

Status: open

Observation:

- The 6.5.x `EFFECTS.m8s` fixture verifies Effects Settings fields in the
  shared Effects & Scope storage region at `0x1a5c1..0x1a5da`.
- The regions `0x1a5be..0x1a5c0`, `0x1a5c5..0x1a5c9`, and
  `0x1a5cf..0x1a5d1` sit adjacent to verified Effects fields but are not
  changed by the current fixture.
- Historical <https://github.com/whitlockjc/m8-js> reference code suggests some
  adjacent bytes may store Delay or Reverb filter settings.

Implication:

- These bytes should remain preserved unknown bytes in the raw schema until
  fixture evidence verifies their meaning.
- The current Effects Settings schema should not expose Delay or Reverb filter
  fields yet.

Needed research:

- Create targeted Effects Settings fixtures if the 6.5.x UI exposes Delay or
  Reverb filter controls.
- If those controls moved, use current-version fixtures to determine whether
  these bytes are obsolete preserved state, hidden state, or renamed controls.

## Sampler Sample Path Length

Status: open

Observation:

- Sampler fixtures store `/Samples/Kick.wav` starting at `0x65`.
- The current schema reserves `0x65..0xe4` as a fixed 128-byte sample path
  range.

Implication:

- The start offset and stored path bytes are fixture-verified.
- The maximum stored path length remains provisional until a longer sample path
  fixture verifies the boundary.

Needed research:

- Create a Sampler fixture with a substantially longer sample path.
- Verify whether the path still starts at `0x65`, where it terminates or pads,
  and whether `0xe4` is the correct final byte for the fixed range.

## Instrument Preserved Bytes

Status: deferred

Observation:

- The 6.5.x Instrument schema is structurally complete for the current fixture
  set, but some preserved bytes are not semantically classified.
- Historical <https://github.com/whitlockjc/m8-js> reference material names
  some early instrument bytes as volume, pitch, and fine tune, but current
  fixture evidence is not sufficient to classify those bytes.

Implication:

- These bytes should remain represented as preserved unknown/reserved regions in
  the raw schema.
- The Instrument schema can be treated as complete for moving on to Song work,
  because byte-level fidelity does not depend on assigning semantic names to
  every preserved byte.

Needed research:

- Revisit preserved Instrument bytes only when targeted fixtures or Song
  embedding evidence can prove their meaning.

Resolved comparison:

- `INSTRUMENTS.m8s` verifies that embedded Wavsynth and Hypersynth records use
  the same 215-byte `instrumentData` structure as standalone Instrument files.
  Their only differences from the corresponding standalone defaults are the
  unset embedded names. This comparison does not assign new semantics to the
  remaining preserved bytes.

## FM Synth Common Enum Slots

Status: mapped

Observation:

- The refreshed `FM_PARAMS.m8i` fixture changes `filter.type` from `OFF`
  (`0x00`) to `ZDF HP` (`0x07`) at `0x41` and `amp.limit` from `CLIP` (`0x00`)
  to `POST:W3` (`0x08`) at `0x45`.
- It also changes `eq` at `0x4c` from unset (`0x80`) to `7F` (`0x7f`).

Implication:

- Both common parameter offsets are now directly verified for FM Synth.
- FM-specific EQ assignment remains fixture-verified.

## MIDI Out Post-CC Bytes

Status: open

Observation:

- MIDI Out does not expose Filter, Amplification, or Mixer parameter groups in
  the M8 UI.
- The `MID_PARAMS.m8i` fixture maps visible MIDI Out parameters through the
  custom CC table ending at `0x39`, then preserves `0x3a..0x4b` as unknown.
- Older <https://github.com/whitlockjc/m8-js> reference code reads shared
  filter, amp, and mixer groups after its MIDI Out custom CC table, but its
  expected offsets do not match the current 6.5.x fixture evidence.

Implication:

- The bytes at `0x3a..0x4b` should not be modeled as Filter, Amplification, or
  Mixer fields for MIDI Out without additional fixture evidence.
- They may be unused bytes, hidden shared state, cached UI state, or a
  MIDI-Out-specific region.

Needed research:

- Create MIDI Out fixtures that exercise any available pages beyond the visible
  params screen, especially MODS, table, and EQ-adjacent behavior.
- Compare MIDI Out instances embedded in Song files once Song instrument regions
  are mapped.

## FX Command Families

Status: partially mapped

Observation:

- The M8 UI groups FX commands into Sequencer, Mixer & Effects, Current
  Instrument, and Instrument Mods sections.
- The `PHRASES.m8s` fixture verifies the command byte values for the Sequencer
  and Mixer & Effects families in Phrase FX slots.
- Instrument table fixtures verify the two-byte FX slot shape and selected
  command byte values for Current Instrument commands.
- Instrument Mods command labels can change based on the target modulator slot
  and selected modulation type.
- `NONE_TABLE.m8i` verifies that NONE tables use the same FX slot shape, but all
  FX slots in that fixture remain unset.

Implication:

- FX command storage should remain a raw command byte plus amount byte in the
  binary schema.
- Command decoding and validation should be contextual. The valid labels may
  depend on whether the slot is in a phrase or table, and on the active
  instrument for Current Instrument and Instrument Mods commands.
- Instrument Mods should be modeled as modulator-specific command sets, not one
  flat command set.

Needed research:

- Create fixtures that exercise Current Instrument and Instrument Mods commands
  in phrase FX slots.
- Create fixtures that exercise Sequencer, Mixer & Effects, Current Instrument,
  and Instrument Mods commands in instrument table FX slots.
- Create a NONE table fixture with non-Current-Instrument commands selected.
- For Instrument Mods, create fixtures that cover every modulation type:
  `AHD ENV`, `ADSR ENV`, `DRUM ENV`, `LFO`, `TRIG ENV`, and `TRACKING`.
- Promote verified command byte values into schema/doc references only after
  fixture mapping accounts for every changed byte.

## Phrase Value Semantics

Status: raw structure mapped; semantic decoding deferred

Observation:

- The `PHRASES.m8s` fixture verifies the Phrase table location, 255 Phrase
  records, 16 steps per Phrase, the 9-byte step layout, unset sentinels, and
  Sequencer and Mixer & Effects command byte values.
- The fixture verifies several note bytes and labels, including the ordinary
  chromatic sequence beginning at `C-1` and the boundary label `G-B`, but it
  does not establish the complete note-byte range or decoding rule.
- Each Phrase FX slot stores a command byte and a raw value byte. The meaning
  of the value byte depends on the selected command.
- Current Instrument and Instrument Mods commands are contextual: available
  commands and value semantics may depend on the active instrument, target
  modulator slot, and modulation type.

Implication:

- The Phrase schema is structurally complete for the current 6.5.x evidence.
- The raw schema should continue exposing note, command, and FX value bytes
  without claiming an unverified complete semantic decoder.
- User-facing readers may eventually provide decoded note labels and
  command-specific FX value views on top of the raw fields.

Needed research:

- Verify the complete note-byte range, chromatic decoding rule, special note
  labels, and unset sentinel with targeted Phrase fixtures.
- Document the valid FX value range, labels, and relative or absolute behavior
  for every Sequencer and Mixer & Effects command.
- Verify Current Instrument and Instrument Mods command availability in Phrase
  FX slots, including how the active instrument and selected modulation type
  affect command labels and value semantics.
- Document runtime behavior that cannot be expressed by the raw binary schema,
  including command interactions and context-dependent interpretation, in the
  generated semantic or API documentation when that layer is designed.
