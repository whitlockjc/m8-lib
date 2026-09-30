meta:
  id: midi_out_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - parameters
doc: MIDI Out specific parameters.
types:
  instrument_params:
    seq:
      - id: port
        type: u1
        enum: port
      - id: channel
        type: u1
        doc: |
          MIDI channel, displayed in decimal; channel 16 is stored as 0x10.
      - id: bank
        type: u1
        doc: |
          MIDI bank, displayed in decimal; bank 127 is stored as 0x7f.
      - id: unknown_0
        size: 2
      - id: program_change
        type: u1
        doc: |
          Program change, displayed in decimal; program 126 is stored as 0x7e.
      - id: unknown_1
        size: 3
      - id: custom_ccs
        type: parameters_6_0_1::custom_cc
        repeat: expr
        repeat-expr: 10
        doc: Ten configurable MIDI controller number and value pairs.
enums:
  port:
    0x00:
      id: midi_usb
      -label: MIDI+USB
    0x01:
      id: midi
      -label: MIDI
    0x02:
      id: usb
      -label: USB
    0x03:
      id: internal
      -label: INTERNAL
  destination:
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
  fx_command:
    0x80:
      id: volume
      -label: VOL
    0x81:
      id: pitch
      -label: PIT
    0x82:
      id: midi_program
      -label: MPG
    0x83:
      id: midi_program_bank
      -label: MPB
    0x84:
      id: add
      -label: ADD
    0x85:
      id: chord
      -label: CHD
    0x86:
      id: cc_a
      -label: CCA
    0x87:
      id: cc_b
      -label: CCB
    0x88:
      id: cc_c
      -label: CCC
    0x89:
      id: cc_d
      -label: CCD
    0x8a:
      id: cc_e
      -label: CCE
    0x8b:
      id: cc_f
      -label: CCF
    0x8c:
      id: cc_g
      -label: CCG
    0x8d:
      id: cc_h
      -label: CCH
    0x8e:
      id: cc_i
      -label: CCI
    0x8f:
      id: cc_j
      -label: CCJ
    0xff:
      id: unset
      -label: --
