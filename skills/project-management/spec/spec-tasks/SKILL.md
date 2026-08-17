---
name: spec-tasks
description: Specifies the task list for a feature or milestone by decomposing it into logically ordered, right-sized tasks with validation checkpoints at integration boundaries. Use when the user says "spec the tasks", "break this down into tasks", or provides a feature/milestone to decompose.
metadata:
  author: zs
  version: "3.0"
---

# Spec Tasks

Decompose a feature or milestone into logically ordered, right-sized, executable tasks with validation checkpoints at integration boundaries.

This skill operates in the context of the codebase — tasks must reflect existing structure, patterns, and conventions.

## Input

A feature or milestone description large enough to break into more than one task (per the sizing criteria in the reference).

### Input Validation

- **Too narrow** (e.g., "change this class", "add a column"): push back hard — this is a single task, not something to decompose. Suggest `spec-task` instead.
- **Too broad** (e.g., "implement the UI", "build the backend"): push back — this needs scoping first. Ask the user to narrow it, or suggest starting from a roadmap milestone.
- **Right-sized**: a feature or milestone that decomposes into roughly 3-12 tasks. Proceed.

## Mode

**Generative.** Upstream docs contain the needed context. Read inputs, produce output, present it. Do not start a conversation. Only ask if the inputs are genuinely ambiguous or contradictory — resolve the specific issue, then generate.

## Procedure

1. **Read the codebase.** Identify the modules, packages, or directories the input touches. Read their structure and key files (entry points, models, public interfaces) — enough to understand existing patterns and boundaries. Don't explore unrelated areas.
2. **Identify tasks.** Follow [references/task-identification.md](references/task-identification.md).
3. **Present for confirmation.** Compact numbered list with VCs marked. Wait for user approval — they may reorder, merge, split, add, or remove.
4. **Output the task list.**

## Output

```
# Task Plan: [Title]

## Summary
[1-2 sentences: what this work delivers]

| # | Item | Type | Depends on | Status |
| --- | --- | --- | --- | --- |
| [1](#1-title) | [title] | Task | None | |
| [2](#2-title) | [title] | Task | 1 | |
| [3](#3-title) | [title] | Task | 1 | |
| [VC1](#vc1-title) | [title] | Validation Checkpoint | 2, 3 | |
| [4](#4-title) | [title] | Task | 2, 3 | |

## Tasks & Validation Checkpoints

### 1. [Imperative title]
[1-3 sentence description]

**Depends on:** [task numbers or "None"]

---

### VC1. Validation Checkpoint: [Descriptive name]

**After tasks:** [N, M, ...]

**What to validate:** [One sentence: what independent work merges and what must be verified before proceeding.]

**Validation scenarios:**

- [action on running system] — [expected observable result]

---
```

Validation checkpoints are interleaved in task order at integration boundaries — where multiple independent task chains feed into a downstream task. Not every multi-dependency is a VC; only genuinely independent branches merging.

Omit VCs entirely for purely linear task chains.
