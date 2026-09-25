meta:
  id: song_midi_mapping_6_5_0
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  MIDI Mapping records and destination groups for Song file schema version
  6.5.0. The Song body determines the 128-entry table position.
types:
  midi_mappings:
    doc: |
      MIDI Mapping page storage. Offsets are relative to absolute file offset
      0x1a5fe in 6.5.x fixtures. M8 supports 128 mapping records.
    seq:
      - id: entries
        type: midi_mapping
        repeat: expr
        repeat-expr: 128
  midi_mapping:
    doc: |
      Seven-byte MIDI Mapping record. Historical m8-js reference code reads
      these fields in this byte order. The 6.5.x MIDI_MAPPING fixture verifies
      the record size and table base offset.
    seq:
      - id: channel
        type: u1
        doc: |
          0x00 is observed for empty mappings. Other values are displayed as
          decimal MIDI channels in the M8 UI.
      - id: control_number
        type: u1
        doc: |
          Observed values include 0x00, 0x7f, 0x80, and 0x81. The M8 UI
          displays 0x80 as T:X and 0x81 as T:Y in the current fixture.
      - id: destination_type
        type: u1
        enum: midi_mapping_destination_type
        doc: |
          Raw destination type byte. Observed labels identify the UI
          destination group. Destination index and parameter interpretation is
          destination-specific and deferred to the corresponding page schemas.
      - id: destination_index
        type: u1
      - id: destination_parameter
        type: u1
      - id: minimum_value
        type: u1
      - id: maximum_value
        type: u1
enums:
  midi_mapping_destination_type:
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
