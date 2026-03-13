# IDE-2: Inline Notifications

**Goal:** Surface task alerts and dependency changes directly in the IDE so developers respond without checking external tools.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Notification subscription | Register the IDE extension with the core engine to receive dispatched notifications |
| VS Code notification display | Present notifications using the native VS Code notification API |
| Blocked-task alert | Show alerts when a task the user cares about is blocked by a dependency |
| Dependency-change alert | Show alerts when dependencies are added or removed on relevant tasks |
| Assignment alert | Show alerts when a task is assigned to the current user |
| Status-change alert | Show alerts when a task's status changes in a way relevant to the user |
| Non-blocking presentation | Notifications appear without blocking the editor or requiring immediate action |

## Dependencies

- [COR-4](../../COR/COR-4/COR-4.md) — Notification dispatch must exist to feed IDE notifications
- [IDE-1](../IDE-1/IDE-1.md) — Sidebar must be in place as the extension's foundation

## Exit Criteria

- When a task becomes blocked by a dependency, the user sees an in-IDE notification
- When a dependency is added or removed on a relevant task, the user sees an in-IDE notification
- When a task is assigned to the current user, the user sees an in-IDE notification
- When a task's status changes in a relevant way, the user sees an in-IDE notification
- Notifications appear without blocking the editor workflow
- Notifications can be dismissed by the user
