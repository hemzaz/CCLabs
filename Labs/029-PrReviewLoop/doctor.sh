#!/usr/bin/env bash
# doctor.sh — pre-flight checks for Lab 029 (PR Review Loop)
set -euo pipefail

PASS=0
FAIL=0

ok()   { echo "  ok  $1"; ((PASS++)) || true; }
fail() { echo "FAIL  $1" >&2; ((FAIL++)) || true; }

echo "=== Lab 029 pre-flight ==="

# 1. claude binary on PATH
if command -v claude &>/dev/null; then
  ok "claude is on PATH ($(command -v claude))"
else
  fail "claude not found on PATH — install Claude Code first"
fi

# 2. quips directory exists
if [[ -d quips ]]; then
  ok "quips/ directory exists"
else
  fail "quips/ directory not found — run from the CCLabs repo root"
fi

# 3. quips is a git repo
if git -C quips rev-parse --git-dir &>/dev/null; then
  ok "quips/ is a git repository"
else
  fail "quips/ is not a git repository — complete earlier labs first"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
  echo "OK lab 029 pre-flight green"
  exit 0
else
  echo "FAIL lab 029 pre-flight: $FAIL check(s) failed" >&2
  exit 1
fi
