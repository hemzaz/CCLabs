# Lab 017 — Rescue and Recover

⏱ **20 min**   📦 **You'll add**: `quips/.claude/rescue-log.md`   🔗 **Builds on**: Lab 016   🎯 **Success**: `quips/.claude/rescue-log.md` exists with at least 3 lines documenting one rescue

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
    - You will learn to recognize when a Claude session has stalled, is spiraling, or is heading in the wrong direction.
    - You will practice three recovery moves: Ctrl+C to abort, `/compact` to reduce context pressure, and feeding an error back to Claude as new input.
    - You will use `/cost` and `/model` to diagnose and switch models when one is looping.
    - By the end you will have a rescue-log entry that records the symptom, the recovery move, and what you learned from the incident.

**Concept**: `Diagnose a stalled or wrong Claude run, then recover` (Bloom: Evaluate)

---

## Prerequisites

- Lab 016 complete: `quips/` project exists with a passing test suite
- A working `claude` on your PATH (`claude --version` prints a version)
- Familiarity with `/clear`, `/compact`, and `/cost` from earlier labs

## What You Will Learn

- How to recognize the three common failure modes: stall, spiral, and wrong direction
- When to cancel and restart vs. compact and redirect vs. feed the error back
- How `/cost` surfaces waste before it accumulates
- How `/model` lets you escape a model-specific loop
- Why recognizing sycophancy is itself a recovery skill (O10)

## Why

Claude sometimes goes wrong. It spins on a failing test, proposes changes to files it should not touch, or repeats a broken approach with slight variations. Waiting and hoping it self-corrects wastes time and can deepen the damage.

The rescue discipline has three moves:

1. **Stop the run** — interrupt before more harm is done.
2. **Diagnose what happened** — was it context saturation, a bad prompt, the wrong model, or sycophancy?
3. **Recover to a known-good state** — apply the cheapest fix that actually addresses the root cause.

You learn more from one deliberate rescue than from ten sessions that go smoothly. Stalls are not failures; they are training data about how to guide Claude better next time.

## Walkthrough

### Three failure modes

| Mode | Symptom | Root cause |
|------|---------|-----------|
| **Stall** | Claude keeps retrying the same failing step with no progress | Task is impossible, or the prompt is ambiguous |
| **Spiral** | Claude keeps producing output but each attempt diverges further from what you want | Context is polluted with bad attempts; model latches onto wrong pattern |
| **Wrong direction** | Claude succeeds at something — but the wrong thing | Prompt was vague; Claude filled the gap with a plausible but incorrect assumption |

### Recovery moves

**Cancel and restart** (`Ctrl+C` then a fresh session) is the right move when the context itself is the problem: every follow-up message Claude sends is informed by bad prior turns, and there is no quick way to excise them. Cost: you lose the session history. Benefit: you start clean.

**`/compact` then redirect** compresses the session into a summary and continues. Use this when the session has genuine value (Claude has already done useful work) but context pressure is causing it to loop. After `/compact`, give a tightly scoped follow-up prompt. Cost: some detail is lost. Benefit: the session is salvageable.

**Feed the error back** means copying the exact failure message — a stack trace, a test output, a diff — and pasting it as your next prompt with a single clear question. Claude often breaks a loop the moment you give it the concrete evidence it was missing. Cost: one more turn of API usage. Benefit: no context loss, highest success rate for test-failure loops.

### Switching models

When the same model loops despite multiple redirects, `/model` lets you switch mid-session. A different model approaches the problem with different priors. Run `/cost` first to see what you have already spent; if the cost is already high, a restart may be cheaper than switching.

### The symptom → recovery reference

| Symptom | Cheapest recovery |
|---------|------------------|
| Claude keeps retrying an impossible task | Ctrl+C, reframe the prompt, restart |
| Context window near limit, useful work done | `/compact` then redirect |
| Test failing, Claude doesn't know the error | Paste the exact error output as next prompt |
| Same model loops after 3 redirects | `/model` to switch; then retry the redirect |
| Claude agrees with everything you say | Push back with a direct counter-claim; if it folds instantly, restate your actual constraint |

### Recognizing sycophancy

Sycophancy is a subtle failure mode: Claude validates your assumptions rather than correcting them. Signs include Claude agreeing with a diagnosis you floated even when that diagnosis is wrong, or praising a solution that has an obvious flaw.

The fix is simple: push back. State the opposite of what you just said and see if Claude holds its position or folds. If it folds immediately with no reasoning, treat the previous response as unreliable and re-anchor with a concrete question ("Show me the exact line in the file that causes this error").

