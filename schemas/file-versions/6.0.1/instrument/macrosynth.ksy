meta:
  id: instrument_macrosynth_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: Macrosynth specific parameters.
types:
  instrument_params:
    seq:
      - id: shape
        type: u1
        enum: shape
      - id: timbre
        type: u1
      - id: color
        type: u1
      - id: degrade
        type: u1
      - id: redux
        type: u1
enums:
  shape:
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
      id: timbre
      -label: TIMBRE
    0x04:
      id: color
      -label: COLOR
    0x05:
      id: degrade
      -label: DEGRADE
    0x06:
      id: redux
      -label: REDUX
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
