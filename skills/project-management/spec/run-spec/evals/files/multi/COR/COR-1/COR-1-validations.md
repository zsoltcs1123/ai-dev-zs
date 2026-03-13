# Validation Scenarios: COR-1 Task Management

## Summary

Validation scenarios for the Task Management feature. These scenarios verify that tasks can be created, persisted, filtered, assigned, prioritized, updated, and deleted. Scenarios are executable against the running task management API or service.

## Exit Criteria Source

[COR-1.md](COR-1.md) — Task Management feature spec

## Automation Legend

- **(A)** — Agent-executable: can be validated via shell commands, HTTP requests, or browser interaction
- **(H)** — Human-only: requires commits, CI triggers, or external tooling

## Scenarios

### COR-1-VS1. Task persistence across sessions
**Validates:** A task can be created, persisted, and retrieved in a subsequent session

**Scenarios:**
- **(A)** Create a task via API with title, status, project — returns 201 with task id; GET by id returns task with same data
- **(A)** Create task, restart service or new session, GET by id — task still exists with correct data

---

### COR-1-VS2. Filtering by status, assignee, and priority
**Validates:** Tasks can be filtered by status, assignee, and priority with correct results

**Scenarios:**
- **(A)** Create tasks with different statuses; GET /tasks?status=InProgress — returns only In Progress tasks
- **(A)** Create tasks assigned to user A and B; GET /tasks?assignee=A — returns only A's tasks
- **(A)** Create tasks with priorities 1, 2, 3; GET /tasks?priority=2 — returns only priority-2 tasks
- **(A)** Filter by status + assignee — returns intersection; empty if no match

---

### COR-1-VS3. Assignment persistence
**Validates:** A task can be assigned to a team member and the assignment persists

**Scenarios:**
- **(A)** Create task, assign to user U via API — task read returns assignee U
- **(A)** Assign task, new session, read task — assignee still U
- **(A)** Reassign to different user — new assignee persists

---

### COR-1-VS4. Priority affects sort order
**Validates:** Task priority affects sort order when listing tasks

**Scenarios:**
- **(A)** Create tasks with priorities 3, 1, 2; list with sort=priority — returned in order 1, 2, 3 (or 3, 2, 1 if high-first)
- **(A)** Update task priority — subsequent list reflects new order

---

### COR-1-VS5. Update and delete persistence
**Validates:** A task can be updated and deleted; changes persist and deletions remove the task from queries

**Scenarios:**
- **(A)** Update task title and status — GET returns updated values; persists across session
- **(A)** Delete task — GET by id returns 404; list does not include deleted task
- **(A)** Delete task, create new task — new task gets distinct id; no collision

---

## Execution Notes

**Prerequisites:** Task management API or service running (e.g., `http://localhost:8080` or equivalent). Project and user/team member entities must exist for assignment and project association.

**Ordering:** Create tasks first; filtering and listing scenarios depend on existing data. Delete scenarios can run last to avoid affecting other tests.

**Human-only:** Scenarios tagged (H) would apply if validation requires CI, commits, or external tooling; none required for core exit criteria.
