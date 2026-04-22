#!/usr/bin/env bash
# scripts/lint-labs.sh — validate all lab READMEs against the DESIGN.md §7 template contract.
# Usage: ./scripts/lint-labs.sh
# Exit: 0 if all pass; 1 if any lab fails structural lint.
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
# check_lab <path>  — validate a full lab README
# ---------------------------------------------------------------------------
check_lab() {
  local file="$1"
  local rel="${file#${REPO_ROOT}/}"
  local errors=()

  # --- Check 1: Line 1 must match  ^# Lab NNN — .+$
  local line1
  line1=$(sed -n '1p' "$file")
  if ! echo "$line1" | grep -qE '^# Lab [0-9]{3} — .+$'; then
    errors+=("line 1 heading malformed: '${line1}'")
  fi

  # --- Check 2: Line 3 must contain all five markers in order
  local line3
  line3=$(sed -n '3p' "$file")
  local meta_ok=true
  # Full pattern: ⏱ **...   📦 **You'll add**:...   🔗 **Builds on**:...   🎯 **Success**:...
  if ! echo "$line3" | grep -qE '^⏱ \*\*.+📦 \*\*You'"'"'ll add\*\*:.+🔗 \*\*Builds on\*\*:.+🎯 \*\*Success\*\*:.+$'; then
    meta_ok=false
    # Diagnose which marker is missing
    local missing_marker=""
    if ! echo "$line3" | grep -q '⏱ \*\*'; then
      missing_marker="⏱ **"
    elif ! echo "$line3" | grep -q "📦 \*\*You'll add\*\*:"; then
      missing_marker="📦 **You'll add**:"
    elif ! echo "$line3" | grep -q '🔗 \*\*Builds on\*\*:'; then
      missing_marker="🔗 **Builds on**:"
    elif ! echo "$line3" | grep -q '🎯 \*\*Success\*\*:'; then
      missing_marker="🎯 **Success**:"
    else
      missing_marker="(order or spacing wrong)"
    fi
    errors+=("line 3 meta-bar missing or malformed (first missing marker: '${missing_marker}')")
  fi

  # --- Check 3: **Concept**: line with Bloom tag in first 40 lines
  local concept_line
  concept_line=$(head -n 40 "$file" | grep -E '\*\*Concept\*\*:.*\(Bloom: (Remember|Understand|Apply|Analyze|Evaluate|Create)\)' || true)
  if [ -z "$concept_line" ]; then
    errors+=("no '**Concept**: ... (Bloom: ...)' line found in first 40 lines")
  fi

  # --- Check 4: Exactly nine H2 sections in exact order
  local expected_h2s=(
    "## Why"
    "## Check"
    "## Do"
    "## Observe"
    "## If stuck"
    "STRETCH"           # special: matches ^## Stretch(\b|$|\s)
    "## Recall"
    "## References"
    "## Next"
  )

  # Extract H2 headings in order
  readarray -t actual_h2s < <(grep -E '^## ' "$file" || true)

  local n_actual=${#actual_h2s[@]}
  if [ "$n_actual" -ne 9 ]; then
    errors+=("expected exactly 9 H2 sections, found ${n_actual}")
  else
    local i
    for i in 0 1 2 3 4 5 6 7 8; do
      local expected="${expected_h2s[$i]}"
      local actual="${actual_h2s[$i]}"
      if [ "$expected" = "STRETCH" ]; then
        # Allow "## Stretch" with any optional trailing text
        if ! echo "$actual" | grep -qE '^## Stretch(\b|$| )'; then
          errors+=("H2 #$((i+1)) expected '## Stretch...' but got: '${actual}'")
        fi
      else
        if [ "$actual" != "$expected" ]; then
          errors+=("H2 #$((i+1)) expected '${expected}' but got: '${actual}'")
        fi
      fi
    done
  fi

  # --- Check 5: "If stuck" section has table with header + separator + >=3 data rows
  # Find the line number of "## If stuck" and the next "^## " heading
  local stuck_start next_heading_line total_lines
  stuck_start=$(grep -nE '^## If stuck$' "$file" | head -1 | cut -d: -f1 || true)
  total_lines=$(wc -l < "$file")

  if [ -n "$stuck_start" ]; then
    # Find next ## heading after stuck_start
    next_heading_line=$(awk -v start="$stuck_start" 'NR > start && /^## / { print NR; exit }' "$file" || true)
    if [ -z "$next_heading_line" ]; then
      next_heading_line=$((total_lines + 1))
    fi

    # Extract lines between stuck heading and next heading
    local section_lines
    section_lines=$(sed -n "$((stuck_start+1)),$((next_heading_line-1))p" "$file")

    # Check header row exists
    if ! echo "$section_lines" | grep -qF '| Symptom | Cause | Fix | Source |'; then
      errors+=("'If stuck' table missing header row '| Symptom | Cause | Fix | Source |'")
    fi

    # Count data rows: lines starting with "| " that are NOT the header and NOT a separator
    local data_row_count
    data_row_count=$(echo "$section_lines" | grep -cE '^\| ' | grep -v '| Symptom' | grep -v '^|---' || true)
    # awk-based count to avoid grep pipeline complexity
    data_row_count=$(echo "$section_lines" | awk '
      /^\| Symptom/ { next }
      /^\|---/      { next }
      /^\| /        { count++ }
      END           { print count+0 }
    ')

    if [ "$data_row_count" -lt 3 ]; then
      errors+=("'If stuck' table needs >=3 data rows, found ${data_row_count}")
    fi
  else
    # Section heading not found — already caught by check 4, skip duplicate error
    true
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
# check_checkpoint <path>  — validate a checkpoint README
# ---------------------------------------------------------------------------
check_checkpoint() {
  local file="$1"
  local rel="${file#${REPO_ROOT}/}"
  local errors=()

  # Line 1: ^# Checkpoint [A-F] — .+$
  local line1
  line1=$(sed -n '1p' "$file")
  if ! echo "$line1" | grep -qE '^# Checkpoint [A-F] — .+$'; then
    errors+=("line 1 heading malformed: '${line1}'")
  fi

  # Required sections
  if ! grep -qF '### Part 1 — Quiz' "$file"; then
    errors+=("missing '### Part 1 — Quiz'")
  fi
  if ! grep -qF '### Part 2 — Integration task' "$file"; then
    errors+=("missing '### Part 2 — Integration task'")
  fi
  if ! grep -qF '### Part 3 — Self-debrief' "$file"; then
    errors+=("missing '### Part 3 — Self-debrief'")
  fi

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
# Main — discover and lint files
# ---------------------------------------------------------------------------

# Labs
while IFS= read -r -d '' readme; do
  check_lab "$readme"
done < <(find "${REPO_ROOT}/Labs" -maxdepth 2 -path '*/[0-9][0-9][0-9]-*/README.md' -print0 | sort -z)

# Checkpoints
while IFS= read -r -d '' readme; do
  check_checkpoint "$readme"
done < <(find "${REPO_ROOT}/Labs/_CHECKPOINTS" -maxdepth 2 -name 'README.md' -print0 | sort -z)

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
TOTAL=$((PASS_COUNT + FAIL_COUNT))
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "${FAIL_COUNT} lab(s) failed structural lint (${PASS_COUNT}/${TOTAL} passed)" >&2
  exit 1
else
  echo "All ${PASS_COUNT} labs passed structural lint"
  exit 0
fi
