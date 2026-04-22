#!/usr/bin/env bash
# Labs/001-InstallAuth/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks baseline only: node >= 20 and npm on PATH.
# Does NOT require claude itself — that is what this lab installs.
set -euo pipefail

# npm must be on PATH (implies node is available via npm's bundled runtime, but we
# also check node directly for a clearer error message).
if ! command -v node >/dev/null 2>&1; then
  echo "missing: node (not on PATH) — install Node 20+: https://nodejs.org/" >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "missing: npm (not on PATH) — install Node 20+ which bundles npm: https://nodejs.org/" >&2
  exit 1
fi

# Require node >= 20.
node_major="$(node --version | sed 's/^v//' | cut -d. -f1)"
if [[ "$node_major" -lt 20 ]]; then
  echo "node version too old: $(node --version) — need >= 20: https://nodejs.org/" >&2
  exit 1
fi

exit 0
