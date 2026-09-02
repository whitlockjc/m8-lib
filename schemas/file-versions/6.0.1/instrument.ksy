meta:
  id: instrument_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for instrument files with header schema version 6.0.1.

  Initial schema verified against M8 6.5.2C NONE, Wavsynth, Macrosynth, and
  Sampler instrument fixtures. The instrument type byte, fixed-size name byte
  range, and common instrument prefix are mapped. Wavsynth/Macrosynth/Sampler
  params, filter params, amp params, mixer params, sample path, and common EQ
  assignment are mapped from params fixtures. Unknown ranges are preserved until
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
    size: 2
  - id: body_before_eq
    type:
      switch-on: instrument_type
      cases:
        'instrument_type::wavsynth': wavsynth_body_before_eq
        'instrument_type::macrosynth': macrosynth_body_before_eq
        'instrument_type::sampler': sampler_body_before_eq
        'instrument_type::none': unused_body_before_eq
    doc: Instrument-specific body before the common EQ field.
  - id: eq
    type: u1
    doc: |
      Common instrument EQ assignment. Observed values: 0x80 displays as --,
      0x7f displays as 7F.
  - id: tail
    type:
      switch-on: instrument_type
      cases:
        'instrument_type::sampler': sampler_tail
        'instrument_type::wavsynth': unused_tail
        'instrument_type::macrosynth': unused_tail
        'instrument_type::none': unused_tail
    doc: Instrument-specific tail after the common EQ field.
types:
  unused_body_before_eq:
    doc: |
      Preserved bytes between the common instrument prefix and common EQ field
      for NONE.
    seq:
      - id: unknown
        size: 45
  wavsynth_body_before_eq:
    seq:
      - id: unknown_before_params
        size: 1
      - id: params
        type: wavsynth_params
      - id: filter
        type: filter_params
      - id: amp
        type: amp_params
      - id: mixer
        type: mixer_params
      - id: unknown_before_eq
        size: 29
  macrosynth_body_before_eq:
    seq:
      - id: unknown_before_params
        size: 1
      - id: params
        type: macrosynth_params
      - id: filter
        type: filter_params
      - id: amp
        type: amp_params
      - id: mixer
        type: mixer_params
      - id: unknown_before_eq
        size: 29
  sampler_body_before_eq:
    seq:
      - id: mode_value
        type: u1
        doc: |
          Displayed as detune, steps, or BPM depending on play_mode.
      - id: play_mode
        type: u1
        enum: sampler_play_mode
      - id: slice
        type: u1
      - id: start
        type: u1
      - id: loop_start
        type: u1
      - id: length
        type: u1
      - id: degrade
        type: u1
      - id: filter
        type: filter_params
      - id: amp
        type: amp_params
      - id: mixer
        type: mixer_params
      - id: unknown_before_eq
        size: 28
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
  unused_tail:
    seq:
      - id: unknown
        size-eos: true
  sampler_tail:
    seq:
      - id: unknown_before_sample_path
        size: 24
      - id: sample_path
        size: 128
        doc: |
          Fixed-size sample path byte range. Start offset and stored path bytes
          are verified by Sampler fixtures; full maximum length is inferred from
          the surrounding fixed instrument layout and should be refined if future
          evidence contradicts it.
      - id: unknown_after_sample_path
        size-eos: true
