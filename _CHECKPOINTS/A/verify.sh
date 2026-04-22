#!/usr/bin/env bash
set -euo pipefail

# Checkpoint A verify script.
# Run from repo root: ./Labs/_CHECKPOINTS/A/verify.sh
# Called by: ./scripts/checkpoint.sh A

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

grep -q "/version" quips/src/server.js \
  || fail "GET /version route not found in quips/src/server.js"

grep -q "/version" quips/test/server.test.js \
  || fail "/version test not found in quips/test/server.test.js"

(cd quips && npm test --silent) \
  || fail "quips test suite did not pass"

[[ -s Labs/_CHECKPOINTS/A/reflection.md ]] \
  || fail "Labs/_CHECKPOINTS/A/reflection.md is missing or empty"

grep -qi 'quiz' Labs/_CHECKPOINTS/A/reflection.md \
  || fail "reflection.md is missing a 'Quiz: X/5' self-debrief line"

echo "OK checkpoint A passed"
