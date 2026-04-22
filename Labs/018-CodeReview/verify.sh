#!/usr/bin/env bash
# verify.sh — acceptance check for Lab 018 (Code Review)
set -euo pipefail

TARGET="quips/REVIEW-NOTES.md"
ERRORS=0

fail() {
  echo "$1" >&2
  ERRORS=$((ERRORS + 1))
}

# File must exist
if [[ ! -f "$TARGET" ]]; then
  fail "FAIL: $TARGET does not exist — complete the Make step first"
  exit 1
fi

# File must be non-empty
if [[ ! -s "$TARGET" ]]; then
  fail "FAIL: $TARGET is empty"
fi

# File must have at least 10 lines
LINE_COUNT=$(wc -l < "$TARGET")
if [[ $LINE_COUNT -lt 10 ]]; then
  fail "FAIL: $TARGET has $LINE_COUNT lines — need at least 10"
fi

# File must contain at least one line with "Challenge" or "challenge"
if ! grep -qi "challenge" "$TARGET"; then
  fail "FAIL: $TARGET contains no line matching 'Challenge' or 'challenge'"
fi

if [[ $ERRORS -eq 0 ]]; then
  echo "OK lab 018 verified"
else
  exit 1
fi
