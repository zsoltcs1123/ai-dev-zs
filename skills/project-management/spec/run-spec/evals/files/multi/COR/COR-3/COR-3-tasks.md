# Task Plan: COR-3 Status Workflow

## Summary

Decompose the Status Workflow feature into tasks for workflow model, default workflow, transition enforcement, and transition hooks — with validation checkpoints at integration boundaries.

| # | Item | Type | Depends on | Status |
| --- | --- | --- | --- | --- |
| [1](#1-define-workflow-model) | Define workflow model | Task | None | |
| [2](#2-implement-default-workflow) | Implement default workflow | Task | 1 | |
| [3](#3-implement-transition-enforcement) | Implement transition enforcement | Task | 2 | |
| [4](#4-implement-custom-workflows) | Implement custom workflows | Task | 2 | |
| [5](#5-implement-transition-hooks) | Implement transition hooks | Task | 3 | |

## Tasks & Validation Checkpoints

### 1. Define workflow model
Configurable state machine defining allowed status transitions. The model supports defining states and valid transitions between them.

**Steps:**
1. Define workflow schema: states and allowed transitions (from-state → to-state)
2. Establish workflow as first-class entity or configuration
3. Support lookup of valid transitions for a given state

**Implementation requirements:**
- Workflow defines finite set of states
- Transitions are explicit (from-state, to-state) pairs
- Model supports query: given state S, what transitions are allowed

**Test coverage:**
- Workflow model — unit tests; valid transitions and state set
- Transition lookup — unit test; returns correct next states

**Verification scenarios:**
- Define workflow with states and transitions — persists and retrieves
- Query allowed transitions from a state — returns correct set

**Depends on:** None

---

### 2. Implement default workflow
Built-in workflow with states: Backlog, To Do, In Progress, Review, Done. The default workflow allows expected transitions (e.g., To Do → In Progress, but not To Do → Done).

**Steps:**
1. Define built-in workflow with states: Backlog, To Do, In Progress, Review, Done
2. Define allowed transitions (e.g., Backlog→To Do, To Do→In Progress, In Progress→Review, Review→Done; plus back-transitions as needed)
3. Ensure To Do → Done is not allowed; To Do → In Progress is allowed
4. Register default workflow as system default

**Implementation requirements:**
- Default workflow is always available
- Transitions match expected lifecycle (To Do → In Progress allowed; To Do → Done rejected)
- Workflow is immutable or versioned

**Test coverage:**
- Default workflow transitions — unit tests; allowed and disallowed pairs
- Transition matrix — unit test; covers all state pairs

**Verification scenarios:**
- To Do → In Progress — allowed
- To Do → Done — rejected
- In Progress → Review — allowed
- Review → Done — allowed

**Depends on:** 1

---

### 3. Implement transition enforcement
Status changes validated against the workflow; invalid transitions rejected. Status changes that violate the workflow are rejected with a clear error.

**Steps:**
1. Intercept status update operations
2. Validate (current status, new status) against workflow
3. Reject invalid transitions with clear error message
4. Apply valid transitions to task

**Implementation requirements:**
- All status changes go through validation
- Invalid transition returns error with current state, requested state, and allowed transitions
- Valid transition persists immediately

**Test coverage:**
- Transition validation — unit tests; valid and invalid cases
- Error message clarity — unit test; includes actionable info

**Verification scenarios:**
- Valid transition — status updates; persists
- Invalid transition — rejected with clear error
- Error message includes which transitions are allowed

**Depends on:** 2

---

### 4. Implement custom workflows
A custom workflow can be defined and applied to a project. Projects can override the default with project-specific workflows.

**Steps:**
1. Add workflow association to project (default or custom)
2. Implement create/update custom workflow operations
3. Resolve workflow for task via project association
4. Apply custom workflow when validating task status changes

**Implementation requirements:**
- Project references a workflow (default or custom)
- Custom workflow has same schema as default (states, transitions)
- Task status validation uses project's workflow

**Test coverage:**
- Custom workflow application — integration test; project uses custom workflow
- Workflow resolution — unit test; project without custom uses default

**Verification scenarios:**
- Create custom workflow, assign to project — project tasks use it
- Custom workflow with different transitions — enforced for that project
- Project without custom — uses default workflow

**Depends on:** 2

---

### 5. Implement transition hooks
Extension point for side effects on status change (e.g., notify assignee). Transition hooks fire on valid status changes.

**Steps:**
1. Define hook registration interface (e.g., on-transition callback)
2. Invoke hooks after successful status transition
3. Pass transition context (task, from-state, to-state, assignee, etc.)
4. Handle hook failures (log, retry, or fail transition per policy)

**Implementation requirements:**
- Hooks are invoked only on valid, persisted transitions
- Hook receives sufficient context for side effects
- Hook failure policy is defined (e.g., log and continue vs fail transition)

**Test coverage:**
- Hook invocation — unit tests; hook called with correct context
- Hook failure handling — unit test; policy applied

**Verification scenarios:**
- Register hook, perform valid transition — hook fires with context
- Hook throws — behavior matches policy (log/fail)
- Invalid transition — hook not invoked

**Depends on:** 3

---
