meta:
  id: file_6_6_x
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - common/file_header
    - file-versions/6.0.2/instrument
    - file-versions/6.6.2/song
    - file-versions/4.0.1/scale
    - file-versions/1.0.2/theme
doc: |
  Entry schema for M8 files created with 6.6.x firmware. Last synchronized
  with fixtures created on M8 firmware 6.6.3C. Shared 6.5.x components are
  provisionally reused where current fixture evidence supports their layout;
  full cross-version semantic compatibility is still under investigation.
seq:
  - id: header
    type: file_header
  - id: body
    type:
      switch-on: header.file_kind
      cases:
        'file_header::file_kind::instrument': instrument_6_0_2
        'file_header::file_kind::scale': scale_4_0_1
        'file_header::file_kind::song': song_6_6_2
        'file_header::file_kind::theme': theme_1_0_2
