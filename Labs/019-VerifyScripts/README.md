# Lab 019 — Verify Scripts

⏱ **25 min**   📦 **You'll add**: `quips/verify-feature.sh`   🔗 **Builds on**: Lab 018   🎯 **Success**: `quips/verify-feature.sh` exits 0 on a healthy server and exits non-zero with a one-line stderr message when the feature is broken

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. Nine sections below (in this exact order, same H2 titles)
    3. Single new concept (a "Concept:" Bloom-tagged line)
    4. Every Do step ends with a verify COMMAND, not a screenshot
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will learn the verify-script design contract: idempotent, finishes in under ten seconds, prints exactly one diagnosis line to stderr, exits 0 on green and non-zero on red.
    - You will write `quips/verify-feature.sh` that proves a POST-then-GET roundtrip works correctly, using `curl` assertions rather than visual inspection.
    - You will intentionally break the feature, confirm the script catches it with a clear message, and time the script to confirm it stays under the ten-second budget.

**Concept**: `Write a verify.sh that fails fast with a one-line diagnosis` (Bloom: Create)

---

## Prerequisites

- Lab 018 complete — the `quips` Express server exists at `quips/src/server.js`
- `curl` available on PATH (`curl --version` exits 0)
- `jq` available on PATH (`jq --version` exits 0) — used for parsing JSON responses
- The quips server can be started with `npm start` inside the `quips/` directory

## What You Will Learn

- The four rules every verify script must satisfy and why each rule matters
- Why `curl --fail` plus a grep beats reading the terminal with your eyes
- How to make a script idempotent so it is safe to run repeatedly without accumulating state
- How to route diagnostic output to stderr so stdout stays clean for pipelines
- How to simulate a broken feature and confirm the verifier catches it

## Why

"It works on my machine" is not a deliverable. A feature claim is only as strong as the script that proves it. The verify-script discipline pairs every feature with a short, idempotent shell script that exits 0 when the feature behaves correctly and exits non-zero — with exactly one diagnostic line on stderr — when it does not. When Claude writes a feature, you write the verifier. That closes the loop and gives both you and Claude a machine-readable definition of done that survives across sessions, teammates, and CI environments.

## Walkthrough

### The four-rule contract

Every verify script in this curriculum satisfies four rules:

| Rule | What it means | Why it matters |
|---|---|---|
| **Idempotent** | Running the script twice leaves the system in the same state as running it once | CI runs scripts on every push; a script that accumulates state will fail on the second run and waste debugging time |
| **Under ten seconds** | The script completes — including any server warm-up probe — within ten seconds | Slow scripts get disabled or skipped; a check that never runs is no check at all |
| **One-line diagnosis on stderr** | On failure, exactly one line describing what went wrong is printed to file descriptor 2 | Humans scanning CI logs need signal, not noise; one line forces you to name the failure precisely |
| **Exit 0 means green** | The script exits 0 if and only if the feature behaves as expected | Tools that call your script (CI, `make`, other scripts) interpret exit code, not output; the exit code is the contract |

### Why curl-then-grep beats "look at the screen"

When you run `curl localhost:3000/quips/1` and read the output visually, you are the assertion. That does not scale, does not run in CI, and is wrong about once every ten inspections because humans pattern-match loosely. The machine-readable alternative is:

```bash
BODY=$(curl --fail --max-time 5 -sS "localhost:3000/quips/$ID")
echo "$BODY" | jq -e '.text == "'"$TEXT"'"' > /dev/null || {
  echo "FAIL: text mismatch — got $(echo "$BODY" | jq -r '.text')" >&2
  exit 1
}
```

`--fail` makes curl exit non-zero on any 4xx or 5xx response. `-sS` suppresses the progress bar but still shows errors. `jq -e` sets a non-zero exit code when the expression is false. Together they turn a visual check into a binary signal that a shell script can act on.

### Reference table of common assertions

