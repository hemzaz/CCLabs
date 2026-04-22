#!/usr/bin/env bash
# Labs/022-SubagentDelegation/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, quips/.claude/agents/reviewer.md exists (Lab 021 artifact).
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 022 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# quips/.claude/agents/reviewer.md must exist (created in Lab 021).
[[ -f "quips/.claude/agents/reviewer.md" ]] || {
  echo "missing: quips/.claude/agents/reviewer.md — complete Lab 021 first" >&2
  exit 1
}

exit 0
