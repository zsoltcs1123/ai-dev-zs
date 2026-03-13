# COR-3: Status Workflow

**Goal:** Enforce configurable status transitions so tasks move through a predictable lifecycle.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Workflow model | Configurable state machine defining allowed status transitions |
| Default workflow | Built-in workflow with states: Backlog, To Do, In Progress, Review, Done |
| Transition enforcement | Status changes validated against the workflow; invalid transitions rejected |
| Transition hooks | Extension point for side effects on status change (e.g., notify assignee) |

## Dependencies

- [COR-1](../COR-1/COR-1.md) — Requires task model with status field

## Exit Criteria

- Status changes that violate the workflow are rejected with a clear error
- The default workflow allows the expected transitions (e.g., To Do → In Progress, but not To Do → Done)
- A custom workflow can be defined and applied to a project
- Transition hooks fire on valid status changes
