meta:
  id: song_project_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Project page and MIDI Settings storage for Song file schema version 6.5.0.
  The Song body determines the Project settings position.
types:
  project_settings:
    doc: |
      Project page settings.
    seq:
      - id: transpose
        type: u1
        doc: Project transpose value.
      - id: tempo
        type: f4
        doc: |
          Song tempo as a 32-bit little-endian float.
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
        doc: Current Song MIDI input and sync settings.
      - id: scale
        type: u1
        doc: |
          Project page Scale selector and Scale View key storage. The high
          nibble stores the key index; the low nibble stores the embedded Scale
          index. Key index, Scale index, and the selected Scale definition are
          distinct values.
      - id: groove
        type: u1
        doc: Index of the selected Song groove.
      - id: unknown
        size: 2
        doc: |
          Preserved bytes of unknown purpose.
  midi_settings:
    doc: |
      MIDI Settings page storage.
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
          0x01 means ON; 0x00 means OFF.
      - id: record_delay_kill
        type: u1
        enum: record_delay_kill
        doc: MIDI recording delay and note-off handling mode.
      - id: control_map_channel
        type: u1
        doc: |
          0x00 means OFF, 0x11 means ALL, and 0x01 through
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
          0x01 means ON; 0x00 means OFF.
      - id: mode
        type: u1
        enum: midi_input_mode
        doc: MIDI input mode.
  midi_sync_settings:
    doc: |
      Sync In and Sync Out storage. The M8 UI combines each clock boolean and
      transport byte into one displayed label.
    seq:
      - id: sync_in_clock
        type: u1
        doc: |
          0x01 means clock enabled; 0x00 means clock disabled.
      - id: sync_in_transport
        type: u1
        enum: midi_sync_transport
      - id: sync_out_clock
        type: u1
        doc: |
          0x01 means clock enabled; 0x00 means clock disabled.
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
