meta:
  id: instrument_table_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - ../../../common/fx_slot
doc: |
  Sixteen eight-byte Instrument Table rows for file schema 6.0.1.
  Standalone Instruments append one table; Songs store 256 tables separately.
  FX command catalogs depend on the active instrument and remain contextual.
seq:
  - id: rows
    type: table_row
    repeat: expr
    repeat-expr: 16
types:
  table_row:
    seq:
      - id: transpose
        type: u1
      - id: volume
        type: u1
        doc: Observed value 0xff displays as --.
      - id: fx
        type: fx_slot
        repeat: expr
        repeat-expr: 3
enums:
  wavsynth_table_fx_command:
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
      id: oscillator
      -label: OSC
    0x84:
      id: size
      -label: SIZ
    0x85:
      id: mult
      -label: MUL
    0x86:
      id: warp
      -label: WRP
    0x87:
      id: scan
      -label: SCN
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
  macrosynth_table_fx_command:
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
      id: oscillator
      -label: OSC
    0x84:
      id: timbre
      -label: TBR
    0x85:
      id: color
      -label: COL
    0x86:
      id: degrade
      -label: DEG
    0x87:
      id: redux
      -label: RED
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
      id: trigger
      -label: TRG
    0xa7:
      id: err
      -label: ERR
    0xff:
      id: unset
      -label: --
  sampler_table_fx_command:
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
      id: play
      -label: PLY
    0x84:
      id: start
      -label: STA
    0x85:
      id: loop
      -label: LOP
    0x86:
      id: length
      -label: LEN
    0x87:
      id: degrade
      -label: DEG
    0x88:
      id: filter
      -label: FLT
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
      id: slice
      -label: SLI
    0xa7:
      id: err
      -label: ERR
    0xff:
      id: unset
      -label: --
  fm_synth_table_fx_command:
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
  midi_out_table_fx_command:
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
  hypersynth_table_fx_command:
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
  external_table_fx_command:
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
  none_table_fx_command:
    0xff:
      id: unset
      -label: --
