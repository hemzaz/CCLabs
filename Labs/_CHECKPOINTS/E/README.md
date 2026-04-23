# Checkpoint E — End of Part V

⏱ 30 min · 📦 You'll add: end-to-end Quips review flow using subagents + hook + skill + MCP + reflection.md · 🔗 Integrates: Labs 021-025 · 🎯 Success: see verify.sh

---

### Part 1 — Quiz (5 min)

Answer from memory. Write your answers in `answers.md`, then compare against the key after Part 2.

1. **(Lab 021)** Which four frontmatter keys are required for a valid subagent definition file?
2. **(Lab 022)** What are the two ways to invoke a subagent — the automatic route and the explicit route?
3. **(Lab 023)** Which exit code from a PreToolUse hook script causes the tool call to be blocked?
4. **(Lab 024)** Where on disk is a project-scope skill stored (give the path relative to the project root)?
5. **(Lab 025)** What is the JSON key under which MCP servers are declared in Claude Code settings?

#### Interactive quiz

<div class="ccg-quiz" data-lab="checkpoint-e">
  <div class="ccg-q" data-answer="c">
    <p><strong>Q1.</strong> Which four frontmatter keys are required for a valid subagent definition file?</p>
    <label><input type="radio" name="checkpoint-e-q1" value="a"> A. <code>name</code>, <code>model</code>, <code>prompt</code>, <code>version</code></label>
    <label><input type="radio" name="checkpoint-e-q1" value="b"> B. <code>name</code>, <code>role</code>, <code>tools</code>, <code>temperature</code></label>
    <label><input type="radio" name="checkpoint-e-q1" value="c"> C. <code>name</code>, <code>description</code>, <code>tools</code>, <code>model</code></label>
    <label><input type="radio" name="checkpoint-e-q1" value="d"> D. <code>id</code>, <code>description</code>, <code>permissions</code>, <code>model</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">A valid subagent file requires exactly four frontmatter keys: <code>name</code> (identifier), <code>description</code> (used for auto-routing), <code>tools</code> (allowed tool list), and <code>model</code> (which Claude model to use).</p>
  </div>
  <div class="ccg-q" data-answer="b">
    <p><strong>Q2.</strong> What are the two ways to invoke a subagent?</p>
    <label><input type="radio" name="checkpoint-e-q2" value="a"> A. Via a slash command and via a CLI flag</label>
    <label><input type="radio" name="checkpoint-e-q2" value="b"> B. Auto-routing by description match, or explicit invocation via the Task tool</label>
    <label><input type="radio" name="checkpoint-e-q2" value="c"> C. By naming it in CLAUDE.md and by calling it from a hook script</label>
    <label><input type="radio" name="checkpoint-e-q2" value="d"> D. Via <code>/agent run</code> command and via a PreToolUse hook</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Claude can route a request to a subagent automatically when the task description matches the agent's <code>description</code> field, or you can invoke it explicitly using the Task tool with the agent's name.</p>
  </div>
  <div class="ccg-q" data-answer="c">
    <p><strong>Q3.</strong> Which exit code from a PreToolUse hook script causes the tool call to be blocked?</p>
    <label><input type="radio" name="checkpoint-e-q3" value="a"> A. Exit code 0</label>
    <label><input type="radio" name="checkpoint-e-q3" value="b"> B. Exit code 1</label>
    <label><input type="radio" name="checkpoint-e-q3" value="c"> C. Exit code 2 or higher</label>
    <label><input type="radio" name="checkpoint-e-q3" value="d"> D. Any non-zero exit code</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Exit code 2 (or higher) from a PreToolUse hook signals a hard block: Claude will not execute the tool call. Exit codes 0 and 1 both allow the tool to proceed.</p>
  </div>
  <div class="ccg-q" data-answer="a">
    <p><strong>Q4.</strong> Where on disk is a project-scope skill stored?</p>
    <label><input type="radio" name="checkpoint-e-q4" value="a"> A. <code>.claude/skills/&lt;skill-name&gt;/SKILL.md</code> inside the project root</label>
    <label><input type="radio" name="checkpoint-e-q4" value="b"> B. <code>~/.claude/skills/&lt;skill-name&gt;/SKILL.md</code> in the user's home directory</label>
    <label><input type="radio" name="checkpoint-e-q4" value="c"> C. <code>.claude/agents/&lt;skill-name&gt;.md</code> inside the project root</label>
    <label><input type="radio" name="checkpoint-e-q4" value="d"> D. <code>skills/&lt;skill-name&gt;.md</code> at the repo root</label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">Project-scope skills live at <code>.claude/skills/&lt;skill-name&gt;/SKILL.md</code> relative to the project root, making them available inside that project but not globally.</p>
  </div>
  <div class="ccg-q" data-answer="d">
    <p><strong>Q5.</strong> What is the JSON key under which MCP servers are declared in Claude Code settings?</p>
    <label><input type="radio" name="checkpoint-e-q5" value="a"> A. <code>servers</code></label>
    <label><input type="radio" name="checkpoint-e-q5" value="b"> B. <code>tools</code></label>
    <label><input type="radio" name="checkpoint-e-q5" value="c"> C. <code>plugins</code></label>
    <label><input type="radio" name="checkpoint-e-q5" value="d"> D. <code>mcpServers</code></label>
    <button class="ccg-check">Check answer</button>
    <p class="ccg-explain">MCP servers are declared under the <code>mcpServers</code> key in <code>.claude/settings.json</code>, where each entry maps a server name to its command and arguments.</p>
  </div>
