#!/usr/bin/env bash
set -euo pipefail

# Checkpoint E verify script.
# Run from repo root: ./Labs/_CHECKPOINTS/E/verify.sh
# Called by: ./scripts/checkpoint.sh E

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# Lab 021 artifact: reviewer subagent
[[ -f quips/.claude/agents/reviewer.md ]] \
  || fail "quips/.claude/agents/reviewer.md is missing (Lab 021)"

# Lab 022 artifact: test-writer subagent
[[ -f quips/.claude/agents/test-writer.md ]] \
  || fail "quips/.claude/agents/test-writer.md is missing (Lab 022)"

# Lab 023 artifact: no-rm hook must exist and be executable
[[ -f quips/.claude/hooks/no-rm.sh ]] \
  || fail "quips/.claude/hooks/no-rm.sh is missing (Lab 023)"
[[ -x quips/.claude/hooks/no-rm.sh ]] \
  || fail "quips/.claude/hooks/no-rm.sh is not executable (Lab 023)"

# Lab 024 artifact: seed-db skill
[[ -f quips/.claude/skills/seed-db/SKILL.md ]] \
  || fail "quips/.claude/skills/seed-db/SKILL.md is missing (Lab 024)"

# Lab 025 artifact: settings.json must contain mcpServers key
[[ -f quips/.claude/settings.json ]] \
  || fail "quips/.claude/settings.json is missing (Lab 025)"
python3 -c "
import json, sys
data = json.load(open('quips/.claude/settings.json'))
if 'mcpServers' not in data:
    sys.exit(1)
" || fail "quips/.claude/settings.json does not contain 'mcpServers' key (Lab 025)"

# Integration log must exist and have at least 15 lines
[[ -f quips/.claude/integration-log.md ]] \
  || fail "quips/.claude/integration-log.md is missing (Part 2 integration task)"
line_count=$(wc -l < quips/.claude/integration-log.md)
[[ "$line_count" -ge 15 ]] \
  || fail "quips/.claude/integration-log.md has only $line_count lines; need at least 15"

# Reflection must exist, be non-empty, and contain "Quiz"
[[ -s Labs/_CHECKPOINTS/E/reflection.md ]] \
  || fail "Labs/_CHECKPOINTS/E/reflection.md is missing or empty"
grep -qi 'quiz' Labs/_CHECKPOINTS/E/reflection.md \
  || fail "Labs/_CHECKPOINTS/E/reflection.md is missing a 'Quiz: X/5' line"

echo "OK checkpoint E passed"
