---
name: agent-readiness
description: >
  Explores a repository and produces an Agent Readiness assessment against the
  Three Surfaces framework (Information, Feedback, Constraints). Evaluates current
  maturity per surface, identifies gaps, and recommends a sequenced improvement path.
  Use when asked to assess agent readiness, evaluate a codebase for AI agents, or
  produce a three-surfaces report.
---

# Agent Readiness Assessment

Output to chat. Save to file only when the user requests it.

## Prerequisites

Before starting, read these reference files:

1. [references/framework.md](references/framework.md) — the Three Surfaces framework, maturity model, and key concepts
2. [references/exploration-checklist.md](references/exploration-checklist.md) — what to look for in a repo, per surface

## Phase 1: Explore

Systematically explore the repository. Use subagents or parallel tool calls to cover all three surfaces efficiently.

**Do not ask the user what's in the repo — find out yourself.** Read configs, count files, check directory structures, scan for patterns. If you cannot determine team size or project stage from repo artifacts alone, ask the user (max 1-2 questions).

Follow the exploration checklist. For each indicator, record:

- Whether it's present (with specifics: tool names, config flags, file counts, line counts)
- Whether it's absent (note what's missing and what the gap implies)

**Exploration order:**

1. **Orientation** — README, AGENTS.md or equivalent, top-level directory structure, package manager config (detect tech stack and project type). Determine skip logic (library vs. service, monorepo vs. single-app).
2. **Information surface** — docs/ hierarchy, specs, ADRs, agent instruction files, conventions, principles, task discovery (issues/PRs), product analytics
3. **Feedback surface** — pre-commit config, linter/formatter configs, type checking, test infrastructure (framework, count, ratio), CI/CD config (triggers, gates), e2e setup, observability, build & release system
4. **Constraint surface** — architectural enforcement tools, SAST config, dependency automation, security scanning, secrets management, advisory-to-executable ratio

For monorepos: distinguish repo-wide from app-scoped indicators.

## Phase 2: Assess

Map exploration findings to the maturity model from [references/framework.md](references/framework.md).

For each surface:

1. Assign a maturity level (Baseline, Functional, Standardized, Autonomous)
2. Use transition notation when between levels (e.g., "Baseline → Functional")
3. Write a 2-3 sentence **Overview** interpreting the findings — what's strong, what's weak, what it means for agent effectiveness
4. Fill in the **Sub-check table** with pass/fail/skip status and one-line evidence for each sub-check from the exploration checklist
5. Compute **pillar scores** (pass count / applicable count) for the Scorecard using the [Scorecard Pillar Mapping](references/exploration-checklist.md#scorecard-pillar-mapping) in the exploration checklist

Be specific in sub-check evidence. Not "tests exist" but "33 test files, ~4,700 lines against ~3,800 lines of app code." Not "no SAST" but "only detect-secrets configured; no CodeQL, Bandit, or Semgrep."

## Phase 3: Recommend

Generate a sequenced improvement path. Group deliverables by surface, order by impact.

Each deliverable gets:

- **ID**: surface initial + number (F1, C2, I3, etc.)
- **Title**: short descriptive name
- **What**: one paragraph — what to do, concretely
- **Why**: one paragraph — why this matters for agent effectiveness, referencing specific gaps found
- **Scope**: effort estimate (minutes / hours / half day / 1 day / 1-2 days)

Then sequence deliverables into waves:

- **Wave 1 — Fast wins**: config changes, one-line fixes, things that activate existing infrastructure
- **Wave 2 — Structural improvements**: bounded implementation work (days, not weeks)
- **Wave 3 — Infrastructure for scale**: matters when agent throughput increases

## Output Template

Follow the output template in [references/output-template.md](references/output-template.md) exactly, including the progress bars defined there. Before outputting, verify against the quality checklist at the end of that file.