</div>

---

### Part 2 — Integration task (20 min)

Wire all five Part V capabilities together inside the Quips project to produce an end-to-end review flow.

**Steps:**

1. **Enable the reviewer subagent (Lab 021).** Confirm `quips/.claude/agents/reviewer.md` exists with the required four frontmatter keys (`name`, `description`, `tools`, `model`). If it does not exist, create it now so it routes code-review requests automatically.

2. **Run the seed-db skill against a fresh Quips DB (Lab 024).** Invoke the skill:
   ```
   /seed-db
   ```
   inside the Quips project. The skill must populate at least 3 quips. Confirm the skill file lives at `quips/.claude/skills/seed-db/SKILL.md`.

3. **List src/ via the filesystem MCP server (Lab 025).** Confirm `quips/.claude/settings.json` declares a `mcpServers` entry for a filesystem server. Use the MCP server to list the contents of `quips/src/` and capture the output.

4. **Trigger the PreToolUse hook (Lab 023).** Confirm `quips/.claude/hooks/no-rm.sh` is executable. Attempt:
   ```bash
   rm -rf /tmp/quips-test-delete-me
   ```
   from within Claude Code and verify the hook blocks it (exit code 2 or higher). Note the exact error message printed to stderr.

5. **Capture outputs in `quips/.claude/integration-log.md`.** Append all four step outputs (subagent confirmation, seed-db result, MCP listing, hook block message) to `quips/.claude/integration-log.md`. The file must be **append-only** and reach **at least 15 lines** before you finish.

   > Tip: prefix each section with a timestamp comment so the log is auditable.

6. **Ask the reviewer subagent to review the log (Lab 022).** Use the explicit `Task` tool to delegate:
   > Review `quips/.claude/integration-log.md` for completeness. Confirm all four integration steps are represented.

   Note whether the subagent was invoked automatically by description matching or whether you had to call it explicitly.

Run the full suite to confirm nothing regressed:

```bash
cd quips && npm test
```

Expected: all tests pass.

---

### Part 3 — Self-debrief (5 min)

Write `Labs/_CHECKPOINTS/E/reflection.md` with at least 3 sentences covering:

- (i) Which tool — subagent, hook, skill, or MCP server — felt most natural to wire up and why.
- (ii) Which one you would NOT add to a brand-new project and your reasoning.
- (iii) One composition pattern that emerged from combining two or more of these tools in a single workflow.

Add one line at the end:

```
Quiz: X/5
```

Replace `X` with your actual score.

---

### References

- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/hooks

---

### Next — Lab 026 opens Part VI.
