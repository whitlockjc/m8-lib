meta:
  id: song_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - ../6.0.1/instrument
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
      Null-terminated directory path followed by preserved bytes. The path is
      /Songs/6_5_X/ in all current 6.5.x Song fixtures. The post-terminator
      bytes vary between fixtures and must not be treated as string padding.
  - id: project
    type: project_settings
  - id: unknown_between_project_and_mixer
    size: 15
    doc: Preserved bytes between Project settings and Mixer settings.
  - id: mixer
    type: mixer_settings
  - id: grooves
    type: grooves
  - id: rows
    type: song_rows
  - id: phrases
    type: phrases
  - id: chains
    type: chains
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
    type: instrument_eqs
  - id: mix_eq
    type: eq_settings
  - id: mod_fx_eq
    type: eq_settings
  - id: delay_eq
    type: eq_settings
  - id: reverb_eq
    type: eq_settings
  - id: unknown_after_reverb_eq
    size-eos: true
types:
  directory_region:
    doc: Fixed 128-byte region containing the Song directory and trailing bytes.
    seq:
      - id: path
        type: strz
        encoding: ASCII
      - id: trailing
        size: _io.size - _io.pos
        doc: Preserved bytes after the path terminator; meaning unknown.
  grooves:
    doc: |
      Groove storage. Offsets are relative to absolute file offset 0x00ee in
      6.5.x fixtures. The M8 stores 32 grooves, and each groove stores 16 one
      byte step values.
    seq:
      - id: entries
        type: groove
        repeat: expr
        repeat-expr: 32
  groove:
    doc: Sixteen-byte Groove record containing one byte per step.
    seq:
      - id: steps
        type: u1
        repeat: expr
        repeat-expr: 16
  phrases:
    doc: |
      Phrase View storage. Offsets are relative to absolute file offset 0x0aee
      in 6.5.x fixtures. The M8 stores phrase indexes 0x00 through 0xfe. Value
      0xff is observed as an unset phrase reference rather than a stored phrase
      record.
    seq:
      - id: entries
        type: phrase
        repeat: expr
        repeat-expr: 255
  phrase:
    doc: One hundred forty-four byte Phrase record containing 16 phrase steps.
    seq:
      - id: steps
        type: phrase_step
        repeat: expr
        repeat-expr: 16
  phrase_step:
    doc: |
      Nine-byte Phrase step. 0xff is observed as unset for note, volume,
      instrument, and FX command bytes. FX value bytes default to 0x00.
    seq:
      - id: note
        type: u1
      - id: volume
        type: u1
      - id: instrument
        type: u1
      - id: fx1
        type: phrase_fx
      - id: fx2
        type: phrase_fx
      - id: fx3
        type: phrase_fx
  phrase_fx:
    doc: Two-byte Phrase FX command/value slot.
    seq:
      - id: command
        type: u1
        enum: phrase_fx_command
      - id: value
        type: u1
  song_rows:
    doc: |
      Song View row storage. Offsets are relative to absolute file offset
      0x02ee in 6.5.x fixtures. The M8 stores 256 rows, and each row stores one
      chain index per track.
    seq:
      - id: entries
        type: song_row
        repeat: expr
        repeat-expr: 256
  song_row:
    doc: |
      Eight-byte Song View row. Each byte stores the chain index assigned to a
      specific track. 0xff is observed as unset.
    seq:
      - id: track_1
        type: u1
      - id: track_2
        type: u1
      - id: track_3
        type: u1
      - id: track_4
        type: u1
      - id: track_5
        type: u1
      - id: track_6
        type: u1
      - id: track_7
        type: u1
      - id: track_8
        type: u1
  chains:
    doc: |
      Chain View storage. Offsets are relative to absolute file offset 0x9a5e
      in 6.5.x fixtures. The M8 stores chain indexes 0x00 through 0xfe; 0xff is
      the unset reference sentinel. Each chain stores 16 rows.
    seq:
      - id: entries
        type: chain
        repeat: expr
        repeat-expr: 255
  chain:
    doc: Thirty-two-byte Chain View record containing 16 two-byte rows.
    seq:
      - id: rows
        type: chain_row
        repeat: expr
        repeat-expr: 16
  chain_row:
    doc: |
      Chain row storage. The phrase byte stores the referenced phrase index;
      0xff is observed as unset.
    seq:
      - id: phrase
        type: u1
      - id: transpose
        type: u1
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
        type: instrument_6_0_1::instrument_table
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
  embedded_scales:
    doc: |
      Embedded Scale storage. Offsets are relative to absolute file offset
      0x1aa7e in 6.5.x fixtures. The M8 stores 16 Scale body records without
      standalone Scale file headers.
    seq:
      - id: entries
        type: embedded_scale
        repeat: expr
        repeat-expr: 16
  embedded_scale:
    doc: |
      Embedded Scale body. This matches the standalone Scale file body layout:
      enabled notes, 12 intervals, a fixed-size name, and tuning offset.
    seq:
      - id: enabled_notes
        type: u2
      - id: intervals
        type: scale_interval
        repeat: expr
        repeat-expr: 12
      - id: name
        size: 16
      - id: tuning_offset
        type: f4
  scale_interval:
    doc: Signed interval offset stored as hundredths of a semitone.
    seq:
      - id: offset
        type: s2
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
  eq_settings:
    doc: |
      Three-band EQ storage. Each known EQ uses three adjacent 6-byte band
      records.
    seq:
      - id: low_band
        type: eq_band
      - id: mid_band
        type: eq_band
      - id: high_band
        type: eq_band
  instrument_eqs:
    doc: 128 assignable Instrument EQ banks, each with the standard 18-byte EQ layout.
    seq:
      - id: entries
        type: eq_settings
        repeat: expr
        repeat-expr: 128
  eq_band:
    doc: |
      Six-byte EQ band record. The type and mode are packed into one byte: bits
      0..4 hold the filter type and bits 5..7 hold the filter mode. Frequency
      is stored as an unsigned little-endian integer. Gain is stored as signed
      hundredths, so 10.50 is stored as 1050.
    seq:
      - id: type_and_mode
        type: u1
      - id: frequency
        type: u2
      - id: gain
        type: s2
      - id: q
        type: u1
    instances:
      filter_type:
        value: type_and_mode & 0x1f
        enum: eq_filter_type
      filter_mode:
        value: type_and_mode >> 5
        enum: eq_filter_mode