| Assertion | Shell idiom |
|---|---|
| HTTP 200 on GET | `curl --fail --max-time 5 -sS -o /dev/null URL` |
| Status code equals N | `CODE=$(curl -o /dev/null -w "%{http_code}" URL); [[ "$CODE" == "N" ]]` |
| JSON field equals value | `curl ... URL \| jq -e '.field == "value"' > /dev/null` |
| JSON field exists and is non-null | `curl ... URL \| jq -e '.field != null' > /dev/null` |
| Body contains string | `curl ... URL \| grep -qF "string"` |
| Response time under N ms | `curl -w "%{time_total}" -o /dev/null URL \| awk '{exit ($1 > N/1000)}'` |
| Resource returns 404 after delete | `CODE=$(curl -o /dev/null -w "%{http_code}" URL); [[ "$CODE" == "404" ]]` |

### Idempotency through unique keys

A POST-then-GET verify script creates data. If the same text is posted on every run, a uniqueness constraint could reject the second run. The fix is to embed a per-run unique value in the payload:

```bash
TEXT="verify-roundtrip-$(date +%s%N)"
```

`date +%s%N` returns nanoseconds since the epoch on Linux. On macOS use `$(date +%s)$$` (seconds plus PID). Either approach produces a value that is unique across runs without requiring any cleanup.

### One-line diagnosis placement

Diagnostic output belongs on stderr, never stdout:

```bash
echo "FAIL: expected '$EXPECTED', got '$ACTUAL'" >&2
exit 1
```

Stdout is for data. Pipelines, redirects, and capture-via-`$()` all consume stdout. Printing a failure message to stdout silently corrupts those consumers. Printing to stderr keeps the failure visible to a human operator while leaving stdout clean.

## Check

```bash
./scripts/doctor.sh 019
```

Expected output: `OK lab 019 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any script, name three things that could silently pass an HTTP 200 check yet still represent broken behavior in the quips feature. Common candidates: the returned `id` does not correspond to the stored record; the `text` field is silently truncated; a concurrent POST overwrites the record before the GET arrives. Write them down in any format.

   ```bash
   echo "prediction written — continue"
   ```

   Expected: `prediction written — continue`

2. **Run** — start the quips server in a background terminal, then confirm the health endpoint responds.

   ```bash
   cd quips && npm start &
   sleep 1
   curl --max-time 5 -sS -o /dev/null -w "%{http_code}" localhost:3000/healthz
   ```

   Expected: `200`

3. **Investigate** — examine the structure of the quips POST and GET responses so you know exactly what fields to assert against.

   ```bash
   curl --max-time 5 -sS -X POST localhost:3000/quips \
     -H 'Content-Type: application/json' \
     -d '{"text":"probe"}' | jq .
   ```

   Note the field names in the response (`id`, `text`, and any others). Then probe a GET:

   ```bash
   curl --max-time 5 -sS localhost:3000/quips/1 | jq .
   ```

   Confirm you can name the exact JSON path to the `text` field before moving on.

   ```bash
   curl --max-time 5 -sS localhost:3000/quips/1 | jq -r '.text'
   ```

   Expected: a non-empty string.

4. **Modify** — create `quips/verify-feature.sh` with the full roundtrip assertion.

   The script must start with `#!/usr/bin/env bash` and `set -euo pipefail`, use a unique `TEXT` value per run, POST to `/quips`, extract the returned `id`, GET `/quips/:id`, assert the returned `text` matches byte-for-byte, and print a one-line diagnosis to stderr on mismatch.

   Reference skeleton (fill in the assertion):

   ```bash
   #!/usr/bin/env bash
   set -euo pipefail

   BASE="localhost:3000"
   TEXT="verify-roundtrip-$(date +%s)$$"

   # POST a new quip
   RESPONSE=$(curl --fail --max-time 5 -sS -X POST "$BASE/quips" \
     -H 'Content-Type: application/json' \
     -d "{\"text\":\"$TEXT\"}")
   ID=$(echo "$RESPONSE" | jq -r '.id')

   # GET it back and assert the text survived
   FETCHED=$(curl --fail --max-time 5 -sS "$BASE/quips/$ID" | jq -r '.text')

   if [[ "$FETCHED" != "$TEXT" ]]; then
     echo "FAIL: quip text did not roundtrip — expected '$TEXT', got '$FETCHED'" >&2
     exit 1
   fi
   ```

   Make it executable and run it:

   ```bash
   chmod +x quips/verify-feature.sh
   bash quips/verify-feature.sh; echo "exit: $?"
   ```

   Expected: `exit: 0`

