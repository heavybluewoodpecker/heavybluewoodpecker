#!/usr/bin/env bash
set -euo pipefail

# Lightweight test harness for scripts/verify-checksums.sh
#
# Usage:
#   ./scripts/verify-checksums_test.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_UNDER_TEST="$SCRIPT_DIR/verify-checksums.sh"

failures=0

run_test() {
  local name="$1"
  shift
  echo "Running: $name"
  if "$@"; then
    echo "  PASS: $name"
  else
    echo "  FAIL: $name"
    failures=$((failures + 1))
  fi
}

make_temp_repo() {
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/scripts"
  cp "$SCRIPT_UNDER_TEST" "$tmp/scripts/"
  printf '%s\n' "$tmp"
}

# 1. The script exits with an error code if CHECKSUMS.txt is missing

test_missing_checksums_exits_with_error() {
  local tmp
  tmp="$(make_temp_repo)"

  if ( cd "$tmp" && bash ./scripts/verify-checksums.sh >"$tmp/out.log" 2>"$tmp/err.log" ); then
    echo "Expected script to fail when CHECKSUMS.txt is missing, but it succeeded"
    return 1
  fi

  if ! grep -q "CHECKSUMS.txt not found" "$tmp/err.log"; then
    echo "Expected error message about missing CHECKSUMS.txt, but did not find it"
    echo "stderr was:" >&2
    cat "$tmp/err.log" >&2 || true
    return 1
  fi

  return 0
}

# 2. The script successfully verifies valid checksums from CHECKSUMS.txt

test_valid_checksums_verify_successfully() {
  local tmp
  tmp="$(make_temp_repo)"

  (
    cd "$tmp"
    echo "hello world" > artifact.bin
    sha256sum artifact.bin > CHECKSUMS.txt

    if ! bash ./scripts/verify-checksums.sh >"$tmp/out.log" 2>"$tmp/err.log"; then
      echo "Expected script to succeed when checksums are valid, but it failed"
      echo "stderr was:" >&2
      cat "$tmp/err.log" >&2 || true
      return 1
    fi
  )

  return 0
}

# 3. The script fails verification for invalid checksums in CHECKSUMS.txt

test_invalid_checksums_fail_verification() {
  local tmp
  tmp="$(make_temp_repo)"

  (
    cd "$tmp"
    echo "hello world" > artifact.bin
    sha256sum artifact.bin > CHECKSUMS.txt

    # Corrupt the file so the checksum no longer matches
    echo "tampered" > artifact.bin

    if bash ./scripts/verify-checksums.sh >"$tmp/out.log" 2>"$tmp/err.log"; then
      echo "Expected script to fail when checksums are invalid, but it succeeded"
      echo "stdout was:" >&2
      cat "$tmp/out.log" >&2 || true
      echo "stderr was:" >&2
      cat "$tmp/err.log" >&2 || true
      return 1
    fi
  )

  return 0
}

# 4. The script correctly finds CHECKSUMS.txt when run from a subdirectory

test_finds_checksums_from_subdirectory() {
  local tmp
  tmp="$(make_temp_repo)"

  (
    cd "$tmp"
    mkdir -p subdir
    echo "hello world" > artifact.bin
    sha256sum artifact.bin > CHECKSUMS.txt

    cd subdir
    if ! bash ../scripts/verify-checksums.sh >"$tmp/out.log" 2>"$tmp/err.log"; then
      echo "Expected script to succeed when run from a subdirectory with valid CHECKSUMS.txt, but it failed"
      echo "stderr was:" >&2
      cat "$tmp/err.log" >&2 || true
      return 1
    fi
  )

  return 0
}

run_test "missing_checksums_exits_with_error" test_missing_checksums_exits_with_error
run_test "valid_checksums_verify_successfully" test_valid_checksums_verify_successfully
run_test "invalid_checksums_fail_verification" test_invalid_checksums_fail_verification
run_test "finds_checksums_from_subdirectory" test_finds_checksums_from_subdirectory

if (( failures > 0 )); then
  echo
  echo "$failures test(s) failed"
  exit 1
else
  echo
  echo "All tests passed"
  exit 0
fi
