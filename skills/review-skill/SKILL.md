---
name: review-skill
description: Reviews Agent Skills (SKILL.md files) for specification conformance, agent usability, token efficiency, instruction structure, and scope cohesion. Use when the user asks to review, audit, check, or validate a skill they created or are editing.
metadata:
  author: zs
  version: "1.1"
---

# Review Skill

## Outcome

Review a target skill across five dimensions. Classify findings by severity. Present summary table. Walk user through fixes interactively. Deliver verdict: Pass, Pass with caveats, or Needs rework.

## Guardrails

Five dimensions: spec conformance, agent usability, brevity & token efficiency, instruction sequencing & structure, scope & cohesion. Detail in [references/review-workflow.md](references/review-workflow.md).

Severity: **Major** (drift, hallucination, wrong behavior, spec violations), **Medium** (suboptimal but workable), **Minor** (cosmetic).

Interaction: Major and Medium one-at-a-time (Fix / Skip / Modify). Minor batched. Issue format and edge cases in [references/review-workflow.md](references/review-workflow.md).

## Tools

- Read target skill directory: SKILL.md plus `references/`, `scripts/`, `assets/`.
- Fetch [agentskills.io/specification](https://agentskills.io/specification) before spec conformance checks.
