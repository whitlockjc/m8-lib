meta:
  id: instrument_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for instrument files with header schema version 6.0.1.

  Initial schema verified against M8 6.5.2C NONE, Wavsynth, and Macrosynth
  instrument fixtures. The instrument type byte, fixed-size name byte range,
  and common instrument prefix are mapped. Wavsynth/Macrosynth params, filter
  params, amp params, mixer params, and common EQ assignment are mapped from the
  WAV_PARAMS and MAC_PARAMS fixtures. Unknown ranges are preserved until
  additional instrument fixtures provide evidence for their layout.
seq:
  - id: instrument_type
    type: u1
    enum: instrument_type
  - id: name
    size: 12
    doc: |
      Fixed-size byte range for the instrument name. Padding bytes are preserved
      as stored.
  - id: transpose
    type: u1
    doc: |
      Common instrument transpose setting. Observed values: 0x01 means ON,
      0x00 means OFF.
  - id: table_tic
    type: u1
    doc: Common instrument table TIC setting.
  - id: unknown_common_0
    size: 3
  - id: instrument_params
    size: 5
    type:
      switch-on: instrument_type
      cases:
        'instrument_type::wavsynth': wavsynth_params
        'instrument_type::macrosynth': macrosynth_params
        'instrument_type::none': unused_instrument_params
    doc: Instrument-specific parameter block.
  - id: filter
    type: filter_params
  - id: amp
    type: amp_params
  - id: mixer
    type: mixer_params
  - id: unknown_before_eq
    size: 29
  - id: eq
    type: u1
    doc: |
      Common instrument EQ assignment. Observed values: 0x80 displays as --,
      0x7f displays as 7F.
  - id: unknown_tail
    size-eos: true
types:
  unused_instrument_params:
    doc: |
      Preserved instrument-specific parameter bytes for NONE.
    seq:
      - id: unknown
        size-eos: true
  wavsynth_params:
    seq:
      - id: shape
        type: u1
        enum: wavsynth_shape
      - id: size
        type: u1
      - id: mult
        type: u1
      - id: warp
        type: u1
      - id: scan
        type: u1
  macrosynth_params:
    seq:
      - id: shape
        type: u1
        enum: macrosynth_shape
      - id: timbre
        type: u1
      - id: color
        type: u1
      - id: degrade
        type: u1
      - id: redux
        type: u1
  filter_params:
    seq:
      - id: type
        type: u1
        enum: filter_type
      - id: cutoff
        type: u1
      - id: resonance
        type: u1
  amp_params:
    seq:
      - id: amp
        type: u1
      - id: limit
        type: u1
        enum: limit_type
      - id: pan
        type: u1
  mixer_params:
    seq:
      - id: dry
        type: u1
      - id: mod_fx
        type: u1
      - id: delay
        type: u1
      - id: reverb
        type: u1
enums:
  instrument_type:
    0x00: wavsynth
    0x01: macrosynth
    0xff: none
  filter_type:
    0x00: off
    0x01: lowpass
    0x02: highpass
    0x03: bandpass
    0x04: bandstop
    0x05: lowpass_to_highpass
    0x06: zdf_lowpass
    0x07: zdf_highpass
    0x08: wav_lowpass
    0x09: wav_highpass
    0x0a: wav_bandpass
    0x0b: wav_bandstop
  limit_type:
    0x00: clip
    0x01: sin
    0x02: fold
    0x03: wrap
    0x04: post
    0x05: post_ad
    0x06: post_w1
    0x07: post_w2
    0x08: post_w3
  wavsynth_shape:
    0x00: pulse_12_percent
    0x01: pulse_25_percent
    0x02: pulse_50_percent
    0x03: pulse_75_percent
    0x04: saw
    0x05: triangle
    0x06: sine
    0x07: noise_pitched
    0x08: noise
    0x09: osc_crush
    0x0a: osc_folding
    0x0b: osc_freq
    0x0c: osc_fuzzy
    0x0d: osc_ghost
    0x0e: osc_graphic
    0x0f: osc_lfoplay
    0x10: osc_liquid
    0x11: osc_morphing
    0x12: osc_mystic
    0x13: osc_sticky
    0x14: osc_tidal
    0x15: osc_tidy
    0x16: osc_tube
    0x17: osc_umbrella
    0x18: osc_unwind
    0x19: osc_viral
    0x1a: osc_waves
    0x1b: bnk_drip
    0x1c: bnk_froggy
    0x1d: bnk_insonic
    0x1e: bnk_radius
    0x1f: bnk_scratch
    0x20: bnk_smooth
    0x21: bnk_wobble
    0x22: hrm_asymmtry
    0x23: hrm_bleen
    0x24: hrm_fractal
    0x25: hrm_gentle
    0x26: hrm_harmonic
    0x27: hrm_hypnotic
    0x28: hrm_iterativ
    0x29: hrm_microwav
    0x2a: hrm_plaits01
    0x2b: hrm_plaits02
    0x2c: hrm_risefall
    0x2d: hrm_tonal
    0x2e: hrm_twine
    0x2f: efx_alien
    0x30: efx_cybernet
    0x31: efx_disordr
    0x32: efx_formant
    0x33: efx_hyper
    0x34: efx_jagged
    0x35: efx_mixed
    0x36: efx_multiply
    0x37: efx_nowhere
    0x38: efx_pinball
    0x39: efx_rings
    0x3a: efx_shimmer
    0x3b: efx_spectral
    0x3c: efx_spooky
    0x3d: efx_transfrm
    0x3e: efx_twisted
    0x3f: efx_vocal
    0x40: efx_washed
    0x41: efx_wonder
    0x42: efx_wowee
    0x43: efx_zap
    0x44: vox_braids
    0x45: vox_voxsynth
  macrosynth_shape:
    0x00: csaw
    0x01: morph
    0x02: saw_square
    0x03: sine_triangle
    0x04: buzz
    0x05: square_sub
    0x06: saw_sub
    0x07: square_sync
    0x08: saw_sync
    0x09: triple_saw
    0x0a: triple_square
    0x0b: triple_triangle
    0x0c: triple_sin
    0x0d: triple_rng
    0x0e: saw_swarm
    0x0f: saw_comb
    0x10: toy
    0x11: digital_filter_lp
    0x12: digital_filter_pk
    0x13: digital_filter_bp
    0x14: digital_filter_hp
    0x15: vosim
    0x16: vowel
    0x17: vowel_fof
    0x18: harmonics
    0x19: fm
    0x1a: feedback_fm
    0x1b: chaotic_feedback_fm
    0x1c: plucked
    0x1d: bowed
    0x1e: blown
    0x1f: fluted
    0x20: struck_bell
    0x21: struck_drum
    0x22: kick
    0x23: cymbal
    0x24: snare
    0x25: wavetables
    0x26: wave_map
    0x27: wav_line
    0x28: wav_paraphonic
    0x29: filtered_noise
    0x2a: twin_peaks_noise
    0x2b: clocked_noise
    0x2c: granular_cloud
    0x2d: particle_noise
    0x2e: digital_mod
    0x2f: morse_noise
