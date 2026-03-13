---
name: run-spec
description: Runs the full spec pipeline for one or more features — task identification, task detailing, and validation suite. Delegates per-feature work to subagents when multiple features are given. Use when the user says "run spec", "spec this feature", "spec these features", or wants to go from feature specs to task plans and validation suites.
metadata:
  author: zs
  version: "1.0"
---

# Run Spec

Orchestrate the full spec layer: decompose feature(s) into tasks, detail each task, and derive validation scenarios. Delegates per-feature work to subagents when processing multiple features; runs the pipeline directly for a single feature.

## Input

Strict — requires structured input:

- **Required:** Path to the project docs directory.
- **Required:** Feature code(s) to spec (e.g., `COR-1` or `COR-1, COR-2, COR-3`).

For each feature code `{FC}` in workstream `{WS}`, the feature spec must already exist at `{docs}/{WS}/{FC}/{FC}.md`. If a feature spec is missing, skip it and report the gap.

The user may also specify "all features in milestone `MS-{WS}-{N}`" or "all features in workstream `{WS}`". In that case, read the relevant roadmap or `FEATURES.md` to resolve the feature codes before proceeding.

## Mode

**Orchestrator.** This skill sequences other skills and delegates work to subagents. Run stages in order. Write artifacts to disk between stages. Verify outputs before proceeding. Do not generate domain content yourself — delegate to the referenced skills.

## Procedure

Use `{docs}` as shorthand for the project docs directory path throughout.

### Resolve feature list

1. Parse the user's input into a list of feature codes. Each code has the form `{WS}-{N}`.
2. For each feature code, verify that `{docs}/{WS}/{FC}/{FC}.md` exists and is non-empty. Collect valid features; report any missing specs immediately.

If 0 valid features remain, stop: "No valid feature specs found. Ensure feature specs exist before running the spec pipeline."

Print:

```
Features to spec: {FC1}, {FC2}, ... ({N} total, {M} skipped)
```

### Single feature — run directly

When the resolved list contains exactly one feature, run all three stages yourself. No subagent needed.

#### Stage 1 — Task identification

1. Read the feature spec at `{docs}/{WS}/{FC}/{FC}.md`.
2. Read and follow the `spec-tasks` skill. Apply its procedure and stance. Since you are an orchestrator, skip the "present for confirmation" step — produce the task list directly.
3. Write the task plan to `{docs}/{WS}/{FC}/{FC}-tasks.md`.

Print progress:

```
[{FC}] Stage 1/3: Task identification — DONE ({T} tasks, {V} VCs)
```

If 0 tasks were produced, stop this feature: "Task identification produced 0 tasks for {FC} — the feature spec may be too narrow."

#### Stage 2 — Task detailing

1. Read the task plan you just wrote at `{docs}/{WS}/{FC}/{FC}-tasks.md`.
2. Read and follow the `spec-task` skill. Apply its procedure. Pass the full task list as input so it details every task.
3. Update `{docs}/{WS}/{FC}/{FC}-tasks.md` in-place — replace each task's stub heading with the fully detailed version (steps, implementation requirements, test coverage, verification scenarios, dependencies).

Print progress:

```
[{FC}] Stage 2/3: Task detailing — DONE ({T} tasks detailed)
```

#### Stage 3 — Validation suite

1. Read the feature spec at `{docs}/{WS}/{FC}/{FC}.md` and the detailed task plan at `{docs}/{WS}/{FC}/{FC}-tasks.md`.
2. Read and follow the `spec-validations` skill. Apply its procedure. Pass both the feature spec and the task plan as input.
3. Write the validation suite to `{docs}/{WS}/{FC}/{FC}-validations.md`.

Print progress:

```
[{FC}] Stage 3/3: Validation suite — DONE ({S} scenarios)
```

### Multiple features — delegate to subagents

When the resolved list contains more than one feature, delegate each feature's full 3-stage pipeline to a subagent. Run in parallel batches of up to 4.

For each feature code `{FC}` in workstream `{WS}`, spawn a subagent with this prompt:

```
You are specifying feature {FC} for a software project.

Read the feature spec:
- {docs}/{WS}/{FC}/{FC}.md

Then execute the following three stages in order, writing all output to disk.

--- Stage 1: Task identification ---
Read and follow the `spec-tasks` skill — it defines the procedure, output format, and quality standards for a task plan.
The input is the feature spec you just read. Since you are generating without user interaction, skip the "present for confirmation" step — produce the task list directly.
Write the task plan to: {docs}/{WS}/{FC}/{FC}-tasks.md
Create the file if it doesn't exist.

--- Stage 2: Task detailing ---
Read the task plan you just wrote at {docs}/{WS}/{FC}/{FC}-tasks.md.
Read and follow the `spec-task` skill — it defines the procedure, output format, and quality standards for task detailing.
Pass the full task list as input so every task is detailed.
Update {docs}/{WS}/{FC}/{FC}-tasks.md in-place — replace each task's stub heading with the fully detailed version.

--- Stage 3: Validation suite ---
Read the feature spec at {docs}/{WS}/{FC}/{FC}.md and the detailed task plan at {docs}/{WS}/{FC}/{FC}-tasks.md.
Read and follow the `spec-validations` skill — it defines the procedure, output format, and quality standards for validation scenarios.
Write the validation suite to: {docs}/{WS}/{FC}/{FC}-validations.md

Do not present in chat — write to files only.
```

After each batch completes, verify that each expected feature produced both output files (`{FC}-tasks.md` and `{FC}-validations.md`) and that they are non-empty. Track which features succeeded and which failed.

Print progress after each batch:

```
[Batch {B}] Spec pipeline — {done}/{total} features done
```

If any features failed, report them but continue with the rest.

### Completion summary

After all features are processed, print a summary:

```
Spec pipeline complete.

Artifacts:
  {docs}/{WS1}/{FC1}/{FC1}-tasks.md
  {docs}/{WS1}/{FC1}/{FC1}-validations.md
  {docs}/{WS1}/{FC2}/{FC2}-tasks.md
  {docs}/{WS1}/{FC2}/{FC2}-validations.md
  ...

Failures: {list of any failed features, or "none"}
```

## Error Handling

- **Feature spec missing:** report which feature code has no spec file, skip it, continue. Include in the completion summary.
- **Subagent fails to produce output files:** report which feature failed, skip it, continue. Include all failures in the completion summary.
- **Task identification produces 0 tasks:** halt that feature, report. Other features continue.
- **Conversation interrupted mid-pipeline:** artifacts written to disk are durable. On re-run, the user can provide the same feature codes and the orchestrator runs fresh. Manual inspection of existing files tells the user where to pick up.

## Stance

This is an orchestrator — focus on sequencing and delegation, not content generation. When running the pipeline yourself (single-feature case), apply each referenced skill's stance fully. When delegating to subagents, trust them to follow the skills they were pointed to.

Do not invent tasks, validation scenarios, or structure beyond what the referenced skills would produce. The orchestrator adds no domain knowledge — it only manages the pipeline.
