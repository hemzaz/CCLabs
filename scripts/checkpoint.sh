#!/usr/bin/env bash
# checkpoint.sh - end-of-Part integration assessment.
# Usage: ./scripts/checkpoint.sh <A|B|C|D|E|F>
# Exit: 0 green; non-zero with a one-line diagnosis.

set -euo pipefail

CP="${1:-}"
if [[ -z "$CP" ]]; then
  echo "usage: scripts/checkpoint.sh <A-F>" >&2
  exit 2
fi

CP_DIR="Labs/_CHECKPOINTS/${CP}"
if [[ ! -d "$CP_DIR" ]]; then
  echo "checkpoint ${CP} not authored yet (expected directory: ${CP_DIR})" >&2
  exit 1
fi

if [[ ! -x "$CP_DIR/verify.sh" ]]; then
  echo "checkpoint ${CP} missing executable verify.sh" >&2
  exit 1
fi

"$CP_DIR/verify.sh"
echo "OK checkpoint ${CP} passed"
