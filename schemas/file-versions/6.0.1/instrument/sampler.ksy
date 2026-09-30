meta:
  id: instrument_sampler_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: Sampler specific parameters.
types:
  instrument_params:
    seq:
      - id: mode_value
        type: u1
        doc: Displayed as detune, steps, or BPM according to play_mode.
      - id: play_mode
        type: u1
        enum: play_mode
        doc: Sampler playback mode.
      - id: slice
        type: u1
        doc: Sampler slice selection.
      - id: start
        type: u1
        doc: Sample start setting.
      - id: loop_start
        type: u1
        doc: Sample loop start setting.
      - id: length
        type: u1
        doc: Sample length setting.
      - id: degrade
        type: u1
        doc: Sampler degrade setting.
  sample_path:
    seq:
      - id: path
        type: strz
        encoding: ASCII
      - id: trailing
        size: _io.size - _io.pos
        doc: Remaining path-field bytes after the terminator; preserve stored bytes.
enums:
  play_mode:
    0x00:
      id: fwd
      -label: FWD
    0x01:
      id: rev
      -label: REV
    0x02:
      id: fwdloop
      -label: FWDLOOP
    0x03:
      id: revloop
      -label: REVLOOP
    0x04:
      id: fwd_ping_pong
      -label: FWD PP
    0x05:
      id: rev_ping_pong
      -label: REV PP
    0x06:
      id: osc
      -label: OSC
    0x07:
      id: osc_rev
      -label: OSC REV
    0x08:
      id: osc_ping_pong
      -label: OSC PP
    0x09:
      id: repitch
      -label: REPITCH
    0x0a:
      id: rep_rev
      -label: REP.REV
    0x0b:
      id: rep_ping_pong
      -label: REP.PP
    0x0c:
      id: rep_bpm
      -label: REP.BPM
    0x0d:
      id: bpm_rev
      -label: BPM.REV
    0x0e:
      id: bpm_ping_pong
      -label: BPM.PP
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
