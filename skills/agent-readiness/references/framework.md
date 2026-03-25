# Three Surfaces of Agent-Ready Engineering

## Dual Assessment Model

This framework uses two complementary lenses:

1. **Three Surfaces** (qualitative) — the organizing principle. Each surface answers a question about agent capability: Can it know? Can it verify? Can it be prevented from being wrong? Maturity levels (Baseline → Autonomous) are assigned per surface based on holistic judgment.
2. **Sub-check scorecard** (quantitative) — binary pass/fail checks derived from [Factory's Agent Readiness criteria](https://factory.ai/news/agent-readiness), mapped into the Three Surfaces structure. Produces per-pillar scores and an overall percentage.

The surfaces tell you *what matters and why*. The scorecard tells you *exactly what's present and what's missing*. Neither replaces the other.

## Core Thesis

Agent performance is a function of the environment, not the model. A weaker model in a well-surfaced environment outperforms a stronger model in a poorly-surfaced one. Most teams try to improve agent output by switching models or tools — the leverage is in the surfaces: make more things knowable, verifiable, and enforceable.

## The Three Surfaces

An agent operates within an environment that has three surfaces. Gaps in any surface produce the "80% problem" — output that's almost right but not quite, requiring expensive human correction.

### 1. Information Surface — *Can the agent know what it needs to know?*

Everything the agent needs must be in the repo, structured for progressive disclosure, and machine-parseable. If it lives in Slack, someone's head, or a Google Doc, it doesn't exist.

Components:
- Short entrypoint (AGENTS.md) pointing to a structured knowledge base — not an encyclopedia, a table of contents
- Specs with acceptance criteria, constraints, and decomposition
- Decision records (ADRs), not just decisions
- Context documents encoding team values, tradeoff hierarchies, and escalation triggers
- Deterministic file placement and naming — the repo as a queryable database

### 2. Feedback Surface — *Can the agent tell if it's right?*

The agent must self-validate without waiting for a human. Every feedback mechanism added removes a human bottleneck from the loop.

Components:
- Fast local linters and formatters (seconds, not CI minutes)
- Unit / integration / e2e tests the agent can run locally
- App bootable per worktree for runtime validation
- Observability the agent can query (logs, metrics, traces)
- External behavioral scenarios — holdout sets the agent can't overfit to

### 3. Constraint Surface — *Can the agent be prevented from being wrong?*

Advisory docs drift. Executable constraints don't. Every observed anti-pattern should become a machine-enforced rule.

Components:
- Architectural boundaries enforced via linters (not comments or conventions)
- Dependency direction rules
- Pre-commit hooks on the hot path
- Security scanning, type checking
- The drift cycle: observe → codify rule → remediate at scale → prevent regression

## Maturity Model

Four levels. Each row requires solid foundations in the rows above it.

### Baseline

| Surface | What it looks like |
|---------|-------------------|
| Information | README exists, maybe some inline comments |
| Feedback | CI runs tests (if CI exists) |
| Constraints | Formatter configured |

### Functional

| Surface | What it looks like |
|---------|-------------------|
| Information | AGENTS.md + docs/ hierarchy; team knowledge is in the repo, not in heads |
| Feedback | Local lint + test in seconds; pre-commit hooks catch errors before push |
| Constraints | Pre-commit hooks enforced; formatting, linting, type checking on the hot path |

### Standardized

| Surface | What it looks like |
|---------|-------------------|
| Information | Specs with all five primitives: (1) self-contained problem statements, (2) acceptance criteria, (3) constraint architecture (musts, must-nots, preferences, escalation triggers), (4) decomposition into subtasks with clear I/O, (5) evaluation design with known-good outputs. ADRs individually trackable. |
| Feedback | App bootable per worktree so agents can launch isolated instances. Observability stack agents can query (structured logs, metrics, traces — not just human dashboards). Comprehensive test suite the agent can run locally in minutes. |
| Constraints | Architectural linters enforce dependency direction (import-linter, Nx module boundaries, NetArchTest). SAST in CI. Advisory docs backed by executable enforcement — not just "please follow this." |

### Autonomous

| Surface | What it looks like |
|---------|-------------------|
| Information | Intent infrastructure: tradeoff hierarchies ("speed vs. thoroughness: choose X when Y"), escalation policies ("stop and ask if Z"), decision constitutions. Without this, agents optimize measured metrics while destroying unmeasured ones. |
| Feedback | External holdout scenarios the agent never sees (prevents overfitting to in-repo tests). Digital Twin simulations of external services. Agent-to-agent review replacing human review as throughput bottleneck. |
| Constraints | Continuous garbage collection: golden principles in-repo, background agents scanning for drift on a cadence, quality grades tracked, refactoring PRs opened automatically. The full drift cycle operates continuously: observe → codify → surface violations → remediate at scale → prevent regression. |

## Anti-Pattern: Intent Without Infrastructure

A well-known failure: an AI agent resolved 2.3M customer conversations, cut resolution time from 11 to 2 minutes, projected $40M savings — then customer satisfaction cratered. The agent optimized for speed (measured) when the organizational intent was relationship quality (unmeasured). Perfect context, missing intent. This is the gap between Standardized and Autonomous on the Information surface.

## Key Insight

The practical starting point from every mature agentic engineering team is the same: **fast local feedback loops** (linters, formatters, pre-commit hooks). Highest impact, lowest effort, and it compounds — every rule you add makes the next agent run better.