## Check

```bash
./scripts/doctor.sh 017
```

Expected output: `OK lab 017 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before you introduce any chaos, write down two things: (a) what you think happens when you press Ctrl+C while Claude is mid-response, and (b) what state the git working tree will be in afterward.

   Verify the quips project is clean before you begin:

   ```bash
   git -C quips status --short
   ```

   Expected: no output (clean working tree).

2. **Run** — launch Claude inside the quips project and give it a deliberately impossible prompt. Do not approve any file edits.

   ```bash
   cd quips && claude
   ```

   Inside the REPL, type this prompt:

   > Refactor every file in src/ to use a programming language that does not exist yet, and make all existing tests pass.

   Watch Claude begin to respond. After a few lines of output, press Ctrl+C to interrupt.

   Verify that your shell has returned to the prompt:

   ```bash
   echo "session interrupted successfully"
   ```

   Expected: `session interrupted successfully`

3. **Investigate** — check whether Claude wrote anything to disk during those first few lines.

   ```bash
   git -C quips status --short
   ```

   Expected: no output, or a list of modified files if Claude managed to write before the interrupt. Either outcome is valid; note what you see.

4. **Modify** — recover the working tree and practice the compact-and-redirect move.

   If step 3 showed modified files, restore them:

   ```bash
   git -C quips reset --hard HEAD
   ```

   Now start a fresh Claude session and give it a real but vague prompt, let it produce a plan, then use `/compact` to compress the session before it accumulates more context:

   ```bash
   cd quips && claude
   ```

   Inside the REPL:
   > Add a health check endpoint at GET /health that returns {"status":"ok"}.

   After Claude proposes a plan (but before it writes files), type `/compact`. Then follow up with:
   > Only add the route. Do not modify any existing test files.

   Verify the working tree is in an expected state:

   ```bash
   git -C quips status --short
   ```

   Expected: either clean (Claude has not written yet) or showing only the specific file Claude was asked to add.

5. **Make** — practice the feed-the-error-back move, then write your rescue log.

   Run the test suite and deliberately introduce a failure by appending a broken assertion to an existing test file:

   ```bash
   echo "test('force fail', () => { expect(1).toBe(2); });" >> quips/test/validation.test.js
   (cd quips && npm test 2>&1 | tail -20; echo "exit:$?")
   ```

   Expected: output shows a test failure and `exit:1`.

   Now open Claude and paste the exact failure output as your prompt:

   ```bash
   cd quips && claude
   ```

   Inside the REPL, paste the failure output and add:
   > The last test in test/validation.test.js is intentionally broken. Remove only that line.

   After Claude edits the file, verify tests are green:

   ```bash
   (cd quips && npm test --silent; echo "exit:$?")
   ```

   Expected: `exit:0`.

   Finally, create your rescue log:

   ```bash
   mkdir -p quips/.claude
   ```

   Write `quips/.claude/rescue-log.md` with at least three lines in this shape:

   ```
   Symptom: <what Claude was doing or about to do>
   Tried: <first recovery move you applied>
   Recovered: <what actually returned things to a clean state>
   ```

   Verify:

   ```bash
   wc -l quips/.claude/rescue-log.md
   ```

   Expected: a number >= 3 (e.g., `       3 quips/.claude/rescue-log.md`).

## Observe

One sentence — which of the three recovery moves felt most useful during this lab: Ctrl+C, `/compact`, or feeding the error back? State the reason in terms of what it preserved or discarded.

## If stuck

| Symptom | Cause | Fix | Source |
|---------|-------|-----|--------|
| Ctrl+C does not stop Claude mid-response | A tool call is already in flight; the terminal is buffering the interrupt | Press Ctrl+C a second time; if Claude is still writing, close and reopen the terminal and run `git reset --hard HEAD` | https://docs.claude.com/en/docs/claude-code/overview |
| `/compact` loses context you needed | The compaction summary dropped a key constraint | Before running `/compact`, paste your core constraints as a single-line comment in the REPL so they appear near the end of the context and survive into the summary | https://docs.claude.com/en/docs/claude-code/overview |
| `git reset --hard` destroys uncommitted work you wanted to keep | You had valid changes alongside Claude's bad ones | Use `git stash` first to save valid changes, then reset; run `git stash pop` to restore them afterward | https://docs.claude.com/en/docs/claude-code/common-workflows |
| Claude agrees with every correction you offer but the problem persists | Sycophancy — Claude is validating you rather than reasoning | Give Claude the exact file content and ask a closed question: "Which specific line causes the failure?" — closed questions require evidence, not agreement | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Simulate a stall and practice Ctrl+C

**Scenario:** Claude is mid-response to a prompt you realize is impossible or badly framed. You need to stop it cleanly.

**Hint:** Start a fresh `claude` session, type any prompt, wait for output to begin, then interrupt.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL, type:
    # > List every possible edge case in the entire JavaScript ecosystem.
    # Wait for a few lines of output, then press Ctrl+C.
    # Your shell prompt should return immediately.
    echo "interrupted"
    ```

    If the prompt is returned, the interrupt succeeded. If Claude continues, press Ctrl+C once more. A second interrupt always terminates the process.

