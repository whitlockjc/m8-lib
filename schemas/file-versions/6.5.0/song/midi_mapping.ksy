meta:
  id: midi_mapping_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  MIDI Mapping records and destination groups for Song file schema version
  6.5.0. The Song body determines the 128-entry table position.
types:
  mappings:
    doc: |
      MIDI Mapping page storage containing 128 mapping records.
    seq:
      - id: entries
        type: mapping
        repeat: expr
        repeat-expr: 128
        doc: Up to 128 MIDI control mappings.
  mapping:
    doc: |
      Seven-byte MIDI Mapping record.
    seq:
      - id: channel
        type: u1
        doc: |
          0x00 represents an empty mapping. Other values are displayed as
          decimal MIDI channels in the M8 UI.
      - id: control_number
        type: u1
        doc: |
          MIDI control number. The M8 UI displays 0x80 as T:X and 0x81 as T:Y.
      - id: destination_type
        type: u1
        enum: destination_type
        doc: |
          Destination group. Index and parameter meanings depend on this type.
      - id: destination_index
        type: u1
        doc: Index within the destination group; interpretation depends on destination type.
      - id: destination_parameter
        type: u1
        doc: Parameter within the selected destination; labels depend on destination type.
      - id: minimum_value
        type: u1
        doc: Lower bound of the mapped parameter range.
      - id: maximum_value
        type: u1
        doc: Upper bound of the mapped parameter range.
enums:
  destination_type:
    0x05:
      id: instrument
      -label: I
    0x0b:
      id: effects
      -label: X
    0x0d:
      id: mixer
      -label: M
    0x19:
      id: eq
      -label: Q
