meta:
  id: song_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for song files with header schema version 6.5.0.

  Initial schema verified against M8 6.5.2C Project page fixtures. The Project
  settings region is partially mapped. Remaining Song regions are preserved as
  raw bytes until future fixtures provide evidence for their layout.
seq:
  - id: unknown_before_project
    size: 128
    doc: |
      Preserved bytes before the mapped Project settings region. The PROJECT
      fixture changes bytes in this region during save, but those changes are
      not mapped to Project UI fields yet.
  - id: project
    type: project_settings
  - id: unknown_after_project
    size-eos: true
types:
  project_settings:
    doc: |
      Project page settings. Offsets are relative to absolute file offset
      0x008e in 6.5.x fixtures.
    seq:
      - id: transpose
        type: u1
      - id: tempo
        type: f4
        doc: |
          Verified as a 32-bit little-endian float. A UI change from 120.00 to
          121.99 stored approximately 121.98999786376953.
      - id: live_quantize
        type: u1
        doc: |
          0x00 displays as CHAIN LEN. Values from 0x01 through 0xff display as
          step counts.
      - id: name
        size: 12
        doc: |
          Fixed-size byte range for the Project name. Padding bytes are
          preserved as stored.
      - id: unknown_before_scale
        size: 27
      - id: scale
        type: u1
        doc: |
          Selects one of the Scales embedded in the Song file. The UI label
          comes from the referenced embedded Scale name.
      - id: groove
        type: u1
      - id: unknown_trailing_state
        size: 2
        doc: |
          Changed in the PROJECT fixture, but not yet mapped to a Project UI
          meaning. Preserve until targeted fixtures provide evidence.
