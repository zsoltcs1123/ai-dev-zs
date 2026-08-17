# IDE-3: Status Bar Integration

**Goal:** Display current task status in the VS Code status bar so developers always know what they're working on.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Status bar item | Persistent status bar item showing current task identifier or label |
| Task state indicator | Visual indicator reflecting task state (not started, in progress, in review, done) |
| Reactive updates | Status bar item updates when task context, workspace, or inferred status changes |
| Click-to-open | Clicking the status bar item opens task detail or quick actions |
| Blocked-state indicator | Visual cue when current task is blocked or has dependency warnings |
| Empty state | Graceful display when no task is selected (e.g., "No task" or hides item) |
| Project context | Status bar reflects task for the active project or workspace |

## Dependencies

- [COR-1](../../COR/COR-1/COR-1.md) — Needs task data to display current task status
- [IDE-1](../IDE-1/IDE-1.md) — Extension foundation must exist

## Exit Criteria

- User can see current task and its status in the status bar without opening the sidebar
- Status bar updates when switching tasks or when Git activity changes inferred status
- Clicking the status bar item opens task context (detail view or quick actions)
- User can tell at a glance if their current task is blocked
- Status bar shows an appropriate empty state when no task is selected
