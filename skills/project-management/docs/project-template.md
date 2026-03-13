# Project Management

How work is organized: abstraction hierarchy, naming, file layout, status tracking, and how artifacts relate.

## Foundational Documents

Two documents sit outside the work hierarchy but feed into it:

| Artifact                             | What It Is                                                        | Consumed By                   |
| ------------------------------------ | ----------------------------------------------------------------- | ----------------------------- |
| **Vision** (`VISION.md`)             | Problem, scope, strategic direction. Rarely changes.              | Architecture, Roadmap         |
| **Architecture** (`ARCHITECTURE.md`) | High-level components, interactions, technology choices. No code. | Roadmap, Features, Task plans |

These are not managed work items — they have no status tracking and no IDs.

## Hierarchy

Five levels, top to bottom:

| Level                | ID Pattern      | What It Is                                                           | Owns                                                    |
| -------------------- | --------------- | -------------------------------------------------------------------- | ------------------------------------------------------- |
| Roadmap              | —               | Sequences project milestones across workstreams                      | Wall-clock timeline, cross-workstream schedule          |
| Project Milestone    | `MS-{N}`        | Cross-workstream release gate (e.g. "Infra Validated", "v1 Release") | Success criteria spanning all workstreams               |
| Workstream Milestone | `MS-{WS}-{N}`   | Release gate within a single workstream; groups features             | Success criteria (union of its features' exit criteria) |
| Feature              | `{WS}-{N}`      | Discrete deliverable with its own goal and exit criteria             | Deliverables, exit criteria, tasks, validation suite    |
| Task                 | `{N}` (integer) | Implementation step within a feature; ordered by dependency          | Steps (3–7 each), implementation requirements           |

Project milestones aggregate workstream milestones. For example, `MS-1` might contain `MS-PLT-1`, `MS-PLT-2` from one workstream plus `MS-IDX-1` from another.

For single-workstream projects, project milestones and workstream milestones collapse into one level. Use `MS-{N}` directly.

**Validation suite** is not a hierarchy level — it's a companion artifact on the feature level. A set of behavioral scenarios (`{FEATURE}-VS{N}`) derived from the feature's exit criteria that validate the full feature functionality end-to-end. The feature-prefixed ID makes scenarios globally addressable (e.g. "run PLT-1-VS1 through VS5").

## Naming Conventions

| Artifact             | Pattern                             | Examples                 |
| -------------------- | ----------------------------------- | ------------------------ |
| Project Milestone    | `MS-{N}`                            | `MS-1`, `MS-2`           |
| Workstream Milestone | `MS-{WS}-{N}`                       | `MS-PLT-1`, `MS-IDX-2`   |
| Feature              | `{WS}-{N}`                          | `PLT-1`, `IDX-3`         |
| Task                 | Sequential integer within task plan | Task 1, Task 2           |
| Validation scenario  | `{FEATURE}-VS{N}`                   | `PLT-1-VS1`, `IDX-3-VS4` |

`{WS}` is a short uppercase code for the workstream (e.g. `PLT`, `IDX`, `API`). Define codes per project.

## File Layout

```
docs/project/
  VISION.md                           # Problem, scope, strategic direction
  ARCHITECTURE.md                     # Components, interactions, tech choices
  ROADMAP.md                          # Composite roadmap (multi-workstream projects)
  {workstream}/
    {workstream}-roadmap.md           # Workstream roadmap (milestones + features)
    {feature-code}/
      {feature-code}.md               # Feature spec (goal, deliverables, exit criteria)
      {feature-code}-tasks.md         # Task plan (ordered tasks)
      {feature-code}-validations.md   # Validation suite (VS scenarios)
```

Not every feature needs all three files. Small features may only have the feature spec. Task plans and validation suites are added when the feature is complex enough to warrant them.

Single-workstream projects can flatten the layout — `docs/project/ROADMAP.md` with feature folders directly underneath.

## Task Plan Format

A task plan file (`*-tasks.md`) has two parts:

**1. Summary table** — all tasks and validation checkpoints with dependencies and status:

| Column     | Content                                          |
| ---------- | ------------------------------------------------ |
| `#`        | Task number or `VC{N}` (links to detail heading) |
| Item       | Imperative-mood title                            |
| Type       | `Task` or `Validation Checkpoint`                |
| Depends on | Task numbers this item requires to be done first |
| Status     | `DONE`, `IN PROGRESS`, or blank                  |

Validation checkpoints (VCs) are interleaved in the task order at integration boundaries — the first point where independent task chains must work together.

**2. Task details** — one heading per task (`### {N}. {Title}`), each containing:

| Section                         | Purpose                                                  |
| ------------------------------- | -------------------------------------------------------- |
| _(opening paragraph)_           | One-sentence description of what the task does           |
| **Steps**                       | Numbered implementation steps (3–7)                      |
| **Implementation requirements** | Concrete, verifiable constraints the result must satisfy |
| **Verification scenarios**      | How to confirm the task is done (commands, checks)       |
| **Depends on**                  | Which tasks must complete first                          |

VC details follow a lighter format: what to validate, which tasks it gates, and the validation scenarios.

## Status Tracking

Three icons, used consistently across all docs:

| Icon | Meaning     |
| ---- | ----------- |
| ✅   | Done        |
| 🔄   | In Progress |
| ⏳   | Not Started |

Applied to milestones, features, and tasks in roadmaps and task plans.

## Relationships

- A project milestone's success criteria spans all workstreams involved.
- A workstream milestone's success criteria = union of its features' exit criteria.
- A feature's exit criteria drive its validation suite.
- Tasks are ordered by dependency within the task plan.
- The validation suite validates the full feature, not individual tasks.
- Features map 1:1 to git branches (`feat/{feature-code}`).
- Commits reference features via `Ref: {feature-code}` footer.

## Scope Rules

How to decide what level something belongs at:

| If it…                                                             | Then it's a…             |
| ------------------------------------------------------------------ | ------------------------ |
| Has its own exit criteria and deliverables                         | **Feature**              |
| Is a step toward a feature's deliverables                          | **Task**                 |
| Groups features within a workstream into a release gate            | **Workstream Milestone** |
| Aggregates workstream milestones into a cross-cutting release gate | **Project Milestone**    |
