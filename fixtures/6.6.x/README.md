# 6.6.x Fixtures

The 11 baselines and three targeted edits were copied from the mounted
`/Volumes/M8Headless` SD card. The user reports firmware **6.6.3C** for every
file. The physical device model has not been independently confirmed from the
files.

The eight Instrument files are in `instruments/`, with their 6.5.x baseline
filenames. The Song and Theme are `songs/DEFAULT.m8s` and
`themes/DEFAULT.m8t`. The Scale is `scales/CHROMATIC.m8n`: the M8 name limit
prevented `CHROMATIC_DEFAULT` on the device. It is still the default Scale
fixture; no rename or normalization has been applied to its stored bytes.

The three targeted edits are `HYP_SHAPE.m8i`, `MODFX_COMB.m8s`, and
`BOOKMARKS.m8s`. Their corresponding YAML manifests record the exact
changed bytes and unrelated save-state changes. The 6.6.x schema parses and
validates these fixtures, but full semantic compatibility of reused 6.5.x
fields still needs targeted checks. Evidence is recorded in
[`6.6.x_BASELINE.md`](../../docs/research/6.6.x_BASELINE.md) and
[`6.6.x_TARGETED.md`](../../docs/research/6.6.x_TARGETED.md).

An additional 6.6.3C export pair, `instruments/HYP_EMB_A.m8i` and
`instruments/HYP_EMB_B.m8i`, was copied from the same volume on 2026-10-13.
`HYP_EMB_B.yaml` accounts for its two changed bytes (name suffix and Shape).
Source paths and matching hashes are recorded in the targeted findings.
The matching `songs/HYP_EMB_A.m8s` and `songs/HYP_EMB_B.m8s` were subsequently
supplied: each loads its corresponding export into slot `7F`. The full embedded
instrument record and associated table equal their standalone counterparts.
The Song manifest records both name changes and Shape, with the unrelated
unknown Project-state byte recorded separately. Screenshots have not been
supplied. This completes the byte comparison for this pair, not general
embedded Instrument coverage.

The 6.6.3C `SCALE_A/B.m8n` and `SCALE_A/B.m8s` pairs were imported on
2026-10-13. Each 46-byte standalone Scale body equals Song slot `00`.
The tuning offset changes from 0.0 to 1.0, consistent with the requested
440.00 to 441.00 Hz edit. Manifests account for names and tuning, with the
unknown Song state byte recorded separately. Screenshots were omitted by
user choice. Source paths, hashes, and evidence limits are in the targeted
findings. Slot `0F` is not covered by this capture.

The subsequent 6.6.3C `songs/SCALE_F_A.m8s` and `songs/SCALE_F_B.m8s`
fixtures load the existing A/B Scale exports into slot `0F`. Each complete
last Scale record matches its corresponding standalone body. The manifest
accounts for name and tuning changes and separately records the unknown
Project-state byte. Both Scale bank boundaries are now covered for this
tuning edit; other Scale parameter changes remain outside this evidence.
