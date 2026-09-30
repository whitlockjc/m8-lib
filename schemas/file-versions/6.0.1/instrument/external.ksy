meta:
  id: external_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - parameters
doc: External specific parameters.
types:
  instrument_params:
    seq:
      - id: input
        type: u1
        enum: input
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
      - id: program_change
        type: u1
        doc: |
          Program change, displayed in decimal; program 126 is stored as 0x7e.
      - id: custom_ccs
        type: parameters_6_0_1::custom_cc
        repeat: expr
        repeat-expr: 4
        doc: Four configurable MIDI controller number and value pairs.
enums:
  input:
    0x00:
      id: line_in_stereo
      -label: LINE-IN STEREO
    0x01:
      id: line_in_left
      -label: LINE-IN LEFT
    0x02:
      id: line_in_right
      -label: LINE-IN RIGHT
    0x03:
      id: usb_stereo
      -label: USB STEREO
    0x04:
      id: usb_left
      -label: USB LEFT
    0x05:
      id: usb_right
      -label: USB RIGHT
    0x06:
      id: all_stereo
      -label: ALL STEREO
    0x07:
      id: all_left
      -label: ALL LEFT
    0x08:
      id: all_right
      -label: ALL RIGHT
  port:
    0x00:
      id: none
      -label: NONE
    0x01:
      id: midi_usb
      -label: MIDI+USB
    0x02:
      id: midi
      -label: MIDI
    0x03:
      id: usb
      -label: USB
  destination:
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
  fx_command:
    0x80:
      id: volume
      -label: VOL
    0x81:
      id: pitch
      -label: PIT
    0x82:
      id: midi_program_bank
      -label: MPB
    0x83:
      id: midi_program
      -label: MPG
    0x84:
      id: cc_a
      -label: CCA
    0x85:
      id: cc_b
      -label: CCB
    0x86:
      id: cc_c
      -label: CCC
    0x87:
      id: cc_d
      -label: CCD
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
      id: add
      -label: ADD
    0xa7:
      id: chord
      -label: CHD
    0xff:
      id: unset
      -label: --
