# Task Plan: COR-2 Dependency Tracking

## Summary

Decompose the Dependency Tracking feature into tasks for dependency model, CRUD, cycle detection, queries, and blocked status — with validation checkpoints at integration boundaries.

| # | Item | Type | Depends on | Status |
| --- | --- | --- | --- | --- |
| [1](#1-define-dependency-model) | Define dependency model | Task | None | |
| [2](#2-implement-dependency-crud) | Implement dependency CRUD | Task | 1 | |
| [3](#3-implement-cycle-detection) | Implement cycle detection | Task | 2 | |
| [4](#4-implement-dependency-queries) | Implement dependency queries | Task | 2 | |
| [5](#5-implement-blocked-status) | Implement blocked status | Task | 2 | |
| [VC1](#vc1-validation-checkpoint-dependency-queries-and-blocked-status) | Validation Checkpoint: Dependency queries and blocked status | Validation Checkpoint | 4, 5 | |

## Tasks & Validation Checkpoints

### 1. Define dependency model
Directed edge representation between tasks persisted in storage. Tasks reference other tasks as predecessors or successors.

**Steps:**
1. Define dependency edge schema (source task, target task, or equivalent)
2. Establish persistence for dependency links
3. Ensure referential integrity to task entities

**Implementation requirements:**
- Dependency is a directed edge from predecessor to successor
- Both endpoints must reference existing tasks
- Storage supports efficient lookup by task (incoming and outgoing edges)

**Test coverage:**
- Dependency model validation — unit tests; invalid references rejected
- Persistence — integration test; edges survive session

**Verification scenarios:**
- Create dependency A → B — persists; both tasks exist
- Create dependency with non-existent task — rejected with clear error

**Depends on:** None

---

### 2. Implement dependency CRUD
Add and remove dependency links between tasks with validation. Dependencies can be created and deleted; invalid references are rejected.

**Steps:**
1. Implement add-dependency operation with validation
2. Implement remove-dependency operation
3. Reject self-references (task depending on itself)
4. Reject duplicate dependencies

**Implementation requirements:**
- Add dependency validates both tasks exist; rejects self-reference and duplicates
- Remove dependency removes the edge; tasks remain
- CRUD operations persist immediately

**Test coverage:**
- Add/remove operations — unit tests; validation and persistence
- Self-reference and duplicate rejection — unit tests

**Verification scenarios:**
- Add valid dependency — persists; removable
- Add self-dependency — rejected
- Add duplicate dependency — rejected or idempotent per spec
- Remove dependency — edge removed; tasks unchanged

**Depends on:** 1

---

### 3. Implement cycle detection
Validation that rejects or reports cycles when adding dependencies. Adding a dependency that would create a cycle is rejected.

**Steps:**
1. Implement cycle detection algorithm (e.g., DFS or topological sort)
2. Run cycle check before persisting new dependency
3. Reject add-dependency when cycle would form
4. Return clear error indicating the cycle

**Implementation requirements:**
- Cycle detection runs on dependency graph before persist
- Rejected add returns error with cycle description or task ids involved
- No cycle can exist in persisted graph

**Test coverage:**
- Cycle detection — unit tests; A→B, B→A and longer cycles
- Cycle rejection — integration test; graph remains acyclic after rejected add

**Verification scenarios:**
- Add A→B, then B→A — second add rejected
- Add A→B→C, then C→A — rejected
- Add A→B, B→C, C→D — valid; add D→A — rejected

**Depends on:** 2

---

### 4. Implement dependency queries
List predecessors and successors for any task. A user can query which tasks block a given task and which tasks it blocks.

**Steps:**
1. Implement get-predecessors (blockers) for a task
2. Implement get-successors (blocked tasks) for a task
3. Ensure queries return task references or full task data as defined
4. Handle tasks with no dependencies (empty lists)

**Implementation requirements:**
- Predecessors = tasks that must be done before this task
- Successors = tasks that this task blocks
- Queries return consistent, up-to-date results

**Test coverage:**
- Query correctness — unit tests; predecessors/successors match graph
- Empty dependency — unit test; returns empty list

**Verification scenarios:**
- A→B→C; query B predecessors — returns A; successors — returns C
- Task with no dependencies — both queries return empty
- Query after add/remove — results reflect current graph

**Depends on:** 2

---

### 5. Implement blocked status
Tasks marked as blocked when any predecessor is not done; surfaced in task listings. Blocked tasks and their unsatisfied dependencies are visible when listing tasks.

**Steps:**
1. Define blocked semantics: blocked when any predecessor status ≠ Done
2. Compute blocked status when listing tasks
3. Include blocked flag and unsatisfied dependencies in task list response
4. Support filter by blocked status

**Implementation requirements:**
- Blocked = at least one predecessor not done
- Task list includes blocked flag and list of blocking (undone) predecessors
- Filter by blocked returns only blocked tasks

**Test coverage:**
- Blocked computation — unit tests; all predecessors done vs not
- List with blocked info — integration test; correct surfaced data

**Verification scenarios:**
- A (To Do) → B; list tasks — B shown as blocked by A
- A (Done) → B; list tasks — B not blocked
- Filter by blocked — returns only tasks with undone predecessors

**Depends on:** 2

---

### VC1. Validation Checkpoint: Dependency queries and blocked status

**After tasks:** 4, 5

**What to validate:** Independent work on queries and blocked status merges; verify blocked tasks appear correctly in listings and dependency queries return consistent data.

**Validation scenarios:**

- Create a chain A → B → C; query predecessors/successors for B — returns A and C correctly; B is blocked until A is done
- List tasks with blocked filter — blocked tasks and their unsatisfied dependencies are surfaced

---
