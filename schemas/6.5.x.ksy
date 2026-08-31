meta:
  id: file_6_5_x
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - common/file_header
    - file-versions/6.0.1/instrument
    - file-versions/6.5.0/song
    - file-versions/4.0.1/scale
    - file-versions/1.0.2/theme
doc: |
  Entry schema for M8 files created or verified against the 6.5.x firmware line.

  Last synchronized with fixtures created from M8 firmware 6.5.2C.
seq:
  - id: header
    type: file_header
  - id: body
    type:
      switch-on: header.file_kind
      cases:
        'file_header::file_kind::instrument': instrument_6_0_1
        'file_header::file_kind::scale': scale_4_0_1
        'file_header::file_kind::song': song_6_5_0
        'file_header::file_kind::theme': theme_1_0_2
