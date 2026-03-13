---
name: update-plan
description: Updates planning and spec artifacts after initial generation — identifies the right skill invocations and cascade chain for any mutation. Use when the user says "update the plan", "change a feature", "add a workstream", "remove a feature", "resequence the roadmap", "move a feature", or wants to modify any planning or spec artifact.
metadata:
  author: zs
  version: "1.0"
---

# Update Plan

Orchestrate mutations to planning and spec artifacts. Given a description of what changed, classify the mutation, identify the primary action and full cascade chain, and execute the cascade by delegating to the referenced skills in sequence.

## Input

A description of what changed or needs to change. Examples:

- "Add feature X to workstream PLT"
- "Update exit criteria for PLT-3"
- "Remove workstream IDX"
- "Move PLT-4 from M2 to M3"
- "Split PLT-2 into two features"
- "Task work on PLT-3 surfaced a new deliverable"

The user must also provide (or the conversation must contain) access to the affected artifacts — feature specs, roadmaps, task plans, etc.

## Mode

**Orchestrator.** This skill sequences other skills and delegates work to subagents. Run stages in order. Write artifacts to disk between stages. Verify outputs before proceeding. Do not generate domain content yourself — delegate to the referenced skills.

## Procedure

1. **Classify the mutation.** Match the user's request against the mutation tables below. If the request spans multiple mutation types (e.g., "split this feature and resequence the roadmap"), decompose into individual mutations and process them in dependency order.
2. **Identify the cascade.** For each mutation, read the primary action, cascade chain, and notes from the matching table row.
3. **Present the plan.** Before executing, show the user:
   - Mutation type identified
   - Skills to invoke, in order
   - Artifacts that will be created, updated, or deleted
4. **Execute.** Run each skill in the cascade chain in order. Write artifacts to disk between steps. Verify outputs before proceeding to the next step.

If the request doesn't match any mutation type, say so and suggest what the user might mean.

## Artifact Dependency Graph

```
FEATURES.md ──> feature specs ──> task plans ──> validation suites
                              \──> WS roadmaps ──> project roadmap
```

### Downward (primary)

Modifying an upstream artifact may require updating downstream ones. Always check what sits below the artifact you changed.

### Upward (feedback)

```
task plan ──(new deliverable discovered)──> feature spec ──> FEATURES.md, WS roadmap
validation suite ──(gap in exit criteria)──> feature spec
```

Spec-level work can surface missing deliverables or exit criteria that must propagate back up to the feature spec. The feature spec is always the pivot point for upward cascades — never update FEATURES.md or a roadmap directly from a task-level discovery.

## Mutation Tables

### Feature map level

| Mutation | Primary action | Cascade | Notes |
| --- | --- | --- | --- |
| Add feature to existing workstream | `plan-features` (update mode) | `plan-feature` for the new spec, then `plan-workstream-roadmap` (update), then `plan-roadmap` (update) if multi-WS | Assign the next available `{WS}-{N}` code |
| Remove feature | Delete `{WS}/{FC}/` folder, `plan-features` (update) | `plan-workstream-roadmap` (update), then `plan-roadmap` (update) if multi-WS | Check for cross-feature dependencies before deleting |
| Merge features | `plan-feature` to produce merged spec, delete absorbed feature folder(s), `plan-features` (update) | `plan-workstream-roadmap` (update), then `plan-roadmap` (update) if multi-WS | Merged feature keeps the lower code; renumber if needed |
| Split feature | `plan-feature` for each new spec, delete original folder, `plan-features` (update) | `plan-workstream-roadmap` (update), then `plan-roadmap` (update) if multi-WS | Assign new codes for the split features |
| Add workstream | `plan-features` (update) to register the WS and its features | `plan-feature` per new feature, `plan-workstream-roadmap` for the new WS, `plan-roadmap` (update) | Define the WS code first |
| Remove workstream | Delete `{WS}/` folder, `plan-features` (update) | `plan-roadmap` (update) | Verify no cross-WS dependencies remain |
| Rename/recode WS or feature | Rename folders and files, update all references in FEATURES.md, roadmaps, task plans, validation suites | None beyond the reference updates | Bulk find-and-replace across all project docs |

