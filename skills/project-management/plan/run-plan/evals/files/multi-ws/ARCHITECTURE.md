# TaskFlow — Architecture

## System Overview

TaskFlow is a local-first project management tool with two primary interfaces (CLI and IDE extension) backed by a shared core engine. The core engine owns all domain logic — task management, dependency resolution, and status inference. Interfaces are thin presentation layers that delegate to the core.

```
┌──────────────┐    ┌──────────────┐
│   CLI App    │    │ IDE Extension│
└──────┬───────┘    └──────┬───────┘
       │                   │
       └─────────┬─────────┘
                 │
       ┌─────────▼─────────┐
       │    Core Engine     │
       │  (domain logic)    │
       ├────────────────────┤
       │ Task Manager       │
       │ Dependency Resolver│
       │ Status Inferrer    │
       │ Notification Hub   │
       └─────────┬─────────┘
                 │
       ┌─────────▼─────────┐
       │   Storage Layer    │
       │  (SQLite + sync)   │
       └─────────┬─────────┘
                 │
       ┌─────────▼─────────┐
       │   Git Adapter      │
       │ (branch/PR reader) │
       └────────────────────┘
```

**Core principle:** The core engine is interface-agnostic. Adding a new interface (web, mobile) requires only a new presentation layer — no changes to domain logic.

---

## Technology Stack

| Layer | Technology | Rationale |
| --- | --- | --- |
| Language | TypeScript | Shared across CLI, IDE extension, and potential future web UI |
| CLI framework | Commander.js | Lightweight, well-documented, sufficient for task management commands |
| IDE extension | VS Code Extension API | Primary target IDE; largest developer market share |
| Storage | SQLite (via better-sqlite3) | Local-first, zero-config, portable; cloud sync layered on top later |
| Git integration | simple-git | Mature Node.js Git client; reads branches, commits, PRs |
| Notifications | VS Code notification API + terminal alerts | Native to each interface; no external notification service needed |
| Build | tsup | Fast bundler for both CLI and extension outputs |
| Testing | Vitest | Fast, TypeScript-native, compatible with both Node and extension contexts |

---

## Components & Responsibilities

### Core Engine

The domain logic layer. All interfaces delegate to it.

| Component | Responsibility |
| --- | --- |
| Task Manager | CRUD operations on tasks; assignment; prioritization; filtering |
| Dependency Resolver | Track explicit dependencies between tasks; detect circular dependencies; surface conflicts when dependencies are blocked |
| Status Inferrer | Read Git activity (branches, commits, PRs) and infer task status (not started, in progress, in review, done) |
| Notification Hub | Evaluate trigger conditions (blocked dependency, status change, assignment) and dispatch notifications to registered interfaces |

### CLI App

Terminal interface for task management. Provides commands for creating, listing, updating, and viewing tasks. Renders board views (kanban, list) in the terminal.

### IDE Extension

VS Code extension providing sidebar views (board, task detail), inline notifications, and status bar indicators. Communicates with Core Engine as an in-process library.

### Storage Layer

SQLite database for task and project data. Handles schema migrations. Provides a sync protocol for optional cloud backup (out of scope for v1 but the interface is designed to accommodate it).

### Git Adapter

Reads local Git repository state — branches, recent commits, and PR metadata (via remote API when available). Maps Git activity to tasks using branch naming conventions.

---

## Data Architecture

### Primary Entities

| Entity | Storage | Notes |
| --- | --- | --- |
| Project | SQLite | One project per Git repository |
| Task | SQLite | Core unit of work; belongs to a project |
| Dependency | SQLite | Directed edge between two tasks |
| GitActivity | Derived (not stored) | Read from Git adapter on demand; cached in memory |
| Notification | SQLite | Persisted until dismissed; includes trigger context |

### Data Flow

```
Git repo → Git Adapter → Status Inferrer → Task Manager → Storage
                                                ↓
                                        Notification Hub → CLI / IDE
```

---

## Key Decisions & Tradeoffs

| Decision | Rationale | Tradeoff |
| --- | --- | --- |
| Local-first with SQLite | Zero setup for solo devs; no server dependency | Multi-device sync requires additional infrastructure later |
| TypeScript everywhere | Single language across CLI, extension, and core | Heavier runtime than Go/Rust for CLI; acceptable for this use case |
| Git branch naming for task mapping | Convention-based; no explicit linking step | Relies on team discipline; misnamed branches won't map |
| In-process core (no IPC) | Simpler architecture; no server process to manage | IDE extension and CLI can't share runtime state; both read from SQLite |
| Notifications via native APIs | No external service; works offline | Different notification UX per interface; no unified inbox |

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 1.0 | 2026-03-11 | Initial version |
