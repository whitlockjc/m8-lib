meta:
  id: song_eq_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Shared EQ layout for Song Instrument banks and Mix, Mod FX, Delay, and
  Reverb EQs in file schema version 6.5.0.
types:
  settings:
    doc: |
      Three-band EQ storage. Each known EQ uses three adjacent 6-byte band
      records.
    seq:
      - id: low_band
        type: band
        doc: Low EQ band.
      - id: mid_band
        type: band
        doc: Mid EQ band.
      - id: high_band
        type: band
        doc: High EQ band.
  instrument_bank:
    doc: 128 assignable Instrument EQ banks, each with the standard 18-byte EQ layout.
    seq:
      - id: entries
        type: settings
        repeat: expr
        repeat-expr: 128
  band:
    doc: |
      Six-byte EQ band record. The type and mode are packed into one byte: bits
      0..4 hold the filter type and bits 5..7 hold the filter mode. Frequency
      is stored as an unsigned little-endian integer. Gain is stored as signed
      hundredths, so 10.50 is stored as 1050.
    seq:
      - id: type_and_mode
        type: u1
        doc: Packed filter type and channel mode.
      - id: frequency
        type: u2
        doc: Band frequency stored as an unsigned little-endian integer.
      - id: gain
        type: s2
        doc: Signed band gain in hundredths.
      - id: q
        type: u1
        doc: Band Q value.
    instances:
      filter_type:
        value: type_and_mode & 0x1f
        enum: filter_type
      filter_mode:
        value: type_and_mode >> 5
        enum: filter_mode
enums:
  filter_type:
    0x00:
      id: lowcut
      -label: LOWCUT
    0x01:
      id: lowshelf
      -label: LOWSHELF
    0x02:
      id: bell
      -label: BELL
    0x03:
      id: bandpass
      -label: BANDPASS
    0x04:
      id: hi_shelf
      -label: HI.SHELF
    0x05:
      id: hi_cut
      -label: HI.CUT
    0x06:
      id: allpass
      -label: ALLPASS
  filter_mode:
    0x00:
      id: stereo
      -label: STEREO
    0x01:
      id: mid
      -label: MID
    0x02:
      id: side
      -label: SIDE
    0x03:
      id: left
      -label: LEFT
    0x04:
      id: right
      -label: RIGHT
