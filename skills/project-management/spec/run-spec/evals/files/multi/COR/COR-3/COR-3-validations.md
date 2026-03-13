# Validation Scenarios: COR-3 Status Workflow

## Summary

Validation scenarios for the Status Workflow feature. These scenarios verify that invalid status transitions are rejected, the default workflow enforces expected transitions, custom workflows can be defined and applied, and transition hooks fire on valid changes. Scenarios are executable against the running task management service with workflow support.

## Exit Criteria Source

[COR-3.md](COR-3.md) — Status Workflow feature spec

## Automation Legend

- **(A)** — Agent-executable: can be validated via shell commands, HTTP requests, or browser interaction
- **(H)** — Human-only: requires commits, CI triggers, or external tooling

## Scenarios

### COR-3-VS1. Invalid transition rejection
**Validates:** Status changes that violate the workflow are rejected with a clear error

**Scenarios:**
- **(A)** Task in To Do; PATCH status to Done — returns 400 or 409 with error indicating invalid transition
- **(A)** Error message includes current status, requested status, and allowed transitions
- **(A)** Task in Backlog; PATCH status to Review — rejected (no direct path)

---

### COR-3-VS2. Default workflow transitions
**Validates:** The default workflow allows the expected transitions (e.g., To Do → In Progress, but not To Do → Done)

**Scenarios:**
- **(A)** Task in To Do; PATCH status to In Progress — returns 200; task status is In Progress
- **(A)** Task in To Do; PATCH status to Done — rejected
- **(A)** Task in In Progress; PATCH status to Review — allowed
- **(A)** Task in Review; PATCH status to Done — allowed
- **(A)** Task in Backlog; PATCH status to To Do — allowed

---

### COR-3-VS3. Custom workflow
**Validates:** A custom workflow can be defined and applied to a project

**Scenarios:**
- **(A)** Create custom workflow with states [Draft, Active, Closed] and transitions Draft→Active, Active→Closed
- **(A)** Assign custom workflow to project P; create task in P — task uses custom workflow
- **(A)** Task in Draft; PATCH to Active — allowed
- **(A)** Task in Draft; PATCH to Closed — rejected (no direct transition)
- **(A)** Task in Active; PATCH to Closed — allowed

---

### COR-3-VS4. Transition hooks
**Validates:** Transition hooks fire on valid status changes

**Scenarios:**
- **(A)** Register hook (e.g., log or mock); perform valid transition To Do → In Progress — hook invoked with task, from=To Do, to=In Progress
- **(A)** Perform invalid transition — hook not invoked
- **(A)** Hook receives assignee or other context when available — verify in hook implementation or logs

---

## Execution Notes

**Prerequisites:** Task management service with COR-1 implemented (task model with status field). Workflow API and task status update endpoint available.

**Ordering:** Create tasks first. Test default workflow before custom. Hook validation may require inspectable side effects (logs, test double).

**Human-only:** Hook verification may require (H) if hooks trigger external systems (email, notifications) that require manual verification.
