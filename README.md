# m8-lib

Language-agnostic schemas for [Dirtywave M8](https://dirtywave.com/)
Instrument, Scale, Song, and Theme files. This repository documents the binary
file layouts through [Kaitai Struct](https://kaitai.io/) schemas,
firmware-versioned fixtures, and human-readable references generated from the
schemas. It does not provide a user-facing M8 library or production
reader/writer.

This is an independent community project. It is not an official Dirtywave M8
project and is not affiliated with or endorsed by Dirtywave. My hopes are that
this information helps others to build tooling for the M8 community as easily
as possible.

## Supported firmware ranges

| M8 firmware | Last verified release | Schema | File reference |
| --- | --- | --- | --- |
| 6.5.x | 6.5.2C | [6.5.x.ksy](schemas/6.5.x.ksy) | [6.5.x](docs/6.5.x.md) |
| 6.6.x | 6.6.3C | [6.6.x.ksy](schemas/6.6.x.ksy) | [6.6.x](docs/6.6.x.md) |

The firmware range selects an entry schema. Each M8 file also carries its own
file-schema version, which may differ from the firmware version. Verification
covers the committed fixtures; it does not establish every possible M8 file
or setting for a range.

## Repository contents

- [`schemas/`](schemas/): canonical Kaitai entry schemas and reusable file-version components.
- [`docs/`](docs/): generated file references plus design and research notes.
- [`fixtures/`](fixtures/): M8-produced binary examples and manifests of controlled changes.
- [`tools/`](tools/): header inspection, fixture comparison, documentation generation, and verification.

## Verify

Install Node.js and the [Kaitai Struct compiler](https://kaitai.io/#download),
then run:

```sh
npm ci
npm run verify
```

`npm run verify` checks both firmware targets, including schema compilation,
parsed fixtures, and generated documentation. To regenerate the references
after changing a schema, run `npm run docs:generate`. See
[documentation generation](docs/DOCUMENTATION_GENERATION.md) for the target
registration process.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
