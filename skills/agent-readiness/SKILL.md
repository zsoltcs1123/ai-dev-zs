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

1. **Orientation** — README, AGENTS.md or equivalent, top-level directory structure, package manager config (detect tech stack and project type)
2. **Information surface** — docs/ hierarchy, specs, ADRs, agent instruction files, conventions, principles
3. **Feedback surface** — pre-commit config, linter/formatter configs, type checking, test infrastructure (framework, count, ratio), CI/CD config (triggers, gates), e2e setup, observability
4. **Constraint surface** — architectural enforcement tools, SAST config, dependency automation, security scanning, advisory-to-executable ratio

For monorepos: distinguish repo-wide from app-scoped indicators.

## Phase 2: Assess

Map exploration findings to the maturity model from [references/framework.md](references/framework.md).

For each surface:

1. Assign a maturity level (Baseline, Functional, Standardized, Autonomous)
2. Use transition notation when between levels (e.g., "Baseline → Functional")
3. List **What's in place** — specific findings with evidence (tool names, file paths, config details, counts)
4. List **Gaps** — specific missing items and their implications

Be specific. Not "tests exist" but "33 test files: 12 unit, 21 integration, ~4,700 lines against ~3,800 lines of app code (>1:1 ratio)." Not "no SAST" but "only detect-secrets is configured; no injection or vulnerability scanning (Bandit, CodeQL, Semgrep, etc.)."

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

## Progress Bars

Use these exact bars in the Maturity Summary and After All Three Waves sections:

| Level                     | Bar              |
| ------------------------- | ---------------- |
| Baseline                  | `████░░░░░░░░░░` |
| Functional                | `██████░░░░░░░░` |
| Functional → Standardized | `████████░░░░░░` |
| Standardized              | `████████████░░` |
| Autonomous                | `██████████████` |

For transition levels (e.g., "Baseline → Functional"), use the bar of the lower level. Annotate the transition in the text label beside the bar.

## Output Template

Follow this structure exactly:

~~~markdown
# [Project Name] — Agent Readiness Assessment

[One-line description: what's being assessed, against what framework.]

Context: [Tech stack / team size / project state — inferred from exploration.]

---

## Current State

### 1. Information Surface — [Maturity Level]

**What's in place:**

- [Specific finding with evidence]
- ...

**Gaps:**

- [Specific gap with implication]
- ...

### 2. Feedback Surface — [Maturity Level]

**What's in place:**

- ...

**Gaps:**

- ...

### 3. Constraint Surface — [Maturity Level]

**What's in place:**

- ...

**Gaps:**

- ...

---

## Maturity Summary

```
Information [bar] [Level]
Feedback    [bar] [Level]
Constraints [bar] [Level]
```

[1-2 paragraph interpretation — what's strong, what's limiting agent effectiveness, where the biggest delta is.]

---

## Path to Three-Surface Coverage

Deliverables grouped by surface and ordered by impact. Each deliverable is scoped to be completable independently.

### [Surface] Surface

#### [ID]. [Title]

**What:** [one paragraph]

**Why:** [one paragraph]

**Scope:** [effort estimate]

[Repeat for each deliverable per surface]

---

## Recommended Sequencing

### Wave 1 — Fast wins ([timeframe])

| #   | Deliverable | Surface | Effort |
| --- | ----------- | ------- | ------ |
| ... | ...         | ...     | ...    |

[1-2 sentence summary of why these come first.]

### Wave 2 — Structural improvements ([timeframe])

| #   | Deliverable | Surface | Effort |
| --- | ----------- | ------- | ------ |

[1-2 sentence summary.]

### Wave 3 — Infrastructure for scale

| #   | Deliverable | Surface | Effort |
| --- | ----------- | ------- | ------ |

[1-2 sentence summary.]

---

## After All Three Waves

```
Information [projected bar] [Projected Level]
Feedback    [projected bar] [Projected Level]
Constraints [projected bar] [Projected Level]
```

[Remaining gaps to full Autonomous — what's left and why it's acceptable for now.]
~~~

## Quality Checklist

Before outputting the report, verify:

- [ ] Every "What's in place" item cites specific evidence (file names, config flags, counts)
- [ ] Every "Gap" item names what's missing and why it matters for agents
- [ ] Maturity levels are consistent with the framework definitions
- [ ] Progress bars match assigned maturity levels
- [ ] Deliverables reference specific gaps from the assessment (not generic advice)
- [ ] Wave sequencing puts config-only changes first, implementation work second
- [ ] The "After All Three Waves" section shows realistic projected levels, not automatic full Autonomous
- [ ] Report reads as specific to THIS repo, not a generic template