5. **Make** — deliberately break the feature. Open `quips/src/server.js`, find the POST handler, and change the returned `id` to a hardcoded wrong value such as `9999`. Re-run the verifier.

   ```bash
   bash quips/verify-feature.sh; echo "exit: $?"
   ```

   Expected: exit code non-zero and exactly one line on stderr containing `FAIL`. Restore the original handler before continuing.

## Observe

One sentence: what is the difference between a test that checks only the HTTP status code and a verify script that asserts content equality, and why does that difference matter for catching silent regressions?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Script hangs waiting for a response | Server not running, or `curl` waits for a response that never arrives | Add `--max-time 5` to every `curl` call; run a health probe before the main assertion: `curl --max-time 2 -sS -o /dev/null localhost:3000/healthz` | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Script exits 0 even when the feature is broken | Assertion is too loose — checking the wrong field or using a partial match | Compare strings byte-for-byte: `[[ "$FETCHED" == "$TEXT" ]]`; avoid `grep` for equality checks because it matches substrings | https://docs.claude.com/en/docs/claude-code/overview |
| Second run fails when the first run passed | Script is not idempotent — the same `TEXT` is posted every run and a uniqueness constraint rejects the duplicate | Embed `$(date +%s)$$` in `TEXT` so every run produces a fresh value that needs no cleanup | https://github.com/anthropics/anthropic-cookbook |
| `jq: command not found` | `jq` is not installed on this machine | Install with `brew install jq` (macOS) or `apt-get install jq` (Debian/Ubuntu); alternatively parse with `grep -o` if `jq` cannot be installed | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Write verify-feature.sh for the quips roundtrip

**Scenario:** You have built the quips POST endpoint and want a machine-readable proof that a quip can be created and retrieved with its text intact.

**Hint:** POST to `/quips` with a `text` payload, capture the returned `id` with `jq -r '.id'`, GET `/quips/:id`, then compare the returned `text` with the original using `[[ "$FETCHED" == "$TEXT" ]]`.

??? success "Solution"

    ```bash
    #!/usr/bin/env bash
    set -euo pipefail

    BASE="localhost:3000"
    TEXT="verify-roundtrip-$(date +%s)$$"

    RESPONSE=$(curl --fail --max-time 5 -sS -X POST "$BASE/quips" \
      -H 'Content-Type: application/json' \
      -d "{\"text\":\"$TEXT\"}")
    ID=$(echo "$RESPONSE" | jq -r '.id')

    FETCHED=$(curl --fail --max-time 5 -sS "$BASE/quips/$ID" | jq -r '.text')

    if [[ "$FETCHED" != "$TEXT" ]]; then
      echo "FAIL: quip text did not roundtrip — expected '$TEXT', got '$FETCHED'" >&2
      exit 1
    fi
    ```

    Save as `quips/verify-feature.sh`, run `chmod +x quips/verify-feature.sh`, then `bash quips/verify-feature.sh; echo $?`. Expected: `0`.

### Task 2 — Make the script idempotent

**Scenario:** CI runs your script on every push. If the same `TEXT` is posted each time, a uniqueness constraint will reject the second run, producing a false failure.

**Hint:** Embed `$(date +%s)$$` in the `TEXT` variable. The `$$` expands to the current shell's PID, the `date` component adds wall-clock seconds. Together they are unique across concurrent runs on the same machine.

??? success "Solution"

    Change the `TEXT` assignment to:

    ```bash
    TEXT="verify-roundtrip-$(date +%s)$$"
    ```

    Verify idempotency by running the script twice in a row without restarting the server:

    ```bash
    bash quips/verify-feature.sh && bash quips/verify-feature.sh
    echo "both runs: $?"
    ```

    Expected: both commands exit 0 and `both runs: 0` prints.

