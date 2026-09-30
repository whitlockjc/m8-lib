meta:
  id: file_header
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Header containing the M8 signature, file schema version, and file kind.
  The file schema version is distinct from the firmware version.
seq:
  - id: magic
    contents: M8VERSION
    doc: ASCII file signature.
  - id: reserved_0
    type: u1
    valid: 0
  - id: schema_version_raw
    type: u2
    doc: Packed schema version as major/minor/patch nibbles.
  - id: reserved_1
    type: u1
    valid: 0
  - id: file_kind
    type: u1
    enum: file_kind
instances:
  schema_version_major:
    value: (schema_version_raw >> 8) & 0xf
  schema_version_minor:
    value: (schema_version_raw >> 4) & 0xf
  schema_version_patch:
    value: schema_version_raw & 0xf
enums:
  file_kind:
    0x00:
      id: song
      -label: Song
    0x10:
      id: instrument
      -label: Instrument
    0x20:
      id: theme
      -label: Theme
    0x30:
      id: scale
      -label: Scale
