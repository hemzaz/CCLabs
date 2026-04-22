#!/usr/bin/env bash
# Labs/027-McpPractice/doctor.sh - lab-specific pre-flight, called by scripts/doctor.sh.
# Checks: claude on PATH, quips dir exists, npx on PATH, python3 on PATH,
#         quips/.claude/settings.json contains mcpServers.fs-scoped (Lab 025 artifact).
# Exit non-zero with a one-line diagnosis on stderr if any check fails.
set -euo pipefail

# Lab 027 requires claude to be installed (Lab 001 artifact).
command -v claude >/dev/null 2>&1 || {
  echo "claude not found — complete Lab 001 first (npm install -g @anthropic-ai/claude-code)" >&2
  exit 1
}

# quips project must exist (proves the repo was cloned with its submodule).
[[ -d "quips" ]] || {
  echo "missing: quips/ — run: git submodule update --init quips" >&2
  exit 1
}

# npx is required to launch the git MCP server.
command -v npx >/dev/null 2>&1 || {
  echo "npx not found — install Node.js (https://nodejs.org)" >&2
  exit 1
}

# python3 is required to validate JSON in the Do steps.
command -v python3 >/dev/null 2>&1 || {
  echo "python3 not found — install Python 3 (https://python.org)" >&2
  exit 1
}

# quips/.claude/settings.json must exist with mcpServers.fs-scoped (Lab 025 artifact).
[[ -f "quips/.claude/settings.json" ]] || {
  echo "missing prior artifact: quips/.claude/settings.json — complete Lab 025 first" >&2
  exit 1
}

python3 -c "
import json, sys
try:
    s = json.load(open('quips/.claude/settings.json'))
except json.JSONDecodeError as e:
    print('quips/.claude/settings.json is not valid JSON: ' + str(e), file=sys.stderr)
    sys.exit(1)
if 'fs-scoped' not in s.get('mcpServers', {}):
    print('missing prior artifact: mcpServers.fs-scoped not in quips/.claude/settings.json — complete Lab 025 first', file=sys.stderr)
    sys.exit(1)
" || exit 1

exit 0
