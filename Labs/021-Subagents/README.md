# Lab 021 — Subagents

⏱ **20 min**   📦 **You'll add**: `quips/.claude/agents/reviewer.md`   🔗 **Builds on**: Checkpoint D   🎯 **Success**: `verify.sh` exits 0 and Claude names `reviewer` when asked to list subagents

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
    - You will learn what a subagent is: a scoped expert with its own system prompt, tool allowlist, and model choice.
    - You will study the four YAML frontmatter keys that every subagent file must declare.
    - You will write a read-only `reviewer` subagent for the Quips project and verify Claude routes to it.
    - You will see how a vague description breaks routing and how pinning `model: haiku` reduces cost.
    - By the end you will have two subagents registered in `quips/.claude/agents/` and understand when to split work into a subagent versus keeping it inline.

**Concept**: `Subagent with YAML frontmatter and model routing` (Bloom: Create)

---

## Prerequisites

- Lab 020 (or Checkpoint D) complete — `quips/` directory exists with at least one source file and a passing test suite
- Claude Code installed and authenticated (`claude --version` prints a semver)
- Familiarity with YAML front-matter (the `---` delimited block used by many static-site generators)

## What You Will Learn

- What a subagent is and how it differs from an inline tool call
- The four required YAML frontmatter keys: `name`, `description`, `tools`, `model`
- Why restricting the `tools` list to read-only tools is the correct default for a code-review agent
- How Claude's routing engine uses the `description` field to decide which subagent to invoke
- When splitting work into a subagent is worth the overhead versus keeping logic in the main conversation

## Why

Claude Code can delegate work to scoped sub-processes called subagents. Each subagent has its own system prompt, a restricted tool allowlist, and an explicit model choice. Delegation keeps the main conversation focused while giving the specialist exactly the access it needs — no more.

A code-review subagent, for example, only needs to read files; giving it write tools would be a mistake both for safety and for clarity of intent. This lab introduces Outcome O5 by having you write the first subagent in the Quips project: a `reviewer` that audits diffs for correctness and test coverage.

Subagents are defined as Markdown files in `.claude/agents/`. Claude discovers them automatically when it starts in a project directory, and it routes requests to them based on the `description` field — which means a precise, action-oriented description is not optional.

## Walkthrough

A subagent file is a Markdown document with a YAML front-matter block followed by a system prompt body. Claude loads every `.md` file it finds in `.claude/agents/` at startup and registers each one as a callable specialist.

The four frontmatter keys you must provide:

| Key | Type | Purpose |
|---|---|---|
| `name` | string | Identifier used when routing and when listing subagents |
| `description` | string | The routing signal — Claude matches this against the user's request |
| `tools` | comma-separated list | The only tools this subagent may call; anything not listed is denied |
| `model` | string | Which Claude model to use, e.g. `sonnet`, `haiku`, `opus` |

**When to split into a subagent versus keeping logic inline:**

Keep logic inline when the task is a one-off, when it needs the full context of the ongoing conversation, or when the extra latency of spawning a process would hurt more than it helps. Split into a subagent when the task is recurring, when it benefits from a focused system prompt that would clutter the main context, or when you want a different model or a tighter tool allowlist for safety.

The routing engine matches the user's message against each subagent's `description`. A vague description like "helps with code" will never win the match. An action-oriented description like "Review a Quips diff for correctness and test coverage" gives the router a precise signal. You will observe both outcomes in this lab.

## Check

```bash
./scripts/doctor.sh 021
```

Expected output: `OK lab 021 pre-flight green`

## Do

Follow PRIMM (Predict → Run → Investigate → Modify → Make). Each step ends with a verify command.

1. **Predict** — before writing anything, list the three tools a code-review subagent actually needs. Justify each in one sentence. A reviewer reads source files, searches for patterns, and lists matching paths — it does not run commands or write files.

   Verify by printing the three tool names:

   ```bash
   echo "Read  Grep  Glob"
   ```

   Expected: `Read  Grep  Glob`

