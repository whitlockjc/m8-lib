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
      The EQ assignment follows the type-specific region.
    seq:
      - id: general_settings
        type: general_settings
      - id: params
        type:
          switch-on: general_settings.type
          cases:
            'type::wavsynth': wavsynth_params
            'type::macrosynth': macrosynth_params
            'type::sampler': sampler_params
            'type::midi_out': midi_out_params
            'type::fm_synth': fm_synth_params
            'type::hypersynth': hypersynth_params
            'type::external': external_params
            'type::none': unused_params
        doc: Instrument settings before the common EQ field.
      - id: eq
        type: u1
        doc: |
          Common instrument EQ assignment. 0x80 displays as
          --, 0x7f displays as 7F.
      - id: tail
        type:
          switch-on: general_settings.type
          cases:
            'type::sampler': sampler_tail
            'type::hypersynth': hypersynth_tail
            'type::midi_out': standard_tail
            'type::wavsynth': standard_tail
            'type::macrosynth': standard_tail
            'type::fm_synth': standard_tail
            'type::external': standard_tail
            'type::none': none_tail
        doc: Instrument-specific tail after the common EQ field.
  general_settings:
    doc: |
      General Instrument Settings prefix. The EQ assignment is stored separately.
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
  unused_params:
    doc: |
      Preserved bytes between the common instrument prefix and common EQ field
      for NONE.
    seq:
      - id: unknown
        size: 47
  wavsynth_params:
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
  macrosynth_params:
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
  sampler_params:
    doc: |
      Sampler-specific controls are stored here; the selected sample_path is
      another Sampler-specific parameter stored in sampler_tail.
    seq:
      - id: unknown_0
        size: 2
      - id: controls
        type: sampler_6_0_1::instrument_params
      - id: filter
        type: parameters_6_0_1::filter_params
      - id: amp
        type: parameters_6_0_1::amp_params
      - id: mixer
        type: parameters_6_0_1::mixer_params
      - id: unknown_1
        size: 28
  midi_out_params:
    seq:
      - id: params
        type: midi_out_6_0_1::instrument_params
      - id: unknown
        size: 18
  fm_synth_params:
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
  hypersynth_params:
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
  external_params:
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
  standard_tail:
    seq:
      - id: modulators
        type: modulators
      - id: unknown
        size: 128
  none_tail:
    seq:
      - id: unknown
        size: 152
  sampler_tail:
    doc: |
      Stores shared modulators followed by the Sampler-specific sample_path.
      The path and instrument_params belong to the same instrument-specific
      configuration despite their noncontiguous storage.
    seq:
      - id: modulators
        type: modulators
      - id: sample_path
        type: sampler_6_0_1::sample_path
        size: 128
        doc: |
          Selected sample path in a fixed 128-byte field, following the same
          null-terminated path and preserved trailing-byte convention as the
          Song directory. The full sample path must be under 128 characters.
  hypersynth_tail:
    seq:
      - id: modulators
        type: modulators
      - id: chords
        type: hypersynth_6_0_1::chord
        repeat: expr
        repeat-expr: 16
      - id: unknown
        size: 16
  modulators:
    doc: |
      Shared Common Modulation Settings block. Four six-byte slots occupy
      standalone offsets 0x4d..0x64 in all seven editable instrument types.
      slots[0] is M8 modulation slot 1. NONE preserves the corresponding
      bytes as unknown, without assigning modulation semantics.
    seq:
      - id: slots
        type: modulation_6_0_1::slot
        repeat: expr
        repeat-expr: 4
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
