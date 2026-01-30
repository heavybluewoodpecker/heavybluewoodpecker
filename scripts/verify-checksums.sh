#!/usr/bin/env bash
set -euo pipefail

# Simple helper to verify checksums for binary artifacts in this repo.
#
# Usage:
#   ./scripts/verify-checksums.sh
#
# Requires coreutils `sha256sum`.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
cd "$REPO_ROOT"

if [[ ! -f CHECKSUMS.txt ]]; then
  echo "ERROR: CHECKSUMS.txt not found in repo root" >&2
  exit 1
fi

sha256sum --check CHECKSUMS.txt
