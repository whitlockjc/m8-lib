meta:
  id: instrument_table_6_0_1
  endian: le
  license: Apache-2.0
  ks-version: 0.11
  imports:
    - ../../../common/fx_slot
doc: |
  Sixteen eight-byte Instrument Table rows for file schema 6.0.1.
  Standalone Instruments append one table; Songs store 256 tables separately.
  FX slots can use the M8 UI's Sequencer, Mixer & Effects, Current Instrument,
  and Instrument Mods command groups. Command labels depend on context.
seq:
  - id: rows
    type: row
    repeat: expr
    repeat-expr: 16
    doc: Sixteen rows of transpose, volume, and three FX slots.
types:
  row:
    doc: One eight-byte instrument table row.
    seq:
      - id: transpose
        type: u1
        doc: Row transpose value.
      - id: volume
        type: u1
        doc: 0xff displays as --.
      - id: fx
        type: fx_slot
        repeat: expr
        repeat-expr: 3
        doc: |
          Three shared FX slots. The UI groups commands as Sequencer,
          Mixer & Effects, Current Instrument, and Instrument Mods. Available
          labels depend on the surrounding instrument and modulation type.
