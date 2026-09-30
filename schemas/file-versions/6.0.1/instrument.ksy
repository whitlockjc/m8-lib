meta:
  id: instrument_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - instrument/modulation
    - instrument/parameters
    - instrument/table
    - instrument/wavsynth
    - instrument/macrosynth
    - instrument/sampler
    - instrument/midi_out
    - instrument/fm_synth
    - instrument/hypersynth
    - instrument/external
    - instrument/none
doc: |
  Instrument body for file schema version 6.0.1, containing an instrument
  record and its table.
seq:
  - id: instrument
    type: data
  - id: table
    type: table_6_0_1
types:
  data:
    doc: |
      Fixed 215-byte instrument record. This record is stored directly in Song
      files; standalone Instrument files append one 128-byte instrument table.
    seq:
      - id: general_settings
        type: general_settings
      - id: body
        type:
          switch-on: general_settings.type
          cases:
            'type::wavsynth': wavsynth_body
            'type::macrosynth': macrosynth_body
            'type::sampler': sampler_body
            'type::midi_out': midi_out_body
            'type::fm_synth': fm_synth_body
            'type::hypersynth': hypersynth_body
            'type::external': external_body
            'type::none': none_body
        doc: Instrument body selected by type.
  general_settings:
    doc: General Instrument Settings prefix.
    seq:
      - id: type
        type: u1
        enum: type
      - id: name
        size: 12
        doc: |
          Fixed-size byte range for the instrument name. Padding bytes are
          preserved as stored.
      - id: transpose
        type: u1
        doc: |
          Common instrument transpose setting. 0x01 means ON;
          0x00 means OFF.
      - id: table_tic
        type: u1
        doc: Common instrument table TIC setting.
  none_body:
    seq:
      - id: unknown
        size: 200
  wavsynth_body:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: wavsynth_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 29
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: unknown_2
        size: 128
  macrosynth_body:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: macrosynth_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 29
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: unknown_2
        size: 128
  sampler_body:
    doc: |
      Sampler-specific controls are stored here; the selected sample_path is
      another Sampler-specific parameter stored later in this body.
    seq:
      - id: unknown_0
        size: 2
      - id: params
        type: sampler_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 28
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: sample_path
        type: sampler_6_0_1::sample_path
        size: 128
        doc: |
          Selected sample path in a fixed 128-byte field, following the same
          null-terminated path and preserved trailing-byte convention as the
          Song directory. The full sample path must be under 128 characters.
  midi_out_body:
    seq:
      - id: params
        type: midi_out_6_0_1::instrument_params
      - id: unknown_0
        size: 18
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: unknown_1
        size: 128
  fm_synth_body:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: fm_synth_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 1
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: unknown_2
        size: 128
  hypersynth_body:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: hypersynth_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 22
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: chords
        type: hypersynth_6_0_1::chord
        repeat: expr
        repeat-expr: 16
      - id: unknown_2
        size: 16
  external_body:
    seq:
      - id: unknown_0
        size: 3
      - id: params
        type: external_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 21
      - id: eq
        type: u1
        doc: Common instrument EQ assignment. 0x80 displays as --; 0x7f displays as 7F.
      - id: modulators
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
      - id: unknown_2
        size: 128
enums:
  type:
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