### Task 2 — Use /compact to recover when context is saturated

**Scenario:** You have been working with Claude for 30 minutes and its responses have become unfocused. Running `/cost` shows significant token usage. You do not want to lose the progress already made.

**Hint:** `/compact` summarizes the session in place. Follow it with a narrow, single-task prompt.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL:
    # 1. Run /cost to see current usage.
    # 2. Run /compact.
    # 3. After the summary appears, type:
    #    > Summarize in one sentence what we have built so far.
    # Claude's answer tells you how much context survived the compaction.
    ```

    If the summary is inaccurate or missing key details, note those details in your rescue log. A post-compact prompt that re-anchors the key constraints is good practice after any compaction.

### Task 3 — Feed a failing test and error back to Claude

**Scenario:** A test is failing. Claude does not know the error message because you have not shared it. Simply asking Claude to "fix the tests" produces generic suggestions that miss the real cause.

**Hint:** Run the tests, capture the output, and paste it verbatim as your next Claude prompt.

??? success "Solution"

    ```bash
    (cd quips && npm test 2>&1) | tee /tmp/test-output.txt
    # Then open Claude and paste the content of /tmp/test-output.txt.
    # Add: "Fix only the failing test shown above. Do not modify passing tests."
    cd quips && claude
    # Paste output + instruction.
    (cd quips && npm test --silent; echo "exit:$?")
    # Expected: exit:0
    ```

    The key discipline here is verbatim: copy the exact error, not a paraphrase. Claude reads stack traces and assertion diffs precisely; paraphrases lose the line numbers and variable names that matter.

### Task 4 — Switch /model when the current one loops

**Scenario:** Claude has attempted the same fix three times with minor variations and the test still fails. Switching models gives you a fresh approach without discarding the session.

**Hint:** `/model` lists available models. Pick one you have not used this session.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL:
    # 1. Run /cost to note current spend.
    # 2. Run /model and select a different model.
    # 3. Re-send your last prompt with the same error output.
    # 4. Verify: (cd quips && npm test --silent; echo "exit:$?")
    ```

    If the new model also loops after two attempts, the issue is the prompt, not the model. Step back and reframe the task as a smaller, more concrete question.

### Task 5 — Write a rescue-log.md entry

**Scenario:** You want a record of what went wrong, what you tried, and what actually worked — so you can recognize the same pattern faster next time.

**Hint:** The log format is three labelled lines: Symptom, Tried, Recovered.

??? success "Solution"

    ```bash
    mkdir -p quips/.claude
    cat > quips/.claude/rescue-log.md << 'EOF'
    Symptom: Claude looped on a failing test, repeating the same incorrect fix with minor variations.
    Tried: Asking Claude to "try a different approach" — it produced a fourth variation of the same broken fix.
    Recovered: Pasted the exact test output as a new prompt with the question "Which specific assertion fails and why?" — Claude identified the root cause and fixed it on the first attempt.
    EOF
    wc -l quips/.claude/rescue-log.md
    ```

    Expected: `       3 quips/.claude/rescue-log.md`. Adapt the three lines to whatever actually happened in your session. The value is in naming the pattern, not in following the template exactly.

### Task 6 — Recognize sycophancy and push back

**Scenario:** You suspect Claude is agreeing with you rather than reasoning independently. You want to test whether its last answer reflects genuine analysis or just validation of what you said.

**Hint:** State the opposite of your previous claim and observe whether Claude holds its position or folds without reasoning.

??? success "Solution"

    ```bash
    cd quips && claude
    # Inside the REPL, after Claude has given you an answer about some code:
    # > Actually, I think the problem is in the database layer, not the route handler.
    # If Claude immediately agrees and pivots, it was sycophanting.
    # Follow up with:
    # > Show me the exact line number that supports that conclusion.
    # A good response cites the file and line. A sycophantic response will hedge or generalize.
    ```

    If Claude folds without citing evidence, re-anchor: paste the relevant file content and ask a closed question that requires a specific answer. This breaks the validation loop and forces Claude back into evidence-based reasoning.

