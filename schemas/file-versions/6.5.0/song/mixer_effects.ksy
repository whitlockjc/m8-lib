meta:
  id: song_mixer_effects_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Mixer, Effects Settings, and Mix & Limiter Scope layouts for Song file
  schema version 6.5.0. The Song body determines their positions.
types:
  mixer:
    doc: |
      Mixer and Mix & Limiter Scope storage.
    seq:
      - id: mix
        type: u1
        doc: Master mix volume.
      - id: limiter
        type: u1
        doc: Master limiter amount.
      - id: track_volumes
        type: u1
        repeat: expr
        repeat-expr: 8
        doc: Volume for each of the eight tracks.
      - id: sends
        type: sends
        doc: Master sends to ModFX, Delay, and Reverb.
      - id: analog_input_volume
        type: u1
        doc: Analog input volume.
      - id: analog_dual_mono_input_volume
        type: u1
        doc: |
          0xff displays as unset until dual mono input is enabled.
      - id: usb_input_volume
        type: u1
        doc: USB input volume.
      - id: analog_input_sends
        type: sends
        doc: Analog input effect sends.
      - id: analog_dual_mono_input_sends
        type: sends
        doc: Second analog mono input effect sends.
      - id: usb_input_sends
        type: sends
        doc: USB input effect sends.
      - id: dj_filter
        type: u1
        doc: DJ filter setting.
      - id: dj_filter_resonance
        type: u1
        doc: DJ filter resonance.
      - id: dj_filter_type
        type: u1
        enum: dj_filter_type
        doc: DJ filter type.
      - id: limiter_attack
        type: u1
        doc: Limiter attack setting.
      - id: limiter_release
        type: u1
        doc: Limiter release setting.
      - id: soft_clip
        type: u1
        doc: |
          0x00 means OFF; 0x01 means ON.
      - id: ott
        type: u1
        doc: OTT amount.
  effects_and_scope:
    doc: |
      Shared storage region for the Effects Settings and Mix & Limiter Scope
      views. Storage order does not fully match the UI grouping; the Mod FX
      type byte is stored after the Mix & Limiter Scope OTT detail bytes.
    seq:
      - id: unknown_0
        size: 3
        doc: Preserved bytes before the mapped Mod FX parameter bytes.
      - id: mod_fx
        type: mod_fx
      - id: unknown_1
        size: 5
        doc: Preserved bytes between Mod FX and Delay parameters.
      - id: delay
        type: delay
      - id: unknown_2
        size: 3
        doc: Preserved bytes between Delay and Reverb parameters.
      - id: reverb
        type: reverb
      - id: mix_limiter_scope
        type: mix_limiter_scope
      - id: mod_fx_type
        type: u1
        enum: mod_fx_type
        doc: ModFX type selected in Effects Settings.
  mod_fx:
    doc: |
      Mod FX parameter storage from the Effects Settings View. The Mod FX type
      byte is stored later in the shared Effects/Mix & Limiter Scope region.
    seq:
      - id: depth
        type: u1
        doc: ModFX depth.
      - id: frequency
        type: u1
        doc: ModFX frequency.
      - id: width
        type: u1
        doc: ModFX stereo width.
      - id: reverb_send
        type: u1
        doc: ModFX send to Reverb.
  delay:
    doc: Delay parameter storage from the Effects Settings View.
    seq:
      - id: time_left
        type: u1
        doc: Left Delay time.
      - id: time_right
        type: u1
        doc: Right Delay time.
      - id: feedback
        type: u1
        doc: Delay feedback.
      - id: width
        type: u1
        doc: Delay stereo width.
      - id: reverb_send
        type: u1
        doc: Delay send to Reverb.
  reverb:
    doc: Reverb parameter storage from the Effects Settings View.
    seq:
      - id: room_size
        type: u1
        doc: Reverb room size.
      - id: decay
        type: u1
        doc: Reverb decay.
      - id: depth
        type: u1
        doc: Reverb depth.
      - id: frequency
        type: u1
        doc: Reverb frequency.
      - id: width
        type: u1
        doc: Reverb stereo width.
      - id: shimmer
        type: u1
        doc: Reverb shimmer.
  mix_limiter_scope:
    doc: |
      Mix & Limiter Scope storage for OTT detail controls from the Mix &
      Limiter Scope View.
    seq:
      - id: ott_time
        type: u1
        doc: OTT time.
      - id: ott_color
        type: u1
        doc: OTT color.
  sends:
    doc: Effect send levels for ModFX, Delay, and Reverb.
    seq:
      - id: mod_fx
        type: u1
        doc: ModFX send level.
      - id: delay
        type: u1
        doc: Delay send level.
      - id: reverb
        type: u1
        doc: Reverb send level.
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
