# Lab 014 — Compaction

⏱ **20 min**   📦 **You'll add**: `Labs/014-Compaction/compact-notes.md`   🔗 **Builds on**: Lab 013   🎯 **Success**: `compact-notes.md exists, non-empty, contains the word 'compact' (case-insensitive) AND a 'before' + 'after' marker`

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
    - You will run `/compact` inside a long Claude Code session and observe how the conversation continues without losing key facts.
    - You will contrast `/compact` (summarises history, preserves state) with `/clear` (wipes everything) through a live experiment.
    - You will use `/cost` to confirm the token reduction that compaction achieves.
    - You will document before/after token counts and what the summary kept in `compact-notes.md`.

**Concept**: `/compact summarises session history to free tokens without wiping state` (Bloom: Apply)

---

## Prerequisites

- Lab 001 complete — `claude` is on PATH
- Lab 013 complete — you are comfortable reading `/cost` output
- The `quips` submodule present (`git submodule update --init quips`)

## What You Will Learn

- What `/compact` does internally: it asks Claude to produce a compact summary of the conversation so far, replaces the raw message history with that summary, and continues the session
- When to reach for `/compact` (context window at or above 60%) and when to leave it alone
- How `/compact` differs from `/clear` and why that distinction matters
- What information a compacted session can and cannot recall, and how to verify it
- How `/cost` confirms the token savings after compaction

## Why

Every token in the context window costs latency and money — and Claude re-reads every token on every response. Long sessions accumulate tool call results, chain-of-thought reasoning, intermediate code, and casual back-and-forth that Claude no longer needs but still pays to process. `/compact` replaces that bulk with a tight summary so the session continues with full awareness of what matters and far fewer tokens. Building this habit means you avoid the hard choice of `/clear` (which wipes everything) and can keep working in the same session much longer. This lab builds that habit through a direct experiment you can see and measure.

## Walkthrough

Claude Code tracks the full conversation in the context window. As a session grows, each new message costs more because the model re-reads everything from the beginning. The context window has a finite limit, and when you approach it Claude's responses slow down and eventually become impossible without starting over.

`/compact` interrupts that trajectory. When you run it, Claude generates a structured summary of the session so far — capturing decisions made, files discussed, code written, and key facts established — and replaces the raw history with that summary. The session continues from that summary rather than from the full transcript. You lose the verbatim history but keep the meaning.

**`/compact` vs `/clear` — when to use which:**

| Situation | Command | Why |
|---|---|---|
| Context window at 60%+ but session still productive | `/compact` | Trims tokens, preserves state — session continues coherently |
| Session is finished; starting a genuinely new topic | `/clear` | Full wipe is fine because you don't need continuity |
| Context window under 40% | Neither | No urgency; compacting too early wastes the summary cost |
| Claude starts forgetting things it said earlier | `/compact` first | Compacting often restores coherence before you resort to `/clear` |
| Accidentally compacted too aggressively | `/clear` + reload files with `@path` | Compact is irreversible; your files are your real memory |

A compacted session can still recall: goals set at the start, schema discussed, file names and paths mentioned, decisions made, code structure explored. It will not recall: exact wording of casual remarks, intermediate attempts that were abandoned, or verbatim text of long file reads. The summary is Claude's interpretation of what mattered.

`/cost` shows cumulative input and output tokens for the session. Run it before and after `/compact` and you will see the input token count drop — that drop is the compaction dividend.

## Check

```bash
./scripts/doctor.sh 014
```

