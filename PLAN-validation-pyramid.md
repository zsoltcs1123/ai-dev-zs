# Validation Pyramid Redesign

## Problem

The current validation system has duplication and waste:

- `spec-validations` produces a flat list of (A)/(H) scenarios
- `extract-regressions` extracts a subset into YAML for the runner
- `run-validations` re-executes everything via agent (slow, burns tokens)
- The validations file duplicates what's already in the regression YAML
- Multi-step and browser scenarios have no dedicated execution path

## The Validation Pyramid

Five tiers, ordered from fast/cheap (base) to slow/expensive (tip). Every scenario derived from exit criteria must land in exactly one tier.

```
           /   Human QA   \            truly manual (CI triggers, UX judgment)
          / Orchestration   \          env manipulation + assertions (wipe, stop/start)
         /  E2E (browser)    \         UI journeys via Playwright
        / System Integration   \       chained API calls, side-effect verification
       /  Regression (YAML)      \     single request/assert, declarative
```

### Tier definitions

- **Regression** — single request or command with a single assertion. Declarative YAML, executed by the existing `scripts/regression.mjs` runner. Fast, cheap, bulk of scenarios.
- **System Integration** — multi-step API sequences where step N depends on step N-1 or verifies a side-effect in another service. Still API-only, no browser. Executed by extending the YAML runner with a `workflow` type, or by dedicated test scripts.
- **E2E (browser)** — user journeys through the UI. Playwright tests. Only needed once Angular apps exist.
- **Orchestration** — destructive/environment-altering scenarios: `docker compose down -v && up`, stop/start containers, run provisioning scripts then verify. Executed by shell scripts or an extended runner with a `sequence` type.
- **Human QA** — genuinely cannot be automated: CI pipeline triggers, devcontainer lifecycle, visual UX review. Should be rare.

### Tier tags

Replace the current `(A)`/`(H)` tags with tier tags in the validations file:

| Tag | Tier | Executor |
|-----|------|----------|
| **(R)** | Regression | YAML runner |
| **(SI)** | System Integration | YAML runner (workflow type) or test script |
| **(E)** | E2E | Playwright |
| **(O)** | Orchestration | Shell script or extended runner |
| **(H)** | Human QA | Manual |

## Changes Required

### 1. Document the pyramid model

Create `skills/project-management/docs/validation-pyramid.md` in the ai-dev-zs repo. This is the shared reference that all validation-related skills point to. Contents:

- Tier definitions (from above)
- Tier tags with executor mapping
- Decision tree: "which tier does this scenario belong to?"
- Examples from PLT-1/PLT-2 mapped to tiers
- Principle: every exit criterion must be covered; every scenario lands in exactly one tier

### 2. Update `spec-validations` skill

File: `skills/project-management/spec/spec-validations/SKILL.md` and `references/derive-validations.md`

Changes to `derive-validations.md`:

- **Automation Legend**: replace `(A)`/`(H)` with the five tier tags `(R)`, `(SI)`, `(E)`, `(O)`, `(H)`
- **Tagging rules**: add a decision tree for assigning tiers (reference the pyramid doc)
- **Per-scenario format**: same structure, just tier tags instead of A/H
- **Coverage matrix**: add a new section after Scenarios — a summary table showing which tier covers each exit criterion, so the user can see at a glance that nothing is unassigned

Changes to `SKILL.md`:

- Update the Output section to mention tier tags instead of A/H
- Reference the pyramid doc

### 3. Update `extract-regressions` skill

File: currently lives in solution-center at `.agents/skills/extract-regressions/SKILL.md`. The canonical source should move to ai-dev-zs under `skills/project-management/exec/extract-regressions/`.

Changes:

- Instead of classifying (A) scenarios by runner type fitness, it now extracts **(R)**-tagged scenarios only — the classification was already done by `spec-validations`
- Still reads the runner source to confirm type taxonomy
- Same YAML output format, same update behavior
- Simpler logic: no more "does it fit?" heuristic — the tier tag is the source of truth

### 4. Update `run-validations` skill

File: `skills/project-management/exec/run-validations/SKILL.md`

This skill's role narrows. It was the "run everything" catch-all. Now:

- It runs **(O)** and **(H)** scenarios only — the ones that don't have a dedicated automated executor yet
- **(R)** scenarios: tell the user to run `node scripts/regression.mjs` instead (or run it for them)
- **(SI)** scenarios: run via the runner if workflow type exists, otherwise execute step-by-step (this is where the agent adds value — it can do multi-step orchestration)
- **(E)** scenarios: tell the user to run the Playwright suite (once it exists)
- **(H)** scenarios: skip as before
- **(O)** scenarios: execute (stop/start containers, wipe, rebuild) — this is where agent execution is genuinely useful and hard to script

The output format stays the same.

### 5. No runner code changes (yet)

The `scripts/regression.mjs` runner and `scripts/lib/regression.mjs` library don't need changes in this plan. The pyramid is a documentation/skill-level change. Runner enhancements (workflow type, sequence type) are future work that can be planned separately once the tier model is established.

## File inventory

All changes in `~/repos/ai-dev-zs/`:

| File | Action |
|------|--------|
| `skills/project-management/docs/validation-pyramid.md` | **Create** — pyramid model reference |
| `skills/project-management/spec/spec-validations/SKILL.md` | **Edit** — reference pyramid, update output description |
| `skills/project-management/spec/spec-validations/references/derive-validations.md` | **Edit** — tier tags, decision tree, coverage matrix |
| `skills/project-management/exec/extract-regressions/SKILL.md` | **Create** — move from solution-center, simplify to (R)-tag extraction |
| `skills/project-management/exec/run-validations/SKILL.md` | **Edit** — narrow scope to O/H/SI scenarios |

After ai-dev-zs changes, sync the solution-center copies (`.agents/skills/` and `~/.cursor/skills/`) from the updated source.

## Tasks

- [ ] Create validation-pyramid.md reference document with tier definitions, tags, decision tree, and examples
- [ ] Update spec-validations SKILL.md and derive-validations.md to use tier tags (R/SI/E/O/H) instead of A/H
- [ ] Move extract-regressions to ai-dev-zs and simplify to extract (R)-tagged scenarios only
- [ ] Narrow run-validations scope to O/H/SI scenarios, delegate R to runner and E to Playwright
- [ ] Sync updated skills to solution-center .agents/skills/ and ~/.cursor/skills/
