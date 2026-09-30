meta:
  id: fx_slot
  endian: le
  license: Apache-2.0
  ks-version: 0.11
doc: |
  Two-byte FX slot used by Phrase steps and Instrument Table rows. Command
  bytes and argument bytes have the same storage in both places. The M8 UI
  groups commands under Sequencer, Mixer & Effects, Current Instrument, and
  Instrument Mods. Current Instrument commands depend on the active instrument;
  Instrument Mods labels also depend on the selected modulation type. These
  groups describe contextual labels and availability, not distinct byte layouts.
  Sequencer and Mixer & Effects byte values are verified in the 6.5.x Phrase
  fixture, and selected Current Instrument values in Instrument Table fixtures.
  Instrument Mods command values still need fixture evidence.
seq:
  - id: command
    type: u1
    doc: Raw command byte; 0xff displays as unset. Interpret using the surrounding context and command group.
  - id: value
    type: u1
    doc: Raw command argument; the Instrument Table UI may call this an amount.
