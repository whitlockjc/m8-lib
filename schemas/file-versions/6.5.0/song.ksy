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
  Song body for file schema version 6.5.0, containing project settings,
  sequencing, instruments, tables, scales, MIDI mappings, and mixer and effects
  settings.
seq:
  - id: directory
    type: directory
    size: 128
    doc: |
      Fixed 128-byte directory field. The null-terminated path is followed by
      the remaining reserved bytes in this field. Post-terminator bytes vary between saves
      and must be preserved verbatim, not assumed to be zero-filled padding.
  - id: project_settings
    type: project_6_5_0::settings
    doc: Project settings, including tempo, scale selection, and MIDI input settings.
  - id: unknown_0
    size: 15
    doc: |
      Preserved bytes between the Project settings record and Mixer settings.
      The preceding two unknown bytes belong to the Project settings record.
  - id: mixer
    type: mixer_effects_6_5_0::mixer
  - id: grooves
    type: sequencing_6_5_0::grooves
  - id: rows
    type: sequencing_6_5_0::rows
  - id: phrases
    type: sequencing_6_5_0::phrases
  - id: chains
    type: sequencing_6_5_0::chains
  - id: tables
    type: tables
    doc: |
      Song table storage. Tables 0x00 through 0x7f correspond to Instruments
      0x00 through 0x7f by index.
  - id: instruments
    type: instruments
  - id: effects_and_scope
    type: mixer_effects_6_5_0::effects_and_scope
  - id: unknown_1
    size: 35
    doc: |
      Preserved bytes between Effects/Mix & Limiter Scope storage and the MIDI
      Mapping table.
  - id: midi_mappings
    type: midi_mapping_6_5_0::mappings
  - id: bookmarks
    type: bookmarks
  - id: scales
    type: scales
  - id: eqs
    type: eqs
    doc: Instrument and global effect EQ settings.
  - id: unknown_2
    size-eos: true
types:
  eqs:
    doc: Contiguous bank of 128 Instrument EQs followed by four global EQs.
    seq:
      - id: instrument
        type: eq_6_5_0::settings
        repeat: expr
        repeat-expr: 128
        doc: One EQ for each of the 128 Song Instruments.
      - id: mix
        type: eq_6_5_0::settings
        doc: Master Mix EQ.
      - id: mod_fx
        type: eq_6_5_0::settings
        doc: ModFX EQ.
      - id: delay
        type: eq_6_5_0::settings
        doc: Delay EQ.
      - id: reverb
        type: eq_6_5_0::settings
        doc: Reverb EQ.
  bookmarks:
    doc: |
      Song View chain-cell bookmarks, with one bitmask byte per Song row.
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
  directory:
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
      Instruments 0x00 through 0x7f by matching index.
    seq:
      - id: entries
        type: table_6_0_1
        repeat: expr
        repeat-expr: 256
  instruments:
    doc: |
      Song instrument storage at absolute offsets 0x13a3e..0x1a5bd. The region
      contains 128 fixed 215-byte instrument records using the same structure as
      the instrument portion of a standalone Instrument file.
    seq:
      - id: entries
        type: instrument_6_0_1::data
        repeat: expr
        repeat-expr: 128
  scales:
    doc: |
      Sixteen embedded Scale body records without standalone Scale file headers.
    seq:
      - id: entries
        type: scale_4_0_1
        repeat: expr
        repeat-expr: 16
