# Lab 019 — Verify Scripts

⏱ **20 min**   📦 **You'll add**: `quips/verify-feature.sh`   🔗 **Builds on**: Lab 018   🎯 **Success**: `quips/verify-feature.sh exits 0 and exits non-zero with a one-line stderr message when the feature is broken`

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

**Concept**: `Write a verify.sh that fails fast with a one-line diagnosis` (Bloom: Create)

---

## Why

"It works on my machine" is not a deliverable. A claim that a feature works is only as good as the script that proves it. The verify-script discipline pairs every feature with a short, idempotent script that exits 0 when the feature behaves and exits non-zero with a one-line diagnosis when it does not. When Claude writes a feature, you write the verifier — that closes the loop and gives both you and Claude a machine-readable definition of done.

## Check

```bash
./scripts/doctor.sh 019
```

Expected output: `OK lab 019 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any script, name three things that could silently go wrong with `POST /quips` that a test suite might miss. Write them down (a text file, a comment, anywhere). Common candidates: the returned `id` does not match what is stored; the `text` field is truncated silently; concurrent requests corrupt state.

   Verify: you have written down at least three failure modes before moving on.
   ```bash
   echo "prediction written — continue"
   ```
   Expected: `prediction written — continue`

2. **Run** — start the quips server in a separate terminal.

   ```bash
   cd quips && npm start &
   ```

   Wait two seconds, then confirm the health endpoint responds.

   ```bash
   curl --max-time 5 -sS -o /dev/null -w "%{http_code}" localhost:3000/healthz
   ```
   Expected: `200`

3. **Investigate** — read the two existing verify scripts to understand the contract.

   ```bash
   cat scripts/verify.sh
   cat Labs/010-MultiFileEdits/verify.sh
   ```

   Note three things: `set -euo pipefail` at the top; all diagnostic messages go to stderr (`>&2`); exit code is non-zero on any failure. Confirm you can name the exit-code rule before continuing.

   ```bash
   grep -c 'set -euo pipefail' scripts/verify.sh Labs/010-MultiFileEdits/verify.sh
   ```
   Expected: `2` (one match per file)

4. **Modify** — write `quips/verify-feature.sh`. The script must:
   - Start with `#!/usr/bin/env bash` and `set -euo pipefail`.
   - POST to `/quips` with a known `text` value and capture the returned `id`.
   - GET `/quips/:id` and assert the returned `text` matches the posted value byte-for-byte.
   - Print a one-line diagnosis to stderr and exit non-zero on any mismatch.
   - Be idempotent: use a unique `text` value per run (e.g. embed `$$` or a timestamp).

   Example skeleton (fill in the assertions):

   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   TEXT="verify-roundtrip-$$"
   RESPONSE=$(curl --max-time 5 -sS -X POST localhost:3000/quips \
     -H 'Content-Type: application/json' \
     -d "{\"text\":\"$TEXT\"}")
   ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
   FETCHED=$(curl --max-time 5 -sS "localhost:3000/quips/$ID" \
     | grep -o '"text":"[^"]*"' | sed 's/"text":"//;s/"//')
   [[ "$FETCHED" == "$TEXT" ]] || {
     echo "quip text did not roundtrip: expected '$TEXT', got '$FETCHED'" >&2
     exit 1
   }
   ```

   Make it executable and run it:

   ```bash
   chmod +x quips/verify-feature.sh
   bash quips/verify-feature.sh; echo $?
   ```
   Expected: `0`

5. **Make** — deliberately break the feature. Open `quips/src/server.js`, find the `POST /quips` handler, and change the returned `id` to a hardcoded wrong value (e.g. `id: 9999`). Re-run the verifier.

   ```bash
   bash quips/verify-feature.sh; echo "exit: $?"
   ```
   Expected: exit code non-zero and one line on stderr containing `did not roundtrip` or `quip text`. Restore the original handler before continuing.

## Observe

One sentence — what is the difference between a test that asserts a status code and a verify script that asserts content equality, and why does that difference matter for catching silent bugs?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Script hangs waiting for a response | Server never started, or curl waits forever | Add `curl --max-time 5` to every curl call and confirm the server is up with a health probe before the main assertion | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Script exits 0 even when the feature is broken | Assertion is too loose — checking status code only, not content | Compare the returned text byte-for-byte: `[[ "$FETCHED" == "$TEXT" ]]` rather than checking HTTP 200 | https://docs.claude.com/en/docs/claude-code/overview |
| Second run fails when the first run passed | Script is not idempotent — previous run left state the second run cannot handle | Use a unique text value per run (embed `$$` or `date +%s%N`) so each run is independent | https://github.com/anthropics/anthropic-cookbook |

## Stretch (optional, ~10 min)

Extend `quips/verify-feature.sh` to also assert that a `DELETE /quips/:id` call removes the quip — a subsequent `GET /quips/:id` should return 404. Keep the script under 30 lines and idempotent.

## Recall

Lab 014 introduced `/compact`. What does `/compact` do, and when should you trigger it during a long session?

> Expected: `/compact` summarises the conversation history and replaces it with a compressed transcript, freeing context-window space. Trigger it when context usage climbs past roughly 60% or before starting a large multi-file task.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/common-workflows
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 020 — Refactor Safely** — use Claude to rename and restructure a module while keeping all verify scripts green throughout.
