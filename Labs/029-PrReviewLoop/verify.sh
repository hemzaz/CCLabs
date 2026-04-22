#!/usr/bin/env bash
# verify.sh — assertions for Lab 029 (PR Review Loop)
set -euo pipefail

PASS=0
FAIL=0

ok()   { echo "  ok  $1"; ((PASS++)) || true; }
fail() { echo "FAIL  $1" >&2; ((FAIL++)) || true; }

echo "=== Lab 029 verify ==="

# 1. review-comments.md exists with at least 3 lines
if [[ -f quips/review-comments.md ]]; then
  ok "quips/review-comments.md exists"
  LINE_COUNT=$(wc -l < quips/review-comments.md)
  if [[ $LINE_COUNT -ge 3 ]]; then
    ok "quips/review-comments.md has $LINE_COUNT lines (>= 3)"
  else
    fail "quips/review-comments.md has only $LINE_COUNT line(s) — need at least 3"
  fi
else
  fail "quips/review-comments.md not found — complete Do step 2"
fi

# 2. PR-LOOP.md exists and is non-empty
if [[ -s quips/PR-LOOP.md ]]; then
  ok "quips/PR-LOOP.md exists and is non-empty"
else
  fail "quips/PR-LOOP.md missing or empty — complete Do step 4"
fi

# 3. PR-LOOP.md mentions at least one of: review, comment, applied, test
if grep -qi 'review\|comment\|applied\|test' quips/PR-LOOP.md 2>/dev/null; then
  ok "quips/PR-LOOP.md contains expected content keyword"
else
  fail "quips/PR-LOOP.md does not mention review, comment, applied, or test — check headless output"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
  echo "OK lab 029 all checks passed"
  exit 0
else
  echo "FAIL lab 029: $FAIL check(s) failed" >&2
  exit 1
fi
