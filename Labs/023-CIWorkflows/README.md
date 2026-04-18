# Lab 023 - CI/CD Workflows with Copilot

!!! hint "Overview"

    - GitHub Copilot can generate, optimize, and debug GitHub Actions workflows and other CI/CD configurations.
    - In this lab, you will build production-ready pipelines covering build, test, lint, security scanning, and deployment steps.
    - You will use Copilot to explain complex YAML syntax, fix broken workflows, and add matrix strategies for multi-environment testing.
    - By the end of this lab, you will be able to use Copilot to create and maintain reliable CI/CD workflows with confidence.

## Prerequisites

- Completed [Lab 022 - Docker and Containers](../022-DockerAndContainers/README.md)

## What You Will Learn

- How to generate GitHub Actions workflows from requirements
- How to debug failing CI runs using terminal context
- How to optimize pipeline performance (caching, parallelism)
- How to generate security scanning and deployment workflows

---

## Lab Steps

## Step 1 - Generate a CI Workflow

```
Create a GitHub Actions CI workflow for a Node.js/TypeScript project that:
- Triggers on push to main and on all pull requests
- Uses a matrix strategy to test on Node.js 18, 20, and 22
- Runs: lint, type-check, unit tests, integration tests
- Caches node_modules using actions/cache
- Uploads test coverage to Codecov
- Fails fast if lint fails (no need to run tests)
```

## Step 2 - Generate a Docker Build & Push Workflow

```
Create a GitHub Actions workflow to:
- Build a multi-platform Docker image (linux/amd64, linux/arm64) using buildx
- Cache Docker layers using GitHub Actions cache
- Push to both GitHub Container Registry (ghcr.io) and Docker Hub
- Tag with: latest, git SHA, and semantic version (from git tag)
- Only push on main branch pushes, not PRs
- Sign the image with Cosign for supply chain security
```

## Step 3 - Debug a Failing Workflow

Paste the Actions log into Copilot Chat:

```
This GitHub Actions job is failing. Here's the log:

Run npm test
  npm test
  shell: /usr/bin/bash -e {0}
Error: Cannot find module '@/utils/logger'
    at Function.Module._resolveFilename (node:internal/modules/cjs/loader:1039:15)

What's wrong and how do I fix the workflow or the code?
```

## Step 4 - Generate a Complete CD Pipeline

```
Create a GitHub Actions deployment pipeline for a Node.js app to AWS ECS:

Stages:
1. test: Run full test suite
2. build: Build and push Docker image to ECR
3. deploy-staging: Deploy to staging ECS cluster (auto, on main branch)
4. integration-test: Run smoke tests against staging
5. deploy-prod: Deploy to production (requires manual approval)
6. notify: Send Slack notification with deployment status

Include:
- Environment secrets for AWS credentials
- Rollback step on production failure
- Deployment protection rules
```

## Step 5 - Optimize Pipeline Performance

```
#file:.github/workflows/ci.yml

This CI pipeline takes 18 minutes to complete.
Analyze it and suggest optimizations:
- What can be parallelized?
- What caching is missing?
- Are there unnecessary sequential steps?
- Can we use composite actions to reduce duplication?
```

## Step 6 - Add Security Scanning

```
Add security scanning to our CI pipeline:
1. Dependency vulnerability scanning with npm audit
2. SAST (Static Application Security Testing) with CodeQL
3. Container image scanning with Trivy
4. Secret scanning to catch accidentally committed credentials
5. SBOM (Software Bill of Materials) generation

Format as a reusable workflow that other repos can reference.
```

## Step 7 - Create a Release Workflow

```
Create a GitHub Actions release workflow triggered by pushing a version tag (v*.*.*):
1. Run full test suite
2. Build production Docker image
3. Create GitHub Release with auto-generated changelog
4. Publish npm package (if applicable)
5. Deploy to production
6. Create a Jira release and transition tickets to "Released"
```

---

