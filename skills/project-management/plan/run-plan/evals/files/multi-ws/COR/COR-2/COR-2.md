# COR-2: Dependency Tracking

**Goal:** Make inter-task dependencies explicit so conflicts and blockers surface at planning time, not during execution.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Dependency model | Directed edge representation between tasks persisted in storage |
| Dependency CRUD | Add and remove dependency links between tasks with validation |
| Circular dependency detection | Validation that rejects or reports cycles when adding dependencies |
| Dependency queries | List predecessors and successors for any task |
| Blocked status | Tasks marked as blocked when any predecessor is not done; surfaced in task listings |
| Conflict surfacing | Ability to surface when a task is blocked and which dependencies are unsatisfied |

## Dependencies

- [COR-1](../COR-1/COR-1.md) — Requires task CRUD to exist before dependencies can reference tasks

## Exit Criteria

- A dependency from one task to another can be added and persisted; it appears in subsequent queries
- Adding a dependency that would create a cycle is rejected or reported
- A task with at least one undone predecessor is shown as blocked
- A user can query which tasks block a given task and which tasks it blocks
- Blocked tasks and their unsatisfied dependencies are surfaced when listing or viewing tasks
