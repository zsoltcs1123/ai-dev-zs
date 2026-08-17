---
name: spec-task
description: Details a single task (or each task in a list) into implementation steps, requirements, test coverage, and verification scenarios. Use when the user says "spec this task", "detail this task", or provides a task to flesh out.
metadata:
  author: zs
  version: "3.0"
---

# Spec Task

Detail a task into implementation steps, implementation requirements, test coverage, and verification scenarios.

## Input

Either:

- A **single task description** — something completable in a focused session (3-7 steps)
- A **task list** — output from `spec-tasks`. In this case, loop through and detail each task.

### Input Validation

- **Too large** (milestone-level): multiple concerns, 8+ steps, words like "system", "module", "full flow". Push back — suggest `spec-tasks` to decompose first.
- **Too small** (sub-task): a single obvious action, 1-2 steps. Push back — this doesn't need a spec, just do it.
- **Right-sized**: single coherent concern, 3-7 steps. Proceed.

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Procedure

For each task, follow [references/task-detailing.md](references/task-detailing.md) to define implementation steps, implementation requirements, test coverage, verification scenarios, and dependencies.

## Output

```
### [#]. [Imperative title]
[1-3 sentence description]

**Steps:**
1. [concrete action]
2. [concrete action]
3. [concrete action]

**Implementation requirements:**
- [statically verifiable constraint]

**Test coverage:**
- [what needs test coverage and why]

**Verification scenarios:**
- [input/condition] — [expected behavior]

**Depends on:** [task numbers or "None"]
```
