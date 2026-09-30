meta:
  id: parameters_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: Shared instrument filter, amplifier, mixer, and custom CC layouts.
types:
  custom_cc:
    doc: Two-byte custom CC entry shared by MIDI Out and External.
    seq:
      - id: cc
        type: u1
        doc: Displayed as decimal in the M8 UI.
      - id: value
        type: u1
        doc: Configured controller value.
  filter_params:
    doc: |
      Shared three-byte Multi-mode Filter Parameters layout. The type byte is
      raw because valid labels depend on the instrument: filter_type lists
      0x00..0x07 for all filter-capable instruments and 0x08..0x0b for
      Wavsynth only. MIDI Out and NONE do not expose this group.
    seq:
      - id: type
        type: u1
      - id: cutoff
        type: u1
      - id: resonance
        type: u1
  amp_params:
    doc: |
      Shared three-byte Amplifier Settings layout: amp, limit, and pan.
      Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth, and External expose
      this group at type-dependent offsets. MIDI Out and NONE do not.
    seq:
      - id: amp
        type: u1
      - id: limit
        type: u1
        enum: limit_type
      - id: pan
        type: u1
  mixer_params:
    doc: |
      Shared four-byte instrument Mixer Parameters layout: dry, mod_fx,
      delay, and reverb. Wavsynth, Macrosynth, Sampler, FM Synth, Hypersynth,
      and External expose this group at type-dependent offsets. It is distinct
      from the Song's master Mixer; MIDI Out and NONE do not expose it.
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
