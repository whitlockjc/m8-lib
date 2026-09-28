#!/usr/bin/env sh

set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$ROOT"

tools/map-fixture.js \
  fixtures/6.5.x/instruments/NONE_DEFAULT.m8i \
  fixtures/6.5.x/instruments/NONE_TABLE.m8i \
  fixtures/6.5.x/instruments/NONE_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/WAV_DEFAULT.m8i \
  fixtures/6.5.x/instruments/WAV_PARAMS.m8i \
  fixtures/6.5.x/instruments/WAV_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/WAV_DEFAULT.m8i \
  fixtures/6.5.x/instruments/WAV_MODS_A.m8i \
  fixtures/6.5.x/instruments/WAV_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/WAV_DEFAULT.m8i \
  fixtures/6.5.x/instruments/WAV_MODS_B.m8i \
  fixtures/6.5.x/instruments/WAV_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/WAV_DEFAULT.m8i \
  fixtures/6.5.x/instruments/WAV_TABLE.m8i \
  fixtures/6.5.x/instruments/WAV_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MAC_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MAC_PARAMS.m8i \
  fixtures/6.5.x/instruments/MAC_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MAC_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MAC_MODS_A.m8i \
  fixtures/6.5.x/instruments/MAC_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MAC_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MAC_MODS_B.m8i \
  fixtures/6.5.x/instruments/MAC_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MAC_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MAC_TABLE.m8i \
  fixtures/6.5.x/instruments/MAC_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/SAM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/SAM_PARAMS.m8i \
  fixtures/6.5.x/instruments/SAM_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/SAM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/SAM_MODS_A.m8i \
  fixtures/6.5.x/instruments/SAM_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/SAM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/SAM_MODS_B.m8i \
  fixtures/6.5.x/instruments/SAM_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/SAM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/SAM_TABLE.m8i \
  fixtures/6.5.x/instruments/SAM_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/SAM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/SAMS_PARAMS.m8i \
  fixtures/6.5.x/instruments/SAMS_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/SAM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/SAMB_PARAMS.m8i \
  fixtures/6.5.x/instruments/SAMB_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MID_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MID_PARAMS.m8i \
  fixtures/6.5.x/instruments/MID_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MID_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MID_MODS_A.m8i \
  fixtures/6.5.x/instruments/MID_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MID_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MID_MODS_B.m8i \
  fixtures/6.5.x/instruments/MID_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/MID_DEFAULT.m8i \
  fixtures/6.5.x/instruments/MID_TABLE.m8i \
  fixtures/6.5.x/instruments/MID_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/FM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/FM_PARAMS.m8i \
  fixtures/6.5.x/instruments/FM_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/FM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/FM_MODS_A.m8i \
  fixtures/6.5.x/instruments/FM_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/FM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/FM_MODS_B.m8i \
  fixtures/6.5.x/instruments/FM_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/FM_DEFAULT.m8i \
  fixtures/6.5.x/instruments/FM_TABLE.m8i \
  fixtures/6.5.x/instruments/FM_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/HYP_DEFAULT.m8i \
  fixtures/6.5.x/instruments/HYP_PARAMS.m8i \
  fixtures/6.5.x/instruments/HYP_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/HYP_DEFAULT.m8i \
  fixtures/6.5.x/instruments/HYP_MODS_A.m8i \
  fixtures/6.5.x/instruments/HYP_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/HYP_DEFAULT.m8i \
  fixtures/6.5.x/instruments/HYP_MODS_B.m8i \
  fixtures/6.5.x/instruments/HYP_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/HYP_DEFAULT.m8i \
  fixtures/6.5.x/instruments/HYP_TABLE.m8i \
  fixtures/6.5.x/instruments/HYP_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/EXT_DEFAULT.m8i \
  fixtures/6.5.x/instruments/EXT_PARAMS.m8i \
  fixtures/6.5.x/instruments/EXT_PARAMS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/EXT_DEFAULT.m8i \
  fixtures/6.5.x/instruments/EXT_MODS_A.m8i \
  fixtures/6.5.x/instruments/EXT_MODS_A.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/EXT_DEFAULT.m8i \
  fixtures/6.5.x/instruments/EXT_MODS_B.m8i \
  fixtures/6.5.x/instruments/EXT_MODS_B.yaml

tools/map-fixture.js \
  fixtures/6.5.x/instruments/EXT_DEFAULT.m8i \
  fixtures/6.5.x/instruments/EXT_TABLE.m8i \
  fixtures/6.5.x/instruments/EXT_TABLE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/PROJECT.m8s \
  fixtures/6.5.x/songs/PROJECT.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/MIDI_SETTING.m8s \
  fixtures/6.5.x/songs/MIDI_SETTING.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/SONG_ROWS.m8s \
  fixtures/6.5.x/songs/SONG_ROWS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/PHRASES.m8s \
  fixtures/6.5.x/songs/PHRASES.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/BOOKMARKS.m8s \
  fixtures/6.5.x/songs/BOOKMARKS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/CHAINS.m8s \
  fixtures/6.5.x/songs/CHAINS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/INSTRUMENTS.m8s \
  fixtures/6.5.x/songs/INSTRUMENTS.yaml

node tools/verify-embedded-instruments.js

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/TABLES.m8s \
  fixtures/6.5.x/songs/TABLES.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/SCALES.m8s \
  fixtures/6.5.x/songs/SCALES.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/KEY_ONLY.m8s \
  fixtures/6.5.x/songs/KEY_ONLY.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/MIXER.m8s \
  fixtures/6.5.x/songs/MIXER.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/GROOVES.m8s \
  fixtures/6.5.x/songs/GROOVES.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/EFFECTS.m8s \
  fixtures/6.5.x/songs/EFFECTS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/MIX_SCOPE.m8s \
  fixtures/6.5.x/songs/MIX_SCOPE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/LIMIT_SCOPE.m8s \
  fixtures/6.5.x/songs/LIMIT_SCOPE.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/MIX_EQ.m8s \
  fixtures/6.5.x/songs/MIX_EQ.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/EQS.m8s \
  fixtures/6.5.x/songs/EQS.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/MODFX_EQ.m8s \
  fixtures/6.5.x/songs/MODFX_EQ.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/DELAY_EQ.m8s \
  fixtures/6.5.x/songs/DELAY_EQ.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/REVERB_EQ.m8s \
  fixtures/6.5.x/songs/REVERB_EQ.yaml

tools/map-fixture.js \
  fixtures/6.5.x/songs/DEFAULT.m8s \
  fixtures/6.5.x/songs/MIDI_MAPPING.m8s \
  fixtures/6.5.x/songs/MIDI_MAPPING.yaml

tools/map-fixture.js \
  fixtures/6.5.x/scales/CHROMATIC_DEFAULT.m8n \
  fixtures/6.5.x/scales/MODIFIED.m8n \
  fixtures/6.5.x/scales/MODIFIED.yaml

tools/map-fixture.js \
  fixtures/6.5.x/themes/DEFAULT.m8t \
  fixtures/6.5.x/themes/MODIFIED.m8t \
  fixtures/6.5.x/themes/MODIFIED.yaml
