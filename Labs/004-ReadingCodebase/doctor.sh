#!/usr/bin/env bash
# Labs/004-ReadingCodebase/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH AND the quips spine project is present.
set -euo pipefail

if ! command -v claude >/dev/null 2>&1; then
  echo "missing: claude (not on PATH) — complete Lab 001 first: npm i -g @anthropic-ai/claude-code" >&2
  exit 1
fi

QUIPS_SERVER="/Users/elad/PROJ/CCLabs/quips/src/server.js"
if [[ ! -f "$QUIPS_SERVER" ]]; then
  echo "missing spine project: $QUIPS_SERVER — ensure the quips submodule is checked out" >&2
  exit 1
fi

exit 0
