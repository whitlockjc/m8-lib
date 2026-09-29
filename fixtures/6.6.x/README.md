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
