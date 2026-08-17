# COR-3: Status Inference

**Goal:** Automatically detect task status from Git activity so the project state stays current without manual updates.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Status Inferrer component | Core component that consumes Git activity from the Git Adapter and produces inferred status for each task |
| Status state model | Canonical set of task statuses (not started, in progress, in review, done) used consistently across the system |
| Branch-to-task mapping | Logic that maps Git branches to tasks using naming conventions so activity on a branch is attributed to the correct task |
| PR-to-status mapping | Logic that infers "in review" status when a task has an open PR and "done" when the PR is merged |
| Status update integration | Flow by which inferred status updates the Task Manager's stored task state so board views and notifications reflect current state |

## Dependencies

- [COR-1](../COR-1/COR-1.md) — Requires tasks to exist before their status can be inferred

## Exit Criteria

- A task with no associated Git activity appears as not started
- A task with an active branch (no PR) appears as in progress
- A task with an open PR appears as in review
- A task with a merged PR appears as done
- Status accuracy (auto-detected vs. manual) meets the vision target of greater than 80 percent
