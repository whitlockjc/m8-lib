meta:
  id: fm_synth_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: FM Synth specific parameters.
types:
  instrument_params:
    seq:
      - id: algo
        type: u1
        enum: algorithm
      - id: operator_shapes
        type: operator_shapes
      - id: operator_ratios
        type: operator_ratios
      - id: operator_levels
        type: operator_level_feedbacks
      - id: operator_mod_a
        type: operator_mod_slots
      - id: operator_mod_b
        type: operator_mod_slots
      - id: mods
        type: mod_values
  operator_shapes:
    seq:
      - id: operator_1
        type: u1
        enum: operator_shape
      - id: operator_2
        type: u1
        enum: operator_shape
      - id: operator_3
        type: u1
        enum: operator_shape
      - id: operator_4
        type: u1
        enum: operator_shape
  operator_ratios:
    seq:
      - id: operator_1
        type: operator_ratio
      - id: operator_2
        type: operator_ratio
      - id: operator_3
        type: operator_ratio
      - id: operator_4
        type: operator_ratio
  operator_ratio:
    seq:
      - id: ratio
        type: u1
      - id: ratio_fine
        type: u1
  operator_level_feedbacks:
    seq:
      - id: operator_1
        type: operator_level_feedback
      - id: operator_2
        type: operator_level_feedback
      - id: operator_3
        type: operator_level_feedback
      - id: operator_4
        type: operator_level_feedback
  operator_level_feedback:
    seq:
      - id: level
        type: u1
      - id: feedback
        type: u1
  operator_mod_slots:
    seq:
      - id: operator_1
        type: u1
        enum: operator_mod_slot
      - id: operator_2
        type: u1
        enum: operator_mod_slot
      - id: operator_3
        type: u1
        enum: operator_mod_slot
      - id: operator_4
        type: u1
        enum: operator_mod_slot
  mod_values:
    seq:
      - id: mod_1
        type: u1
      - id: mod_2
        type: u1
      - id: mod_3
        type: u1
      - id: mod_4
        type: u1
