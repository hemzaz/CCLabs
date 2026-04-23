# ClaudeCodeLabs

30 hands-on labs + a Capstone + an optional Prompting Workshop, taking a fresher from zero to shipping with Claude Code. Every lab ends with a concrete artifact; every lab has scenario-driven tasks, a 4-question quiz, and a recall prompt. Your progress is tracked locally (points, streak, badges) via a lightweight in-browser tracker — no account, no server.

## Why Claude Code

Claude Code is an agentic CLI that runs directly in your terminal and executes multi-step
tasks autonomously. It is codebase-aware by default, reading your files, git history, and
project structure before acting. It is built and documented by Anthropic, so every lab in
this series tracks the authoritative source.

## Prerequisites

- Node 20+
- Git
- GitHub account
- Claude Code CLI: `npm i -g @anthropic-ai/claude-code`
- Claude Pro/Max plan OR `ANTHROPIC_API_KEY`
- macOS, Linux, or WSL2

## The Curriculum

The series is organized into six parts:

- **Part I — Orientation**: install, authenticate, and get your bearings
- **Part II — Working Loop**: edit, run, commit with Claude in the loop
- **Part III — Context & Memory**: CLAUDE.md, memory files, project knowledge
- **Part IV — Quality Gates**: tests, linting, CI triggered from the CLI
- **Part V — Autonomy & Orchestration**: agents, sub-agents, parallel tasks
- **Part VI — Shipping**: pull requests, releases, deployment pipelines

All 30 labs plus six checkpoints and the Capstone are live. An optional bonus — [Lab 031 — Prompting Workshop](Labs/031-PromptingWorkshop/README.md) — sits after the Capstone for deliberate practice on prompt patterns. Start at Lab 001 and advance with `./scripts/labs.sh next`. Full lab index: [Labs/index.md](Labs/index.md).

## Quips — the Spine Project

Quips is a small Express API that lives in `quips/` and grows with you across every lab.
Each lab adds one capability to Quips so you always have a real artifact to show for your work.

## Run Locally

Clone, install, and preview the site:

```bash
git clone https://github.com/hemzaz/CCLabs.git
cd CCLabs
pip install uv && uv pip install --system -r mkdocs/requirements.txt
make serve     # dev server with live reload at http://localhost:8000
# OR
make run       # build and preview the shippable artifact at http://localhost:8000
```

To work through the labs:

```bash
cd quips && npm ci && npm test
./scripts/labs.sh next
```

## Deploy

Production deploys run on push-to-main via GitHub Actions:

- **Vercel** — `.github/workflows/deploy-vercel.yml` (needs `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID` secrets)
- **Netlify** — `.github/workflows/deploy-netlify.yml` (needs `NETLIFY_AUTH_TOKEN`, `NETLIFY_SITE_ID` secrets)
- **GitHub Pages** — `.github/workflows/deploy-ghpages.yml`

### One-time secret setup (CI deploys)

After pushing, the CI workflows will fire automatically. They'll fail until you register the relevant secrets:

```bash
# Vercel — token at https://vercel.com/account/tokens
gh secret set VERCEL_TOKEN --body "<token>"
gh secret set VERCEL_ORG_ID --body "<org_id>"
gh secret set VERCEL_PROJECT_ID --body "<project_id>"

# Netlify — token at https://app.netlify.com/user/applications#personal-access-tokens
gh secret set NETLIFY_AUTH_TOKEN --body "<token>"
gh secret set NETLIFY_SITE_ID --body "<site_id>"

# Re-run a previously-failed deploy after registering its secrets
gh run list --workflow=deploy-vercel.yml --limit 1
gh run rerun <run-id>
```

To fetch Vercel IDs from a locally linked project: `cat .vercel/project.json`. For Netlify, `netlify status` shows the site ID.

### One-off preview deployments from your machine

```bash
npm i -g vercel && vercel login && make deploy-vercel
npm i -g netlify-cli && netlify login && make deploy-netlify
```

Both targets check the CLI is installed and print install hints if it isn't.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Forked From

Originally forked from [nirgeier/GithubCopilotLabs](https://github.com/nirgeier/GithubCopilotLabs) (Apache 2.0). See NOTICE for full attributions.

## License

Apache 2.0.
