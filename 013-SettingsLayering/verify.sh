#!/usr/bin/env bash
# Labs/013-SettingsLayering/verify.sh - lab-specific post-flight, called by scripts/verify.sh.
# Assert the expected artifact exists / tests pass / endpoint responds as spec'd.
# Must be idempotent and run in <10s.
set -euo pipefail

OBS="Labs/013-SettingsLayering/observations.md"

[[ -f "$OBS" ]] || { echo "missing artifact: $OBS" >&2; exit 1; }
[[ -s "$OBS" ]] || { echo "$OBS is empty" >&2; exit 1; }

grep -qi "user"    "$OBS" || { echo "$OBS must mention 'user' scope"    >&2; exit 1; }
grep -qi "project" "$OBS" || { echo "$OBS must mention 'project' scope" >&2; exit 1; }
grep -qi "local"   "$OBS" || { echo "$OBS must mention 'local' scope"   >&2; exit 1; }

exit 0
