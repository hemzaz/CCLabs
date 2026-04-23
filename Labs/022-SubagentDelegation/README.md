# Lab 022 — Subagent Delegation

⏱ **30 min**   📦 **You'll add**: `quips/.claude/agents/test-writer.md` + `quips/.claude/delegation-log.md`   🔗 **Builds on**: Lab 021   🎯 **Success**: `test-writer.md` has valid frontmatter and `delegation-log.md` references both subagents

<!--
  Template contract - do not remove this comment.
  CI (lint-prose + structure linter) enforces:
    1. Header line above (one line, five fields, in this exact order)
    2. !!! hint "Overview" admonition with >=3 bullets
    3. Concept: line with a Bloom tag
    4. Fourteen H2 sections below in this exact order:
       Prerequisites, What You Will Learn, Why, Walkthrough, Check, Do,
       Observe, If stuck, Tasks, Quiz, Stretch, Recall, References, Next
    5. >=5 Tasks, each with a ??? success "Solution" block
    6. >=3 MCQ questions inside a <div class="ccg-quiz">
  See CONTRIBUTING.md and docs/DESIGN.md §7 for the full author contract.
-->

!!! hint "Overview"
    - You will create a `test-writer` subagent alongside the existing `reviewer` subagent.
    - You will orchestrate a two-agent chain: test-writer drafts tests, reviewer critiques them.
    - You will observe the hand-off in the session transcript and record it in a delegation log.
    - By the end you can explain when delegation accelerates work and when it adds unnecessary overhead.

**Concept**: `Main-agent-as-orchestrator delegating to specialist subagents` (Bloom: Apply)

---

## Prerequisites

- Completed [Lab 021 — Subagents](../021-Subagents/README.md)
- `quips/.claude/agents/reviewer.md` exists (created in Lab 021)

## What You Will Learn

- How to compose two subagents into a delegation chain (draft then critique)
- How the main agent acts as an orchestrator, sequencing specialist calls
- How to read the transcript to confirm the hand-off actually happened
- When routing a task to a subagent improves quality versus adding latency

## Why

A subagent that exists but never gets work is useless. Delegation — routing a task to the right specialist — is what turns a directory of agent definitions into a working system. Claude can delegate automatically when a subagent's description matches the task, or you can direct it with an explicit prompt. Understanding both paths lets you build sessions where a `test-writer` drafts tests and a `reviewer` critiques them, without you having to do either job manually. This lab practices Outcome O5 by wiring those two agents together and recording what happens at the seam.

## Walkthrough

### The main-agent-as-orchestrator pattern

When you run `claude` in a project, the session you talk to is the **main agent**. Subagents defined in `.claude/agents/` are specialists the main agent can summon. The main agent is responsible for:

1. Deciding which subagent fits the task
2. Packaging the right context into the Task call
3. Receiving the subagent's output and deciding what to do with it next
4. Returning a final answer or triggering the next specialist

The subagents themselves are unaware of each other. They receive a prompt and return a result. Sequencing, error handling, and synthesis all belong to the orchestrator.

### Two delegation paths

| Path | How it works | When to use |
|---|---|---|
| **Automatic** | Claude reads each subagent's `description` field and routes matching tasks without you asking | Descriptions are action-specific and unambiguous |
| **Explicit** | You ask Claude to "use test-writer to..." in your prompt | You want to force a particular specialist or verify routing |

Automatic routing is convenient but fails silently if the description is too generic. Explicit routing is reliable but more verbose. For orchestrated chains, explicit prompts are safer because you control the order.

### Delegation chain template

A reusable pattern for chaining two subagents looks like this in a prompt:

```
Use <agent-A> to <first task> for <subject>.
Then use <agent-B> to <second task> on that output.
Write both outputs to <log-file>.
```

The main agent executes agent-A, collects the result, passes it as context to agent-B, then writes the combined output. You can see each step in the transcript because Claude announces which subagent it is invoking.

### When delegation speeds up vs slows down work

Delegation helps when:

- The task is well-defined and fits within one subagent's expertise
- The subagent has a tighter tool scope than the main agent (safer, faster)
- The same specialist will be reused across many sessions

Delegation slows work when:

