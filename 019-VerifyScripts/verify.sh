#!/usr/bin/env bash
# Labs/019-VerifyScripts/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: quips/verify-feature.sh exists, is executable, and exits 0 on a clean run.
# Must be idempotent and run in <10s.
set -euo pipefail

[[ -f "quips/verify-feature.sh" ]] || {
  echo "missing: quips/verify-feature.sh — complete Lab 019 step 4 first" >&2
  exit 1
}

[[ -x "quips/verify-feature.sh" ]] || {
  echo "quips/verify-feature.sh is not executable — run: chmod +x quips/verify-feature.sh" >&2
  exit 1
}

bash quips/verify-feature.sh || {
  echo "quips/verify-feature.sh exited non-zero — the feature roundtrip is broken" >&2
  exit 1
}

exit 0
