---
hide:
  - toc
---

# About ClaudeCodeLabs

## Why this exists

Most AI coding tutorials stop at "look at this cool autocomplete." ClaudeCodeLabs goes further: every lab ends with working code, a saved artifact, or a PR — checked into a real repo, graded by a real verify script. The curriculum is grounded in Anthropic's official documentation so it stays accurate as Claude Code evolves.

## What each lab gives you

Every lab is the same shape, so you never waste energy parsing structure:

- **Overview** — three bullets of what you'll learn, build, and practice
- **Walkthrough** — the teaching section (read here, practice below)
- **PRIMM steps** — Predict, Run, Investigate, Modify, Make; each with a verify command
- **Tasks** — five to eight scenario drills with hints and collapsible solutions
- **Quiz** — four multiple-choice questions with instant feedback (answers persist locally in your browser)
- **Recall** — one question about a lab 5+ steps back, to keep the thread alive

The tasks and quiz progress you make survives browser refreshes — there's a small client-side tracker (localStorage) so you can come back tomorrow and pick up where you left off.

## Design principles

- **Relentless** — one clear goal, one deliverable, one verify command per lab. No busywork.
- **Cohesive** — every lab builds on the same Quips project, so context accumulates.
- **Continuous** — each lab's ending sets up the next. No gaps, no concept jumps.
- **Uniform** — fourteen sections, same order, every time. Predictable is fast.

## Prerequisites

- Node 20+, Git, a GitHub account
- Claude Code CLI (`npm i -g @anthropic-ai/claude-code`)
- Claude Pro/Max plan **or** an `ANTHROPIC_API_KEY`
- macOS, Linux, or Windows via WSL2

## Quick links

| Resource | Link |
|---|---|
| Claude Code docs | [docs.claude.com/en/docs/claude-code](https://docs.claude.com/en/docs/claude-code/overview) |
| Claude Code GitHub | [github.com/anthropics/claude-code](https://github.com/anthropics/claude-code) |
| This repository | [github.com/hemzaz/CCLabs](https://github.com/hemzaz/CCLabs) |

Start with [Lab 001 — Install and Auth](001-InstallAuth/README.md).