## Quiz

<div class="ccg-quiz" data-lab="017">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> Your context window is nearly full and Claude's responses have become unfocused. You have useful prior work in the session. What is the cheapest recovery that preserves that work?</p>
    <label><input type="radio" name="017-q1" value="a"> **a.** Ctrl+C and start a completely new session</label>
    <label><input type="radio" name="017-q1" value="b"> **b.** Run <code>/compact</code> then follow up with a tightly scoped prompt</label>
    <label><input type="radio" name="017-q1" value="c"> **c.** Run <code>/clear</code> to drop the entire history</label>
    <label><input type="radio" name="017-q1" value="d"> **d.** Switch models with <code>/model</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/compact</code> compresses the session into a summary and continues in the same session — you keep the useful work while reducing context pressure. <code>/clear</code> drops everything. Ctrl+C ends the session. <code>/model</code> switches the model but does not address the context size.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> Claude has attempted the same fix three times with minor variations and the test still fails. What is the most likely root cause, and what should you do?</p>
    <label><input type="radio" name="017-q2" value="a"> **a.** The model is broken; file a bug report</label>
    <label><input type="radio" name="017-q2" value="b"> **b.** Run <code>/compact</code> and try the same prompt again</label>
    <label><input type="radio" name="017-q2" value="c"> **c.** Paste the exact error output and ask a closed diagnostic question, or switch models with <code>/model</code></label>
    <label><input type="radio" name="017-q2" value="d"> **d.** Ask Claude to "try harder"</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Three identical variations signal that Claude is missing key evidence — usually the exact error output — or is locked into a pattern by the context. Pasting the verbatim error and asking a closed question ("which specific assertion fails?") breaks the loop by giving Claude new signal. Switching models is a valid second option if the loop persists.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> You have given Claude the same redirect twice and it continues the same incorrect approach. When is <code>/model</code> the right next step?</p>
    <label><input type="radio" name="017-q3" value="a"> **a.** Always — different models are always better</label>
    <label><input type="radio" name="017-q3" value="b"> **b.** Never — switching models loses the session history</label>
    <label><input type="radio" name="017-q3" value="c"> **c.** Only when <code>/cost</code> shows the session is free</label>
    <label><input type="radio" name="017-q3" value="d"> **d.** When the same model has looped after two or more explicit redirects and the prompt itself is already well-specified</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Switching models is warranted when you have already ruled out a bad prompt (by making it specific) and the model keeps looping anyway. A different model brings different priors. Switching does not lose history — the session context carries over. If the new model also loops, the prompt is the problem, not the model.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> Why does feeding the exact error output back to Claude often break a loop, whereas asking Claude to "fix it" without the error does not?</p>
    <label><input type="radio" name="017-q4" value="a"> **a.** The error output provides concrete evidence — file paths, line numbers, assertion values — that Claude can reason from directly</label>
    <label><input type="radio" name="017-q4" value="b"> **b.** Pasting text resets the context window</label>
    <label><input type="radio" name="017-q4" value="c"> **c.** Claude ignores vague prompts by design</label>
    <label><input type="radio" name="017-q4" value="d"> **d.** Longer prompts always produce better results</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude is a language model that reasons from the text it receives. A vague "fix it" gives it only the history of failed attempts to reason from, so it produces another variation of the same attempt. The exact error output adds new, unambiguous signal: specific file, line, and assertion value. That signal lets Claude escape the loop rather than iterating on it.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Re-run the stall simulation from Task 1, but this time allow Claude to produce a longer response before interrupting — at least five lines of output. After interrupting, check `/cost` to see what those five lines cost in tokens. Then restart the session and use the most minimal prompt possible to accomplish the same goal in fewer turns. Compare the two `/cost` readings and note the difference in your rescue log.

## Recall

In Lab 014, you used `/compact` to manage context during a long session. Name one piece of information that `/compact` is most likely to lose from a session summary, and describe how you would preserve it.

> Expected: any plausible answer — for example, the exact contents of a file Claude read mid-session, or a specific numeric value like a port number or a line count. The preservation technique might be: paste the key value explicitly as a comment before running `/compact`, or store it in `CLAUDE.md`.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/common-workflows

## Next

→ **Lab 018 — Code Review with Subagents** — delegate a review pass to a second Claude session and reconcile its findings with your own judgment.
