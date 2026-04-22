#!/usr/bin/env bash
# Labs/015-CustomInstructions/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH and quips/CLAUDE.md exists (Lab 011 artifact).
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 015 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips/CLAUDE.md must exist (Lab 011 artifact).
[[ -f "quips/CLAUDE.md" ]] || {
  echo "missing: quips/CLAUDE.md — complete Lab 011 first" >&2
  exit 1
}

exit 0