2. **Run** — read the official subagents reference before writing any file.

   Open: https://docs.claude.com/en/docs/claude-code/sub-agents

   Then confirm the `.claude/agents/` directory exists (or create it):

   ```bash
   [[ -d quips/.claude/agents ]] && echo "dir present" || (mkdir -p quips/.claude/agents && echo "created")
   ```

   Expected: `dir present` or `created`

3. **Investigate** — examine any existing subagent file on your machine to confirm the frontmatter shape:

   ```bash
   cat ~/.claude/agents/*.md 2>/dev/null | head -40
   ```

   Name the four frontmatter fields before continuing. They are: `name`, `description`, `tools`, `model`.

   Verify you can identify them:

   ```bash
   echo "name  description  tools  model"
   ```

   Expected: `name  description  tools  model`

4. **Modify** — create `quips/.claude/agents/reviewer.md` with the frontmatter block below and a 3–5 line system prompt body.

   Frontmatter:

   ```
   ---
   name: reviewer
   description: Review Quips diffs for correctness and test coverage
   tools: Read, Grep, Glob
   model: sonnet
   ---
   ```

   System prompt body (write this after the closing `---`):

   ```
   You are a code reviewer for the Quips project.
   Check every diff for correctness: logic errors, missing null checks, and broken contracts.
   Verify that new behaviour is covered by tests in quips/test/.
   Flag any function or variable name that does not match the existing naming style.
   Report findings as a numbered list; mark each item PASS, WARN, or FAIL.
   ```

   Verify the frontmatter delimiters and keys are present:

   ```bash
   grep -c '^---$' quips/.claude/agents/reviewer.md
   ```

   Expected: `2`

   ```bash
   grep -E '^(name|description|tools|model):' quips/.claude/agents/reviewer.md | wc -l | tr -d ' '
   ```

   Expected: `4`

5. **Make** — launch Claude inside the Quips project and confirm the subagent is registered:

   ```bash
   cd quips && claude
   ```

   Inside the REPL type:

   > List the available subagents

   Claude should name `reviewer` in its response.

   Verify:

   ```bash
   echo "confirm Claude's answer includes 'reviewer'"
   ```

## Observe

One sentence — why does restricting the `tools` list to `Read, Grep, Glob` make the reviewer subagent safer than giving it full tool access?

## If stuck

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Claude does not see the new subagent | Claude was already running when the file was created | Exit and re-launch `claude` in the same directory | https://docs.claude.com/en/docs/claude-code/sub-agents |
| Frontmatter tools list includes Bash | reviewer should be read-only | Restrict `tools:` to `Read, Grep, Glob` — remove all write and execute tools | https://docs.claude.com/en/docs/claude-code/sub-agents |
| Subagent never gets invoked | Claude did not route to it because the description was vague | Make the description action-specific: "Review a diff for correctness and test coverage" | https://docs.claude.com/en/docs/claude-code/sub-agents |

## Tasks

Click the checkbox next to each task to mark it done — your progress is saved locally.

### Task 1 — Write reviewer.md with correct frontmatter

**Scenario:** You are setting up the Quips project's first subagent. Create `quips/.claude/agents/reviewer.md` with all four required frontmatter keys and a 3–5 line system prompt body.

**Hint:** The body goes after the closing `---`. It should tell the reviewer what project it works on, what to look for, and how to format its output.

??? success "Solution"

    ```bash
    mkdir -p quips/.claude/agents
    cat > quips/.claude/agents/reviewer.md << 'EOF'
    ---
    name: reviewer
    description: Review Quips diffs for correctness and test coverage
    tools: Read, Grep, Glob
    model: sonnet
    ---
    You are a code reviewer for the Quips project.
    Check every diff for correctness: logic errors, missing null checks, and broken contracts.
    Verify that new behaviour is covered by tests in quips/test/.
    Flag any function or variable name that does not match the existing naming style.
    Report findings as a numbered list; mark each item PASS, WARN, or FAIL.
    EOF
    grep -c '^---$' quips/.claude/agents/reviewer.md
    # Expected: 2
    ```

### Task 2 — Restrict reviewer to read-only tools

