---
name: work-breakdown
description: Breaks a unit of work into executable, right-sized tasks with logical ordering. Use when the user wants to decompose work into tasks, says "break this down", "create tasks/issues", "what needs to be done for this", or provides a feature/epic/phase to decompose.
metadata:
  author: zs
  version: "1.0"
---

# Work Breakdown

Decompose any unit of work into logically ordered, right-sized, executable tasks.

## Communication Style

- Concise, specific, clear
- Ask before assuming on key decisions
- Make educated assumptions on minor details — state them
- Flag risks early
- Challenge unrealistic scope

## When Activated

1. Validate the input
2. Identify tasks (Phase 1)
3. Confirm task plan with user (checkpoint)
4. Detail each task (Phase 2)
5. Present the result

Phases are not strictly linear. If detailing reveals a task needs splitting or merging, return to Step 2 to adjust the task list, then confirm again (Step 3) before continuing.

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

Ask the minimum questions needed to proceed. Frame as "I'm assuming X — correct?" when possible.

## Step 2: Identify Tasks

Load and follow [references/task-identification.md](references/task-identification.md).

**Hard constraints (authoritative — references elaborate but do not override):**

- Tasks MUST be in **logical dependency order** — earlier tasks unlock later ones
- Each task must be a reasonable unit of work (completable in a focused session)
- If candidates exceed **20 tasks**, suggest restructuring before proceeding
- **Do not proceed to detailing until the user confirms the task list** (see Step 3)

## Step 3: Confirm Task Plan

Present the numbered task list to the user using a compact format: number, title, one-line description, and dependencies. Then **stop and wait for the user's response**.

The user may:

- **Approve** — proceed to Step 4
- **Reorder** — move tasks to a different position
- **Merge** — consolidate multiple tasks into one
- **Split** — break a task into smaller ones
- **Add or remove** — introduce new tasks or drop existing ones

If the user requests changes, apply them, re-validate ordering and dependencies, and present the updated list. Repeat until confirmed.

## Step 4: Detail Tasks

Load and follow [references/task-detailing.md](references/task-detailing.md).

**Hard constraints (authoritative):**

- **The 7-step ceiling:** if a task needs more than 7 implementation steps, it's too large — split it, return to Step 2 to reorder, and confirm again (Step 3)
- Each step must be a specific, verifiable action
- Acceptance criteria must be observable, specific, and consolidate task objectives — not restate implementation steps

## Step 5: Output

Each task includes:

- **Title** — concise, imperative verb
- **Description** — what and why (1-3 sentences)
- **Steps** — 5-7 max concrete actions
- **Acceptance criteria** — bullet list of verifiable outcomes (not a restatement of the steps)
- **Dependencies** — which prior tasks, if any

```
# Work Breakdown: [Work Title]

## Summary
[1-2 sentences: what this work delivers]

| # | Task | Depends On |
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
- [verifiable criterion]
- [verifiable criterion]

**Depends on:** [task numbers or "None"]

---

### 2. [Imperative title]
...
```
