# M8 FX Commands

Generated from Kaitai schemas. Do not edit; run `npm run docs:generate`.

[Documentation index](README.md)

Phrase steps and Instrument Table rows use the same two-byte FX slot. The M8 UI groups command labels by purpose; availability and behavior depend on the slot context, active instrument, and modulation type. Each firmware section below uses the enums selected by its entry schema.

## Firmware Ranges

- [6.5.x](#65x)
- [6.6.x](#66x)

## 6.5.x

Based on firmware `6.5.2C`. Values come from [schemas/file-versions/6.5.0/song/sequencing.ksy](../schemas/file-versions/6.5.0/song/sequencing.ksy) and [schemas/file-versions/6.0.1/instrument/table.ksy](../schemas/file-versions/6.0.1/instrument/table.ksy). Shared schemas may be carried forward provisionally rather than independently retested for every firmware range.

### Instrument (Current Instrument)

These enums contain fixture-verified command subsets for each instrument, not every command available in an FX slot.

#### Wavsynth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | OSC | `oscillator` |
| `0x84` | SIZ | `size` |
| `0x85` | MUL | `mult` |
| `0x86` | WRP | `warp` |
| `0x87` | SCN | `scan` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SNC | `snc` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### Macrosynth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | OSC | `oscillator` |
| `0x84` | TBR | `timbre` |
| `0x85` | COL | `color` |
| `0x86` | DEG | `degrade` |
| `0x87` | RED | `redux` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | TRG | `trigger` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### Sampler

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | PLY | `play` |
| `0x84` | STA | `start` |
| `0x85` | LOP | `loop` |
| `0x86` | LEN | `length` |
| `0x87` | DEG | `degrade` |
| `0x88` | FLT | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SLI | `slice` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### FM Synth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | ALG | `algorithm` |
| `0x84` | FM1 | `fm1` |
| `0x85` | FM2 | `fm2` |
| `0x86` | FM3 | `fm3` |
| `0x87` | FM4 | `fm4` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SNC | `snc` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### MIDI Out

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | MPG | `midi_program` |
| `0x83` | MPB | `midi_program_bank` |
| `0x84` | ADD | `add` |
| `0x85` | CHD | `chord` |
| `0x86` | CCA | `cc_a` |
| `0x87` | CCB | `cc_b` |
| `0x88` | CCC | `cc_c` |
| `0x89` | CCD | `cc_d` |
| `0x8a` | CCE | `cc_e` |
| `0x8b` | CCF | `cc_f` |
| `0x8c` | CCG | `cc_g` |
| `0x8d` | CCH | `cc_h` |
| `0x8e` | CCI | `cc_i` |
| `0x8f` | CCJ | `cc_j` |
| `0xff` | -- | `unset` |

#### Hypersynth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | CRD | `chord` |
| `0x84` | CVO | `chord_volume` |
| `0x85` | SWM | `swarm` |
| `0x86` | WID | `width` |
| `0x87` | SUB | `subosc` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SNC | `snc` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### External

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | MPB | `midi_program_bank` |
| `0x83` | MPG | `midi_program` |
| `0x84` | CCA | `cc_a` |
| `0x85` | CCB | `cc_b` |
| `0x86` | CCC | `cc_c` |
| `0x87` | CCD | `cc_d` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | ADD | `add` |
| `0xa7` | CHD | `chord` |
| `0xff` | -- | `unset` |

#### NONE

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0xff` | -- | `unset` |

### Instrument Mods

No verified command-value enum is available yet. Labels depend on the selected modulation slot and modulation type; targeted fixtures are needed before listing byte values.

### Mixer & Effects

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x1b` | VMV | `main_volume` |
| `0x1c` | XMM | `mod_fx_modulation_depth` |
| `0x1d` | XMF | `mod_fx_modulation_frequency` |
| `0x1e` | XMW | `mod_fx_stereo_width` |
| `0x1f` | XMR | `mod_fx_reverb_mix` |
| `0x20` | XDT | `delay_time` |
| `0x21` | XDF | `delay_feedback` |
| `0x22` | XDW | `delay_stereo_width` |
| `0x23` | XDR | `delay_reverb_mix` |
| `0x24` | XRS | `reverb_room_size` |
| `0x25` | XRD | `reverb_decay` |
| `0x26` | XRM | `reverb_modulation_depth` |
| `0x27` | XRF | `reverb_modulation_frequency` |
| `0x28` | XRW | `reverb_stereo_width` |
| `0x29` | XRZ | `reverb_freeze` |
| `0x2a` | VMX | `mod_fx_volume` |
| `0x2b` | VDE | `delay_volume` |
| `0x2c` | VRE | `reverb_volume` |
| `0x2d` | VT1 | `track_1_volume` |
| `0x2e` | VT2 | `track_2_volume` |
| `0x2f` | VT3 | `track_3_volume` |
| `0x30` | VT4 | `track_4_volume` |
| `0x31` | VT5 | `track_5_volume` |
| `0x32` | VT6 | `track_6_volume` |
| `0x33` | VT7 | `track_7_volume` |
| `0x34` | VT8 | `track_8_volume` |
| `0x35` | DJC | `dj_filter_cutoff` |
| `0x36` | VIN | `line_input_volume` |
| `0x37` | IMX | `line_input_mod_fx_send` |
| `0x38` | IDE | `line_input_delay_send` |
| `0x39` | IRE | `line_input_reverb_send` |
| `0x3a` | VI2 | `second_line_input_volume` |
| `0x3b` | IM2 | `second_line_input_mod_fx_send` |
| `0x3c` | ID2 | `second_line_input_delay_send` |
| `0x3d` | IR2 | `second_line_input_reverb_send` |
| `0x3e` | USB | `usb_input_volume` |
| `0x3f` | DJR | `dj_filter_resonance` |
| `0x40` | DJT | `dj_filter_type` |
| `0x41` | EQM | `main_song_eq_assignment` |
| `0x42` | EQI | `current_instrument_eq_assignment` |
| `0x48` | XRH | `reverb_highpass` |
| `0x49` | XMT | `mod_fx_type_and_phase` |
| `0x4a` | OTT | `ott` |
| `0x4b` | OTC | `ott_color` |
| `0x4c` | OTI | `ott_time` |

### Sequencer

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x00` | ARP | `arpeggio` |
| `0x01` | CHA | `chance` |
| `0x02` | DEL | `delay` |
| `0x03` | GRV | `groove` |
| `0x04` | HOP | `hop` |
| `0x05` | KIL | `kill_note` |
| `0x06` | RND | `randomize` |
| `0x07` | RNL | `randomize_left` |
| `0x08` | RET | `retrig` |
| `0x09` | REP | `repeat` |
| `0x0a` | RMX | `remix` |
| `0x0b` | NTH | `nth` |
| `0x0c` | PSL | `pitch_slide` |
| `0x0d` | PBN | `pitch_bend` |
| `0x0e` | PVB | `vibrato` |
| `0x0f` | PVX | `extreme_vibrato` |
| `0x10` | SCA | `track_scale` |
| `0x11` | SCG | `global_scale` |
| `0x12` | SED | `random_seed` |
| `0x13` | SNG | `song_hop` |
| `0x14` | TBL | `table` |
| `0x15` | THO | `table_hop` |
| `0x16` | TIC | `table_tick` |
| `0x17` | TBX | `aux_table` |
| `0x18` | TPO | `tempo` |
| `0x19` | TSP | `transpose` |
| `0x1a` | OFF | `note_off` |
| `0x43` | INS | `instrument` |
| `0x44` | RTO | `repeat_boundary` |
| `0x45` | ARC | `arpeggio_config` |
| `0x46` | GGR | `global_groove` |
| `0x47` | NXT | `next_track` |
| `0x4d` | MTT | `micro_time` |

## 6.6.x

Based on firmware `6.6.3C`. Values come from [schemas/file-versions/6.5.0/song/sequencing.ksy](../schemas/file-versions/6.5.0/song/sequencing.ksy) and [schemas/file-versions/6.0.1/instrument/table.ksy](../schemas/file-versions/6.0.1/instrument/table.ksy). Shared schemas may be carried forward provisionally rather than independently retested for every firmware range.

### Instrument (Current Instrument)

These enums contain fixture-verified command subsets for each instrument, not every command available in an FX slot.

#### Wavsynth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | OSC | `oscillator` |
| `0x84` | SIZ | `size` |
| `0x85` | MUL | `mult` |
| `0x86` | WRP | `warp` |
| `0x87` | SCN | `scan` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SNC | `snc` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### Macrosynth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | OSC | `oscillator` |
| `0x84` | TBR | `timbre` |
| `0x85` | COL | `color` |
| `0x86` | DEG | `degrade` |
| `0x87` | RED | `redux` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | TRG | `trigger` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### Sampler

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | PLY | `play` |
| `0x84` | STA | `start` |
| `0x85` | LOP | `loop` |
| `0x86` | LEN | `length` |
| `0x87` | DEG | `degrade` |
| `0x88` | FLT | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SLI | `slice` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### FM Synth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | ALG | `algorithm` |
| `0x84` | FM1 | `fm1` |
| `0x85` | FM2 | `fm2` |
| `0x86` | FM3 | `fm3` |
| `0x87` | FM4 | `fm4` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SNC | `snc` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### MIDI Out

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | MPG | `midi_program` |
| `0x83` | MPB | `midi_program_bank` |
| `0x84` | ADD | `add` |
| `0x85` | CHD | `chord` |
| `0x86` | CCA | `cc_a` |
| `0x87` | CCB | `cc_b` |
| `0x88` | CCC | `cc_c` |
| `0x89` | CCD | `cc_d` |
| `0x8a` | CCE | `cc_e` |
| `0x8b` | CCF | `cc_f` |
| `0x8c` | CCG | `cc_g` |
| `0x8d` | CCH | `cc_h` |
| `0x8e` | CCI | `cc_i` |
| `0x8f` | CCJ | `cc_j` |
| `0xff` | -- | `unset` |

#### Hypersynth

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | FIN | `fine` |
| `0x83` | CRD | `chord` |
| `0x84` | CVO | `chord_volume` |
| `0x85` | SWM | `swarm` |
| `0x86` | WID | `width` |
| `0x87` | SUB | `subosc` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | SNC | `snc` |
| `0xa7` | ERR | `err` |
| `0xff` | -- | `unset` |

#### External

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x80` | VOL | `volume` |
| `0x81` | PIT | `pitch` |
| `0x82` | MPB | `midi_program_bank` |
| `0x83` | MPG | `midi_program` |
| `0x84` | CCA | `cc_a` |
| `0x85` | CCB | `cc_b` |
| `0x86` | CCC | `cc_c` |
| `0x87` | CCD | `cc_d` |
| `0x88` | FIL | `filter` |
| `0x89` | CUT | `cutoff` |
| `0x8a` | RES | `resonance` |
| `0x8b` | AMP | `amp` |
| `0x8c` | LIM | `limit` |
| `0x8d` | PAN | `pan` |
| `0x8e` | DRY | `dry` |
| `0x8f` | SMX | `smx` |
| `0x90` | SDL | `send_delay` |
| `0x91` | SRV | `send_reverb` |
| `0xa6` | ADD | `add` |
| `0xa7` | CHD | `chord` |
| `0xff` | -- | `unset` |

#### NONE

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0xff` | -- | `unset` |

### Instrument Mods

No verified command-value enum is available yet. Labels depend on the selected modulation slot and modulation type; targeted fixtures are needed before listing byte values.

### Mixer & Effects

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x1b` | VMV | `main_volume` |
| `0x1c` | XMM | `mod_fx_modulation_depth` |
| `0x1d` | XMF | `mod_fx_modulation_frequency` |
| `0x1e` | XMW | `mod_fx_stereo_width` |
| `0x1f` | XMR | `mod_fx_reverb_mix` |
| `0x20` | XDT | `delay_time` |
| `0x21` | XDF | `delay_feedback` |
| `0x22` | XDW | `delay_stereo_width` |
| `0x23` | XDR | `delay_reverb_mix` |
| `0x24` | XRS | `reverb_room_size` |
| `0x25` | XRD | `reverb_decay` |
| `0x26` | XRM | `reverb_modulation_depth` |
| `0x27` | XRF | `reverb_modulation_frequency` |
| `0x28` | XRW | `reverb_stereo_width` |
| `0x29` | XRZ | `reverb_freeze` |
| `0x2a` | VMX | `mod_fx_volume` |
| `0x2b` | VDE | `delay_volume` |
| `0x2c` | VRE | `reverb_volume` |
| `0x2d` | VT1 | `track_1_volume` |
| `0x2e` | VT2 | `track_2_volume` |
| `0x2f` | VT3 | `track_3_volume` |
| `0x30` | VT4 | `track_4_volume` |
| `0x31` | VT5 | `track_5_volume` |
| `0x32` | VT6 | `track_6_volume` |
| `0x33` | VT7 | `track_7_volume` |
| `0x34` | VT8 | `track_8_volume` |
| `0x35` | DJC | `dj_filter_cutoff` |
| `0x36` | VIN | `line_input_volume` |
| `0x37` | IMX | `line_input_mod_fx_send` |
| `0x38` | IDE | `line_input_delay_send` |
| `0x39` | IRE | `line_input_reverb_send` |
| `0x3a` | VI2 | `second_line_input_volume` |
| `0x3b` | IM2 | `second_line_input_mod_fx_send` |
| `0x3c` | ID2 | `second_line_input_delay_send` |
| `0x3d` | IR2 | `second_line_input_reverb_send` |
| `0x3e` | USB | `usb_input_volume` |
| `0x3f` | DJR | `dj_filter_resonance` |
| `0x40` | DJT | `dj_filter_type` |
| `0x41` | EQM | `main_song_eq_assignment` |
| `0x42` | EQI | `current_instrument_eq_assignment` |
| `0x48` | XRH | `reverb_highpass` |
| `0x49` | XMT | `mod_fx_type_and_phase` |
| `0x4a` | OTT | `ott` |
| `0x4b` | OTC | `ott_color` |
| `0x4c` | OTI | `ott_time` |

### Sequencer

| Stored Value | M8 Label | Identifier |
| --- | --- | --- |
| `0x00` | ARP | `arpeggio` |
| `0x01` | CHA | `chance` |
| `0x02` | DEL | `delay` |
| `0x03` | GRV | `groove` |
| `0x04` | HOP | `hop` |
| `0x05` | KIL | `kill_note` |
| `0x06` | RND | `randomize` |
| `0x07` | RNL | `randomize_left` |
| `0x08` | RET | `retrig` |
| `0x09` | REP | `repeat` |
| `0x0a` | RMX | `remix` |
| `0x0b` | NTH | `nth` |
| `0x0c` | PSL | `pitch_slide` |
| `0x0d` | PBN | `pitch_bend` |
| `0x0e` | PVB | `vibrato` |
| `0x0f` | PVX | `extreme_vibrato` |
| `0x10` | SCA | `track_scale` |
| `0x11` | SCG | `global_scale` |
| `0x12` | SED | `random_seed` |
| `0x13` | SNG | `song_hop` |
| `0x14` | TBL | `table` |
| `0x15` | THO | `table_hop` |
| `0x16` | TIC | `table_tick` |
| `0x17` | TBX | `aux_table` |
| `0x18` | TPO | `tempo` |
| `0x19` | TSP | `transpose` |
| `0x1a` | OFF | `note_off` |
| `0x43` | INS | `instrument` |
| `0x44` | RTO | `repeat_boundary` |
| `0x45` | ARC | `arpeggio_config` |
| `0x46` | GGR | `global_groove` |
| `0x47` | NXT | `next_track` |
| `0x4d` | MTT | `micro_time` |
