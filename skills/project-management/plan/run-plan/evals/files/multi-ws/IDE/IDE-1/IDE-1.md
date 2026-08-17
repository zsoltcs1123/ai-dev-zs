# IDE-1: Sidebar Views

**Goal:** Show board and task detail in the VS Code sidebar so developers access project state without leaving the editor.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Board tree view | A sidebar panel that renders the kanban board as an expandable tree of columns and tasks |
| Task detail panel | A webview panel that displays full task details (assignee, priority, dependencies, status) when a task is selected |
| Task quick-edit | Inline editing of task properties (status, assignee, priority) directly from the sidebar without opening a separate form |
| Refresh and sync | Automatic sidebar refresh when underlying task data changes, keeping the view current without manual reload |

## Dependencies

- [COR-1](../../COR/COR-1/COR-1.md) — Core task data must exist to display in the sidebar

## Exit Criteria

- The sidebar board view displays all tasks grouped by status columns
- Selecting a task in the board view opens its detail panel with correct information
- Editing a task property from the sidebar persists the change and reflects it immediately
- The sidebar updates automatically when tasks are created, modified, or deleted through other interfaces