### Task 3 — Add a one-line diagnosis for each failure path

**Scenario:** The script currently exits non-zero but gives no information about what went wrong. A teammate looking at CI output needs to know which assertion failed without reading the script.

**Hint:** Before every `exit 1`, print exactly one line to stderr with `>&2`. Include the expected value, the actual value, and the word `FAIL` so it is greppable.

??? success "Solution"

    Extend the roundtrip assertion block:

    ```bash
    if [[ "$FETCHED" != "$TEXT" ]]; then
      echo "FAIL: text mismatch — expected '$TEXT', got '$FETCHED'" >&2
      exit 1
    fi
    ```

    Add a similar block for the case where `curl --fail` returns a non-200 on the GET:

    ```bash
    HTTP_CODE=$(curl -o /dev/null -w "%{http_code}" --max-time 5 -sS "$BASE/quips/$ID")
    if [[ "$HTTP_CODE" != "200" ]]; then
      echo "FAIL: GET /quips/$ID returned HTTP $HTTP_CODE, expected 200" >&2
      exit 1
    fi
    ```

    Verify: intentionally post to a wrong endpoint and confirm stderr contains `FAIL`.

### Task 4 — Exit non-zero without stdout chatter

**Scenario:** Another script captures your verifier's stdout with `OUTPUT=$(bash quips/verify-feature.sh)`. Any failure message on stdout corrupts `$OUTPUT`. All diagnostics must go to stderr only.

**Hint:** Replace every bare `echo "..."` in failure paths with `echo "..." >&2`. Success paths should produce no output at all.

??? success "Solution"

    Audit every `echo` in the script. Failure echoes get `>&2`:

    ```bash
    echo "FAIL: ..." >&2
    exit 1
    ```

    Remove any informational echoes on the success path. The final test:

    ```bash
    OUTPUT=$(bash quips/verify-feature.sh)
    echo "stdout was: '$OUTPUT'"
    echo "exit: $?"
    ```

    Expected: `stdout was: ''` and `exit: 0`. Nothing on stdout when the script passes.

### Task 5 — Test the script under an intentional break

**Scenario:** A verify script that always exits 0 — even when the feature is broken — is worse than no script because it produces false confidence. You need to confirm the script actually catches failures.

**Hint:** Open `quips/src/server.js`, find the POST handler's `res.json(...)` call, and change the returned `id` to `9999`. The GET will then fetch a different record (or 404), and the text will not match.

??? success "Solution"

    ```bash
    # In quips/src/server.js, change:
    #   res.json({ id: newQuip.id, text: newQuip.text })
    # to:
    #   res.json({ id: 9999, text: newQuip.text })

    bash quips/verify-feature.sh
    echo "exit: $?"
    ```

    Expected: exit code `1` and a line on stderr such as:
    ```
    FAIL: text mismatch — expected 'verify-roundtrip-...', got '...'
    ```

    Restore the original handler (`id: newQuip.id`) before continuing.

### Task 6 — Time the script — must complete in under ten seconds

**Scenario:** Slow verify scripts get disabled. The ten-second budget is a hard rule. Measure your script's wall time with `time` and confirm it stays within budget.

**Hint:** `time bash quips/verify-feature.sh` prints `real`, `user`, and `sys` times. The `real` line is wall-clock time. If it exceeds ten seconds, add `--max-time 5` to every `curl` call and probe the health endpoint before the main assertion so startup latency is bounded.

??? success "Solution"

    ```bash
    time bash quips/verify-feature.sh
    ```

    Expected output ends with a `real` line under `0m10.000s`, for example `real    0m0.312s`.

    If the script is slow, add a health check before the main assertion so `curl` does not wait for a hung server:

    ```bash
    curl --max-time 2 -sS -o /dev/null localhost:3000/healthz || {
      echo "FAIL: server not responding" >&2
      exit 1
    }
    ```

## Quiz

