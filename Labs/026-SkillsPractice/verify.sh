#!/usr/bin/env bash
# verify.sh — completion checks for Lab 026 — Skills Practice
set -euo pipefail

PASS=0
FAIL=0

ok()   { echo "  [ok] $*"; ((PASS++)) || true; }
fail() { echo "  [FAIL] $*" >&2; ((FAIL++)) || true; }

SKILL_MD="quips/.claude/skills/dump-db/SKILL.md"
DUMP_SH="quips/.claude/skills/dump-db/dump.sh"

echo "Lab 026 verification..."

# 1. SKILL.md exists and is non-empty
if [[ -s "$SKILL_MD" ]]; then
  ok "SKILL.md exists and is non-empty"
else
  fail "$SKILL_MD missing or empty"
fi

# 2. SKILL.md has exactly 2 YAML fence lines (---)
fence_count=$(grep -c '^---$' "$SKILL_MD" 2>/dev/null || echo 0)
if [[ "$fence_count" -eq 2 ]]; then
  ok "SKILL.md has two --- fence lines"
else
  fail "SKILL.md has $fence_count --- fence line(s); expected 2"
fi

# 3. SKILL.md contains required frontmatter keys
if grep -q '^name:' "$SKILL_MD" 2>/dev/null; then
  ok "SKILL.md has 'name:' key"
else
  fail "$SKILL_MD is missing 'name:' frontmatter key"
fi

if grep -q '^description:' "$SKILL_MD" 2>/dev/null; then
  ok "SKILL.md has 'description:' key"
else
  fail "$SKILL_MD is missing 'description:' frontmatter key"
fi

# 4. dump.sh exists and is executable
if [[ -f "$DUMP_SH" ]]; then
  ok "dump.sh exists"
else
  fail "$DUMP_SH not found"
fi

if [[ -x "$DUMP_SH" ]]; then
  ok "dump.sh is executable"
else
  fail "$DUMP_SH is not executable — run: chmod +x $DUMP_SH"
fi

# 5. Running dump.sh produces valid JSON (requires seed-db to have been run first)
if [[ -f "quips/quips.db" ]]; then
  json_output=$(bash "$DUMP_SH" 2>&1) || true
  if python3 -c "import sys,json; json.loads(sys.stdin.read())" <<<"$json_output" 2>/dev/null; then
    ok "dump.sh output is valid JSON"
  else
    fail "dump.sh output is not valid JSON — run /seed-db inside claude first, then retry"
  fi
else
  fail "quips/quips.db not found — run /seed-db inside claude first, then retry"
fi

echo ""
if ((FAIL == 0)); then
  echo "OK lab 026 complete"
  exit 0
else
  echo "FAIL $FAIL check(s) failed — see details above" >&2
  exit 1
fi