Expected output: `OK lab 014 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before running anything, write down which categories of content you expect Claude to keep vs. drop when compacting. For example: schema details, file contents, casual remarks, abandoned attempts, decisions made. Note your predictions somewhere — you will check them in step 5.

   Verify the quips submodule is present:

   ```bash
   [[ -d quips ]] && echo "quips present" || echo "missing quips — run: git submodule update --init quips"
   ```

   Expected: `quips present`

2. **Run** — start a dense session. From the repo root:

   ```bash
   cd quips && claude
   ```

   Inside the REPL, run `/cost` immediately and note the baseline token count. Then ask at least 10 questions across varied topics, for example:

   - What Node.js version does this project target?
   - Explain the schema in `src/db.js`.
   - What is integration testing?
   - What does `express.json()` do?
   - What HTTP status code means "created"?
   - What is a foreign key?
   - How does `npm test` discover test files in this project?
   - What is the difference between `==` and `===` in JavaScript?
   - What does the `PORT` environment variable control here?
   - What is the purpose of `resetDb()` in this codebase?

   After the 10 questions, run `/cost` again and note the token count before compaction.

   Verify you have a before-compact token count recorded:

   ```bash
   echo "confirm: you have run /cost and noted the token count before /compact"
   ```

3. **Investigate** — compare `/compact` and `/clear` in theory before using either. Inside the same REPL, ask Claude:

   > In one sentence each: what does /compact do, and what does /clear do?

   Note how Claude describes the difference. Then verify you understand the distinction:

   ```bash
   echo "confirm: you can articulate in your own words what /compact preserves that /clear discards"
   ```

4. **Modify** — run `/compact` inside the REPL. After compaction completes, immediately run `/cost` again and note the new token count. Then test recall by asking:

   > What was the schema I asked about?

   Claude should answer correctly from the compact summary. Then ask a second recall question:

   > What is the first question I asked you in this session?

   Note whether Claude recalls it verbatim, approximately, or not at all.

   Verify the session is still active and you have an after-compact token count:

   ```bash
   echo "confirm: session still active, /cost run after /compact, token count recorded"
   ```

5. **Make** — write `Labs/014-Compaction/compact-notes.md` with three sections:

   - **Before** — token count before compaction (or turn count if `/cost` was unavailable), topics covered
   - **After** — token count after compaction, topics Claude preserved correctly
   - **Dropped** — any topics Claude answered less precisely or could not recall

   Then verify:

   ```bash
   ./scripts/verify.sh 014
   ```

   Expected: `OK lab 014 verified`

## Observe

One sentence — what kind of session content is worst to lose in a compact, and what does that imply about where you should store it instead?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| `/compact` errors or is unrecognised | CLI version too old | Update with `npm i -g @anthropic-ai/claude-code@latest` | https://github.com/anthropics/claude-code |
| Compaction drops a schema or decision you needed | Claude summarises low-salience facts away | Save critical outputs to files before compacting; reload with `@path` — the session history is not your only memory | https://docs.claude.com/en/docs/claude-code/overview |
| `/cost` shows no change after `/compact` | The summary itself costs tokens; very short sessions may show little net gain | Compaction pays off most on sessions with 20+ turns; on short sessions the overhead dominates | https://docs.claude.com/en/docs/claude-code/overview |
| Claude can't recall the first message after `/compact` | The summary captures decisions and facts, not verbatim turn order | This is expected behaviour; the summary is semantic, not a transcript | https://docs.claude.com/en/docs/claude-code/overview |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Trigger `/compact` after a dense session and observe post-compact responses

**Scenario:** You have asked Claude 10+ questions in a single session. You want to free up context without losing the thread.

**Hint:** Run `/compact` at the REPL prompt. After it completes, ask a question that depends on something from earlier in the session and compare the quality of the answer.

??? success "Solution"

    ```
    # Inside the claude REPL after 10+ turns:
    /compact

    # Then ask a recall question:
    > What was the Node.js version this project targets?
    # Claude should answer from the compact summary without re-reading the full history.
    ```

    Run `/cost` before and after `/compact` to see the input token count drop.

### Task 2 — Compact at 40% vs 80% context and compare quality

**Scenario:** You want to understand whether timing matters — does compacting early (40% context) produce a better summary than waiting until 80%?

**Hint:** Start two sessions. Compact the first after ~5 questions, the second after ~15. Ask the same recall question in both and compare how detailed the summaries are.

??? success "Solution"

    ```
    # Session A — compact early (~5 turns)
    cd quips && claude
    # Ask 5 questions, run /cost (note ~40% context), run /compact
    > What was the schema in src/db.js?

    # Session B — compact late (~15 turns)
    cd quips && claude
    # Ask 15 questions, run /cost (note ~80% context), run /compact
    > What was the schema in src/db.js?
    ```

    The late-compact session often produces a richer summary because there is more to summarise. The early-compact session costs fewer tokens overall. Neither is wrong — the tradeoff is richness vs. cost.

### Task 3 — Compare `/compact` with `/clear` on follow-up questions

**Scenario:** You want to see the concrete difference between a compacted session and a cleared one when you ask about earlier conversation content.

**Hint:** Run two back-to-back sessions. In the first, use `/compact` and then ask about the first question. In the second, use `/clear` and ask the same thing.

??? success "Solution"

    ```
    # Session with /compact:
    cd quips && claude
    # Ask: "What Node.js version does this project target?"
    /compact
    > What was my first question?
    # Claude will recall it (approximately) from the summary.

    # Session with /clear:
    cd quips && claude
    # Ask: "What Node.js version does this project target?"
    /clear
    > What was my first question?
    # Claude has no memory of it — /clear wiped the context entirely.
    ```

    The contrast makes the difference concrete: `/compact` preserves meaning; `/clear` preserves nothing.

### Task 4 — Ask Claude about the first message of the session after `/compact`

**Scenario:** You compacted a session and want to know exactly how much of the turn-by-turn history Claude retained.

**Hint:** After `/compact`, ask Claude directly: "What is the first question I asked you in this session?" The answer reveals whether the summary is verbatim, approximate, or semantic.

??? success "Solution"

    ```
    # After /compact, inside the REPL:
    > What is the very first question I asked you in this session?
    ```

    Claude typically answers with the topic rather than the exact wording — "You asked about the Node.js version this project targets" rather than a verbatim quote. This is the expected behaviour: the summary captures intent and fact, not transcript.

### Task 5 — Observe what the compact summary retains

**Scenario:** You want to probe the compact summary systematically to understand which categories of information survive.

**Hint:** After `/compact`, ask one recall question per category: a schema detail, a decision made, a file name mentioned, a casual remark, and an abandoned approach.

??? success "Solution"

    ```
    # After /compact, probe each category:
    > What schema did we discuss? (schema detail — likely retained)
    > Did we decide anything about how to test resetDb()? (decision — likely retained)
    > Which files did I ask you to read? (file names — likely retained)
    > Do you remember the exact phrasing of my third question? (verbatim phrasing — typically not retained)
    > Did I ask about anything and then abandon it? (abandoned attempts — often not retained)
    ```

    Use the results to fill in the **Dropped** section of `compact-notes.md`.

### Task 6 — Use `/cost` to confirm token savings

**Scenario:** You want numerical evidence that `/compact` actually reduces the token count, not just a feeling that it does.

**Hint:** Run `/cost` before `/compact`, run `/compact`, run `/cost` again. Subtract to find the net reduction. Record both numbers in `compact-notes.md`.

??? success "Solution"

    ```
    # Inside the claude REPL:
    /cost
    # Note: "Input tokens: X"

    /compact

    /cost
    # Note: "Input tokens: Y"

    # The difference X - Y is the compaction dividend.
    # A 20-turn session typically saves 40–70% of input tokens.
    ```

    If the net saving is small, the session was too short for compaction to pay off. Compaction is most valuable on sessions with 20+ turns or when you are approaching context limits.

## Quiz

<div class="ccg-quiz" data-lab="014">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> After running <code>/compact</code>, which of the following does the session still have access to?</p>
    <label><input type="radio" name="014-q1" value="a"> **a.** The verbatim wording of every message sent before compaction</label>
    <label><input type="radio" name="014-q1" value="b"> **b.** The key facts, decisions, and file details captured in the compact summary</label>
    <label><input type="radio" name="014-q1" value="c"> **c.** The exact token count of the pre-compact history</label>
    <label><input type="radio" name="014-q1" value="d"> **d.** A transcript file saved to disk</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/compact</code> replaces the raw message history with a structured summary. The summary captures meaning — facts, decisions, schemas, file names — not verbatim wording. The session continues coherently from that summary.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q2.</strong> You run <code>/clear</code> in the middle of a session. What does Claude still know about your earlier conversation?</p>
    <label><input type="radio" name="014-q2" value="a"> **a.** Everything — <code>/clear</code> only clears the screen display</label>
    <label><input type="radio" name="014-q2" value="b"> **b.** The last three messages</label>
    <label><input type="radio" name="014-q2" value="c"> **c.** Any facts mentioned in the system prompt</label>
    <label><input type="radio" name="014-q2" value="d"> **d.** Nothing from the prior conversation — the context is fully wiped</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain"><code>/clear</code> wipes the entire conversation context. Claude starts fresh with no memory of anything said before the command. This is appropriate when starting a genuinely new topic, but destructive if you still need continuity from the current session.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q3.</strong> Your context window is at 75% and your session is still productive. Which command should you reach for?</p>
    <label><input type="radio" name="014-q3" value="a"> **a.** <code>/clear</code>, because a full reset is always safer</label>
    <label><input type="radio" name="014-q3" value="b"> **b.** Neither — wait until the window is completely full</label>
    <label><input type="radio" name="014-q3" value="c"> **c.** <code>/compact</code>, because it frees tokens while preserving session state</label>
    <label><input type="radio" name="014-q3" value="d"> **d.** <code>/cost</code>, to reduce token usage</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">At 75% context you still have room to compact cleanly. <code>/compact</code> generates a summary and replaces the raw history, freeing significant token space while keeping your session coherent. Waiting until the window is full risks hitting the limit mid-response.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> After <code>/compact</code>, you ask "What was the schema in src/db.js?" What kind of answer should you expect?</p>
    <label><input type="radio" name="014-q4" value="a"> **a.** A semantically accurate description of the schema, derived from the compact summary</label>
    <label><input type="radio" name="014-q4" value="b"> **b.** No answer — compaction deletes all file-related context</label>
    <label><input type="radio" name="014-q4" value="c"> **c.** The verbatim file contents, re-read from disk automatically</label>
    <label><input type="radio" name="014-q4" value="d"> **d.** An error, because the session no longer has access to file paths</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">The compact summary captures schema details, file names, and key facts discussed during the session. Claude can answer questions about them from the summary — accurately, though not verbatim. If you need the exact file contents, reload with <code>@src/db.js</code>.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Deliberately compact a session when the context is below 20%. Then compact another session above 70%. Compare the two summaries by asking Claude in each: "What is the compact summary of our conversation?" Note how the depth and specificity of the summaries differs. Write one sentence explaining the relationship between session length and compact summary quality.

## Recall

What Part II lab taught you to check how much a session has cost before running more prompts?

> Expected: Lab 013 — Cost Monitoring

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/overview
- https://github.com/anthropics/claude-code

## Next

→ **Lab 015 — Custom Instructions** — shape Claude's default behaviour for every session with persistent instructions.
