# CLI-2: Board Views

**Goal:** Render kanban and list views in the terminal so teams visualize project state at a glance.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Kanban view | Terminal output showing tasks grouped into columns by status (e.g. Not Started, In Progress, In Review, Done) |
| List view | Terminal output showing tasks in a flat list with key attributes visible |
| Status-based columns | Kanban columns driven by task status from the core engine |
| Filtering | Ability to filter board output by assignee, status, or priority |
| Sort options | Ability to order tasks within views (e.g. by priority, due date, or creation order) |
| Empty-state handling | Clear indication when no tasks match the current view or filters |

## Dependencies

- [CLI-1](../CLI-1/CLI-1.md) — Task commands must exist before board views can display them

## Exit Criteria

- User can invoke a command and see a kanban-style layout with tasks in status columns
- User can invoke a command and see a list-style layout with tasks and their attributes
- User can apply filters and see only matching tasks in either view
- User can change sort order and see tasks reordered accordingly
- Empty or filtered-out result shows a clear message instead of a blank screen
