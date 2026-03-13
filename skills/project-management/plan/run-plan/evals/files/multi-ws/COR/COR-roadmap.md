# Core Engine — Roadmap

> **Status:** Draft v1.0
> **Date:** 2026-03-11
> **Parent:** [ROADMAP](../ROADMAP.md)

---

## Overview

The Core Engine workstream delivers the domain logic layer of TaskFlow: task management, dependency resolution, status inference, and notification dispatch. All interfaces (CLI and IDE extension) delegate to this engine, which remains interface-agnostic.

The roadmap is sequenced in two milestones. The first establishes the foundation — task CRUD, assignment, prioritization, and explicit dependency tracking with conflict detection. The second builds on that foundation by adding automatic status inference from Git activity and a notification hub that alerts team members to blocked tasks and dependency changes. This order ensures Status Inferrer and Notification Hub have a stable task model and dependency graph to operate on.

---

## Milestones

| Milestone | Name | Features | Key Outcomes |
| --------- | ---- | -------- | ------------ |
| ⏳ [MS-COR-1](#ms-cor-1-foundation) | Foundation | ⏳ [COR-1](COR-1/COR-1.md) <br> ⏳ [COR-2](COR-2/COR-2.md) | Task CRUD, assignment, prioritization, and filtering; explicit dependencies with cycle detection; blocked status surfaced |
| ⏳ [MS-COR-2](#ms-cor-2-intelligence) | Intelligence | ⏳ [COR-3](COR-3/COR-3.md) <br> ⏳ [COR-4](COR-4/COR-4.md) | Auto-inferred status from Git (branch/PR); notifications for blocked tasks, dependency changes, assignments, and status changes |

---

## MS-COR-1: Foundation

**Features:** [COR-1](COR-1/COR-1.md), [COR-2](COR-2/COR-2.md)

Task management and dependency tracking form the base layer. COR-1 delivers the task model, CRUD, assignment, prioritization, and filtering. COR-2 adds directed dependencies between tasks, circular dependency detection, and blocked-status surfacing. Together they provide the data and domain rules that all downstream components depend on.

---

## MS-COR-2: Intelligence

**Features:** [COR-3](COR-3/COR-3.md), [COR-4](COR-4/COR-4.md)

Status inference and notification dispatch layer on top of the foundation. COR-3 maps Git activity (branches, PRs) to task status (not started, in progress, in review, done). COR-4 evaluates triggers (blocked task, dependency change, assignment, status change) and dispatches notifications to registered interfaces. Both require the task model and dependency graph from MS-COR-1.

---

## Version History

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2026-03-11 | Initial version |
