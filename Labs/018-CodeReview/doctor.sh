#!/usr/bin/env bash
# doctor.sh — pre-flight check for Lab 018 (Code Review)
set -euo pipefail

ERRORS=0

fail() {
  echo "FAIL $1" >&2
  ERRORS=$((ERRORS + 1))
}

# claude must be on PATH
if ! command -v claude >/dev/null 2>&1; then
  fail "claude not found on PATH — install Claude Code first"
fi

# quips directory must exist
if [[ ! -d quips ]]; then
  fail "quips/ directory not found — complete Lab 005 first"
fi

# quips/src/server.js must exist (artifact from prior labs)
if [[ ! -f quips/src/server.js ]]; then
  fail "quips/src/server.js not found — complete Lab 005 through Lab 017 first"
fi

if [[ $ERRORS -eq 0 ]]; then
  echo "OK lab 018 pre-flight green"
else
  echo "FAIL lab 018 pre-flight: $ERRORS error(s) found" >&2
  exit 1
fi
