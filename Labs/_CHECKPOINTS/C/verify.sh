#!/usr/bin/env bash
set -euo pipefail

# Checkpoint C verify script.
# Run from repo root: ./Labs/_CHECKPOINTS/C/verify.sh
# Called by: ./scripts/checkpoint.sh C

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

[[ -s quips/CLAUDE.md ]] \
  || fail "quips/CLAUDE.md is missing or empty"

rule_count=$(grep -cE '^[-*]|^[0-9]+\.' quips/CLAUDE.md || true)
[[ "$rule_count" -ge 5 ]] \
  || fail "quips/CLAUDE.md has fewer than 5 rule lines (found ${rule_count})"

grep -q 'PATCH' quips/src/server.js \
  || fail "PATCH /quips/:id route not found in quips/src/server.js"

grep -q 'PATCH' quips/test/server.test.js \
  || fail "PATCH tests not found in quips/test/server.test.js"

(cd quips && npm test --silent) \
  || fail "quips test suite did not pass"

[[ -s Labs/_CHECKPOINTS/C/reflection.md ]] \
  || fail "Labs/_CHECKPOINTS/C/reflection.md is missing or empty"

grep -qi 'quiz' Labs/_CHECKPOINTS/C/reflection.md \
  || fail "reflection.md is missing a 'Quiz: X/5' self-debrief line"

echo "OK checkpoint C passed"
