#!/usr/bin/env bash
set -euo pipefail

# Checkpoint D verify script.
# Run from repo root: ./Labs/_CHECKPOINTS/D/verify.sh
# Called by: ./scripts/checkpoint.sh D

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

grep -qE 'DELETE|app\.delete|router\.delete' quips/src/server.js \
  || fail "DELETE /quips/:id route not found in quips/src/server.js"

grep -q 'DELETE' quips/test/server.test.js \
  || fail "DELETE tests not found in quips/test/server.test.js"

[[ -x quips/verify-delete.sh ]] \
  || fail "quips/verify-delete.sh is missing or not executable"

(cd quips && npm test --silent) \
  || fail "quips test suite did not pass"

[[ -s Labs/_CHECKPOINTS/D/reflection.md ]] \
  || fail "Labs/_CHECKPOINTS/D/reflection.md is missing or empty"

grep -qi 'quiz' Labs/_CHECKPOINTS/D/reflection.md \
  || fail "reflection.md is missing a 'Quiz: X/5' self-debrief line"

echo "OK checkpoint D passed"