**Scenario:** A teammate accidentally added `Bash` to the reviewer's tools list. Fix the `tools:` value so the agent can only read, search, and list files.

**Hint:** The three read-only tools are `Read`, `Grep`, and `Glob`. Remove any tool that can write, execute, or modify state.

??? success "Solution"

    ```bash
    # Open quips/.claude/agents/reviewer.md and ensure the tools line reads:
    grep '^tools:' quips/.claude/agents/reviewer.md
    # Expected: tools: Read, Grep, Glob
    #
    # If it contains Bash or Edit, replace the line:
    sed -i '' 's/^tools:.*/tools: Read, Grep, Glob/' quips/.claude/agents/reviewer.md
    grep '^tools:' quips/.claude/agents/reviewer.md
    ```

### Task 3 — Test routing with a specific description

**Scenario:** Your `reviewer.md` has the precise description "Review Quips diffs for correctness and test coverage." Launch Claude inside the Quips project and ask it to review the diff. Observe that it delegates to the reviewer subagent.

**Hint:** Start Claude in the `quips/` directory so it can discover `.claude/agents/`. Then use a request that matches the description closely.

??? success "Solution"

    ```bash
    # Inside quips/, start Claude:
    # cd quips && claude
    #
    # In the REPL, type:
    #   review the diff between the last two commits
    #
    # Claude should respond by invoking the reviewer subagent.
    # You will see "Using reviewer" or similar delegation notice.
    echo "observe Claude's routing decision in the REPL"
    ```

### Task 4 — Observe routing failure with a vague description

**Scenario:** Change the `description` field to something generic — for example, "helps with code" — and ask Claude to review the diff again. Notice that routing fails or routes to the wrong agent.

**Hint:** A vague description gives the router no signal to prefer `reviewer` over inline handling.

??? success "Solution"

    ```bash
    # Edit quips/.claude/agents/reviewer.md:
    # Change: description: Review Quips diffs for correctness and test coverage
    # To:     description: helps with code
    #
    # Re-launch Claude and repeat the request. Claude will likely handle it inline.
    # Restore the precise description when done:
    sed -i '' 's/^description:.*/description: Review Quips diffs for correctness and test coverage/' \
      quips/.claude/agents/reviewer.md
    grep '^description:' quips/.claude/agents/reviewer.md
    ```

### Task 5 — Pin model: haiku for cost savings

**Scenario:** The reviewer runs frequently on every commit. Switch it to `model: haiku` to reduce cost while keeping the same system prompt and tool restrictions.

**Hint:** `haiku` is faster and cheaper than `sonnet`. For a read-only reviewer that produces structured output, it is usually sufficient.

??? success "Solution"

    ```bash
    sed -i '' 's/^model:.*/model: haiku/' quips/.claude/agents/reviewer.md
    grep '^model:' quips/.claude/agents/reviewer.md
    # Expected: model: haiku
    ```

### Task 6 — Add a second subagent with a different purpose

**Scenario:** The team wants an `explainer` agent that reads a single function and explains it in plain English. Create `quips/.claude/agents/explainer.md` with `model: haiku`, `tools: Read` only, and a 3-line body.

**Hint:** A narrower tool list (`Read` alone) reinforces that the explainer only needs to read one file at a time — no pattern searches required.

??? success "Solution"

    ```bash
    cat > quips/.claude/agents/explainer.md << 'EOF'
    ---
    name: explainer
    description: Explain a single Quips function in plain English for a new contributor
    tools: Read
    model: haiku
    ---
    You are a documentation helper for the Quips project.
    Read the function the user points to and explain what it does in 3–5 plain-English sentences.
    Avoid jargon; assume the reader is familiar with JavaScript but new to this codebase.
    EOF
    ls quips/.claude/agents/
    # Expected: explainer.md  reviewer.md
    ```

## Quiz

