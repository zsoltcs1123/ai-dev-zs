---
name: run-plan
description: Runs the full planning pipeline from VISION + ARCHITECTURE to project roadmap. Produces feature inventory, feature specs, workstream roadmaps, and project roadmap — using subagents for fan-out stages. Use when the user says "run plan", "run the plan", "plan everything", or wants to go from vision/architecture to a complete project plan.
metadata:
  author: zs
  version: "1.0"
---

# Run Plan

Orchestrate the full plan layer: decompose VISION + ARCHITECTURE into features, detail each feature, build workstream roadmaps, and aggregate into a project roadmap. Delegates self-contained generation work to subagents; runs aggregation stages directly.

## Input

Strict — requires structured input:

- **Required:** Path to the project docs directory containing `VISION.md` and `ARCHITECTURE.md`.

Both files must already exist. If either is missing, stop: "I need both VISION.md and ARCHITECTURE.md in the docs directory. Consider running `plan-vision` / `plan-architecture` first."

The user provides the docs directory path. All output files are written relative to this directory.

## Mode

**Orchestrator.** This skill sequences other skills and delegates work to subagents. Run stages in order. Write artifacts to disk between stages. Verify outputs before proceeding. Do not generate domain content yourself — delegate to the referenced skills.

## Procedure

Execute the four stages in order. Each stage writes its artifacts to disk before the next stage begins.

Use `{docs}` as shorthand for the project docs directory path throughout.

### Stage 1 — Feature inventory

Run this yourself (needs full VISION + ARCHITECTURE context).

1. Read `{docs}/VISION.md` and `{docs}/ARCHITECTURE.md`.
2. Read and follow the `plan-features` skill. Apply its procedure and stance.
3. Write the feature map to `{docs}/FEATURES.md`.
4. Parse the feature map you just wrote. Extract:
   - List of workstream codes (e.g., `PLT`, `IDX`)
   - List of feature codes per workstream (e.g., `PLT-1`, `PLT-2`, `IDX-1`)

Print progress:

```
[Stage 1/4] Feature inventory — DONE ({M} workstreams, {N} features)
```

If 0 features were produced, stop immediately — the inputs are insufficient.

### Stage 2 — Feature specs

Delegate to subagents. Each feature is independent — run in parallel batches of up to 4.

For each feature code `{FC}` in workstream `{WS}`, spawn a subagent with this prompt:

```
You are detailing feature {FC} for a software project.

Read these files:
- {docs}/VISION.md
- {docs}/ARCHITECTURE.md
- {docs}/FEATURES.md

Read and follow the `plan-feature` skill — it defines the procedure, output format, and quality standards for a feature spec.

The feature code is {FC}. Write the feature spec directly to file:
{docs}/{WS}/{FC}/{FC}.md

Create the directories if they don't exist. Do not present in chat — write to file only.
```

After each batch completes, verify that each expected output file exists and is non-empty. Track which features succeeded and which failed.

Print progress after each batch:

```
[Stage 2/4] Feature specs — {done}/{total} done
```

If any features failed, report them but continue with the rest.

### Stage 3 — Workstream roadmaps

Delegate to subagents. Each workstream is independent — run in parallel (up to 4).

For each workstream `{WS}` that has at least one successfully detailed feature, spawn a subagent:

```
You are building the workstream roadmap for workstream {WS}.

Read these files:
- {docs}/VISION.md
- {docs}/ARCHITECTURE.md
- All feature specs: {docs}/{WS}/*/*.md

Read and follow the `plan-workstream-roadmap` skill — it defines the procedure, output format, and quality standards for a workstream roadmap.

Write the roadmap directly to file:
{docs}/{WS}/{WS}-roadmap.md

Do not present in chat — write to file only.
```

After all subagents complete, verify output files. Skip any workstream with 0 successfully detailed features — report the gap.

Print progress:

```
[Stage 3/4] Workstream roadmaps — DONE ({M}/{M_total} workstreams)
```

### Stage 4 — Project roadmap

Run this yourself (needs to read all workstream roadmaps).

1. Read `{docs}/VISION.md` and all workstream roadmaps (`{docs}/{WS}/{WS}-roadmap.md`).
2. Read and follow the `plan-roadmap` skill. Apply its procedure.
3. Write the project roadmap to `{docs}/ROADMAP.md`.

Print progress:

```
[Stage 4/4] Project roadmap — DONE
```

### Single-workstream simplification

If Stage 1 produces exactly one workstream:

- Stage 3: run plan-workstream-roadmap yourself (no subagent needed for a single item). Write directly to `{docs}/ROADMAP.md`.
- Stage 4: skip entirely — the workstream roadmap IS the project roadmap.

Print:

```
[Stage 3/3] Roadmap — DONE (single workstream, no project-level aggregation needed)
```

### Completion summary

After all stages, print a summary:

```
Pipeline complete.

Artifacts:
  {docs}/FEATURES.md
  {docs}/{WS1}/{WS1-1}/{WS1-1}.md
  {docs}/{WS1}/{WS1-2}/{WS1-2}.md
  ...
  {docs}/{WS1}/{WS1}-roadmap.md
  {docs}/ROADMAP.md

Failures: {list of any failed features/workstreams, or "none"}
```

## Error Handling

- **Subagent fails to produce output file:** report which feature/workstream failed, skip it, continue. Include all failures in the completion summary.
- **Plan-features produces 0 features:** halt immediately.
- **Workstream has 0 successfully detailed features:** skip its roadmap, report the gap.
- **Conversation interrupted mid-pipeline:** artifacts written to disk are durable. On re-run, the user can point to the docs directory and existing files indicate what completed. The orchestrator does not auto-detect existing files — it always runs fresh. Manual inspection tells the user where to pick up.

## Stance

This is an orchestrator — focus on sequencing and delegation, not content generation. When running Stages 1 and 4 yourself, apply the referenced skill's stance fully. When delegating, trust the subagent to follow the skill it was pointed to.

Do not invent features, roadmap structure, or milestones beyond what the referenced skills would produce. The orchestrator adds no domain knowledge — it only manages the pipeline.
