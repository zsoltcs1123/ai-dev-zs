---
name: plan-roadmap
description: Produces a project roadmap that aggregates workstream roadmaps into project milestones with cross-workstream scheduling. Use when the user says "plan roadmap", "create the roadmap", or wants to sequence multiple workstreams into a unified timeline.
metadata:
  author: zs
  version: "1.0"
---

# Plan Roadmap

Aggregate workstream roadmaps into a project roadmap with project milestones, cross-workstream scheduling, and a unified timeline. This skill does NOT define features or workstream milestones — it organizes existing workstream roadmaps.

This is a **high-abstraction** document. Never include code examples, file names, directory paths, or specific version numbers. Those belong in task specs and execution plans.

## Input

Strict — no freeform. Requires structured input:

- **Required:** One or more workstream roadmaps (from `plan-workstream-roadmap` runs) — each with milestones and features.
- **Required:** VISION (or equivalent structured project description).

If workstream roadmaps are not yet defined, push back: "I need workstream roadmaps to build a project roadmap from. Consider running `plan-workstream-roadmap` for each workstream first."

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Procedure

### Creating a new project roadmap

1. **Read the inputs.** Understand scope from VISION. Read all workstream roadmaps, their milestones and features.
2. **Define project milestones.** Group workstream milestones into project milestones (`MS-{N}`). Each project milestone is a cross-workstream release gate with success criteria spanning all involved workstreams.
3. **Build the schedule.** Determine what runs in parallel across workstreams within each project milestone. Identify cross-workstream dependencies.
4. **Set statuses.** Mark each project milestone with a status icon. Workstream milestone and feature statuses come from the workstream roadmaps.
5. **Produce the roadmap.** Present in chat. Write to file only if the user asks.

### Updating an existing project roadmap

1. **Read the current project roadmap fully.**
2. **Clarify what changed and why.** Common scenarios:
   - **Workstream roadmap updated** — reflect changes in schedule and project milestones
   - **New workstream added** — integrate into schedule and project milestones
   - **Project milestone restructure** — regroup workstream milestones
   - **Status update** — update icons
3. **Apply changes** while maintaining structure and consistency.
4. **Bump version** for significant changes.

## Output

Follow [references/plan-roadmap.md](references/plan-roadmap.md) for the project roadmap structure, section reference, and quality standards.