## GitHub Actions Patterns Reference

| Pattern             | Use Case                            |
| :------------------ | :---------------------------------- |
| `paths:` filter     | Only run when specific files change |
| `concurrency:`      | Cancel in-progress runs on new push |
| `needs:`            | Define job dependencies             |
| `matrix:`           | Test across multiple versions/OS    |
| `reusable-workflow` | Share workflows across repositories |
| `environment:`      | Add approval gates for production   |
| `GITHUB_TOKEN`      | Built-in token for repo operations  |

---

## Summary

Copilot can generate complex CI/CD pipelines from plain-English requirements, debug cryptic failure logs, and help optimize pipeline execution time - making DevOps accessible to the entire team.

## Next Steps

Continue with [Lab 024 - Regex and Parsing](../024-RegexAndParsing/README.md)

---

## Tasks

## Task 01 - Generate a CI Workflow

**Scenario:** Create a GitHub Actions CI workflow that runs tests on multiple Node.js versions.

**Hint:** Describe the triggers, matrix, and steps.

??? success "Solution"

    `     Create a GitHub Actions CI workflow for a Node.js project:
    - Triggers: push to main, all PRs
    - Matrix: Node.js 18, 20, 22
    - Steps: lint, type-check, unit tests, integration tests
    - Cache node_modules with actions/cache
    - Upload coverage to Codecov
    `

---

## Task 02 - Generate a Docker Build and Push Workflow

**Scenario:** Build a multi-platform Docker image and push to GitHub Container Registry.

**Hint:** Describe platforms, registry targets, and tagging strategy.

??? success "Solution"

    `     Create a GitHub Actions workflow to:
    - Build for linux/amd64 and linux/arm64 using buildx
    - Push to ghcr.io
    - Tag with: latest, git SHA, semver tag (v*.*.*)
    - Only push on main branch (not PRs)
    - Cache Docker layers
    `

---

## Task 03 - Debug a Failing Workflow

**Scenario:** A workflow job fails with a module-not-found error. Diagnose with Copilot.

**Hint:** Paste the Actions log output into Chat.

??? success "Solution"

    ```
    This GitHub Actions job is failing. What's wrong and how do I fix it?

    Error: Cannot find module '@/utils/logger'
    Require stack: - /home/runner/work/app/src/server.ts
    ```

---

## Task 04 - Generate a Full CD Pipeline

**Scenario:** Create a pipeline with staging, integration tests, and a manual production gate.

**Hint:** Describe each stage and its trigger/approval.

??? success "Solution"

    `     Create a GitHub Actions deployment pipeline with stages:
    1. test: full test suite
    2. build: Docker image to ECR
    3. deploy-staging: auto-deploy to staging (on main push)
    4. integration-test: smoke tests against staging
    5. deploy-prod: manual approval required
    6. notify: Slack notification on success/failure
    `

---

## Task 05 - Optimize a Slow Pipeline

**Scenario:** Your CI takes 18 minutes. Find what can be parallelized or cached.

**Hint:** Reference the workflow file and ask for optimization suggestions.

??? success "Solution"

    ```
    #file:.github/workflows/ci.yml

    This pipeline takes 18 minutes. Suggest optimizations:
    - What can be parallelized?
    - What caching is missing?
    - Are there unnecessary sequential steps?
    - Can we use composite actions to reduce duplication?
    ```

---

## Task 06 - Add Security Scanning

**Scenario:** Add vulnerability scanning for code, dependencies, and container images.

**Hint:** Ask for CodeQL, npm audit, Trivy, and secret scanning as separate jobs.

??? success "Solution"

    `     Add a security scanning workflow with these jobs:
    1. CodeQL SAST analysis (JavaScript/TypeScript)
    2. npm audit for dependency vulnerabilities
    3. Trivy container image scan
    4. Secret scanning with trufflesecurity/trufflehog
    Make it a reusable workflow other repos can reference.
    `
