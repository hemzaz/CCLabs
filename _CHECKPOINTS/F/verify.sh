#!/usr/bin/env bash
set -euo pipefail

# Checkpoint F verify script.
# Run from repo root: ./Labs/_CHECKPOINTS/F/verify.sh
# Called by: ./scripts/checkpoint.sh F

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# Lab 026 artifact: dump-db skill
[[ -f quips/.claude/skills/dump-db/SKILL.md ]] \
  || fail "quips/.claude/skills/dump-db/SKILL.md is missing (Lab 026)"

# Lab 027 artifact: settings.json must contain both fs-scoped and git-read MCP servers
[[ -f quips/.claude/settings.json ]] \
  || fail "quips/.claude/settings.json is missing (Lab 027)"
python3 -c "
import json, sys
data = json.load(open('quips/.claude/settings.json'))
servers = data.get('mcpServers', {})
if 'fs-scoped' not in servers:
    sys.exit(1)
if 'git-read' not in servers:
    sys.exit(2)
" || fail "quips/.claude/settings.json must contain both 'fs-scoped' and 'git-read' under mcpServers (Lab 027)"

# Lab 028 artifact: claude-review workflow
[[ -f .github/workflows/claude-review.yml ]] \
  || fail ".github/workflows/claude-review.yml is missing (Lab 028)"

# Lab 029 artifact: PR-LOOP.md capturing headless claude -p invocation
[[ -f quips/PR-LOOP.md ]] \
  || fail "quips/PR-LOOP.md is missing (Lab 029)"

# Lab 030 artifact: SHIPPED.md must exist and contain a PR URL line
[[ -f quips/SHIPPED.md ]] \
  || fail "quips/SHIPPED.md is missing (Lab 030)"
grep -qE '^PR: https?://' quips/SHIPPED.md \
  || fail "quips/SHIPPED.md does not contain a 'PR: https://...' line (Lab 030)"

# Reflection must exist, be non-empty, and contain "Quiz"
[[ -s Labs/_CHECKPOINTS/F/reflection.md ]] \
  || fail "Labs/_CHECKPOINTS/F/reflection.md is missing or empty"
grep -qi 'quiz' Labs/_CHECKPOINTS/F/reflection.md \
  || fail "Labs/_CHECKPOINTS/F/reflection.md is missing a 'Quiz: X/5' line"

echo "OK checkpoint F passed"
