#!/usr/bin/env bash
set -euo pipefail

# Checkpoint B verify script.
# Run from repo root: ./Labs/_CHECKPOINTS/B/verify.sh
# Called by: ./scripts/checkpoint.sh B

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

grep -q "limit" quips/src/server.js \
  || fail "pagination 'limit' param not found in quips/src/server.js"

grep -q "offset" quips/src/server.js \
  || fail "pagination 'offset' param not found in quips/src/server.js"

grep -qE "limit|offset" quips/test/server.test.js \
  || fail "pagination tests (limit/offset) not found in quips/test/server.test.js"

(cd quips && npm test --silent) \
  || fail "quips test suite did not pass"

[[ -s Labs/_CHECKPOINTS/B/reflection.md ]] \
  || fail "Labs/_CHECKPOINTS/B/reflection.md is missing or empty"

grep -qi "quiz" Labs/_CHECKPOINTS/B/reflection.md \
  || fail "reflection.md is missing a 'Quiz: X/5' self-debrief line"

echo "OK checkpoint B passed"