### Feature spec level

| Mutation | Primary action | Cascade | Notes |
| --- | --- | --- | --- |
| Update feature (goal, deliverables, exit criteria) | `plan-feature` (update mode) | If exit criteria changed: regenerate validation suite via `spec-validations`. If scope shifted significantly: update FEATURES.md via `plan-features` (update), update WS roadmap, regenerate task plan via `spec-tasks` | Minor wording fixes don't cascade |

### Roadmap level

| Mutation | Primary action | Cascade | Notes |
| --- | --- | --- | --- |
| Update WS roadmap (add/remove/move features between milestones, add/remove milestones) | `plan-workstream-roadmap` (update mode) | `plan-roadmap` (update) if multi-WS | Pure resequencing rarely cascades |
| Update project roadmap (restructure project milestones, integrate WS changes) | `plan-roadmap` (update mode) | None | Downstream of everything else |
| Update statuses | Edit status icons directly in the relevant roadmap or task plan | None | Leaf operation — never cascades |

### Spec level

| Mutation | Primary action | Cascade | Notes |
| --- | --- | --- | --- |
| Generate full spec for feature(s) | `run-spec` (runs spec-tasks → spec-task → spec-validations) | None — produces both `{FC}-tasks.md` and `{FC}-validations.md` | Use for initial generation or full regeneration; accepts one or many feature codes |
| Regenerate task plan | `spec-tasks` (fresh run against updated feature spec) | Regenerate validation suite if VCs changed materially | Use when the feature changed significantly |
| Update task plan (add/remove/reorder tasks) | Edit `{FC}-tasks.md` directly or re-run `spec-tasks` | Update validation suite if exit-criteria-relevant tasks changed | For small changes, direct edit is fine |
| Regenerate validation suite | `spec-validations` (fresh run against updated feature spec) | None | Use when exit criteria changed |
| Update validation suite (add/remove scenarios) | Edit `{FC}-validations.md` directly or re-run `spec-validations` | None | For small changes, direct edit is fine |

### Upward feedback (spec to plan)

| Trigger | Primary action | Cascade | Notes |
| --- | --- | --- | --- |
| Task work surfaces new deliverable | `plan-feature` (update) to add the deliverable | If scope/goal shifted: `plan-features` (update), `plan-workstream-roadmap` (update). Regenerate validation suite via `spec-validations` | Always land on the feature spec first |
| Task work reveals exit criteria gap | `plan-feature` (update) to add exit criteria | Regenerate validation suite via `spec-validations` | Don't patch the validation suite directly — fix the source |
| Validation work exposes missing exit criteria | `plan-feature` (update) to add exit criteria | Regenerate task plan via `spec-tasks` if the gap implies missing tasks | The feature spec is the single source of truth for what "done" means |

## Cascade Rules

**Downward:**

- Always check downstream artifacts after any change. If you change a feature's exit criteria, the validation suite must be regenerated (not just patched).
- Deleting a feature means deleting its entire folder (`{WS}/{FC}/`) and removing references from FEATURES.md and the WS roadmap.
- Roadmap resequencing (moving features between milestones without changing their content) rarely cascades.
- Status updates are leaf operations — they never cascade.

**Upward:**

- Upward cascades always land on the feature spec first. From there, decide whether FEATURES.md or the WS roadmap also need updating (they do if the feature's scope or goal shifted, not for minor exit criteria additions).
- Never skip the feature spec when propagating upward — don't update FEATURES.md or a roadmap directly from a task-level discovery.
- After updating the feature spec upward, cascade downward from it as normal.

## Stance

This is an orchestrator — focus on sequencing and delegation, not content generation. When delegating, trust the subagent to follow the skill it was pointed to. Do not invent feature content, roadmap structure, or milestones beyond what the referenced skills would produce.

Challenge requests that skip cascade steps (e.g., updating a validation suite without updating the feature spec that drives it). The cascade chain exists to maintain artifact consistency.
