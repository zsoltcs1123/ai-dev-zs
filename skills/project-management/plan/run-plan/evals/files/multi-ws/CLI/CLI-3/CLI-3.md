# CLI-3: Team Dashboard

**Goal:** Display a unified view of all team members' task status so the whole team has shared visibility.

**Status:** ⏳ Pending

## Deliverables

| Deliverable | Description |
| ----------- | ----------- |
| Dashboard command | Single CLI command that renders the full team dashboard |
| Team member overview | List of team members with their task counts and status distribution |
| Aggregate task summary | Project-wide task counts by status (not started, in progress, in review, done) |
| Assignment view | Tasks grouped by assignee so who-is-working-on-what is visible at a glance |
| Terminal-friendly layout | Dashboard renders clearly in standard terminal with appropriate formatting |

## Dependencies

- [CLI-1](../CLI-1/CLI-1.md) — Task commands provide the data the dashboard aggregates
- [COR-1](../../COR/COR-1/COR-1.md) — Core task data must exist

## Exit Criteria

- User can run a single command and see all team members' task status at a glance
- Dashboard shows task counts per status across the project
- Dashboard shows assignment breakdown (who has what)
- Output is readable in a standard terminal
