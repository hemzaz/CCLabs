#!/usr/bin/env bash
# Labs/025-MCP/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, npx on PATH, python3 on PATH, quips/.claude/ exists or is creatable.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 025 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# npx is required to run the filesystem MCP server.
command -v npx >/dev/null 2>&1 || {
  echo "npx not found — install Node.js (https://nodejs.org) to get npx" >&2
  exit 1
}

# python3 is required for JSON validation in the Do steps.
command -v python3 >/dev/null 2>&1 || {
  echo "python3 not found — install Python 3 (https://python.org)" >&2
  exit 1
}

# quips/.claude/ must exist or be creatable so settings.json can be written there.
if [[ ! -d "quips/.claude" ]]; then
  mkdir -p "quips/.claude" || {
    echo "cannot create quips/.claude/ — check directory permissions" >&2
    exit 1
  }
fi

exit 0
