meta:
  id: instrument_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for instrument files with header schema version 6.0.1.

  Initial schema verified against an M8 6.5.2C NONE instrument fixture. The
  instrument type byte and fixed-size name byte range are mapped. The remaining
  bytes are preserved as an unknown range until instrument-type fixtures provide
  evidence for their layout.
seq:
  - id: instrument_type
    type: u1
    enum: instrument_type
  - id: name
    size: 12
    doc: |
      Fixed-size byte range for the instrument name. Padding behavior has not
      yet been verified because the NONE_DEFAULT fixture fills all 12 bytes.
  - id: unknown_body
    size-eos: true
enums:
  instrument_type:
    0xff: none
