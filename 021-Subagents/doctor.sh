#!/usr/bin/env bash
# Labs/021-Subagents/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips directory exists, quips/.claude/ dir exists or can be created.
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 021 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# Ensure the .claude/agents directory exists or can be created.
if [[ ! -d "quips/.claude/agents" ]]; then
  mkdir -p "quips/.claude/agents" 2>/dev/null || {
    echo "cannot create quips/.claude/agents — check directory permissions" >&2
    exit 1
  }
fi

exit 0
