meta:
  id: song_mixer_effects_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Mixer, Effects Settings, and Mix & Limiter Scope layouts for Song file
  schema version 6.5.0. The Song body determines their positions.
types:
  mixer_settings:
    doc: |
      Mixer and Mix & Limiter Scope storage. Offsets are relative to absolute
      file offset 0x00ce in 6.5.x fixtures.
    seq:
      - id: mix
        type: u1
      - id: limiter
        type: u1
      - id: track_volumes
        type: u1
        repeat: expr
        repeat-expr: 8
      - id: sends
        type: mixer_sends
      - id: analog_input_volume
        type: u1
      - id: analog_dual_mono_input_volume
        type: u1
        doc: |
          Default fixture stores 0xff. The M8 UI displays this as unset until
          dual mono input is enabled.
      - id: usb_input_volume
        type: u1
      - id: analog_input_sends
        type: mixer_sends
      - id: analog_dual_mono_input_sends
        type: mixer_sends
      - id: usb_input_sends
        type: mixer_sends
      - id: dj_filter
        type: u1
      - id: dj_filter_resonance
        type: u1
      - id: dj_filter_type
        type: u1
        enum: dj_filter_type
      - id: limiter_attack
        type: u1
      - id: limiter_release
        type: u1
      - id: soft_clip
        type: u1
        doc: |
          Observed values: 0x00 means OFF, 0x01 means ON.
      - id: ott
        type: u1
  effects_and_scope_settings:
    doc: |
      Shared storage region for the Effects Settings and Mix & Limiter Scope
      views. Offsets are relative to absolute file offset 0x1a5be in 6.5.x
      fixtures. Storage order does not fully match the UI grouping; the Mod FX
      type byte is stored after the Mix & Limiter Scope OTT detail bytes.
    seq:
      - id: unknown_before_mod_fx
        size: 3
        doc: Preserved bytes before the mapped Mod FX parameter bytes.
      - id: mod_fx
        type: mod_fx_settings
      - id: unknown_between_mod_fx_and_delay
        size: 5
        doc: |
          Preserved bytes between Mod FX and Delay parameters. Historical
          <https://github.com/whitlockjc/m8-js> reference code treats part of
          this region as delay filter storage, but this fixture does not change
          those controls.
      - id: delay
        type: delay_settings
      - id: unknown_between_delay_and_reverb
        size: 3
        doc: |
          Preserved bytes between Delay and Reverb parameters. Historical
          <https://github.com/whitlockjc/m8-js> reference code treats part of
          this region as reverb filter storage, but this fixture does not
          change those controls.
      - id: reverb
        type: reverb_settings
      - id: mix_limiter_scope
        type: mix_limiter_scope_settings
      - id: mod_fx_type
        type: u1
        enum: mod_fx_type
  mod_fx_settings:
    doc: |
      Mod FX parameter storage from the Effects Settings View. The Mod FX type
      byte is stored later in the shared Effects/Mix & Limiter Scope region.
    seq:
      - id: depth
        type: u1
      - id: frequency
        type: u1
      - id: width
        type: u1
      - id: reverb_send
        type: u1
  delay_settings:
    doc: Delay parameter storage from the Effects Settings View.
    seq:
      - id: time_left
        type: u1
      - id: time_right
        type: u1
      - id: feedback
        type: u1
      - id: width
        type: u1
      - id: reverb_send
        type: u1
  reverb_settings:
    doc: Reverb parameter storage from the Effects Settings View.
    seq:
      - id: room_size
        type: u1
      - id: decay
        type: u1
      - id: depth
        type: u1
      - id: frequency
        type: u1
      - id: width
        type: u1
      - id: shimmer
        type: u1
  mix_limiter_scope_settings:
    doc: |
      Mix & Limiter Scope storage for OTT detail controls from the Mix &
      Limiter Scope View. Offsets are relative to absolute file offset
      0x1a5d8 in 6.5.x fixtures.
    seq:
      - id: ott_time
        type: u1
      - id: ott_color
        type: u1
  mixer_sends:
    seq:
      - id: mod_fx
        type: u1
      - id: delay
        type: u1
      - id: reverb
        type: u1
enums:
  mod_fx_type:
    0x00:
      id: chorus
      -label: CHORUS
    0x01:
      id: phaser
      -label: PHASER
    0x02:
      id: flanger
      -label: FLANGER
  dj_filter_type:
    0x00:
      id: lowpass_highpass
      -label: LOWPASS:HIGHPASS
    0x01:
      id: lowpass_bandstop
      -label: LOWPASS:BANDSTOP
    0x02:
      id: bandpass_highpass
      -label: BANDPASS:HIGHPASS
