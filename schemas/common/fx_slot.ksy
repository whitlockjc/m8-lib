meta:
  id: fx_slot
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Two-byte FX slot used by Phrase steps and Instrument Table rows. Command
  availability and labels depend on the surrounding context and are not part
  of this raw storage type.
seq:
  - id: command
    type: u1
    doc: Observed 0xff displays as unset.
  - id: value
    type: u1
