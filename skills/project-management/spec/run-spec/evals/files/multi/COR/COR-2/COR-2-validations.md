# Validation Scenarios: COR-2 Dependency Tracking

## Summary

Validation scenarios for the Dependency Tracking feature. These scenarios verify that dependencies can be added and persisted, cycles are rejected, blocked status is computed, and dependency queries return correct data. Scenarios are executable against the running task management service with dependency support.

## Exit Criteria Source

[COR-2.md](COR-2.md) — Dependency Tracking feature spec

## Automation Legend

- **(A)** — Agent-executable: can be validated via shell commands, HTTP requests, or browser interaction
- **(H)** — Human-only: requires commits, CI triggers, or external tooling

## Scenarios

### COR-2-VS1. Dependency persistence
**Validates:** A dependency from one task to another can be added and persisted

**Scenarios:**
- **(A)** Create tasks A and B; add dependency A→B via API — dependency persists; GET task B predecessors returns A
- **(A)** Add dependency, new session, query predecessors — dependency still exists

---

### COR-2-VS2. Cycle rejection
**Validates:** Adding a dependency that would create a cycle is rejected

**Scenarios:**
- **(A)** Add A→B, then add B→A — second add returns 400 or 409 with cycle error
- **(A)** Add A→B→C, then add C→A — rejected; graph remains acyclic
- **(A)** After rejected add, query graph — no cycle; A, B, C have correct predecessor/successor sets

---

### COR-2-VS3. Blocked status
**Validates:** A task with at least one undone predecessor is shown as blocked

**Scenarios:**
- **(A)** Create A (To Do), B (To Do); add A→B; list tasks — B has blocked=true, blocking=[A]
- **(A)** Set A to Done; list tasks — B has blocked=false
- **(A)** Add A→B, B→C; A and B To Do — C blocked; A Done — B unblocked, C still blocked

---

### COR-2-VS4. Dependency queries
**Validates:** A user can query which tasks block a given task and which tasks it blocks

**Scenarios:**
- **(A)** A→B→C; GET /tasks/B/predecessors — returns [A]; GET /tasks/B/successors — returns [C]
- **(A)** Task with no dependencies — predecessors and successors return []
- **(A)** Remove A→B; query B predecessors — A no longer in list

---

### COR-2-VS5. Blocked tasks surfaced in listings
**Validates:** Blocked tasks and their unsatisfied dependencies are surfaced when listing tasks

**Scenarios:**
- **(A)** A (To Do)→B; list tasks — response includes B with blocked=true and blocking task ids or refs
- **(A)** Filter list by blocked=true — returns only blocked tasks
- **(A)** List includes for each blocked task the list of blocking (undone) predecessors

---

## Execution Notes

**Prerequisites:** Task management service with COR-1 implemented (task CRUD, status). Dependency API endpoints available (e.g., POST /tasks/{id}/dependencies, GET /tasks/{id}/predecessors, GET /tasks/{id}/successors).

**Ordering:** Create tasks first. Add dependencies before testing cycle rejection. Blocked status scenarios depend on task status and dependency graph.

**Human-only:** None required for core exit criteria.
