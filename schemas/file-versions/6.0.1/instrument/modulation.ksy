meta:
  id: instrument_modulation_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Shared modulation slot storage for M8 Instrument file schema 6.0.1.
  Destination labels remain contextual to the enclosing instrument type.
types:
  slot:
    doc: |
      Shared six-byte modulation slot: one packed type/destination byte, one
      amount byte, and four type-dependent parameter bytes. The first two
      bytes are Common Modulation Settings; params selects one of six
      modulation-type-specific structures. The slot layout is independent of
      the instrument-specific destination labels.
    seq:
      - id: type_and_destination
        type: u1
        doc: |
          Packed byte: high nibble stores modulation type, low nibble stores
          destination. Destination labels are instrument-specific.
      - id: amount
        type: u1
        doc: Modulation amount.
      - id: params
        type:
          switch-on: modulation_type
          cases:
            'type::ahd_env': ahd_env_params
            'type::adsr_env': adsr_env_params
            'type::drum_env': drum_env_params
            'type::lfo': lfo_params
            'type::trig_env': trig_env_params
            'type::tracking': tracking_params
        doc: Four-byte payload interpreted according to the modulation type.
    instances:
      modulation_type:
        value: type_and_destination >> 4
        enum: type
      destination:
        value: type_and_destination & 0x0f
        doc: |
          Raw destination nibble shared by all modulation slots. Interpret it
          using the enclosing instrument type and its corresponding one of
          seven modulation destination enums in instrument.ksy. No single
          enum is valid for every instrument.
  ahd_env_params:
    doc: AHD ENV payload; fourth byte is preserved with unknown purpose.
    seq:
      - id: attack
        type: u1
        doc: Attack setting.
      - id: hold
        type: u1
        doc: Hold setting.
      - id: decay
        type: u1
        doc: Decay setting.
      - id: unknown
        type: u1
  adsr_env_params:
    seq:
      - id: attack
        type: u1
      - id: decay
        type: u1
      - id: sustain
        type: u1
      - id: release
        type: u1
  drum_env_params:
    doc: DRUM ENV payload; fourth byte is preserved with unknown purpose.
    seq:
      - id: peak
        type: u1
      - id: body
        type: u1
      - id: decay
        type: u1
      - id: unknown
        type: u1
  lfo_params:
    doc: LFO payload; fourth byte is preserved with unknown purpose.
    seq:
      - id: oscillator
        type: u1
        enum: lfo_oscillator
      - id: trigger
        type: u1
        enum: lfo_trigger
      - id: frequency
        type: u1
      - id: unknown
        type: u1
  trig_env_params:
    seq:
      - id: attack
        type: u1
      - id: hold
        type: u1
      - id: decay
        type: u1
      - id: source
        type: u1
  tracking_params:
    doc: TRACKING payload; fourth byte is preserved with unknown purpose.
    seq:
      - id: source
        type: u1
        enum: tracking_source
      - id: lowest_value
        type: u1
      - id: highest_value
        type: u1
      - id: unknown
        type: u1
enums:
  type:
    0x00:
      id: ahd_env
      -label: AHD ENV
    0x01:
      id: adsr_env
      -label: ADSR ENV
    0x02:
      id: drum_env
      -label: DRUM ENV
    0x03:
      id: lfo
      -label: LFO
    0x04:
      id: trig_env
      -label: TRIG ENV
    0x05:
      id: tracking
      -label: TRACKING
  tracking_source:
    0x00:
      id: note
      -label: NOTE
    0x01:
      id: velocity
      -label: VELOCITY
    0x02:
      id: velocity_take
      -label: VEL.TAKE
  lfo_oscillator:
    0x00:
      id: triangle
      -label: TRI
    0x01:
      id: sine
      -label: SIN
    0x02:
      id: ramp_down
      -label: RAMP DN
    0x03:
      id: ramp_up
      -label: RAMP UP
    0x04:
      id: exp_down
      -label: EXP DN
    0x05:
      id: exp_up
      -label: EXP UP
    0x06:
      id: square_down
      -label: SQU DN
    0x07:
      id: square_up
      -label: SQU UP
    0x08:
      id: random
      -label: RANDOM
    0x09:
      id: drunk
      -label: DRUNK
    0x0a:
      id: triangle_t
      -label: TRI T
    0x0b:
      id: sine_t
      -label: SIN T
    0x0c:
      id: ramp_down_t
      -label: RAMPDN T
    0x0d:
      id: ramp_up_t
      -label: RAMPUP T
    0x0e:
      id: exp_down_t
      -label: EXP DN T
    0x0f:
      id: exp_up_t
      -label: EXP UP T
    0x10:
      id: square_down_t
      -label: SQU DN T
    0x11:
      id: square_up_t
      -label: SQU UP T
    0x12:
      id: random_t
      -label: RAND T
    0x13:
      id: drunk_t
      -label: DRUNK T
  lfo_trigger:
    0x00:
      id: free
      -label: FREE
    0x01:
      id: retrig
      -label: RETRIG
    0x02:
      id: hold
      -label: HOLD
    0x03:
      id: once
      -label: ONCE
