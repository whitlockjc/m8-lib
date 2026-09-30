meta:
  id: song_6_6_2
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - ../6.0.2/instrument
    - ../6.0.1/instrument/table
    - ../4.0.1/scale
    - ../../common/fx_slot
    - ../6.5.0/song/eq
    - ../6.5.0/song/sequencing
    - ../6.5.0/song/project
    - song/mixer_effects
    - ../6.5.0/song/midi_mapping
doc: |
  Body schema for song files with header schema version 6.6.2.

  Mapped with M8 6.6.3C Song fixtures for ModFX Comb, chain bookmarks, and
  row bookmark colors. Other fields reuse 6.5.0 components. Unknown byte
  ranges remain preserved.
seq:
  - id: directory
    type: directory
    size: 128
    doc: |
      Fixed 128-byte directory field. The null-terminated path is followed by
      the remaining reserved bytes in this field. Post-terminator bytes vary between saves
      and must be preserved verbatim, not assumed to be zero-filled padding.
  - id: project_settings
    type: song_project_6_5_0::project_settings
    doc: Project settings, including tempo, scale selection, and MIDI input settings.
  - id: unknown_0
    size: 15
    doc: |
      Preserved bytes between the Project settings record and Mixer settings.
      The preceding two unknown bytes remain inside project_settings to retain
      that record boundary and the existing fixture attribution.
  - id: mixer
    type: song_mixer_effects_6_6_2::mixer_settings
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
    type: song_mixer_effects_6_6_2::effects_and_scope_settings
  - id: unknown_1
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
  - id: eqs
    type: eqs
    doc: Instrument and global effect EQ settings.
  - id: unknown_2
    size: 32
    doc: Preserved 32-byte region present in both 6.5.0 and 6.6.2 Songs.
  - id: row_bookmark_colors
    type: row_bookmark_colors
    doc: |
      Added in 6.6.2 at absolute offset 0x1b6c6. One color code per Song
      row, independent of chain-cell bookmark bitmasks.
types:
  eqs:
    doc: Contiguous bank of 128 Instrument EQs followed by four global EQs.
    seq:
      - id: instrument
        type: song_eq_6_5_0::eq_settings
        repeat: expr
        repeat-expr: 128
        doc: One EQ for each of the 128 Song Instruments.
      - id: mix
        type: song_eq_6_5_0::eq_settings
        doc: Master Mix EQ.
      - id: mod_fx
        type: song_eq_6_5_0::eq_settings
        doc: ModFX EQ.
      - id: delay
        type: song_eq_6_5_0::eq_settings
        doc: Delay EQ.
      - id: reverb
        type: song_eq_6_5_0::eq_settings
        doc: Reverb EQ.
  row_bookmark_colors:
    seq:
      - id: entries
        type: row_bookmark_color
        repeat: expr
        repeat-expr: 256
  row_bookmark_color:
    seq:
      - id: color
        type: u1
        enum: row_bookmark_color_value
  bookmarks:
    doc: |
      Song View bookmark storage. Offsets are relative to absolute file offset
      0x1a97e in 6.5.x and 6.6.x fixtures. The M8 stores one bitmask byte per Song row.
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
      Instruments 0x00 through 0x7f by matching index. The purpose of Tables
      0x80 through 0xff is not yet documented by this schema. TABLES.m8s
      verified rows 0 and 15 in Tables 0x00 and 0xff in 6.5.x fixtures.
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
        type: instrument_6_0_2::data
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
enums:
  row_bookmark_color_value:
    0x00:
      id: unselected
    0x01:
      id: text_empty
      -label: TEXT:EMPTY
    0x02:
      id: text_info
      -label: TEXT:INFO
    0x03:
      id: text_default
      -label: TEXT:DEFAULT
    0x04:
      id: text_value
      -label: TEXT:VALUE
    0x05:
      id: text_titles
      -label: TEXT:TITLES
    0x06:
      id: play_markers
      -label: PLAY MARKERS
    0x07:
      id: cursor
      -label: CURSOR
    0x08:
      id: selection
      -label: SELECTION
    0x09:
      id: scope_slider
      -label: SCOPE/SLIDER
    0x0a:
      id: meter_low
      -label: METER LOW
    0x0b:
      id: meter_mid
      -label: METER MID
    0x0c:
      id: meter_peak
      -label: METER PEAK
    0x11:
      id: text_empty_arrows
      -label: TEXT:EMPTY ><
    0x12:
      id: text_info_arrows
      -label: TEXT:INFO ><
    0x13:
      id: text_default_arrows
      -label: TEXT:DEFAULT ><
    0x14:
      id: text_value_arrows
      -label: TEXT:VALUE ><
    0x15:
      id: text_titles_arrows
      -label: TEXT:TITLES ><
    0x16:
      id: play_markers_arrows
      -label: PLAY MARKER ><
    0x17:
      id: cursor_arrows
      -label: CURSOR ><
    0x18:
      id: selection_arrows
      -label: SELECTION ><
    0x19:
      id: scope_slider_arrows
      -label: SCOPE/SLIDER ><
    0x1a:
      id: meter_low_arrows
      -label: METER LOW ><
    0x1b:
      id: meter_mid_arrows
      -label: METER MID ><
    0x1c:
      id: meter_peak_arrows
      -label: METER PEAK ><
