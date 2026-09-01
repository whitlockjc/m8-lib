# Research Backlog

This document tracks observed M8 behavior that needs targeted fixture evidence
before it can become schema documentation.

## Theme Color Mode

Status: open

Observation:

- M8 6.5.x theme files store theme color values, but RGB versus HSV editing mode
  is not stored in the theme file itself.

Implication:

- Theme schemas should model stored color triples without a theme-level
  `mode` field unless future evidence proves otherwise.
- RGB/HSV editing mode may be stored in Song/Project data, device/global
  settings, or another location outside portable M8 files.

Needed research:

- Create fixtures that toggle theme RGB/HSV mode while holding theme color bytes
  constant.
- Compare Song/Project files or other available M8 storage before and after
  toggling the mode.
- If no portable M8 file changes, document the setting as device/global state
  outside the file schemas.

## Theme Display Name

Status: open

Observation:

- M8 6.5.x theme files with header schema version 1.0.2 contain the file header
  followed by 39 color bytes.
- The theme display name is not stored in the `.m8t` file body.

Implication:

- Theme schemas should not include a `name` field unless future fixture
  evidence proves one exists in another theme file version.
- Theme display names may come from filenames or external metadata.

Needed research:

- Confirm whether the M8 UI derives theme names from `.m8t` filenames.
- Check whether any companion metadata exists outside the portable `.m8t` file.

## Scale Key

Status: open

Observation:

- Scale key is displayed on the Scale Editor UI screen but is stored in the
  Song, not in the Scale file.

Implication:

- Scale schemas should not include a `key` field.

Needed research:

- Create Song fixtures that change only the active scale key.
- Map the stored Song field for scale key once Song settings are researched.
