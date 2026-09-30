meta:
  id: instrument_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - instrument/modulation
    - instrument/parameters
    - instrument/table
doc: |
  Body schema for instrument files with header schema version 6.0.1.

  Initial schema verified against M8 6.5.2C NONE, Wavsynth, Macrosynth,
  Sampler, MIDI Out, FM Synth, Hypersynth, and External instrument fixtures. The
  instrument type byte, fixed-size name byte range, common instrument prefix,
  and NONE table are mapped.
  Wavsynth/Macrosynth/Sampler/MIDI Out/FM Synth/Hypersynth/External params,
  filter params, amp params, mixer params, modulators, Wavsynth/Macrosynth/
  Sampler/MIDI Out/FM Synth/Hypersynth/External instrument tables, sample path,
  Hypersynth chord table, and common EQ assignment are mapped from params,
  MODS, and table fixtures. Unknown ranges are preserved until additional
  instrument fixtures provide evidence for their layout.
seq:
  - id: instrument
    type: instrument_data
  - id: table
    type: instrument_table_6_0_1
types:
  instrument_data:
    doc: |
      Fixed 215-byte instrument record. This record is stored directly in Song
      files; standalone Instrument files append one 128-byte instrument table.
      The M8 manual groups general_settings and eq as General Instrument
      Settings. EQ is stored after the type-specific region, so it remains a
      separate field in the raw storage sequence.
    seq:
      - id: general_settings
        type: general_instrument_settings
      - id: body_before_eq
        type:
          switch-on: general_settings.type
          cases:
            'instrument_type::wavsynth': wavsynth_body_before_eq
            'instrument_type::macrosynth': macrosynth_body_before_eq
            'instrument_type::sampler': sampler_body_before_eq
            'instrument_type::midi_out': midi_out_body_before_eq
            'instrument_type::fm_synth': fm_synth_body_before_eq
            'instrument_type::hypersynth': hypersynth_body_before_eq
            'instrument_type::external': external_body_before_eq
            'instrument_type::none': unused_body_before_eq
        doc: Instrument-specific body before the common EQ field.
      - id: eq
        type: u1
        doc: |
          Common instrument EQ assignment. Observed values: 0x80 displays as
          --, 0x7f displays as 7F.
      - id: tail
        type:
          switch-on: general_settings.type
          cases:
            'instrument_type::sampler': sampler_data_tail
            'instrument_type::hypersynth': hypersynth_data_tail
            'instrument_type::midi_out': standard_data_tail
            'instrument_type::wavsynth': standard_data_tail
            'instrument_type::macrosynth': standard_data_tail
            'instrument_type::fm_synth': standard_data_tail
            'instrument_type::external': standard_data_tail
            'instrument_type::none': none_data_tail
        doc: Instrument-specific tail after the common EQ field.
  general_instrument_settings:
    doc: |
      Contiguous General Instrument Settings prefix. The M8 manual also groups
      the noncontiguous eq assignment with these settings.
    seq:
      - id: type
        type: u1
        enum: instrument_type
      - id: name
        size: 12
        doc: |
          Fixed-size byte range for the instrument name. Padding bytes are
          preserved as stored.
      - id: transpose
        type: u1
        doc: |
          Common instrument transpose setting. Observed values: 0x01 means ON,
          0x00 means OFF.
      - id: table_tic
        type: u1
        doc: Common instrument table TIC setting.
  unused_body_before_eq:
    doc: |
      Preserved bytes between the common instrument prefix and common EQ field
      for NONE.
    seq:
      - id: unknown
        size: 47
  wavsynth_body_before_eq:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: instrument_parameters_6_0_1::wavsynth_params
      - id: filter
        type: instrument_parameters_6_0_1::filter_params
      - id: amp
        type: instrument_parameters_6_0_1::amp_params
      - id: mixer
        type: instrument_parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 29
  macrosynth_body_before_eq:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: instrument_parameters_6_0_1::macrosynth_params
      - id: filter
        type: instrument_parameters_6_0_1::filter_params
      - id: amp
        type: instrument_parameters_6_0_1::amp_params
      - id: mixer
        type: instrument_parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 29
  sampler_body_before_eq:
    doc: |
      Sampler-specific controls are stored here; the selected sample_path is
      another Sampler-specific parameter stored in sampler_data_tail.
    seq:
      - id: unknown_0
        size: 2
      - id: controls
        type: instrument_parameters_6_0_1::sampler_controls
      - id: filter
        type: instrument_parameters_6_0_1::filter_params
      - id: amp
        type: instrument_parameters_6_0_1::amp_params
      - id: mixer
        type: instrument_parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 28
  midi_out_body_before_eq:
    seq:
      - id: params
        type: instrument_parameters_6_0_1::midi_out_params
      - id: unknown
        size: 18
  fm_synth_body_before_eq:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: instrument_parameters_6_0_1::fm_synth_params
      - id: filter
        type: instrument_parameters_6_0_1::filter_params
        doc: |
          Type, cutoff, and resonance offsets are verified by FM_PARAMS.
      - id: amp
        type: instrument_parameters_6_0_1::amp_params
        doc: |
          Amp, limit, and pan offsets are verified by FM_PARAMS.
      - id: mixer
        type: instrument_parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 1
  hypersynth_body_before_eq:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: instrument_parameters_6_0_1::hypersynth_params
      - id: filter
        type: instrument_parameters_6_0_1::filter_params
      - id: amp
        type: instrument_parameters_6_0_1::amp_params
      - id: mixer
        type: instrument_parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 22
  external_body_before_eq:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: instrument_parameters_6_0_1::external_params
      - id: filter
        type: instrument_parameters_6_0_1::filter_params
      - id: amp
        type: instrument_parameters_6_0_1::amp_params
      - id: mixer
        type: instrument_parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 21
  standard_data_tail:
    seq:
      - id: modulators
        type: instrument_modulators
      - id: unknown
        size: 128
  none_data_tail:
    seq:
      - id: unknown
        size: 152
  sampler_data_tail:
    doc: |
      Stores shared modulators followed by the Sampler-specific sample_path.
      The path and sampler_controls belong to the same instrument-specific
      configuration despite their noncontiguous storage.
    seq:
      - id: modulators
        type: instrument_modulators
      - id: sample_path
        type: sample_path_region
        size: 128
        doc: |
          Selected sample path in a fixed 128-byte field, following the same
          null-terminated path and preserved trailing-byte convention as the
          Song directory. SAM_PARAMS stores /Samples/Kick.wav at offset 0x65.
          The M8 manual requires the entire path to be under 128 characters.
  sample_path_region:
    seq:
      - id: path
        type: strz
        encoding: ASCII
      - id: trailing
        size: _io.size - _io.pos
        doc: Remaining path-field bytes after the terminator; preserve stored bytes.
  hypersynth_data_tail:
    seq:
      - id: modulators
        type: instrument_modulators
      - id: chords
        type: hypersynth_chord
        repeat: expr
        repeat-expr: 16
      - id: unknown
        size: 16
  hypersynth_chord:
    seq:
      - id: enabled_notes
        type: u1
        doc: |
          Observed as a bit mask for six chord notes. Chord 0 changed from
          0xff to 0xfe when note 1 was unset. Chord 15 changed from 0xff to
          0xdf when note 6 was unset.
      - id: notes
        type: instrument_parameters_6_0_1::hypersynth_chord_notes
  instrument_modulators:
    doc: |
      Shared Common Modulation Settings block. Four six-byte slots occupy
      standalone offsets 0x4d..0x64 in all seven editable instrument types.
      slots[0] is M8 modulation slot 1. NONE preserves the corresponding
      bytes as unknown, without assigning modulation semantics.
    seq:
      - id: slots
        type: instrument_modulation_6_0_1::modulation_slot
        repeat: expr
        repeat-expr: 4
