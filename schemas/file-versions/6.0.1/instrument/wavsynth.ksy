meta:
  id: wavsynth_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: Wavsynth specific parameters.
types:
  instrument_params:
    seq:
      - id: shape
        type: u1
        enum: shape
      - id: size
        type: u1
      - id: mult
        type: u1
      - id: warp
        type: u1
      - id: scan
        type: u1
enums:
  shape:
    0x00:
      id: pulse_12_percent
      -label: PULSE 12%
    0x01:
      id: pulse_25_percent
      -label: PULSE 25%
    0x02:
      id: pulse_50_percent
      -label: PULSE 50%
    0x03:
      id: pulse_75_percent
      -label: PULSE 75%
    0x04:
      id: saw
      -label: SAW
    0x05:
      id: triangle
      -label: TRIANGLE
    0x06:
      id: sine
      -label: SINE
    0x07:
      id: noise_pitched
      -label: NOISE PITCHED
    0x08:
      id: noise
      -label: NOISE
    0x09:
      id: osc_crush
      -label: OSC:CRUSH
    0x0a:
      id: osc_folding
      -label: OSC:FOLDING
    0x0b:
      id: osc_freq
      -label: OSC:FREQ
    0x0c:
      id: osc_fuzzy
      -label: OSC:FUZZY
    0x0d:
      id: osc_ghost
      -label: OSC:GHOST
    0x0e:
      id: osc_graphic
      -label: OSC:GRAPHIC
    0x0f:
      id: osc_lfoplay
      -label: OSC:LFOPLAY
    0x10:
      id: osc_liquid
      -label: OSC:LIQUID
    0x11:
      id: osc_morphing
      -label: OSC:MORPHING
    0x12:
      id: osc_mystic
      -label: OSC:MYSTIC
    0x13:
      id: osc_sticky
      -label: OSC:STICKY
    0x14:
      id: osc_tidal
      -label: OSC:TIDAL
    0x15:
      id: osc_tidy
      -label: OSC:TIDY
    0x16:
      id: osc_tube
      -label: OSC:TUBE
    0x17:
      id: osc_umbrella
      -label: OSC:UMBRELLA
    0x18:
      id: osc_unwind
      -label: OSC:UNWIND
    0x19:
      id: osc_viral
      -label: OSC:VIRAL
    0x1a:
      id: osc_waves
      -label: OSC:WAVES
    0x1b:
      id: bnk_drip
      -label: BNK:DRIP
    0x1c:
      id: bnk_froggy
      -label: BNK:FROGGY
    0x1d:
      id: bnk_insonic
      -label: BNK:INSONIC
    0x1e:
      id: bnk_radius
      -label: BNK:RADIUS
    0x1f:
      id: bnk_scratch
      -label: BNK:SCRATCH
    0x20:
      id: bnk_smooth
      -label: BNK:SMOOTH
    0x21:
      id: bnk_wobble
      -label: BNK:WOBBLE
    0x22:
      id: hrm_asymmtry
      -label: HRM:ASYMMTRY
    0x23:
      id: hrm_bleen
      -label: HRM:BLEEN
    0x24:
      id: hrm_fractal
      -label: HRM:FRACTAL
    0x25:
      id: hrm_gentle
      -label: HRM:GENTLE
    0x26:
      id: hrm_harmonic
      -label: HRM:HARMONIC
    0x27:
      id: hrm_hypnotic
      -label: HRM:HYPNOTIC
    0x28:
      id: hrm_iterativ
      -label: HRM:ITERATIV
    0x29:
      id: hrm_microwav
      -label: HRM:MICROWAV
    0x2a:
      id: hrm_plaits01
      -label: HRM:PLAITS01
    0x2b:
      id: hrm_plaits02
      -label: HRM:PLAITS02
    0x2c:
      id: hrm_risefall
      -label: HRM:RISEFALL
    0x2d:
      id: hrm_tonal
      -label: HRM:TONAL
    0x2e:
      id: hrm_twine
      -label: HRM:TWINE
    0x2f:
      id: efx_alien
      -label: EFX:ALIEN
    0x30:
      id: efx_cybernet
      -label: EFX:CYBERNET
    0x31:
      id: efx_disordr
      -label: EFX:DISORDR
    0x32:
      id: efx_formant
      -label: EFX:FORMANT
    0x33:
      id: efx_hyper
      -label: EFX:HYPER
    0x34:
      id: efx_jagged
      -label: EFX:JAGGED
    0x35:
      id: efx_mixed
      -label: EFX:MIXED
    0x36:
      id: efx_multiply
      -label: EFX:MULTIPLY
    0x37:
      id: efx_nowhere
      -label: EFX:NOWHERE
    0x38:
      id: efx_pinball
      -label: EFX:PINBALL
    0x39:
      id: efx_rings
      -label: EFX:RINGS
    0x3a:
      id: efx_shimmer
      -label: EFX:SHIMMER
    0x3b:
      id: efx_spectral
      -label: EFX:SPECTRAL
    0x3c:
      id: efx_spooky
      -label: EFX:SPOOKY
    0x3d:
      id: efx_transfrm
      -label: EFX:TRANSFRM
    0x3e:
      id: efx_twisted
      -label: EFX:TWISTED
    0x3f:
      id: efx_vocal
      -label: EFX:VOCAL
    0x40:
      id: efx_washed
      -label: EFX:WASHED
    0x41:
      id: efx_wonder
      -label: EFX:WONDER
    0x42:
      id: efx_wowee
      -label: EFX:WOWEE
    0x43:
      id: efx_zap
      -label: EFX:ZAP
    0x44:
      id: vox_braids
      -label: VOX:BRAIDS
    0x45:
      id: vox_voxsynth
      -label: VOX:VOXSYNTH
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
