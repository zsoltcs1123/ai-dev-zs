# IDE Extension — Roadmap

> **Status:** Draft v1.0
> **Date:** 2026-03-11
> **Parent:** [ROADMAP](../ROADMAP.md)

---

## Overview

The IDE Extension workstream delivers the VS Code interface for TaskFlow: sidebar views, inline notifications, and status bar integration. Developers access project state, receive task alerts, and see current work context without leaving the editor.

Features are sequenced in two milestones. IDE-1 (Sidebar Views) establishes the extension foundation — board tree view, task detail panel, and quick-edit — and is required by both IDE-2 and IDE-3. IDE-2 (Inline Notifications) and IDE-3 (Status Bar Integration) build on that foundation, adding notification subscription and status bar display once the core sidebar and task context are in place.

---

## Milestones

| Milestone | Name | Features | Key Outcomes |
| --------- | ---- | -------- | ------------ |
| ⏳ [MS-IDE-1](#ms-ide-1-sidebar-foundation) | Sidebar Foundation | ⏳ [IDE-1](IDE-1/IDE-1.md) | Board tree view in sidebar; task detail panel; inline quick-edit; auto-refresh when task data changes |
| ⏳ [MS-IDE-2](#ms-ide-2-notifications-and-status-bar) | Notifications and Status Bar | ⏳ [IDE-2](IDE-2/IDE-2.md) <br> ⏳ [IDE-3](IDE-3/IDE-3.md) | Inline notifications for blocked tasks, dependencies, assignments, status changes; status bar showing current task and state; click-to-open from status bar |

---

## MS-IDE-1: Sidebar Foundation

Delivers the core sidebar experience: board tree view, task detail panel, and quick-edit with automatic refresh. Establishes the extension foundation required by IDE-2 and IDE-3.

---

## MS-IDE-2: Notifications and Status Bar

Adds inline notifications (blocked-task, dependency-change, assignment, status-change alerts) and status bar integration (current task display, state indicator, click-to-open). Both features depend on IDE-1.

---

## Version History

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2026-03-11 | Initial version |
