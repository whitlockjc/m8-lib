meta:
  id: theme_1_0_2
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Theme body with 13 color triples. RGB versus HSV editing mode is not stored
  in the Theme file.
seq:
  - id: background
    type: color
    doc: Background color.
  - id: text_empty
    type: color
    doc: Color for empty text.
  - id: text_info
    type: color
    doc: Color for informational text.
  - id: text_default
    type: color
    doc: Default text color.
  - id: text_value
    type: color
    doc: Color for displayed values.
  - id: text_titles
    type: color
    doc: Color for titles.
  - id: play_markers
    type: color
    doc: Color for play markers.
  - id: cursor
    type: color
    doc: Cursor color.
  - id: selection
    type: color
    doc: Selection color.
  - id: scope_slider
    type: color
    doc: Color for scopes and sliders.
  - id: meter_low
    type: color
    doc: Low meter color.
  - id: meter_mid
    type: color
    doc: Mid meter color.
  - id: meter_peak
    type: color
    doc: Peak meter color.
types:
  color:
    doc: |
      Three adjacent color component bytes.
    seq:
      - id: r
        type: u1
        doc: Red component.
      - id: g
        type: u1
        doc: Green component.
      - id: b
        type: u1
        doc: Blue component.