<div class="ccg-quiz" data-lab="021">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> Which of the following is a required frontmatter key in a Claude Code subagent file?</p>
    <label><input type="radio" name="021-q1" value="a"> **a.** <code>prompt</code></label>
    <label><input type="radio" name="021-q1" value="b"> **b.** <code>version</code></label>
    <label><input type="radio" name="021-q1" value="c"> **c.** <code>description</code></label>
    <label><input type="radio" name="021-q1" value="d"> **d.** <code>timeout</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">All four required keys are <code>name</code>, <code>description</code>, <code>tools</code>, and <code>model</code>. The <code>description</code> is especially critical because it is the signal Claude's routing engine uses to decide whether to invoke this subagent. Without it, the agent can never be selected.</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> Why should a code-review subagent be restricted to <code>Read, Grep, Glob</code> instead of full tool access?</p>
    <label><input type="radio" name="021-q2" value="a"> **a.** Read-only tools are faster than write tools</label>
    <label><input type="radio" name="021-q2" value="b"> **b.** A reviewer only needs to read files; write access could accidentally modify the codebase</label>
    <label><input type="radio" name="021-q2" value="c"> **c.** Claude ignores extra tools anyway</label>
    <label><input type="radio" name="021-q2" value="d"> **d.** The <code>tools</code> key only accepts three values</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Least-privilege is the principle: give a subagent only the tools it actually needs. A reviewer's job is to read and report — not to edit files, run commands, or create new content. Restricting to <code>Read, Grep, Glob</code> makes it impossible for the agent to accidentally mutate state even if something goes wrong.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q3.</strong> Your reviewer subagent is never invoked even though you ask Claude to "review the diff." What is the most likely cause?</p>
    <label><input type="radio" name="021-q2" value="a"> **a.** The <code>model</code> key is set to <code>haiku</code></label>
    <label><input type="radio" name="021-q2" value="b"> **b.** The subagent file is in the wrong directory</label>
    <label><input type="radio" name="021-q2" value="c"> **c.** The system prompt body is too short</label>
    <label><input type="radio" name="021-q2" value="d"> **d.** The <code>description</code> is too vague to match the request</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude's routing engine matches the user's request against each subagent's <code>description</code>. A vague description like "helps with code" produces a weak match score. An action-oriented description like "Review Quips diffs for correctness and test coverage" gives the router a strong, specific signal that wins the match.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> When is it better to keep logic inline in the main conversation rather than splitting it into a subagent?</p>
    <label><input type="radio" name="021-q4" value="a"> **a.** When the task is a one-off and benefits from the full conversation context</label>
    <label><input type="radio" name="021-q4" value="b"> **b.** When you want a different model for the task</label>
    <label><input type="radio" name="021-q4" value="c"> **c.** When the task is recurring and needs a focused system prompt</label>
    <label><input type="radio" name="021-q4" value="d"> **d.** When you need to restrict the tool allowlist for safety</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Subagents add overhead: a separate process, a scoped context, and a routing decision. That overhead pays off for recurring tasks with a focused purpose and a tighter tool allowlist. For one-off tasks that depend on the current conversation's context, inline handling is simpler and faster.</p>
  </div>
</div>

## Stretch (optional, ~10 min)

Compare the quality of haiku versus sonnet on the same reviewer task. With `model: haiku` in `reviewer.md`, ask Claude to review a recent diff. Note the output. Then switch to `model: sonnet`, repeat the request, and compare depth of analysis and tone. Save both outputs to files:

```bash
# haiku review
cd quips && claude -p "review the last git diff" > /tmp/review-haiku.txt
# change model: haiku → model: sonnet in reviewer.md, then:
claude -p "review the last git diff" > /tmp/review-sonnet.txt
diff /tmp/review-haiku.txt /tmp/review-sonnet.txt
```

## Recall

Lab 016 introduced the red-green-refactor loop. What is the correct order: write the test first, or write the implementation first?

> Expected: write the test first (red), then the implementation (green), then refactor

## References

<!-- Auto-rendered from sources.yml at mkdocs build time. Do not edit by hand. -->
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/overview

## Next

→ **Lab 022 — Subagent Delegation** — invoke the reviewer subagent explicitly and interpret its structured findings on a real Quips diff
