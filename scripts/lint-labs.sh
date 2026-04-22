#!/usr/bin/env bash
# scripts/lint-labs.sh — validate all lab READMEs against the template contract.
# Supports two shapes during migration:
#   - LEGACY (9 H2s): Why, Check, Do, Observe, If stuck, Stretch, Recall, References, Next
#   - RICH   (14 H2s): Prerequisites, What You Will Learn, Why, Walkthrough, Check, Do,
#                      Observe, If stuck, Tasks, Quiz, Stretch, Recall, References, Next
# Shape is auto-detected by presence of '!!! hint "Overview"' admonition.
# Usage: ./scripts/lint-labs.sh
# Exit: 0 if all pass; 1 if any fail.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL_COUNT=0
PASS_COUNT=0

fail() {
  local path="$1"
  local reason="$2"
  echo "FAIL ${path}: ${reason}" >&2
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

pass() {
  local path="$1"
  echo "OK ${path}"
  PASS_COUNT=$((PASS_COUNT + 1))
}

# ---------------------------------------------------------------------------
# check_lab_legacy <file> <rel> errors-array-name
# ---------------------------------------------------------------------------
check_lab_legacy() {
  local file="$1"
  local -n errors_ref="$2"

  local expected_h2s=(
    "## Why"
    "## Check"
    "## Do"
    "## Observe"
    "## If stuck"
    "STRETCH"
    "## Recall"
    "## References"
    "## Next"
  )

  readarray -t actual_h2s < <(grep -E '^## ' "$file" || true)
  local n_actual=${#actual_h2s[@]}
  if [ "$n_actual" -ne 9 ]; then
    errors_ref+=("[legacy shape] expected exactly 9 H2 sections, found ${n_actual}")
    return
  fi

  local i
  for i in 0 1 2 3 4 5 6 7 8; do
    local expected="${expected_h2s[$i]}"
    local actual="${actual_h2s[$i]}"
    if [ "$expected" = "STRETCH" ]; then
      if ! echo "$actual" | grep -qE '^## Stretch(\b|$| )'; then
        errors_ref+=("H2 #$((i+1)) expected '## Stretch...' but got: '${actual}'")
      fi
    else
      if [ "$actual" != "$expected" ]; then
        errors_ref+=("H2 #$((i+1)) expected '${expected}' but got: '${actual}'")
      fi
    fi
  done
}

# ---------------------------------------------------------------------------
# check_lab_rich <file> <rel> errors-array-name
# ---------------------------------------------------------------------------
check_lab_rich() {
  local file="$1"
  local -n errors_ref="$2"

  local expected_h2s=(
    "## Prerequisites"
    "## What You Will Learn"
    "## Why"
    "## Walkthrough"
    "## Check"
    "## Do"
    "## Observe"
    "## If stuck"
    "## Tasks"
    "## Quiz"
    "STRETCH"
    "## Recall"
    "## References"
    "## Next"
  )

  readarray -t actual_h2s < <(grep -E '^## ' "$file" || true)
  local n_actual=${#actual_h2s[@]}
  if [ "$n_actual" -ne 14 ]; then
    errors_ref+=("[rich shape] expected exactly 14 H2 sections, found ${n_actual}")
    return
  fi

  local i
  for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13; do
    local expected="${expected_h2s[$i]}"
    local actual="${actual_h2s[$i]}"
    if [ "$expected" = "STRETCH" ]; then
      if ! echo "$actual" | grep -qE '^## Stretch(\b|$| )'; then
        errors_ref+=("H2 #$((i+1)) expected '## Stretch...' but got: '${actual}'")
      fi
    else
      if [ "$actual" != "$expected" ]; then
        errors_ref+=("H2 #$((i+1)) expected '${expected}' but got: '${actual}'")
      fi
    fi
  done

  # --- Overview admonition: !!! hint "Overview" with >=3 bullets
  local overview_line
  overview_line=$(grep -nF '!!! hint "Overview"' "$file" | head -1 | cut -d: -f1 || true)
  if [ -z "$overview_line" ]; then
    errors_ref+=("missing '!!! hint \"Overview\"' admonition")
  else
    # Count bullets (lines starting with 4 spaces + "- ") after the admonition, before the next blank-line block
    local bullet_count
    bullet_count=$(awk -v start="$overview_line" '
      NR > start {
        if (match($0, /^    - /)) { count++; next }
        if (/^[^ ]/) exit
      }
      END { print count+0 }
    ' "$file")
    if [ "$bullet_count" -lt 3 ]; then
      errors_ref+=("Overview admonition needs >=3 bullets, found ${bullet_count}")
    fi
  fi

  # --- Tasks: >=5 '### Task N' with matching '??? success "Solution"' blocks
  local task_count solution_count
  task_count=$(grep -cE '^### Task [0-9]+' "$file" || true)
  solution_count=$(grep -cF '??? success "Solution"' "$file" || true)
  if [ "$task_count" -lt 5 ]; then
    errors_ref+=("Tasks section needs >=5 '### Task N' entries, found ${task_count}")
  fi
  if [ "$solution_count" -lt "$task_count" ]; then
    errors_ref+=("each Task needs a '??? success \"Solution\"' block; tasks=${task_count}, solutions=${solution_count}")
  fi

  # --- Quiz: >=3 '<div class="ccg-q"' inside a '<div class="ccg-quiz"'
  if ! grep -qF '<div class="ccg-quiz"' "$file"; then
    errors_ref+=("Quiz section missing '<div class=\"ccg-quiz\"'")
  fi
  local quiz_q_count
  quiz_q_count=$(grep -cE '<div class="ccg-q"' "$file" || true)
  if [ "$quiz_q_count" -lt 3 ]; then
    errors_ref+=("Quiz needs >=3 '<div class=\"ccg-q\"' questions, found ${quiz_q_count}")
  fi
}

# ---------------------------------------------------------------------------
# check_lab <file> — dispatch to legacy or rich checker based on Overview presence
# ---------------------------------------------------------------------------
check_lab() {
  local file="$1"
  local rel="${file#${REPO_ROOT}/}"
  local errors=()

  # --- Check: Line 1 must match  ^# Lab NNN — .+$
  local line1
  line1=$(sed -n '1p' "$file")
  if ! echo "$line1" | grep -qE '^# Lab [0-9]{3} — .+$'; then
    errors+=("line 1 heading malformed: '${line1}'")
  fi

  # --- Check: Line 3 meta-bar
  local line3
  line3=$(sed -n '3p' "$file")
  if ! echo "$line3" | grep -qE '^⏱ \*\*.+📦 \*\*You'"'"'ll add\*\*:.+🔗 \*\*Builds on\*\*:.+🎯 \*\*Success\*\*:.+$'; then
    errors+=("line 3 meta-bar missing or malformed")
  fi

  # --- Check: Concept line with Bloom
  if ! head -n 40 "$file" | grep -qE '\*\*Concept\*\*:.*\(Bloom: (Remember|Understand|Apply|Analyze|Evaluate|Create)\)'; then
    errors+=("no '**Concept**: ... (Bloom: ...)' line found in first 40 lines")
  fi

  # --- Dispatch by shape
  if grep -qF '!!! hint "Overview"' "$file"; then
    check_lab_rich "$file" errors
  else
    check_lab_legacy "$file" errors
  fi

  # --- Check: If stuck table has >=3 rows
  local stuck_start next_heading_line total_lines
  stuck_start=$(grep -nE '^## If stuck$' "$file" | head -1 | cut -d: -f1 || true)
  total_lines=$(wc -l < "$file")
  if [ -n "$stuck_start" ]; then
    next_heading_line=$(awk -v start="$stuck_start" 'NR > start && /^## / { print NR; exit }' "$file" || true)
    if [ -z "$next_heading_line" ]; then
      next_heading_line=$((total_lines + 1))
    fi
    local section_lines data_row_count
    section_lines=$(sed -n "$((stuck_start+1)),$((next_heading_line-1))p" "$file")
    if ! echo "$section_lines" | grep -qF '| Symptom | Cause | Fix | Source |'; then
      errors+=("'If stuck' table missing header row")
    fi
    data_row_count=$(echo "$section_lines" | awk '
      /^\| Symptom/ { next }
      /^\|---/      { next }
      /^\| /        { count++ }
      END           { print count+0 }
    ')
    if [ "$data_row_count" -lt 3 ]; then
      errors+=("'If stuck' table needs >=3 data rows, found ${data_row_count}")
    fi
  fi

  # --- Report
  if [ ${#errors[@]} -eq 0 ]; then
    pass "$rel"
  else
    local i
    for i in "${!errors[@]}"; do
      fail "$rel" "${errors[$i]}"
    done
  fi
}

# ---------------------------------------------------------------------------
# check_checkpoint <file>
# ---------------------------------------------------------------------------
check_checkpoint() {
  local file="$1"
  local rel="${file#${REPO_ROOT}/}"
  local errors=()

  local line1
  line1=$(sed -n '1p' "$file")
  if ! echo "$line1" | grep -qE '^# Checkpoint [A-F] — .+$'; then
    errors+=("line 1 heading malformed: '${line1}'")
  fi
  grep -qF '### Part 1 — Quiz' "$file"             || errors+=("missing '### Part 1 — Quiz'")
  grep -qF '### Part 2 — Integration task' "$file" || errors+=("missing '### Part 2 — Integration task'")
  grep -qF '### Part 3 — Self-debrief' "$file"     || errors+=("missing '### Part 3 — Self-debrief'")

  if [ ${#errors[@]} -eq 0 ]; then
    pass "$rel"
  else
    local i
    for i in "${!errors[@]}"; do
      fail "$rel" "${errors[$i]}"
    done
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

while IFS= read -r -d '' readme; do
  check_lab "$readme"
done < <(find "${REPO_ROOT}/Labs" -maxdepth 2 -path '*/[0-9][0-9][0-9]-*/README.md' -print0 | sort -z)

while IFS= read -r -d '' readme; do
  check_checkpoint "$readme"
done < <(find "${REPO_ROOT}/Labs/_CHECKPOINTS" -maxdepth 2 -name 'README.md' -print0 | sort -z)

TOTAL=$((PASS_COUNT + FAIL_COUNT))
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "${FAIL_COUNT} lab(s) failed structural lint (${PASS_COUNT}/${TOTAL} passed)" >&2
  exit 1
else
  echo "All ${PASS_COUNT} labs passed structural lint"
  exit 0
fi
