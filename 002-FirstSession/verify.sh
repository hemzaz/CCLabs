#!/usr/bin/env bash
# Labs/002-FirstSession/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Asserts: Labs/002-FirstSession/transcript.md exists, is non-empty, and contains "node".
# Must be idempotent and run in <10s.
set -euo pipefail

TRANSCRIPT="Labs/002-FirstSession/transcript.md"

if [[ ! -f "$TRANSCRIPT" ]]; then
  echo "missing artifact: $TRANSCRIPT — complete Lab 002 and save your transcript" >&2
  exit 1
fi

if [[ ! -s "$TRANSCRIPT" ]]; then
  echo "artifact is empty: $TRANSCRIPT — transcript must contain session content" >&2
  exit 1
fi

if ! grep -qi "node" "$TRANSCRIPT"; then
  echo "artifact missing required word: $TRANSCRIPT must contain 'node' (case-insensitive)" >&2
  exit 1
fi

exit 0
