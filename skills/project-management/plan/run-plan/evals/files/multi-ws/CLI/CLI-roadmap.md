# CLI App — Roadmap

> **Status:** Draft v1.0
> **Date:** 2026-03-11
> **Parent:** [ROADMAP](../ROADMAP.md)

---

## Overview

The CLI App workstream delivers the terminal interface for TaskFlow, enabling developers to manage tasks, view boards, and see team status without leaving the terminal. It is a thin presentation layer over the Core Engine, using Commander.js for commands and delegating all domain logic to the shared core.

Sequencing follows a foundation-then-visualization approach. CLI-1 (Task Commands) establishes the full task lifecycle (create, list, show, update, delete) and must ship first. CLI-2 (Board Views) and CLI-3 (Team Dashboard) both depend on CLI-1 for task data and commands; they add kanban/list views and a unified team overview, and can be delivered together in the second milestone.

---

## Milestones

| Milestone | Name | Features | Key Outcomes |
| --------- | ---- | -------- | ------------ |
| ⏳ [MS-CLI-1](#ms-cli-1-task-commands-foundation) | Task Commands (Foundation) | ⏳ [CLI-1](CLI-1/CLI-1.md) | Full task CRUD from terminal; tasks persist; filtering and single-task detail with dependencies |
| ⏳ [MS-CLI-2](#ms-cli-2-board-views--team-dashboard) | Board Views & Team Dashboard | ⏳ [CLI-2](CLI-2/CLI-2.md) <br> ⏳ [CLI-3](CLI-3/CLI-3.md) | Kanban and list views with filtering/sorting; team dashboard with aggregate status and assignment breakdown |

---

## MS-CLI-1: Task Commands (Foundation)

**Features:** [CLI-1](CLI-1/CLI-1.md)

**Key outcomes:** Users can create, list, show, update, and delete tasks via CLI. Tasks persist across sessions. List supports filtering by status, assignee, or project. Single-task view shows full details including dependencies.

---

## MS-CLI-2: Board Views & Team Dashboard

**Features:** [CLI-2](CLI-2/CLI-2.md), [CLI-3](CLI-3/CLI-3.md)

**Key outcomes:** Users can render kanban and list views in the terminal with status-based columns, filtering, and sort options. Users can run a team dashboard command to see project-wide task counts by status and assignment breakdown.

---

## Version History

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2026-03-11 | Initial version |