enums:
  phrase_fx_command:
    0x00:
      id: arpeggio
      -label: ARP
    0x01:
      id: chance
      -label: CHA
    0x02:
      id: delay
      -label: DEL
    0x03:
      id: groove
      -label: GRV
    0x04:
      id: hop
      -label: HOP
    0x05:
      id: kill_note
      -label: KIL
    0x06:
      id: randomize
      -label: RND
    0x07:
      id: randomize_left
      -label: RNL
    0x08:
      id: retrig
      -label: RET
    0x09:
      id: repeat
      -label: REP
    0x0a:
      id: remix
      -label: RMX
    0x0b:
      id: nth
      -label: NTH
    0x0c:
      id: pitch_slide
      -label: PSL
    0x0d:
      id: pitch_bend
      -label: PBN
    0x0e:
      id: vibrato
      -label: PVB
    0x0f:
      id: extreme_vibrato
      -label: PVX
    0x10:
      id: track_scale
      -label: SCA
    0x11:
      id: global_scale
      -label: SCG
    0x12:
      id: random_seed
      -label: SED
    0x13:
      id: song_hop
      -label: SNG
    0x14:
      id: table
      -label: TBL
    0x15:
      id: table_hop
      -label: THO
    0x16:
      id: table_tick
      -label: TIC
    0x17:
      id: aux_table
      -label: TBX
    0x18:
      id: tempo
      -label: TPO
    0x19:
      id: transpose
      -label: TSP
    0x1a:
      id: note_off
      -label: OFF
    0x1b:
      id: main_volume
      -label: VMV
    0x1c:
      id: mod_fx_modulation_depth
      -label: XMM
    0x1d:
      id: mod_fx_modulation_frequency
      -label: XMF
    0x1e:
      id: mod_fx_stereo_width
      -label: XMW
    0x1f:
      id: mod_fx_reverb_mix
      -label: XMR
    0x20:
      id: delay_time
      -label: XDT
    0x21:
      id: delay_feedback
      -label: XDF
    0x22:
      id: delay_stereo_width
      -label: XDW
    0x23:
      id: delay_reverb_mix
      -label: XDR
    0x24:
      id: reverb_room_size
      -label: XRS
    0x25:
      id: reverb_decay
      -label: XRD
    0x26:
      id: reverb_modulation_depth
      -label: XRM
    0x27:
      id: reverb_modulation_frequency
      -label: XRF
    0x28:
      id: reverb_stereo_width
      -label: XRW
    0x29:
      id: reverb_freeze
      -label: XRZ
    0x2a:
      id: mod_fx_volume
      -label: VMX
    0x2b:
      id: delay_volume
      -label: VDE
    0x2c:
      id: reverb_volume
      -label: VRE
    0x2d:
      id: track_1_volume
      -label: VT1
    0x2e:
      id: track_2_volume
      -label: VT2
    0x2f:
      id: track_3_volume
      -label: VT3
    0x30:
      id: track_4_volume
      -label: VT4
    0x31:
      id: track_5_volume
      -label: VT5
    0x32:
      id: track_6_volume
      -label: VT6
    0x33:
      id: track_7_volume
      -label: VT7
    0x34:
      id: track_8_volume
      -label: VT8
    0x35:
      id: dj_filter_cutoff
      -label: DJC
    0x36:
      id: line_input_volume
      -label: VIN
    0x37:
      id: line_input_mod_fx_send
      -label: IMX
    0x38:
      id: line_input_delay_send
      -label: IDE
    0x39:
      id: line_input_reverb_send
      -label: IRE
    0x3a:
      id: second_line_input_volume
      -label: VI2
    0x3b:
      id: second_line_input_mod_fx_send
      -label: IM2
    0x3c:
      id: second_line_input_delay_send
      -label: ID2
    0x3d:
      id: second_line_input_reverb_send
      -label: IR2
    0x3e:
      id: usb_input_volume
      -label: USB
    0x3f:
      id: dj_filter_resonance
      -label: DJR
    0x40:
      id: dj_filter_type
      -label: DJT
    0x41:
      id: main_song_eq_assignment
      -label: EQM
    0x42:
      id: current_instrument_eq_assignment
      -label: EQI
    0x43:
      id: instrument
      -label: INS
    0x44:
      id: repeat_boundary
      -label: RTO
    0x45:
      id: arpeggio_config
      -label: ARC
    0x46:
      id: global_groove
      -label: GGR
    0x47:
      id: next_track
      -label: NXT
    0x48:
      id: reverb_highpass
      -label: XRH
    0x49:
      id: mod_fx_type_and_phase
      -label: XMT
    0x4a:
      id: ott
      -label: OTT
    0x4b:
      id: ott_color
      -label: OTC
    0x4c:
      id: ott_time
      -label: OTI
    0x4d:
      id: micro_time
      -label: MTT
    0xff:
      id: unset
      -label: --
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
  eq_filter_type:
    0x00:
      id: lowcut
      -label: LOWCUT
    0x01:
      id: lowshelf
      -label: LOWSHELF
    0x02:
      id: bell
      -label: BELL
    0x03:
      id: bandpass
      -label: BANDPASS
    0x04:
      id: hi_shelf
      -label: HI.SHELF
    0x05:
      id: hi_cut
      -label: HI.CUT
    0x06:
      id: allpass
      -label: ALLPASS
  eq_filter_mode:
    0x00:
      id: stereo
      -label: STEREO
    0x01:
      id: mid
      -label: MID
    0x02:
      id: side
      -label: SIDE
    0x03:
      id: left
      -label: LEFT
    0x04:
      id: right
      -label: RIGHT
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
