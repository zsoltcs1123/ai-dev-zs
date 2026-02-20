---
name: dev-breakdown
description: Breaks a software development unit of work into executable, right-sized tasks with logical ordering, verification, and validation scenarios. Use when the user wants to decompose development work into tasks, says "break this down", "what needs to be done for this", or provides a feature/epic/phase to decompose.
metadata:
  author: zs
  version: "1.2"
---

# Dev Breakdown

Decompose a software development unit of work into logically ordered, right-sized, executable tasks.

## Communication Style

- Concise, specific, clear
- Ask before assuming on key decisions
- Make educated assumptions on minor details — state them
- Flag risks early
- Challenge unrealistic scope

## When Activated

1. Validate the input
2. Identify tasks
3. Confirm task plan with user
4. Detail each task
5. Present the result

## Step 1: Validate Input

The input must describe a concrete unit of work — something that can be built, changed, or delivered.

**Reject gracefully if:**

- Input is too vague to act on (e.g., "make it better")
- Input is a question, not work (e.g., "should we use Redis?")
- Input is a goal without actionable scope (e.g., "improve performance")

When rejecting, explain **why** it's not actionable and **what** would make it workable. Suggest a reframing if possible.

**Probe for missing context if:**

- The input is actionable but lacks key context (e.g., "add OAuth login" — to what? which provider? existing auth system?)
- Decisions that materially affect the breakdown haven't been made

Ask the minimum questions needed to proceed. Frame as "I'm assuming X — correct?" when possible. Wait for answers before proceeding to Step 2.

## Step 2: Identify Tasks

Extract task candidates from the input, right-size them (3-7 steps each), order logically, and present a compact numbered list for confirmation.

Load and follow [references/task-identification.md](references/task-identification.md).

Present the list, then proceed to Step 3.

## Step 3: Confirm Task Plan

After the task list is presented, **stop and wait for the user's response**.

The user may:

- **Approve** — proceed to Step 4
- **Reorder** — move tasks to a different position
- **Merge** — consolidate multiple tasks into one
- **Split** — break a task into smaller ones
- **Add or remove** — introduce new tasks or drop existing ones

If the user requests changes, apply them, re-validate ordering and dependencies, and present the updated list. Repeat until confirmed.

## Step 4: Detail Tasks

Define implementation steps, acceptance criteria, verification scenarios, validation scenarios, and dependencies for each confirmed task.

Load and follow [references/task-detailing.md](references/task-detailing.md).

## Step 5: Output

Present the fully detailed breakdown using this template:

```
# Work Breakdown: [Work Title]

## Summary
[1-2 sentences: what this work delivers]

| # | Task | Depends on |
| --- | --- | --- |
| 1 | [title] | None |
| 2 | [title] | 1 |
| 3 | [title] | 1, 2 |

## Tasks

### 1. [Imperative title]
[1-3 sentence description]

**Steps:**
1. [concrete action]
2. [concrete action]
3. [concrete action]

**Acceptance criteria:**
- [observable outcome — the 'done' contract]

**Verification scenarios:**
- [input/condition] — [expected behavior]

**Validation scenarios:**
- [action on running software] — [expected observable result] — Automation: [full | partial | human-only]

**Depends on:** [task numbers or "None"]

---

### 2. [Imperative title]
...
```