enums:
  algorithm:
    0x00:
      id: algorithm_00
      -label: A>B>C>D
    0x01:
      id: algorithm_01
      -label: '[A+B]>C>D'
    0x02:
      id: algorithm_02
      -label: '[A>B+C]>D'
    0x03:
      id: algorithm_03
      -label: '[A>B+A>C]>D'
    0x04:
      id: algorithm_04
      -label: '[A+B+C]>D'
    0x05:
      id: algorithm_05
      -label: '[A>B>C]+D'
    0x06:
      id: algorithm_06
      -label: '[A>B>C]+[A>B>D]'
    0x07:
      id: algorithm_07
      -label: '[A>B]+[C>D]'
    0x08:
      id: algorithm_08
      -label: '[A>B]+[A>C]+[A>D]'
    0x09:
      id: algorithm_09
      -label: '[A>B]+[A>C]+D'
    0x0a:
      id: algorithm_0a
      -label: '[A>B]+C+D'
    0x0b:
      id: algorithm_0b
      -label: A+B+C+D
  operator_shape:
    0x00:
      id: sin
      -label: SIN
    0x01:
      id: sw2
      -label: SW2
    0x02:
      id: sw3
      -label: SW3
    0x03:
      id: sw4
      -label: SW4
    0x04:
      id: sw5
      -label: SW5
    0x05:
      id: sw6
      -label: SW6
    0x06:
      id: tri
      -label: TRI
    0x07:
      id: saw
      -label: SAW
    0x08:
      id: squ
      -label: SQU
    0x09:
      id: pul
      -label: PUL
    0x0a:
      id: imp
      -label: IMP
    0x0b:
      id: noi
      -label: NOI
    0x0c:
      id: nlp
      -label: NLP
    0x0d:
      id: nhp
      -label: NHP
    0x0e:
      id: nbp
      -label: NBP
    0x0f:
      id: clk
      -label: CLK
    0x10:
      id: w09
      -label: W09
    0x11:
      id: w0a
      -label: W0A
    0x12:
      id: w0b
      -label: W0B
    0x13:
      id: w0c
      -label: W0C
    0x14:
      id: w0d
      -label: W0D
    0x15:
      id: w0e
      -label: W0E
    0x16:
      id: w0f
      -label: W0F
    0x17:
      id: w10
      -label: W10
    0x18:
      id: w11
      -label: W11
    0x19:
      id: w12
      -label: W12
    0x1a:
      id: w13
      -label: W13
    0x1b:
      id: w14
      -label: W14
    0x1c:
      id: w15
      -label: W15
    0x1d:
      id: w16
      -label: W16
    0x1e:
      id: w17
      -label: W17
    0x1f:
      id: w18
      -label: W18
    0x20:
      id: w19
      -label: W19
    0x21:
      id: w1a
      -label: W1A
    0x22:
      id: w1b
      -label: W1B
    0x23:
      id: w1c
      -label: W1C
    0x24:
      id: w1d
      -label: W1D
    0x25:
      id: w1e
      -label: W1E
    0x26:
      id: w1f
      -label: W1F
    0x27:
      id: w20
      -label: W20
    0x28:
      id: w21
      -label: W21
    0x29:
      id: w22
      -label: W22
    0x2a:
      id: w23
      -label: W23
    0x2b:
      id: w24
      -label: W24
    0x2c:
      id: w25
      -label: W25
    0x2d:
      id: w26
      -label: W26
    0x2e:
      id: w27
      -label: W27
    0x2f:
      id: w28
      -label: W28
    0x30:
      id: w29
      -label: W29
    0x31:
      id: w2a
      -label: W2A
    0x32:
      id: w2b
      -label: W2B
    0x33:
      id: w2c
      -label: W2C
    0x34:
      id: w2d
      -label: W2D
    0x35:
      id: w2e
      -label: W2E
    0x36:
      id: w2f
      -label: W2F
    0x37:
      id: w30
      -label: W30
    0x38:
      id: w31
      -label: W31
    0x39:
      id: w32
      -label: W32
    0x3a:
      id: w33
      -label: W33
    0x3b:
      id: w34
      -label: W34
    0x3c:
      id: w35
      -label: W35
    0x3d:
      id: w36
      -label: W36
    0x3e:
      id: w37
      -label: W37
    0x3f:
      id: w38
      -label: W38
    0x40:
      id: w39
      -label: W39
    0x41:
      id: w3a
      -label: W3A
    0x42:
      id: w3b
      -label: W3B
    0x43:
      id: w3c
      -label: W3C
    0x44:
      id: w3d
      -label: W3D
    0x45:
      id: w3e
      -label: W3E
    0x46:
      id: w3f
      -label: W3F
    0x47:
      id: w40
      -label: W40
    0x48:
      id: w41
      -label: W41
    0x49:
      id: w42
      -label: W42
    0x4a:
      id: w43
      -label: W43
    0x4b:
      id: w44
      -label: W44
    0x4c:
      id: w45
      -label: W45
  operator_mod_slot:
    0x00:
      id: unset
      -label: --
    0x01:
      id: operator_1_level
      -label: 1>LEV
    0x02:
      id: operator_2_level
      -label: 2>LEV
    0x03:
      id: operator_3_level
      -label: 3>LEV
    0x04:
      id: operator_4_level
      -label: 4>LEV
    0x05:
      id: operator_1_ratio
      -label: 1>RAT
    0x06:
      id: operator_2_ratio
      -label: 2>RAT
    0x07:
      id: operator_3_ratio
      -label: 3>RAT
    0x08:
      id: operator_4_ratio
      -label: 4>RAT
    0x09:
      id: operator_1_pitch
      -label: 1>PIT
    0x0a:
      id: operator_2_pitch
      -label: 2>PIT
    0x0b:
      id: operator_3_pitch
      -label: 3>PIT
    0x0c:
      id: operator_4_pitch
      -label: 4>PIT
    0x0d:
      id: operator_1_feedback
      -label: 1>FBK
    0x0e:
      id: operator_2_feedback
      -label: 2>FBK
    0x0f:
      id: operator_3_feedback
      -label: 3>FBK
    0x10:
      id: operator_4_feedback
      -label: 4>FBK
  destination:
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
  fx_command:
    0x80:
      id: volume
      -label: VOL
    0x81:
      id: pitch
      -label: PIT
    0x82:
      id: fine
      -label: FIN
    0x83:
      id: algorithm
      -label: ALG
    0x84:
      id: fm1
      -label: FM1
    0x85:
      id: fm2
      -label: FM2
    0x86:
      id: fm3
      -label: FM3
    0x87:
      id: fm4
      -label: FM4
    0x88:
      id: filter
      -label: FIL
    0x89:
      id: cutoff
      -label: CUT
    0x8a:
      id: resonance
      -label: RES
    0x8b:
      id: amp
      -label: AMP
    0x8c:
      id: limit
      -label: LIM
    0x8d:
      id: pan
      -label: PAN
    0x8e:
      id: dry
      -label: DRY
    0x8f:
      id: smx
      -label: SMX
    0x90:
      id: send_delay
      -label: SDL
    0x91:
      id: send_reverb
      -label: SRV
    0xa6:
      id: snc
      -label: SNC
    0xa7:
      id: err
      -label: ERR
    0xff:
      id: unset
      -label: --
