# TaskFlow — Roadmap

> **Status:** Draft v1.0
> **Date:** 2026-03-11

---

## Overview

TaskFlow is a local-first project management tool with three workstreams: Core Engine (domain logic), CLI App (terminal interface), and IDE Extension (VS Code interface). The Core Engine must deliver its foundation before interfaces can build on it, but within each milestone the CLI and IDE workstreams can progress in parallel.

| Workstream | Scope | Detailed Roadmap |
| ---------- | ----- | ---------------- |
| **Core Engine** | Task management, dependency tracking, status inference, notifications | [Core Engine Roadmap](COR/COR-roadmap.md) |
| **CLI App** | Terminal commands, board views, team dashboard | [CLI App Roadmap](CLI/CLI-roadmap.md) |
| **IDE Extension** | Sidebar views, inline notifications, status bar integration | [IDE Extension Roadmap](IDE/IDE-roadmap.md) |

**Key principle:** The Core Engine is interface-agnostic. CLI and IDE workstreams are thin presentation layers — they start once the corresponding core milestones deliver stable APIs.

---

## Schedule

| Milestone | Duration | Core Engine | CLI App | IDE Extension |
| --------- | -------- | ----------- | ------- | ------------- |
| ⏳ [MS-1](#ms-1-foundation) | ~6 weeks | ⏳ [MS-COR-1](COR/COR-roadmap.md) | ⏳ [MS-CLI-1](CLI/CLI-roadmap.md) | ⏳ [MS-IDE-1](IDE/IDE-roadmap.md) |
| ⏳ [MS-2](#ms-2-intelligence-and-experience) | ~6 weeks | ⏳ [MS-COR-2](COR/COR-roadmap.md) | ⏳ [MS-CLI-2](CLI/CLI-roadmap.md) | ⏳ [MS-IDE-2](IDE/IDE-roadmap.md) |

---

## Milestones

### ⏳ MS-1: Foundation

**Goal:** Deliver the core task management and dependency tracking engine alongside functional CLI and IDE interfaces for basic task operations.

**Wall-clock estimate:** ~6 weeks (with ~50% buffer for unknowns)

| Workstream | Activity |
| ---------- | -------- |
| Core Engine | [MS-COR-1](COR/COR-roadmap.md): Task CRUD, assignment, prioritization, dependency tracking with cycle detection |
| CLI App | [MS-CLI-1](CLI/CLI-roadmap.md): Full task lifecycle commands in terminal; starts after COR-1 delivers task APIs |
| IDE Extension | [MS-IDE-1](IDE/IDE-roadmap.md): Sidebar board view, task detail panel, quick-edit; starts after COR-1 delivers task APIs |

**Success criteria:**

- Tasks can be created, assigned, prioritized, and tracked through both CLI and IDE
- Dependencies between tasks are explicit and circular dependencies are detected
- Board view and task detail are visible in the VS Code sidebar
- All task operations persist to local SQLite storage

---

### ⏳ MS-2: Intelligence and Experience

**Goal:** Add automatic status inference from Git activity, notifications for blockers and changes, plus richer visualization (board views, dashboard, status bar) across both interfaces.

**Wall-clock estimate:** ~6 weeks (with ~50% buffer for unknowns)

| Workstream | Activity |
| ---------- | -------- |
| Core Engine | [MS-COR-2](COR/COR-roadmap.md): Git-based status inference, notification dispatch for blocked tasks and dependency changes |
| CLI App | [MS-CLI-2](CLI/CLI-roadmap.md): Kanban/list board views with filtering, team dashboard |
| IDE Extension | [MS-IDE-2](IDE/IDE-roadmap.md): Inline notifications, status bar integration |

**Success criteria:**

- Task status auto-updates from Git branch and PR activity with >80% accuracy
- Blocked tasks and dependency changes trigger notifications in both CLI and IDE
- Terminal kanban and list views render correctly with filtering and sorting
- Team dashboard shows unified project state across all team members
- Status bar in VS Code shows current task and state

---

## Version History

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2026-03-11 | Initial version |
