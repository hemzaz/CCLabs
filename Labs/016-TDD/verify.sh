#!/usr/bin/env bash
# Labs/016-TDD/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/test/validation.test.js exists, contains at least one test call, and npm test passes.
# Must be idempotent and run in <30s.
set -euo pipefail

[[ -f "quips/test/validation.test.js" ]] || {
  echo "missing: quips/test/validation.test.js — complete Lab 016 step 2 first" >&2
  exit 1
}

grep -qE 'test\(|it\(' quips/test/validation.test.js || {
  echo "invalid: quips/test/validation.test.js has no test() or it() calls — add at least one assertion" >&2
  exit 1
}

(cd quips && npm test --silent) || {
  echo "quips tests failed — run 'cd quips && npm test' to see errors" >&2
  exit 1
}

exit 0