enums:
  instrument_type:
    0x00:
      id: wavsynth
      -label: Wavsynth
    0x01:
      id: macrosynth
      -label: Macrosynth
    0x02:
      id: sampler
      -label: Sampler
    0xff:
      id: none
      -label: NONE
  filter_type:
    0x00:
      id: off
      -label: OFF
    0x01:
      id: lowpass
      -label: LOWPASS
    0x02:
      id: highpass
      -label: HIGHPAS
    0x03:
      id: bandpass
      -label: BANDPAS
    0x04:
      id: bandstop
      -label: BANDSTP
    0x05:
      id: lowpass_to_highpass
      -label: LP > HP
    0x06:
      id: zdf_lowpass
      -label: ZDF LP
    0x07:
      id: zdf_highpass
      -label: ZDF HP
    0x08:
      id: wav_lowpass
      -label: WAV LP
    0x09:
      id: wav_highpass
      -label: WAV HP
    0x0a:
      id: wav_bandpass
      -label: WAV BP
    0x0b:
      id: wav_bandstop
      -label: WAV BS
  limit_type:
    0x00:
      id: clip
      -label: CLIP
    0x01:
      id: sin
      -label: SIN
    0x02:
      id: fold
      -label: FOLD
    0x03:
      id: wrap
      -label: WRAP
    0x04:
      id: post
      -label: POST
    0x05:
      id: post_ad
      -label: POST:AD
    0x06:
      id: post_w1
      -label: POST:W1
    0x07:
      id: post_w2
      -label: POST:W2
    0x08:
      id: post_w3
      -label: POST:W3
  wavsynth_shape:
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
  macrosynth_shape:
    0x00:
      id: csaw
      -label: CSAW
    0x01:
      id: morph
      -label: MORPH
    0x02:
      id: saw_square
      -label: SAW SQUARE
    0x03:
      id: sine_triangle
      -label: SINE TRIANGLE
    0x04:
      id: buzz
      -label: BUZZ
    0x05:
      id: square_sub
      -label: SQUARE SUB
    0x06:
      id: saw_sub
      -label: SAW SUB
    0x07:
      id: square_sync
      -label: SQUARE SYNC
    0x08:
      id: saw_sync
      -label: SAW SYNC
    0x09:
      id: triple_saw
      -label: TRIPLE SAW
    0x0a:
      id: triple_square
      -label: TRIPLE SQUARE
    0x0b:
      id: triple_triangle
      -label: TRIPLE TRIANGLE
    0x0c:
      id: triple_sin
      -label: TRIPLE SIN
    0x0d:
      id: triple_rng
      -label: TRIPLE RNG
    0x0e:
      id: saw_swarm
      -label: SAW SWARM
    0x0f:
      id: saw_comb
      -label: SAW COMB
    0x10:
      id: toy
      -label: TOY
    0x11:
      id: digital_filter_lp
      -label: DIGITAL FILTER LP
    0x12:
      id: digital_filter_pk
      -label: DIGITAL FILTER PK
    0x13:
      id: digital_filter_bp
      -label: DIGITAL FILTER BP
    0x14:
      id: digital_filter_hp
      -label: DIGITAL FILTER HP
    0x15:
      id: vosim
      -label: VOSIM
    0x16:
      id: vowel
      -label: VOWEL
    0x17:
      id: vowel_fof
      -label: VOWEL FOF
    0x18:
      id: harmonics
      -label: HARMONICS
    0x19:
      id: fm
      -label: FM
    0x1a:
      id: feedback_fm
      -label: FEEDBACK FM
    0x1b:
      id: chaotic_feedback_fm
      -label: CHAOTIC FEEDBACK FM
    0x1c:
      id: plucked
      -label: PLUCKED
    0x1d:
      id: bowed
      -label: BOWED
    0x1e:
      id: blown
      -label: BLOWN
    0x1f:
      id: fluted
      -label: FLUTED
    0x20:
      id: struck_bell
      -label: STRUCK BELL
    0x21:
      id: struck_drum
      -label: STRUCK DRUM
    0x22:
      id: kick
      -label: KICK
    0x23:
      id: cymbal
      -label: CYMBAL
    0x24:
      id: snare
      -label: SNARE
    0x25:
      id: wavetables
      -label: WAVETABLES
    0x26:
      id: wave_map
      -label: WAVE MAP
    0x27:
      id: wav_line
      -label: WAV LINE
    0x28:
      id: wav_paraphonic
      -label: WAV PARAPHONIC
    0x29:
      id: filtered_noise
      -label: FILTERED NOISE
    0x2a:
      id: twin_peaks_noise
      -label: TWIN PEAKS NOISE
    0x2b:
      id: clocked_noise
      -label: CLOCKED NOISE
    0x2c:
      id: granular_cloud
      -label: GRANULAR CLOUD
    0x2d:
      id: particle_noise
      -label: PARTICLE NOISE
    0x2e:
      id: digital_mod
      -label: DIGITAL MOD
    0x2f:
      id: morse_noise
      -label: MORSE NOISE
  sampler_play_mode:
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
