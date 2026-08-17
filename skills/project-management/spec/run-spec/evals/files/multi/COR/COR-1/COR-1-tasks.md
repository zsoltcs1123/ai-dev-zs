# Task Plan: COR-1 Task Management

## Summary

Decompose the Task Management feature into tasks for task model, CRUD, assignment, prioritization, and filtering — with validation checkpoints at integration boundaries.

| # | Item | Type | Depends on | Status |
| --- | --- | --- | --- | --- |
| [1](#1-define-task-model) | Define task model | Task | None | |
| [2](#2-implement-task-crud) | Implement task CRUD | Task | 1 | |
| [3](#3-implement-assignment) | Implement assignment | Task | 2 | |
| [4](#4-implement-prioritization) | Implement prioritization | Task | 2 | |
| [VC1](#vc1-validation-checkpoint-crud-assignment-prioritization) | Validation Checkpoint: CRUD, assignment, prioritization | Validation Checkpoint | 3, 4 | |
| [5](#5-implement-filtering) | Implement filtering | Task | 3, 4 | |

## Tasks & Validation Checkpoints

### 1. Define task model
Define the data structure for tasks with required fields (title, status, project association) and optional metadata. Establishes the foundation for all task operations.

**Steps:**
1. Define the task schema with required fields: title, status, project association
2. Add optional metadata fields (e.g., description, due date, tags)
3. Establish persistence mapping for the task entity

**Implementation requirements:**
- Task entity has non-null title, status, and project reference
- Status field supports at least the values needed for workflow (e.g., Backlog, To Do, In Progress, Done)
- Optional metadata is extensible without schema migration for common extensions

**Test coverage:**
- Task model validation — unit tests; ensures required fields and constraints are enforced
- Persistence mapping — integration test; verifies round-trip serialization

**Verification scenarios:**
- Create task with required fields only — persists and retrieves correctly
- Create task with invalid or missing required field — validation rejects
- Create task with optional metadata — metadata persists and retrieves

**Depends on:** None

---

### 2. Implement task CRUD
Create, read, update, and delete operations for tasks with persistence. Tasks can be created, retrieved, updated, and deleted; changes persist across sessions.

**Steps:**
1. Implement create operation with validation of required fields
2. Implement read operations (by id, by project)
3. Implement update operation with partial update support
4. Implement delete operation with cascade or orphan handling as defined
5. Ensure all operations persist to storage and survive session boundaries

**Implementation requirements:**
- Create returns the persisted task with generated identifier
- Read by id returns null or error when task does not exist
- Update applies only to provided fields; unchanged fields retain values
- Delete removes the task from storage; subsequent reads return not-found

**Test coverage:**
- CRUD operations — integration tests; persistence and retrieval correctness
- Update partial fields — unit test; ensures only specified fields change

**Verification scenarios:**
- Create task, retrieve in same session — returns correct data
- Create task, start new session, retrieve — task persists across sessions
- Update task fields — changes persist; unmodified fields unchanged
- Delete task — task removed; subsequent get returns not-found

**Depends on:** 1

---

### 3. Implement assignment
Assign tasks to team members and reassign them. Assignment persists and is queryable.

**Steps:**
1. Add assignee field to task (reference to team member or user)
2. Implement assign and reassign operations
3. Ensure assignment persists and is included in task reads
4. Support unassign (null assignee)

**Implementation requirements:**
- Assignee field references a valid team member entity
- Assignment and reassignment update the task in storage
- Unassign sets assignee to null; task remains otherwise unchanged

**Test coverage:**
- Assignment operations — unit tests; assign, reassign, unassign behavior
- Assignment persistence — integration test; assignment survives session

**Verification scenarios:**
- Assign task to user — assignment persists; task read returns assignee
- Reassign task to different user — new assignee persists
- Unassign task — assignee cleared; task still retrievable

**Depends on:** 2

---

### 4. Implement prioritization
Set and update task priority with ordering support. Priority affects sort order when listing tasks.

**Steps:**
1. Add priority field to task with ordering semantics
2. Implement set-priority and update-priority operations
3. Ensure listing/sort operations order by priority correctly
4. Define priority scale (e.g., numeric or enum with order)

**Implementation requirements:**
- Priority field has defined scale and default value
- List operations support sort-by-priority; higher priority first (or configurable)
- Priority updates persist immediately

**Test coverage:**
- Priority ordering — unit tests; sort order correctness
- Priority persistence — integration test; priority survives session

**Verification scenarios:**
- Set priority on task — persists; listing shows correct order
- Update priority — new value persists; sort order updates
- List tasks with mixed priorities — returned in correct order

**Depends on:** 2

---

### VC1. Validation Checkpoint: CRUD, assignment, prioritization

**After tasks:** 3, 4

**What to validate:** Independent work on assignment and prioritization merges; verify both features work together with CRUD before adding filtering.

**Validation scenarios:**

- Create a task, assign it to a user, set priority — task persists with both assignment and priority; listing returns correct sort order
- Update task assignee and priority — both changes persist and are reflected in queries

---

### 5. Implement filtering
Filter tasks by status, assignee, priority, and other criteria. Filter results are correct and consistent with stored data.

**Steps:**
1. Add filter parameters to list/query operations (status, assignee, priority)
2. Implement filter application in query layer
3. Support combination of filters (AND semantics)
4. Ensure filtered results match stored data

**Implementation requirements:**
- Filter by status returns only tasks with that status
- Filter by assignee returns only tasks assigned to that user
- Filter by priority returns only tasks with that priority
- Combined filters apply AND logic; empty filter returns unfiltered (or default) set

**Test coverage:**
- Filter logic — unit tests; each filter type produces correct subset
- Combined filters — integration test; AND semantics and correctness

**Verification scenarios:**
- Filter by status — returns only matching tasks
- Filter by assignee — returns only tasks for that assignee
- Filter by priority — returns only tasks with that priority
- Filter by status + assignee — returns intersection
- No filter — returns all tasks (or paginated default)

**Depends on:** 3, 4

---
