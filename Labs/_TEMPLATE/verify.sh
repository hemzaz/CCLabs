#!/usr/bin/env bash
# Labs/_TEMPLATE/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Assert the expected artifact exists / tests pass / endpoint responds as spec'd.
# Must be idempotent and run in <10s.
set -euo pipefail

# Example shape:
# [[ -f quips/src/routes/version.js ]] || { echo "missing artifact: routes/version.js" >&2; exit 1; }
# (cd quips && npm test --silent) || { echo "quips tests failed" >&2; exit 1; }

exit 0
