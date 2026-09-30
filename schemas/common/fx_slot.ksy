meta:
  id: fx_slot
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Two-byte FX slot used by Phrase steps and Instrument Table rows. Command
  and argument bytes have the same layout in both places. The command label
  depends on its group, active instrument, and modulation type.
seq:
  - id: command
    type: u1
    doc: Raw command byte; 0xff displays as unset. Interpret using the surrounding context and command group.
  - id: value
    type: u1
    doc: Raw command argument; the Instrument Table UI may call this an amount.
