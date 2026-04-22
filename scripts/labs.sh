#!/usr/bin/env bash
# labs.sh - navigation helper. Tells the learner what lab to do next.
# Usage:
#   ./scripts/labs.sh list          # list all authored labs
#   ./scripts/labs.sh next          # show next lab based on progress file
#   ./scripts/labs.sh done NNN      # mark lab NNN complete

set -euo pipefail

PROGRESS_FILE=".labs/progress"

list_labs() {
  find Labs -maxdepth 1 -type d -name '[0-9]*' 2>/dev/null | sort
}

cmd="${1:-next}"

case "$cmd" in
  list)
    list_labs
    ;;

  next)
    mkdir -p "$(dirname "$PROGRESS_FILE")"
    cur="$(cat "$PROGRESS_FILE" 2>/dev/null || echo 000)"
    next="$(printf '%03d' $((10#$cur + 1)))"
    next_dir="$(find Labs -maxdepth 1 -type d -name "${next}-*" 2>/dev/null | head -1 || true)"
    if [[ -z "$next_dir" ]]; then
      echo "no lab ${next} authored yet - you are done or ahead of the curriculum"
      exit 0
    fi
    echo "-> ${next_dir}"
    ;;

  done)
    [[ -z "${2:-}" ]] && { echo "usage: scripts/labs.sh done <NNN>" >&2; exit 2; }
    mkdir -p "$(dirname "$PROGRESS_FILE")"
    echo "$2" > "$PROGRESS_FILE"
    echo "OK marked ${2} done"
    ;;

  *)
    echo "usage: scripts/labs.sh {list|next|done NNN}" >&2
    exit 2
    ;;
esac