- The task is ambiguous and the subagent will need back-and-forth clarification
- The overhead of spawning an agent exceeds the complexity of the task itself
- The description does not match and Claude picks the wrong subagent

A useful rule: if you can write the subagent's entire output yourself in under a minute, do not delegate. If the subagent is better at that narrow task than you are at prompting for it, delegate.

### Observing the hand-off

When Claude delegates, the transcript shows a Tool Use block for the Task tool, including the subagent name and the prompt sent to it. The response block shows what that subagent returned. Reading these two blocks tells you:

- Whether the correct subagent was chosen
- Whether the context passed to it was complete
- Whether the output was usable or needed repair

If the subagent name is wrong, the description needs to be more specific. If the output is incomplete, the context passed in was too thin.

## Check

```bash
./scripts/doctor.sh 022
```

Expected output: `OK lab 022 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing any files, write one sentence: why should `test-writer` NOT have `Edit` access to `quips/src/`?

   Capture your prediction:
   ```bash
   echo "prediction captured"
   ```
   Expected: `prediction captured`

2. **Run** — confirm the `reviewer` subagent from Lab 021 is present and has valid frontmatter.

   ```bash
   grep -c '^---$' quips/.claude/agents/reviewer.md
   ```
   Expected: `2`

3. **Investigate** — read the subagent delegation docs to learn both routing paths.

   Open: https://docs.claude.com/en/docs/claude-code/sub-agents

   After reading, verify you can name both paths:
   ```bash
   echo "automatic (description-match) and explicit (Task tool)"
   ```
   Expected: `automatic (description-match) and explicit (Task tool)`

4. **Modify** — create the `test-writer` subagent definition.

   Create `quips/.claude/agents/test-writer.md` with this exact content:

   ```
   ---
   name: test-writer
   description: Draft Vitest tests for quips routes and functions
   tools: Read, Grep, Write
   model: sonnet
   ---
   Draft focused Vitest tests for the route or function you are given.
   Write tests to quips/test/. Do not touch quips/src/.
   Cover the happy path, missing required fields, and invalid input.
   Return the path to the file you wrote.
   ```

   Verify the frontmatter delimiters are present:
   ```bash
   grep -c '^---$' quips/.claude/agents/test-writer.md
   ```
   Expected: `2`

   Verify the four required frontmatter keys are present:
   ```bash
   grep -E '^(name|description|tools|model):' quips/.claude/agents/test-writer.md | wc -l | tr -d ' '
   ```
   Expected: `4`

5. **Make** — run a coordinated delegation session. Start a new `claude` session inside `quips/` and issue this prompt:

   > Use test-writer to draft tests for POST /quips edge cases, then use reviewer to critique the draft. Paste both outputs into quips/.claude/delegation-log.md.

   After Claude finishes, verify the log was created and references both subagents:
   ```bash
   [[ -s quips/.claude/delegation-log.md ]] && grep -qi 'test-writer' quips/.claude/delegation-log.md && grep -qi 'reviewer' quips/.claude/delegation-log.md && echo "ok" || echo "missing or empty"
   ```
   Expected: `ok`

## Observe

One paragraph in your own words: did Claude route to `test-writer` automatically or did it need an explicit prompt? When you look at the transcript, what do the Task tool blocks tell you about the context that was passed to each subagent? No answer key -- this is metacognition practice.

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude never routes to test-writer automatically | description was too generic | Rewrite description with an action verb and a noun, such as "Draft Vitest tests for quips routes and functions" | https://docs.claude.com/en/docs/claude-code/sub-agents |
| test-writer writes files to quips/src/ instead of quips/test/ | the system prompt body did not restrict the write path | Add "Do not touch quips/src/." to the system prompt body | https://docs.claude.com/en/docs/claude-code/settings |
| Reviewer and test-writer contradict each other with no resolution | no orchestrator is synthesizing their outputs | Prompt the main agent to sequence them explicitly: draft first, then review, then summarise conflicts | https://docs.claude.com/en/docs/claude-code/sub-agents |

## Tasks

Click the checkbox next to each task to mark it done -- your progress is saved locally.

### Task 1 — Write the test-writer frontmatter from scratch

**Scenario:** You deleted `test-writer.md` accidentally and need to recreate it from memory, including all four required frontmatter keys.

**Hint:** The four keys are `name`, `description`, `tools`, and `model`. The tools list must not include `Edit` or `Bash`.

??? success "Solution"

    ```
    ---
    name: test-writer
    description: Draft Vitest tests for quips routes and functions
    tools: Read, Grep, Write
    model: sonnet
    ---
    Draft focused Vitest tests for the route or function you are given.
    Write tests to quips/test/. Do not touch quips/src/.
    Cover the happy path, missing required fields, and invalid input.
    Return the path to the file you wrote.
    ```

### Task 2 — Orchestrate the two-agent chain

**Scenario:** You want the main agent to draft tests and then critique them without you doing either step yourself.

**Hint:** Use a single prompt that names both subagents and specifies the order: draft first, then review.

??? success "Solution"

    Inside a `claude` session in `quips/`:

    ```
    Use test-writer to draft tests for the GET /quips route.
    Then use reviewer to critique the draft for coverage and correctness.
    Write both outputs to quips/.claude/delegation-log.md.
    ```

### Task 3 — Observe the hand-off in the transcript

**Scenario:** You want to confirm that both subagents ran and that the context passed between them was correct.

**Hint:** Look for the Task tool use blocks in the session transcript. Each block names the subagent and shows the prompt sent to it.

??? success "Solution"

    In the transcript, find the two Task blocks:

    ```
    Task(subagent="test-writer", prompt="Draft tests for GET /quips ...")
    Task(subagent="reviewer",   prompt="Critique the following test draft: ...")
    ```

    If the reviewer's prompt contains the test-writer's output, the hand-off was clean. If the reviewer received an empty or generic prompt, the orchestrator did not pass context correctly -- rewrite the main prompt to include "pass the draft to reviewer".

### Task 4 — Intentionally misroute a task and correct it

**Scenario:** You ask the reviewer to write new tests (a task it should not handle), observe what goes wrong, then reroute to test-writer.

**Hint:** The reviewer's tool list does not include Write, so it cannot create files. Watch for the error and then issue a corrected prompt.

??? success "Solution"

    First, issue the wrong prompt:

    ```
    Use reviewer to write new tests for DELETE /quips/:id.
    ```

    The reviewer will either refuse (because `Write` is not in its tool list) or return a plan without creating any file. Note the failure mode.

    Then correct it:

    ```
    Use test-writer to write new tests for DELETE /quips/:id.
    Then use reviewer to check them.
    ```

    This is the correct routing: test-writer creates, reviewer reads.

### Task 5 — Write delegation-log.md documenting the cycle

**Scenario:** You want a written record of the full delegation cycle -- which subagent was used, what it was asked, and what it returned -- so a teammate can audit the session later.

**Hint:** The log should have a section for each subagent call. Include the prompt sent, the output received, and a one-line assessment.

??? success "Solution"

    Create or append to `quips/.claude/delegation-log.md`:

    ```markdown
    # Delegation Log

    ## Run 1 — POST /quips edge-case tests

    ### test-writer
    - **Prompt sent**: Draft Vitest tests for POST /quips edge cases
    - **Output**: quips/test/post-quips.test.ts (created)
    - **Assessment**: covered happy path and missing-body case; skipped auth error

    ### reviewer
    - **Prompt sent**: Critique the test draft in quips/test/post-quips.test.ts
    - **Output**: PASS x2, WARN x1 (no auth-error test), FAIL x0
    - **Assessment**: useful critique; auth-error test should be added next
    ```

### Task 6 — Compare solo-run vs delegated-run quality

**Scenario:** You want to know whether the two-agent chain produces better tests than asking the main agent directly in a single prompt.

**Hint:** Run the same request twice: once as "write tests for POST /quips edge cases" (solo) and once with the chain (test-writer then reviewer). Compare line count, scenario coverage, and assertion variety.

??? success "Solution"

    Solo run (single prompt to main agent):

    ```
    Write Vitest tests for POST /quips edge cases and save to quips/test/post-quips-solo.test.ts
    ```

    Delegated run (chain):

    ```
    Use test-writer to draft tests for POST /quips edge cases, saving to quips/test/post-quips-delegated.test.ts.
    Then use reviewer to critique the draft.
    ```

    Compare the two files:

    ```bash
    wc -l quips/test/post-quips-solo.test.ts quips/test/post-quips-delegated.test.ts
    ```

    Add a short note to `delegation-log.md` on which version had more distinct `it(...)` blocks and whether the reviewer's feedback changed any assertions.

## Quiz

<div class="ccg-quiz" data-lab="022">
  <div class="ccg-q" data-answer="b">
    <p><strong>Q1.</strong> When is it most appropriate to delegate a task to a subagent rather than handling it in the main agent session?</p>
    <label><input type="radio" name="022-q1" value="a"> A. Whenever the task involves more than one file</label>
    <label><input type="radio" name="022-q1" value="b"> B. When the task fits a well-defined specialist role and the subagent has a tighter, safer tool scope</label>
    <label><input type="radio" name="022-q1" value="c"> C. Always, because subagents are faster than the main agent</label>
    <label><input type="radio" name="022-q1" value="d"> D. Only when the main agent runs out of context</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Delegation pays off when the specialist has a scoped tool list (safer) and the task is unambiguous. Delegating simple tasks adds latency without quality gain; always-delegate is not a sound policy.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q2.</strong> In the main-agent-as-orchestrator pattern, which agent is responsible for sequencing specialist calls and synthesizing their outputs?</p>
    <label><input type="radio" name="022-q2" value="a"> A. The first subagent that runs</label>
    <label><input type="radio" name="022-q2" value="b"> B. A dedicated coordinator subagent</label>
    <label><input type="radio" name="022-q2" value="c"> C. The main agent (the session you talk to directly)</label>
    <label><input type="radio" name="022-q2" value="d"> D. Subagents coordinate automatically via shared memory</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Subagents are isolated -- they receive a prompt and return a result. The main agent owns sequencing, context passing, and synthesis. Subagents do not communicate with each other directly.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q3.</strong> You ask the reviewer subagent to write new test files, but it returns a plan without creating any files. What is the most likely cause?</p>
    <label><input type="radio" name="022-q3" value="a"> A. The reviewer's tool list does not include Write, so it cannot create files</label>
    <label><input type="radio" name="022-q3" value="b"> B. The reviewer model is too small to generate test code</label>
    <label><input type="radio" name="022-q3" value="c"> C. The description field is too long</label>
    <label><input type="radio" name="022-q3" value="d"> D. Claude requires a separate API call to switch subagents</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Each subagent can only use the tools listed in its frontmatter. The reviewer is defined with Read, Grep, Glob -- no Write. Routing a write task to it is a misroute; the fix is to send that task to test-writer instead.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q4.</strong> How do you confirm in the session transcript that a subagent hand-off actually occurred?</p>
    <label><input type="radio" name="022-q4" value="a"> A. The main agent prints "Subagent activated" in its response</label>
    <label><input type="radio" name="022-q4" value="b"> B. A new terminal window opens for each subagent</label>
    <label><input type="radio" name="022-q4" value="c"> C. The token count resets to zero at each delegation boundary</label>
    <label><input type="radio" name="022-q4" value="d"> D. The transcript shows a Task tool use block naming the subagent and the prompt sent to it</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">When the main agent delegates, it emits a Task tool use block. That block includes the subagent name and the exact prompt sent to it, making the hand-off visible and auditable in the transcript.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Add a third subagent `quips/.claude/agents/reviser.md` with tools `Read, Write` and a system prompt that reads `delegation-log.md`, extracts the reviewer's WARN items, and applies fixes to the test file. Prompt Claude to run all three in sequence: test-writer drafts, reviewer critiques, reviser applies the feedback. Check whether the final test file addresses all WARN items from the review.

## Recall

Lab 017 introduced session rescue moves. One command resets Claude's understanding of the task without touching any files on disk. Which command is it, and when should you prefer it over `git reset --hard HEAD`?

> Expected: `/clear` drops session context without touching disk; prefer it when no files were written and you only need to reset Claude's working understanding of the current task. Use `git reset --hard HEAD` when files were written and you want to discard those changes.

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/settings

## Next

→ **Lab 023 — Hooks** — attach pre- and post-tool hooks to automate checks that run on every Claude action without manual prompting.
