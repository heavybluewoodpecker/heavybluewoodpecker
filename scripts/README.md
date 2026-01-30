# Scripts

This directory contains small helper scripts for working with the artifacts in this repository.

## `verify-checksums.sh`

Verifies the integrity of binary artifacts listed in `CHECKSUMS.txt`.

```bash
./scripts/verify-checksums.sh
```

This uses `sha256sum --check` under the hood. Run it after cloning the repo or copying files to ensure the Magisk APK (and any future binaries you add) were not corrupted or tampered with.
