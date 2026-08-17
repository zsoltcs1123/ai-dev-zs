---
name: plan-workstream-roadmap
description: Produces a workstream roadmap by grouping pre-defined features into milestones. Use when the user says "plan workstream roadmap", "create a workstream roadmap", or wants to sequence features into milestones within a single workstream.
metadata:
  author: zs
  version: "3.0"
---

# Plan Workstream Roadmap

Group pre-defined features into workstream milestones and produce a workstream roadmap. This skill does NOT define features — it organizes existing ones.

This is a **high-abstraction** document. Never include code examples, file names, directory paths, or specific version numbers. Those belong in task specs and execution plans.

The roadmap is the most frequently updated planning document — it changes as the project evolves, new work is discovered, and priorities shift.

## Input

Strict — no freeform. Requires structured input:

- **Required:** Pre-defined features (from `plan-feature` runs) — each with goal, deliverables, and exit criteria.
- **Required:** VISION (or equivalent structured project description).
- **Recommended:** ARCHITECTURE — informs sequencing and risk.

If features are not yet defined, push back: "I need defined features to build a roadmap from. Consider running `plan-features` to identify workstreams and features, then `plan-feature` for each one."

If the input is freeform or too vague, push back: "I need a structured project description and defined features. Consider starting with `plan-vision`, then `plan-features` to identify the feature inventory."

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Procedure

### Creating a new roadmap

1. **Read the inputs.** Understand scope from VISION and ARCHITECTURE. Read all provided feature specs.
2. **Group into milestones.** Organize features into delivery phases (e.g., MS-PLT-1: Infra Functional, MS-PLT-2: Auth Works). Each milestone is a release gate with success criteria = union of its features' exit criteria.
3. **Sequence.** Determine milestone order based on feature dependencies and risk. Find parallel opportunities within milestones.
4. **Set statuses.** Mark each milestone and feature with a status icon (✅ Done, 🔄 In Progress, ⏳ Pending). New roadmaps default to ⏳ unless the user indicates otherwise.
5. **Produce the roadmap.** Present in chat. Write to file only if the user asks.

It's fine if a small project has just one milestone with a few features. Don't force structure where it doesn't add value.

### Updating an existing roadmap

1. **Read the current roadmap fully.**
2. **Clarify what changed and why.** Common scenarios:
   - **New feature added** — place it in an existing or new milestone
   - **Feature removed or moved** — update milestone and dependency graph
   - **Milestone restructure** — move features between milestones, add/remove milestones
   - **Status update** — update icons
3. **Apply changes** while maintaining structure and consistency.
4. **Bump version** for significant changes.

## Output

Follow [references/plan-workstream-roadmap.md](references/plan-workstream-roadmap.md) for the workstream roadmap structure, section reference, and quality standards.
