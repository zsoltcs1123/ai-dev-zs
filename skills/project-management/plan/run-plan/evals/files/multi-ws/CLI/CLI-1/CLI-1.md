# CLI-1: Task Commands

**Goal:** Provide terminal commands for the full task lifecycle so developers manage work without leaving the terminal.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Task add command | Create a new task from the terminal with title, optional assignee, and priority |
| Task list command | List tasks with filtering by status, assignee, or project |
| Task show command | Display full details of a single task including dependencies |
| Task update command | Modify task attributes (status, assignee, priority, title) |
| Task delete command | Remove a task from the project with appropriate handling of dependent tasks |

## Dependencies

- [COR-1](../../COR/COR-1/COR-1.md) — Core task management must exist before CLI can expose it

## Exit Criteria

- User can create a task via CLI and see it persisted
- User can list tasks with filters and see correct results
- User can view a single task and see its details including dependencies
- User can update task attributes and see changes reflected
- User can delete a task and confirm it no longer appears in listings