<div class="ccg-quiz" data-lab="019">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> A verify script is called idempotent when:</p>
    <label><input type="radio" name="019-q1" value="a"> **a.** It runs exactly once and then deletes itself.</label>
    <label><input type="radio" name="019-q1" value="b"> **b.** It produces the same stdout output on every run.</label>
    <label><input type="radio" name="019-q1" value="c"> **c.** Running it multiple times leaves the system in the same state as running it once.</label>
    <label><input type="radio" name="019-q1" value="d"> **d.** It exits 0 on every run regardless of feature state.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Idempotency means repeated runs have no cumulative side effects. A script that posts the same fixed text each run may fail on the second run if a uniqueness constraint exists. Using a per-run unique value (such as a timestamp plus PID) makes each run independent and safe to repeat.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> A verify script exits 0. What does that tell you?</p>
    <label><input type="radio" name="019-q2" value="a"> **a.** The script ran but found nothing to check.</label>
    <label><input type="radio" name="019-q2" value="b"> **b.** Every assertion in the script passed — the feature behaves as expected.</label>
    <label><input type="radio" name="019-q2" value="c"> **c.** The script printed no output.</label>
    <label><input type="radio" name="019-q2" value="d"> **d.** The server returned HTTP 200 at least once during the run.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Exit code 0 is the POSIX convention for success. In a well-written verify script every assertion is wired to exit non-zero on failure, so exit 0 means all assertions passed. Tools like CI systems, <code>make</code>, and shell <code>&amp;&amp;</code> chains all read exit code, not stdout, so the exit code is the primary contract.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> Where should a verify script print its failure diagnosis?</p>
    <label><input type="radio" name="019-q3" value="a"> **a.** stdout, so it is easy to capture with <code>$()</code>.</label>
    <label><input type="radio" name="019-q3" value="b"> **b.** A log file in <code>/tmp</code>.</label>
    <label><input type="radio" name="019-q3" value="c"> **c.** Both stdout and stderr simultaneously.</label>
    <label><input type="radio" name="019-q3" value="d"> **d.** stderr only, using <code>echo "..." &gt;&amp;2</code>.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Stdout is for data; pipelines and <code>$()</code> captures consume it. Printing a failure message to stdout silently corrupts any caller that captures stdout. Stderr is the correct destination for diagnostics because it is visible to the operator without interfering with data consumers.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> Why is <code>curl --fail</code> combined with a <code>jq -e</code> assertion better than reading the response visually?</p>
    <label><input type="radio" name="019-q4" value="a"> **a.** It produces a binary exit code that a shell script can act on, making the check repeatable and CI-compatible.</label>
    <label><input type="radio" name="019-q4" value="b"> **b.** It is faster than reading because <code>curl</code> uses HTTP/2 by default.</label>
    <label><input type="radio" name="019-q4" value="c"> **c.** It avoids the need to start the server before running the check.</label>
    <label><input type="radio" name="019-q4" value="d"> **d.** It works even when the server returns a 5xx error.</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>--fail</code> makes <code>curl</code> exit non-zero on 4xx or 5xx responses; <code>jq -e</code> exits non-zero when the expression evaluates to false or null. Together they turn a visual check into a shell-scriptable binary signal. A human reading the terminal is the assertion exactly once — a script does it the same way every time across every environment.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Extend `quips/verify-feature.sh` to also assert that `DELETE /quips/:id` removes the record — a subsequent `GET /quips/:id` should return HTTP 404. Keep the total script under 40 lines and keep it idempotent. Add a one-line stderr diagnosis for the DELETE path.

## Recall

Lab 018 introduced the challenge-then-revise review loop. In that lab you sent two challenge prompts before accepting Claude's diff. Name those two prompts and explain why sending them as separate messages (rather than one combined message) produces better results.

> Expected: the two prompts were "What edge cases would this route miss?" and "Write 3 tests for this route. At least one test must currently fail against your proposed implementation." Sending them separately gives Claude a chance to reason about edge cases before it is asked to expose gaps through tests. Combining them into one message often produces a hedged answer that addresses both superficially.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/common-workflows
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/anthropic-cookbook

## Next

→ **Lab 020 — Refactor Safely** — use Claude to rename and restructure a module while keeping all verify scripts green throughout.
