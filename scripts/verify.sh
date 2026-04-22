#!/usr/bin/env bash
# verify.sh - post-flight check for a single lab.
# Usage: ./scripts/verify.sh NNN
# Exit: 0 green; non-zero with a one-line diagnosis. Must run in <10s.

set -euo pipefail

LAB="${1:-}"
if [[ -z "$LAB" ]]; then
  echo "usage: scripts/verify.sh <lab-number, e.g. 001>" >&2
  exit 2
fi

LAB_DIR="$(find Labs -maxdepth 1 -type d -name "${LAB}-*" 2>/dev/null | head -1 || true)"
if [[ -z "$LAB_DIR" ]]; then
  echo "no lab directory matching ${LAB}-*" >&2
  exit 1
fi

if [[ ! -x "$LAB_DIR/verify.sh" ]]; then
  echo "lab ${LAB} missing executable verify.sh (author contract violation)" >&2
  exit 1
fi

"$LAB_DIR/verify.sh"
echo "OK lab ${LAB} verified"
