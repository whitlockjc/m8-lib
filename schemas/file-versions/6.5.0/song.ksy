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
    type: project_settings
  - id: unknown_between_project_and_mixer
    size: 15
    doc: Preserved bytes between Project settings and Mixer settings.
  - id: mixer
    type: mixer_settings
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
    type: effects_and_scope_settings
  - id: unknown_between_effects_and_scope_and_midi_mappings
    size: 35
    doc: |
      Preserved bytes between Effects/Mix & Limiter Scope storage and the MIDI
      Mapping table.
  - id: midi_mappings
    type: midi_mappings
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
  project_settings:
    doc: |
      Project page settings. Offsets are relative to absolute file offset
      0x008e in 6.5.x fixtures.
    seq:
      - id: transpose
        type: u1
      - id: tempo
        type: f4
        doc: |
          Verified as a 32-bit little-endian float. A UI change from 120.00 to
          121.99 stored approximately 121.98999786376953.
      - id: live_quantize
        type: u1
        doc: |
          0x00 displays as CHAIN LEN. Values from 0x01 through 0xff display as
          step counts.
      - id: name
        size: 12
        doc: |
          Fixed-size byte range for the Project name. Padding bytes are
          preserved as stored.
      - id: midi_settings
        type: midi_settings
      - id: scale
        type: u1
        doc: |
          Project page Scale selector and Scale View key storage. The high
          nibble stores the key index; the low nibble stores the embedded Scale
          index. The PROJECT fixture changed this byte from 0x00 to 0xfe while
          changing the Project page Scale value. The SCALES fixture changed the
          key from C to E and changed this byte from 0x00 to 0x40. The KEY_ONLY
          fixture changed the key from C to G and changed this byte from 0x00
          to 0x70. The UI presents key and scale together, but the schema model
          has distinct values: key index, scale index, and Scale definition
          record.
      - id: groove
        type: u1
      - id: unknown_trailing_state
        size: 2
        doc: |
          Changed in the PROJECT fixture, but not yet mapped to a Project UI
          meaning. Preserve until targeted fixtures provide evidence.
  midi_settings:
    doc: |
      MIDI Settings page storage. Offsets are relative to absolute file offset
      0x00a0 in 6.5.x fixtures.
    seq:
      - id: sync_settings
        type: midi_sync_settings
        doc: |
          Two-byte Sync In and two-byte Sync Out storage. Each setting is
          represented as a clock-enabled boolean plus a transport mode byte.
      - id: record_note_channel
        type: u1
        doc: Displayed as decimal in the M8 UI.
      - id: record_velocity
        type: u1
        doc: |
          Observed values: 0x01 means ON, 0x00 means OFF.
      - id: record_delay_kill
        type: u1
        enum: record_delay_kill
      - id: control_map_channel
        type: u1
        doc: |
          Observed values: 0x00 means OFF, 0x11 means ALL, and 0x01 through
          0x10 display as decimal channels 01 through 16.
      - id: song_row_cue_channel
        type: u1
        doc: Displayed as decimal in the M8 UI.
      - id: track_midi_input_channels
        type: u1
        repeat: expr
        repeat-expr: 8
        doc: |
          MIDI channel for each of the 8 tracks. Displayed as decimal in the M8
          UI.
      - id: track_midi_input_instruments
        type: u1
        repeat: expr
        repeat-expr: 8
        doc: Instrument index/number for each of the 8 tracks.
      - id: program_change
        type: u1
        doc: |
          Observed values: 0x01 means ON, 0x00 means OFF.
      - id: mode
        type: u1
        enum: midi_input_mode
  midi_sync_settings:
    doc: |
      Sync In and Sync Out storage. The M8 UI combines each clock boolean and
      transport byte into one displayed label.
    seq:
      - id: sync_in_clock
        type: u1
        doc: |
          Observed values: 0x01 means clock enabled, 0x00 means clock disabled.
      - id: sync_in_transport
        type: u1
        enum: midi_sync_transport
      - id: sync_out_clock
        type: u1
        doc: |
          Observed values: 0x01 means clock enabled, 0x00 means clock disabled.
      - id: sync_out_transport
        type: u1
        enum: midi_sync_transport
  mixer_settings:
    doc: |
      Mixer and Mix & Limiter Scope storage. Offsets are relative to absolute
      file offset 0x00ce in 6.5.x fixtures.
    seq:
      - id: mix
        type: u1
      - id: limiter
        type: u1
      - id: track_volumes
        type: u1
        repeat: expr
        repeat-expr: 8
      - id: sends
        type: mixer_sends
      - id: analog_input_volume
        type: u1
      - id: analog_dual_mono_input_volume
        type: u1
        doc: |
          Default fixture stores 0xff. The M8 UI displays this as unset until
          dual mono input is enabled.
      - id: usb_input_volume
        type: u1
      - id: analog_input_sends
        type: mixer_sends
      - id: analog_dual_mono_input_sends
        type: mixer_sends
      - id: usb_input_sends
        type: mixer_sends
      - id: dj_filter
        type: u1
      - id: dj_filter_resonance
        type: u1
      - id: dj_filter_type
        type: u1
        enum: dj_filter_type
      - id: limiter_attack
        type: u1
      - id: limiter_release
        type: u1
      - id: soft_clip
        type: u1
        doc: |
          Observed values: 0x00 means OFF, 0x01 means ON.
      - id: ott
        type: u1
  effects_and_scope_settings:
    doc: |
      Shared storage region for the Effects Settings and Mix & Limiter Scope
      views. Offsets are relative to absolute file offset 0x1a5be in 6.5.x
      fixtures. Storage order does not fully match the UI grouping; the Mod FX
      type byte is stored after the Mix & Limiter Scope OTT detail bytes.
    seq:
      - id: unknown_before_mod_fx
        size: 3
        doc: Preserved bytes before the mapped Mod FX parameter bytes.
      - id: mod_fx
        type: mod_fx_settings
      - id: unknown_between_mod_fx_and_delay
        size: 5
        doc: |
          Preserved bytes between Mod FX and Delay parameters. Historical
          <https://github.com/whitlockjc/m8-js> reference code treats part of
          this region as delay filter storage, but this fixture does not change
          those controls.
      - id: delay
        type: delay_settings
      - id: unknown_between_delay_and_reverb
        size: 3
        doc: |
          Preserved bytes between Delay and Reverb parameters. Historical
          <https://github.com/whitlockjc/m8-js> reference code treats part of
          this region as reverb filter storage, but this fixture does not
          change those controls.
      - id: reverb
        type: reverb_settings
      - id: mix_limiter_scope
        type: mix_limiter_scope_settings
      - id: mod_fx_type
        type: u1
        enum: mod_fx_type
  mod_fx_settings:
    doc: |
      Mod FX parameter storage from the Effects Settings View. The Mod FX type
      byte is stored later in the shared Effects/Mix & Limiter Scope region.
    seq:
      - id: depth
        type: u1
      - id: frequency
        type: u1
      - id: width
        type: u1
      - id: reverb_send
        type: u1
  delay_settings:
    doc: Delay parameter storage from the Effects Settings View.
    seq:
      - id: time_left
        type: u1
      - id: time_right
        type: u1
      - id: feedback
        type: u1
      - id: width
        type: u1
      - id: reverb_send
        type: u1
  reverb_settings:
    doc: Reverb parameter storage from the Effects Settings View.
    seq:
      - id: room_size
        type: u1
      - id: decay
        type: u1
      - id: depth
        type: u1
      - id: frequency
        type: u1
      - id: width
        type: u1
      - id: shimmer
        type: u1
  mix_limiter_scope_settings:
    doc: |
      Mix & Limiter Scope storage for OTT detail controls from the Mix &
      Limiter Scope View. Offsets are relative to absolute file offset
      0x1a5d8 in 6.5.x fixtures.
    seq:
      - id: ott_time
        type: u1
      - id: ott_color
        type: u1
  mixer_sends:
    seq:
      - id: mod_fx
        type: u1
      - id: delay
        type: u1
      - id: reverb
        type: u1
  midi_mappings:
    doc: |
      MIDI Mapping page storage. Offsets are relative to absolute file offset
      0x1a5fe in 6.5.x fixtures. M8 supports 128 mapping records.
    seq:
      - id: entries
        type: midi_mapping
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
  midi_mapping:
    doc: |
      Seven-byte MIDI Mapping record. Historical m8-js reference code reads
      these fields in this byte order. The 6.5.x MIDI_MAPPING fixture verifies
      the record size and table base offset.
    seq:
      - id: channel
        type: u1
        doc: |
          0x00 is observed for empty mappings. Other values are displayed as
          decimal MIDI channels in the M8 UI.
      - id: control_number
        type: u1
        doc: |
          Observed values include 0x00, 0x7f, 0x80, and 0x81. The M8 UI
          displays 0x80 as T:X and 0x81 as T:Y in the current fixture.
      - id: destination_type
        type: u1
        enum: midi_mapping_destination_type
        doc: |
          Raw destination type byte. Observed labels identify the UI
          destination group. Destination index and parameter interpretation is
          destination-specific and deferred to the corresponding page schemas.
      - id: destination_index
        type: u1
      - id: destination_parameter
        type: u1
      - id: minimum_value
        type: u1
      - id: maximum_value
        type: u1
