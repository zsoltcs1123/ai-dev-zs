# COR-4: Notification Dispatch

**Goal:** Alert team members to blocked tasks and dependency changes so issues are addressed before they cascade.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Notification model | Data structure for notifications with trigger context and metadata |
| Notification persistence | Persist notifications until dismissed with storage and retrieval |
| Trigger evaluation | Logic to detect blocked-task, dependency-change, assignment, and status-change events |
| Interface registration | Allow CLI and IDE to register as notification receivers |
| Dispatch mechanism | Route notifications to registered interfaces when triggers fire |
| Blocked-task notification | Generate and dispatch when a task is blocked by a dependency |
| Dependency-change notification | Generate and dispatch when dependencies are added or removed |
| Assignment notification | Generate and dispatch when a task is assigned to a user |
| Status-change notification | Generate and dispatch when a task's status changes |

## Dependencies

- [COR-1](../COR-1/COR-1.md) — Needs tasks to exist for triggering notifications
- [COR-2](../COR-2/COR-2.md) — Needs dependency data for blocked-task alerts

## Exit Criteria

- When a task becomes blocked by a dependency, a notification is generated and delivered to registered interfaces
- When a dependency is added or removed, affected assignees receive a notification
- When a task is assigned to a user, that user receives a notification
- When a task's status changes, relevant parties receive a notification
- Notifications persist until dismissed and can be retrieved
- Registered interfaces receive notifications through the dispatch mechanism
- Notifications include sufficient trigger context for the recipient to act
