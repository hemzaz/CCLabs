#!/usr/bin/env bash
# doctor.sh — pre-flight checks for Lab 026 — Skills Practice
set -euo pipefail

PASS=0
FAIL=0

ok()   { echo "  [ok] $*"; ((PASS++)) || true; }
fail() { echo "  [FAIL] $*" >&2; ((FAIL++)) || true; }

echo "Lab 026 pre-flight..."

# 1. claude on PATH
if command -v claude &>/dev/null; then
  ok "claude is on PATH"
else
  fail "claude not found — install Claude Code first"
fi

# 2. quips directory exists
if [[ -d quips ]]; then
  ok "quips/ directory present"
else
  fail "quips/ not found — run from the repo root"
fi

# 3. sqlite3 on PATH
if command -v sqlite3 &>/dev/null; then
  ok "sqlite3 is on PATH"
else
  fail "sqlite3 not found — install sqlite3 (brew install sqlite or apt install sqlite3)"
fi

# 4. python3 on PATH (needed for JSON validation)
if command -v python3 &>/dev/null; then
  ok "python3 is on PATH"
else
  fail "python3 not found — install Python 3"
fi

# 5. Lab 024 artifact present
if [[ -f quips/.claude/skills/seed-db/SKILL.md ]]; then
  ok "seed-db skill present (Lab 024 artifact)"
else
  fail "quips/.claude/skills/seed-db/SKILL.md missing — complete Lab 024 first"
fi

echo ""
if ((FAIL == 0)); then
  echo "OK lab 026 pre-flight green"
  exit 0
else
  echo "FAIL $FAIL check(s) failed — fix the issues above before starting the lab" >&2
  exit 1
fi