enums:
  mod_fx_type:
    0x00:
      id: chorus
      -label: CHORUS
    0x01:
      id: phaser
      -label: PHASER
    0x02:
      id: flanger
      -label: FLANGER
  dj_filter_type:
    0x00:
      id: lowpass_highpass
      -label: LOWPASS:HIGHPASS
    0x01:
      id: lowpass_bandstop
      -label: LOWPASS:BANDSTOP
    0x02:
      id: bandpass_highpass
      -label: BANDPASS:HIGHPASS
  midi_mapping_destination_type:
    0x05:
      id: instrument
      -label: I
    0x0b:
      id: effects
      -label: X
    0x0d:
      id: mixer
      -label: M
    0x19:
      id: eq
      -label: Q
  midi_sync_transport:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: transport
      -label: TRANSPORT
    0x02:
      id: transport_spp
      -label: TRANSPORT+SPP
  record_delay_kill:
    0x00:
      id: none
      -label: NONE
    0x01:
      id: note_off
      -label: NOTE OFF
    0x02:
      id: delay
      -label: DELAY
    0x03:
      id: both
      -label: BOTH
  midi_input_mode:
    0x00:
      id: mono
      -label: MONO
    0x01:
      id: legato
      -label: LEGATO
    0x02:
      id: poly
      -label: POLY
