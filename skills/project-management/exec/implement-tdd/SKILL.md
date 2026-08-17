---
name: implement-tdd
description: Implements code using test-driven development. Use when asked to "TDD this", "implement with TDD", "test-first", or "red-green-refactor".
metadata:
  version: "1.1.0"
---

# Implement (TDD)

Executes a task spec or implementation plan using test-driven development. Tests are written first; code is written only to make them pass.

## When to Use

- User asks to "TDD this", "implement with TDD", or "test-first"

## Input

A task spec (output of `spec-task`) or an implementation plan with concrete steps.

## Procedure

1. **Classify input** (Step 1 below).
2. **Validate the plan** (Step 2 below).
3. **Execute TDD loop** (Step 3 below).

## Step 1: Classify Input

The skill can be invoked with anything. Figure out what you're looking at and respond helpfully.

**Classify the input (in priority order):**

1. **Valid input** — contains a summary/description, concrete steps, and implementation requirements. This includes task specs (from `spec-task`) and implementation plans. Proceed to Step 2.
2. **Plan-like but incomplete** — recognizably a plan or task spec but missing required elements (see Step 2). List what is missing, ask the user to complete it. **STOP.**
3. **Not a plan or task spec** — the input is a feature request, question, idea, or raw requirements without actionable steps. Explain that this skill implements from task specs or plans. Suggest `spec-task` to create one. **STOP.**
4. **No input / off-topic** — nothing actionable provided. State what the skill expects and stop. **STOP.**

## Step 2: Validate Plan

A plan is valid when these **required** elements are present:

- A description or summary
- Concrete steps to be executed
- Implementation requirements

If a required element is missing → **STOP** and report exactly what is missing.

**Resolve behavioral scenarios** (not blocking):

Behavioral scenarios are runtime checks against the built software — an action on the running system and an expected observable result (e.g., "run the CLI with X flag — output contains Y", "start the server and hit /health — returns 200").

1. **In the plan** — use them directly.
2. **Not in the plan** — search the conversation context for the originating task spec or feature spec. If found, extract the scenarios from there.
3. **Not found anywhere** — warn: "No behavioral scenarios found — scenario verification will be skipped."

## Step 3: Execute TDD Loop

The task spec or plan defines **what** to build. Follow project conventions found in the codebase (linter configs, existing patterns, documentation standards).

For each plan step:

   1. **Red** — write failing tests derived from the step's implementation requirements and resolved behavioral scenarios. Run tests, confirm they fail for the right reasons.
   2. **Green** — write the minimal code to make the failing tests pass. Nothing more.
   3. **Refactor** — clean up the code while keeping tests green. Follow project conventions.
   4. **Lint** — run linter, fix issues, re-run tests to confirm still green.

After all steps:

   5. Run behavioral scenarios — execute each resolved scenario, verify the expected result, report pass/fail. Iterate on failures until green or blocked. Skip if none were resolved in Step 2.
   6. Update documentation (if needed).
   7. Collect deviations (if any). Follow deviation handling below.

## Deviation Rules

1. **Plan assumptions that don't hold** (API works differently than expected, library behavior differs from docs, signatures don't match) — adapt and keep going, note what the plan assumed vs. what was actually needed under Deviations.
2. **Bugs, missing guards, edge cases** — fix on the spot without stopping, note what was changed and why under Deviations.
3. **Plan's approach is unviable** (required capability doesn't exist, dependency is incompatible, fix would require a fundamentally different design, or adapting one step would invalidate multiple downstream steps) — **STOP**, report as BLOCKED. The plan itself needs revision, not just a local adaptation.

## Output Format

```markdown
## Implementation (TDD): {COMPLETE|BLOCKED}

### Changes Made

- {file}: {what was changed}

### Tests Written

- {file}: {what is tested}

### Behavioral Scenario Results

- [x] {scenario passed}
- [ ] {scenario failed}

### Deviations

- {description — what changed and why}
  Or: "None — plan executed as written."

### Notes

{Issues encountered, if any}
```
