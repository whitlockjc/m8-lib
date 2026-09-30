meta:
  id: scale_4_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for scale files with header schema version 4.0.1.

  Verified against M8 6.5.2C scale fixtures. The body contains an enabled-note
  bitmask, 12 interval offsets, a fixed-size name byte range, and a tuning
  offset. No unaccounted bytes remain in the verified fixture pair.
seq:
  - id: enabled_notes
    type: u2
    doc: Bitmask selecting the enabled intervals.
  - id: intervals
    type: interval
    repeat: expr
    repeat-expr: 12
    doc: Twelve interval offsets in Scale View order.
  - id: name
    size: 16
    doc: |
      Fixed-size byte range for the scale name. Padding bytes are preserved as
      stored.
  - id: tuning_offset
    type: f4
    doc: |
      Scale tuning offset from A440, stored as a 32-bit float. The M8 UI defaults
      to 440.00 Hz and stores 0.0 here. A UI change from 440.00 to 439.97
      stored approximately -0.03, so this appears to be an offset from the
      standard A440 tuning reference rather than an absolute tuning value.
types:
  interval:
    doc: |
      Signed interval offset stored as hundredths of a semitone.
    seq:
      - id: offset
        type: s2
        doc: Signed interval offset in hundredths of a semitone.
