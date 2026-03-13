# TaskFlow — Vision

## Problem Statement

**Who:** Small development teams (3-8 people) managing software projects across multiple tools.

**Current state:** Teams juggle tasks across spreadsheets, chat threads, and ad-hoc documents. There is no single place to see what's planned, in progress, or blocked. Status updates happen in meetings, not in the tool. When priorities shift, the team discovers conflicts days later.

**Pain points:**

- No unified view of project state across planning and execution
- Manual status tracking leads to stale information
- Dependencies between tasks are implicit — discovered at conflict time, not planning time
- Context switching between planning tools and development tools wastes time

---

## Vision & Success

**Vision:** A lightweight project management tool that lives where developers already work — in the terminal and IDE — providing real-time visibility into project state without requiring manual status updates.

**Success looks like:** A team of 5 can plan a 3-month project, track daily progress, and surface blockers — all without leaving their development environment or attending a status meeting.

**Metrics:**

| Metric | Target |
| --- | --- |
| Time from task creation to visible on board | < 30 seconds |
| Status accuracy (auto-detected vs. manual) | > 80% |
| Daily active usage per team member | > 3 interactions |
| Time spent in status meetings per week | < 30 min (down from 2+ hrs) |

---

## Scope

### In Scope (v1)

- Task management: create, assign, prioritize, and track tasks
- Board views: kanban and list views with filtering
- Dependency tracking: explicit task dependencies with conflict detection
- Git integration: auto-detect task status from branch and PR activity
- Notifications: in-IDE alerts for blocked tasks and dependency changes
- Team dashboard: unified view of project state for all team members

### Out of Scope

- Time tracking or estimation
- Billing or invoicing
- External client access or portal
- Mobile application
- AI-powered task suggestion or auto-assignment

### Future

- API for third-party integrations
- Custom workflow definitions
- Cross-project portfolio view

---

## Constraints

### Technical

- Must run as a local-first application with optional cloud sync
- CLI and IDE extension are the primary interfaces — no standalone web app in v1
- Must support Git repositories as the source of truth for code activity

### Business

- Solo developer building v1 — scope must be achievable in ~4 months
- Open source under MIT license

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 1.0 | 2026-03-11 | Initial version |
