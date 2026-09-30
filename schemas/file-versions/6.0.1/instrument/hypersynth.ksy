meta:
  id: instrument_hypersynth_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: Hypersynth specific parameters.
types:
  instrument_params:
    seq:
      - id: current_chord
        type: current_chord
        doc: |
          Currently selected chord and its notes. These bytes mirror the
          selected entry in the separately stored Hypersynth chord table.
      - id: scale
        type: u1
      - id: shift
        type: u1
      - id: swarm
        type: u1
      - id: width
        type: u1
      - id: subosc
        type: u1
  current_chord:
    seq:
      - id: index
        type: u1
      - id: notes
        type: chord_notes
  chord_notes:
    seq:
      - id: note_1
        type: u1
      - id: note_2
        type: u1
      - id: note_3
        type: u1
      - id: note_4
        type: u1
      - id: note_5
        type: u1
      - id: note_6
        type: u1
  chord:
    seq:
      - id: enabled_notes
        type: u1
        doc: Bitmask for six chord notes; bits 0 through 5 indicate enabled notes.
      - id: notes
        type: chord_notes
enums:
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
      id: chord
      -label: CRD
    0x84:
      id: chord_volume
      -label: CVO
    0x85:
      id: swarm
      -label: SWM
    0x86:
      id: width
      -label: WID
    0x87:
      id: subosc
      -label: SUB
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
