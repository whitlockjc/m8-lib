meta:
  id: song_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - ../6.0.1/instrument
    - ../6.0.1/instrument/table
    - ../4.0.1/scale
    - ../../common/fx_slot
    - song/eq
    - song/sequencing
    - song/project
    - song/mixer_effects
    - song/midi_mapping
doc: |
  Body schema for song files with header schema version 6.5.0.

  Initial schema verified against M8 6.5.2C Project, MIDI Settings, Song View,
  Phrase View, Bookmarks, Chain View, Scales View, Mixer, Grooves, Effects
  Settings, Mix & Limiter Scope, Instrument EQs, Mix EQ, ModFX EQ, Delay EQ, Reverb EQ, and
  MIDI Mapping, Instrument, and Table fixtures. The Project settings, MIDI Settings,
  Song rows, Phrases, Bookmarks, Chains, Tables, Instruments, embedded Scales,
  Mixer, Grooves, Effects Settings, Mix & Limiter Scope, Instrument EQs, Mix EQ, ModFX EQ, Delay
  EQ, Reverb EQ, and MIDI Mapping regions are partially mapped. Remaining Song
  regions are preserved as raw bytes until future fixtures provide evidence for
  their layout.
seq:
  - id: directory_region
    type: directory_region
    size: 128
    doc: |
      Fixed 128-byte directory field. The null-terminated path is followed by
      the remaining reserved bytes in this field. The path is /Songs/6_5_X/
      in current 6.5.x Song fixtures. Post-terminator bytes vary between saves
      and must be preserved verbatim, not assumed to be zero-filled padding.
  - id: project
    type: song_project_6_5_0::project_settings
  - id: unknown_between_project_and_mixer
    size: 15
    doc: Preserved bytes between Project settings and Mixer settings.
  - id: mixer
    type: song_mixer_effects_6_5_0::mixer_settings
  - id: grooves
    type: song_sequencing_6_5_0::grooves
  - id: rows
    type: song_sequencing_6_5_0::song_rows
  - id: phrases
    type: song_sequencing_6_5_0::phrases
  - id: chains
    type: song_sequencing_6_5_0::chains
  - id: tables
    type: tables
    doc: |
      Song table storage. Record boundaries and default bytes are verified by
      INSTRUMENTS.m8s. Tables 0x00 through 0x7f are associated by matching index
      with Instruments 0x00 through 0x7f.
  - id: instruments
    type: instruments
  - id: effects_and_scope
    type: song_mixer_effects_6_5_0::effects_and_scope_settings
  - id: unknown_between_effects_and_scope_and_midi_mappings
    size: 35
    doc: |
      Preserved bytes between Effects/Mix & Limiter Scope storage and the MIDI
      Mapping table.
  - id: midi_mappings
    type: song_midi_mapping_6_5_0::midi_mappings
  - id: bookmarks
    type: bookmarks
  - id: scales
    type: embedded_scales
  - id: instrument_eqs
    type: song_eq_6_5_0::instrument_eqs
  - id: mix_eq
    type: song_eq_6_5_0::eq_settings
  - id: mod_fx_eq
    type: song_eq_6_5_0::eq_settings
  - id: delay_eq
    type: song_eq_6_5_0::eq_settings
  - id: reverb_eq
    type: song_eq_6_5_0::eq_settings
  - id: unknown_after_reverb_eq
    size-eos: true
types:
  bookmarks:
    doc: |
      Song View bookmark storage. Offsets are relative to absolute file offset
      0x1a97e in 6.5.x fixtures. The M8 stores one bitmask byte per Song row.
    seq:
      - id: entries
        type: bookmark_row
        repeat: expr
        repeat-expr: 256
  bookmark_row:
    doc: Bookmark state for one Song row. Bits 0..7 correspond to tracks 1..8.
    seq:
      - id: track_mask
        type: u1
    instances:
      track_1:
        value: (track_mask & 0x01) != 0
      track_2:
        value: (track_mask & 0x02) != 0
      track_3:
        value: (track_mask & 0x04) != 0
      track_4:
        value: (track_mask & 0x08) != 0
      track_5:
        value: (track_mask & 0x10) != 0
      track_6:
        value: (track_mask & 0x20) != 0
      track_7:
        value: (track_mask & 0x40) != 0
      track_8:
        value: (track_mask & 0x80) != 0
  directory_region:
    doc: Fixed 128-byte Song directory field, including reserved post-terminator space.
    seq:
      - id: path
        type: strz
        encoding: ASCII
      - id: trailing
        size: _io.size - _io.pos
        doc: Reserved directory-field capacity after the path terminator; preserve stored bytes.
  tables:
    doc: |
      Song table storage at absolute offsets 0xba3e..0x13a3d. The region contains
      256 fixed 128-byte tables using the same table structure appended to a
      standalone Instrument file. Tables 0x00 through 0x7f are associated with
      Instruments 0x00 through 0x7f by matching index. The purpose of Tables
      0x80 through 0xff is not yet documented by this schema. TABLES.m8s
      verifies rows 0 and 15 in Tables 0x00 and 0xff.
    seq:
      - id: entries
        type: instrument_table_6_0_1
        repeat: expr
        repeat-expr: 256
  instruments:
    doc: |
      Song instrument storage at absolute offsets 0x13a3e..0x1a5bd. The region
      contains 128 fixed 215-byte instrument records using the same structure as
      the instrument portion of a standalone Instrument file.
    seq:
      - id: entries
        type: instrument_6_0_1::instrument_data
        repeat: expr
        repeat-expr: 128
  embedded_scales:
    doc: |
      Embedded Scale storage. Offsets are relative to absolute file offset
      0x1aa7e in 6.5.x fixtures. The M8 stores 16 Scale body records without
      standalone Scale file headers.
    seq:
      - id: entries
        type: scale_4_0_1
        repeat: expr
        repeat-expr: 16
