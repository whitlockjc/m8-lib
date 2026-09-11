meta:
  id: song_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for song files with header schema version 6.5.0.

  Initial schema verified against M8 6.5.2C Project and MIDI Settings page
  fixtures. The Project settings region is partially mapped. Remaining Song
  regions are preserved as raw bytes until future fixtures provide evidence for
  their layout.
seq:
  - id: unknown_before_project
    size: 128
    doc: |
      Preserved bytes before the mapped Project settings region. The PROJECT
      fixture changes bytes in this region during save, but those changes are
      not mapped to Project UI fields yet.
  - id: project
    type: project_settings
  - id: unknown_after_project
    size-eos: true
types:
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
          Selects one of the Scales embedded in the Song file. The UI label
          comes from the referenced embedded Scale name.
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
enums:
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
