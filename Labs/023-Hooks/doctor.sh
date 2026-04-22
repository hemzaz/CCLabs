#!/usr/bin/env bash
# Labs/023-Hooks/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, jq or python3 available for JSON parsing,
#         quips/.claude/ is present or can be created.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 023 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# JSON parsing requires jq or python3 (python3 ships with macOS and most Linux distros).
if ! command -v jq >/dev/null 2>&1 && ! command -v python3 >/dev/null 2>&1; then
  echo "neither jq nor python3 found — install jq: brew install jq" >&2
  exit 1
fi

# quips/.claude/ must be present or creatable (needed for hooks and settings.json).
if [[ ! -d "quips/.claude" ]]; then
  mkdir -p "quips/.claude" 2>/dev/null || {
    echo "cannot create quips/.claude/ — check directory permissions" >&2
    exit 1
  }
fi

exit 0
