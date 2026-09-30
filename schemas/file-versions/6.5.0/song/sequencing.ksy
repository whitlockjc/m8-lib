meta:
  id: song_sequencing_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  -fx-sequencer-ranges:
    - [0x00, 0x1a]
    - [0x43, 0x47]
    - [0x4d, 0x4d]
  -fx-instrument-mods:
    base: 0x92
    slots: 4
    parameters-per-slot: 5
    prefixes:
      ahd_env: [EA, AT, HO, DE, ET]
      adsr_env: [EA, AT, DE, SU, ET]
      drum_env: [EA, PK, BO, DE, ET]
      lfo: [LA, LO, LS, LF, LT]
      trig_env: [EA, AT, HO, DE, ET]
      tracking: [TA, TS, TL, TH, TX]
  imports:
    - ../../../common/fx_slot
doc: |
  Song rows, phrases, chains, and grooves for file schema
  version 6.5.0. The Song body determines their positions.
types:
  grooves:
    doc: |
      Thirty-two grooves, each containing 16 one-byte step values.
    seq:
      - id: entries
        type: groove
        repeat: expr
        repeat-expr: 32
        doc: Thirty-two Song groove definitions.
  groove:
    doc: Sixteen-byte Groove record containing one byte per step.
    seq:
      - id: steps
        type: u1
        repeat: expr
        repeat-expr: 16
        doc: Sixteen groove step values.
  phrases:
    doc: |
      Phrases indexed 0x00 through 0xfe; 0xff is an unset phrase reference.
    seq:
      - id: entries
        type: phrase
        repeat: expr
        repeat-expr: 255
        doc: Stored phrases indexed 0x00 through 0xfe.
  phrase:
    doc: One hundred forty-four byte Phrase record containing 16 phrase steps.
    seq:
      - id: steps
        type: phrase_step
        repeat: expr
        repeat-expr: 16
        doc: Sixteen steps in this phrase.
  phrase_step:
    doc: |
      Nine-byte Phrase step. 0xff means unset for note, volume,
      instrument, and FX command bytes. FX value bytes default to 0x00.
    seq:
      - id: note
        type: u1
        doc: Note value; 0xff is unset.
      - id: volume
        type: u1
        doc: Step volume; 0xff is unset.
      - id: instrument
        type: u1
        doc: Instrument index; 0xff is unset.
      - id: fx
        type: fx_slot
        repeat: expr
        repeat-expr: 3
        doc: |
          Three shared FX slots. The UI groups commands as Sequencer,
          Mixer & Effects, Current Instrument, and Instrument Mods. Available
          labels depend on the surrounding instrument and modulation type.
  song_rows:
    doc: |
      Song View storage of 256 rows, each with one chain index per track.
    seq:
      - id: entries
        type: song_row
        repeat: expr
        repeat-expr: 256
        doc: Song rows indexed 0x00 through 0xff.
  song_row:
    doc: |
      Eight-byte Song View row. Each byte stores the chain index assigned to a
      track; tracks[0] is M8 Track 1. 0xff means unset.
    seq:
      - id: tracks
        type: u1
        repeat: expr
        repeat-expr: 8
        doc: Chain index for each of the eight tracks; 0xff is unset.
  chains:
    doc: |
      Chain View storage. Chains have indexes 0x00 through 0xfe; 0xff is
      the unset reference sentinel. Each chain stores 16 rows.
    seq:
      - id: entries
        type: chain
        repeat: expr
        repeat-expr: 255
        doc: Stored chains indexed 0x00 through 0xfe.
  chain:
    doc: Thirty-two-byte Chain View record containing 16 two-byte rows.
    seq:
      - id: rows
        type: chain_row
        repeat: expr
        repeat-expr: 16
        doc: Sixteen rows in this chain.
  chain_row:
    doc: |
      Chain row storage. The phrase byte stores the referenced phrase index;
      0xff means unset.
    seq:
      - id: phrase
        type: u1
        doc: Referenced phrase index; 0xff is unset.
      - id: transpose
        type: u1
        doc: Transpose value for the referenced phrase.
enums:
  instrument_mod_fx_command:
    0x92: { id: mod_1_parameter_1 }
    0x93: { id: mod_1_parameter_2 }
    0x94: { id: mod_1_parameter_3 }
    0x95: { id: mod_1_parameter_4 }
    0x96: { id: mod_1_parameter_5 }
    0x97: { id: mod_2_parameter_1 }
    0x98: { id: mod_2_parameter_2 }
    0x99: { id: mod_2_parameter_3 }
    0x9a: { id: mod_2_parameter_4 }
    0x9b: { id: mod_2_parameter_5 }
    0x9c: { id: mod_3_parameter_1 }
    0x9d: { id: mod_3_parameter_2 }
    0x9e: { id: mod_3_parameter_3 }
    0x9f: { id: mod_3_parameter_4 }
    0xa0: { id: mod_3_parameter_5 }
    0xa1: { id: mod_4_parameter_1 }
    0xa2: { id: mod_4_parameter_2 }
    0xa3: { id: mod_4_parameter_3 }
    0xa4: { id: mod_4_parameter_4 }
    0xa5: { id: mod_4_parameter_5 }
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
