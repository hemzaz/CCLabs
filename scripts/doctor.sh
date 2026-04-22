#!/usr/bin/env bash
# doctor.sh - pre-flight check for a single lab.
# Usage: ./scripts/doctor.sh NNN
# Exit: 0 green; non-zero with a one-line diagnosis on stderr.

set -euo pipefail

LAB="${1:-}"
if [[ -z "$LAB" ]]; then
  echo "usage: scripts/doctor.sh <lab-number, e.g. 001>" >&2
  exit 2
fi

# Baseline prereqs re-checked by every lab. Extend per-lab via Labs/NNN-*/doctor.sh.
need() {
  local name="$1" cmd="$2" hint="${3:-}"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "missing: $name ($cmd not on PATH). ${hint}" >&2
    return 1
  fi
}

need git git
need node node "install Node 20: https://nodejs.org/"
need npm npm
need claude claude "install: npm i -g @anthropic-ai/claude-code"

# Lab directory must exist.
LAB_DIR="$(find Labs -maxdepth 1 -type d -name "${LAB}-*" 2>/dev/null | head -1 || true)"
if [[ -z "$LAB_DIR" ]]; then
  echo "no lab directory matching ${LAB}-* (run scripts/labs.sh list)" >&2
  exit 1
fi

# Lab-specific pre-flight hook (optional, executed if present and executable).
if [[ -x "$LAB_DIR/doctor.sh" ]]; then
  "$LAB_DIR/doctor.sh"
fi

echo "OK lab ${LAB} pre-flight green"
