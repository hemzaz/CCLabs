#!/usr/bin/env bash
# Labs/003-SlashCommands/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Assert notes.md exists and contains at least 3 lines starting with '/'.
# Must be idempotent and run in <10s.
set -euo pipefail

NOTES="Labs/003-SlashCommands/notes.md"

[[ -f "$NOTES" ]] || { echo "missing artifact: $NOTES" >&2; exit 1; }

count=$(grep -c '^/' "$NOTES" 2>/dev/null || true)
[[ "$count" -ge 3 ]] || { echo "notes.md must have at least 3 lines starting with '/' (found $count)" >&2; exit 1; }

exit 0