enums:
  wavsynth_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: volume
      -label: VOLUME
    0x02:
      id: pitch
      -label: PITCH
    0x03:
      id: size
      -label: SIZE
    0x04:
      id: mult
      -label: MULT
    0x05:
      id: warp
      -label: WARP
    0x06:
      id: scan
      -label: SCAN
    0x07:
      id: cutoff
      -label: CUTOFF
    0x08:
      id: resonance
      -label: RES
    0x09:
      id: amp
      -label: AMP
    0x0a:
      id: pan
      -label: PAN
    0x0b:
      id: mod_amount
      -label: MOD AMT
    0x0c:
      id: mod_rate
      -label: MOD RATE
    0x0d:
      id: mod_both
      -label: MOD BOTH
    0x0e:
      id: mod_binv
      -label: MOD BINV
  macrosynth_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: volume
      -label: VOLUME
    0x02:
      id: pitch
      -label: PITCH
    0x03:
      id: timbre
      -label: TIMBRE
    0x04:
      id: color
      -label: COLOR
    0x05:
      id: degrade
      -label: DEGRADE
    0x06:
      id: redux
      -label: REDUX
    0x07:
      id: cutoff
      -label: CUTOFF
    0x08:
      id: resonance
      -label: RES
    0x09:
      id: amp
      -label: AMP
    0x0a:
      id: pan
      -label: PAN
    0x0b:
      id: mod_amount
      -label: MOD AMT
    0x0c:
      id: mod_rate
      -label: MOD RATE
    0x0d:
      id: mod_both
      -label: MOD BOTH
    0x0e:
      id: mod_binv
      -label: MOD BINV
  sampler_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: volume
      -label: VOLUME
    0x02:
      id: pitch
      -label: PITCH
    0x03:
      id: loop_start
      -label: LOOP ST
    0x04:
      id: length
      -label: LENGTH
    0x05:
      id: degrade
      -label: DEGRADE
    0x06:
      id: cutoff
      -label: CUTOFF
    0x07:
      id: resonance
      -label: RES
    0x08:
      id: amp
      -label: AMP
    0x09:
      id: pan
      -label: PAN
    0x0a:
      id: mod_amount
      -label: MOD AMT
    0x0b:
      id: mod_rate
      -label: MOD RATE
    0x0c:
      id: mod_both
      -label: MOD BOTH
    0x0d:
      id: mod_binv
      -label: MOD BINV
  midi_out_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: cc_a
      -label: CCA
    0x02:
      id: cc_b
      -label: CCB
    0x03:
      id: cc_c
      -label: CCC
    0x04:
      id: cc_d
      -label: CCD
    0x05:
      id: cc_e
      -label: CCE
    0x06:
      id: cc_f
      -label: CCF
    0x07:
      id: cc_g
      -label: CCG
    0x08:
      id: cc_h
      -label: CCH
    0x09:
      id: cc_i
      -label: CCI
    0x0a:
      id: cc_j
      -label: CCJ
    0x0b:
      id: mod_amount
      -label: MOD AMT
    0x0c:
      id: mod_rate
      -label: MOD RATE
    0x0d:
      id: mod_both
      -label: MOD BOTH
    0x0e:
      id: mod_binv
      -label: MOD BINV
  fm_synth_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: volume
      -label: VOLUME
    0x02:
      id: pitch
      -label: PITCH
    0x03:
      id: mod_1
      -label: MOD 1
    0x04:
      id: mod_2
      -label: MOD 2
    0x05:
      id: mod_3
      -label: MOD 3
    0x06:
      id: mod_4
      -label: MOD 4
    0x07:
      id: cutoff
      -label: CUTOFF
    0x08:
      id: resonance
      -label: RES
    0x09:
      id: amp
      -label: AMP
    0x0a:
      id: pan
      -label: PAN
    0x0b:
      id: mod_amount
      -label: MOD AMT
    0x0c:
      id: mod_rate
      -label: MOD RATE
    0x0d:
      id: mod_both
      -label: MOD BOTH
    0x0e:
      id: mod_binv
      -label: MOD BINV
  hypersynth_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: volume
      -label: VOLUME
    0x02:
      id: pitch
      -label: PITCH
    0x03:
      id: shift
      -label: SHIFT
    0x04:
      id: swarm
      -label: SWARM
    0x05:
      id: width
      -label: WIDTH
    0x06:
      id: subosc
      -label: SUBOSC
    0x07:
      id: cutoff
      -label: CUTOFF
    0x08:
      id: resonance
      -label: RES
    0x09:
      id: amp
      -label: AMP
    0x0a:
      id: pan
      -label: PAN
    0x0b:
      id: mod_amount
      -label: MOD AMT
    0x0c:
      id: mod_rate
      -label: MOD RATE
    0x0d:
      id: mod_both
      -label: MOD BOTH
    0x0e:
      id: mod_binv
      -label: MOD BINV
  external_modulation_destination:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: volume
      -label: VOLUME
    0x02:
      id: cutoff
      -label: CUTOFF
    0x03:
      id: resonance
      -label: RES
    0x04:
      id: amp
      -label: AMP
    0x05:
      id: pan
      -label: PAN
    0x06:
      id: cc_a
      -label: CCA
    0x07:
      id: cc_b
      -label: CCB
    0x08:
      id: cc_c
      -label: CCC
    0x09:
      id: cc_d
      -label: CCD
    0x0a:
      id: mod_amount
      -label: MOD AMT
    0x0b:
      id: mod_rate
      -label: MOD RATE
    0x0c:
      id: mod_both
      -label: MOD BOTH
    0x0d:
      id: mod_binv
      -label: MOD BINV
  instrument_type:
    0x00:
      id: wavsynth
      -label: Wavsynth
    0x01:
      id: macrosynth
      -label: Macrosynth
    0x02:
      id: sampler
      -label: Sampler
    0x03:
      id: midi_out
      -label: MIDI Out
    0x04:
      id: fm_synth
      -label: FM Synth
    0x05:
      id: hypersynth
      -label: Hypersynth
    0x06:
      id: external
      -label: External
    0xff:
      id: none
      -label: NONE
