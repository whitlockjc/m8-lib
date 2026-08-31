meta:
  id: theme_1_0_2
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Body schema for theme files with header schema version 1.0.2.

  Verified against M8 6.5.2C theme fixtures. The body contains 13 color triples
  and no unaccounted bytes.

  M8 6.5.x fixture evidence indicates that RGB versus HSV editing mode is not
  stored in the theme file itself. Do not add a theme-level mode field unless
  future fixture evidence proves one exists.
seq:
  - id: background
    type: color
  - id: text_empty
    type: color
  - id: text_info
    type: color
  - id: text_default
    type: color
  - id: text_value
    type: color
  - id: text_titles
    type: color
  - id: play_markers
    type: color
  - id: cursor
    type: color
  - id: selection
    type: color
  - id: scope_slider
    type: color
  - id: meter_low
    type: color
  - id: meter_mid
    type: color
  - id: meter_peak
    type: color
types:
  color:
    doc: |
      Three adjacent color component bytes.
    seq:
      - id: r
        type: u1
      - id: g
        type: u1
      - id: b
        type: u1
