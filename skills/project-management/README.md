# Project Management Skills

Layered skills for AI-assisted development — successive refinement from raw idea to shipped code.

Every skill is **standalone** — it takes input, produces output to chat, and has no dependencies on other skills. An orchestrator or the user sequences them.

Ported from [anneal](https://github.com/AiDev-Zs/anneal).

## Quick Start

**New project:**

1. `plan-vision` — define problem and direction (conversational)
2. `plan-architecture` — define technical structure (conversational)
3. `run-plan` — generates feature inventory, feature specs, workstream roadmaps, and project roadmap

**Ready to build a feature:**

4. `spec-tasks` — decompose feature into ordered tasks
5. `spec-task` — detail each task with steps, requirements, and verification
6. `spec-validations` — derive acceptance scenarios from exit criteria
7. `implement` / `implement-tdd` — write code and tests
8. `review` — check changes against standards
9. `run-validations` — run acceptance scenarios against running software
10. `finalize` — commit

**Need to change the plan?** Use `update-plan` — it identifies the right skill invocations and cascade chain for any mutation.

## Pipeline

Four layers, each adding concreteness. Output of one layer feeds into the next.

```
Idea → Plan → Spec → Exec
```

### Idea (highest abstraction)

Capture and explore ideas. No structure, no commitments.

| Skill          | Input            | Output                                          |
| -------------- | ---------------- | ----------------------------------------------- |
| `capture-idea` | Freeform text    | Bullet points                                   |
| `vibe-plan`    | Idea or freeform | Vibe plan (with optional suggested workstreams) |

### Plan (high abstraction)

Define the project's vision, architecture, features, and roadmap. The first two skills are **conversational** — they explore decisions through guided dialogue. From `plan-features` onward, skills are **generative** — upstream docs contain enough context to produce output directly.

| Skill                     | Input                           | Output                                  | Mode           |
| ------------------------- | ------------------------------- | --------------------------------------- | -------------- |
| `plan-vision`             | Freeform / idea / vibe plan     | VISION.md                               | Conversational |
| `plan-architecture`       | VISION (required)               | ARCHITECTURE.md                         | Conversational |
| `plan-features`           | VISION + ARCHITECTURE           | Feature map (workstreams + features)    | Generative     |
| `plan-feature`            | Feature code + context          | Feature spec (`{WS}-{N}.md`)            | Generative     |
| `plan-workstream-roadmap` | VISION + features (pre-defined) | Workstream roadmap                      | Generative     |
| `plan-roadmap`            | Workstream roadmaps + VISION    | Project roadmap                         | Generative     |
| `run-plan`                | VISION + ARCHITECTURE           | All plan artifacts (features, roadmaps) | Orchestrator   |
| `update-plan`             | Description of what changed     | Cascaded updates to affected artifacts  | Orchestrator   |

**Typical sequence for a new project:**

1. `plan-vision` — define the problem and direction
2. `plan-architecture` — define technical structure
3. `plan-features` — decompose into workstreams and features
4. `plan-feature` (repeated) — fully spec each feature
5. `plan-workstream-roadmap` (per workstream) — group features into milestones
6. `plan-roadmap` — aggregate workstreams (multi-workstream projects only)

Steps 3-5 often iterate — defining features may reveal the need for workstream restructuring or milestone changes.

### Spec (medium-to-low abstraction, codebase-aware)

Decompose work into tasks, detail them, and derive validations. All skills operate in codebase context.

| Skill              | Input                    | Output                                        |
| ------------------ | ------------------------ | --------------------------------------------- |
| `spec-tasks`       | Feature / milestone      | Task plan with VCs (`{feature}-tasks.md`)     |
| `spec-task`        | Single task or task list | Detailed task(s) with verification scenarios  |
| `spec-validations` | Feature / milestone      | Validation suite (`{feature}-validations.md`) |

**Typical sequence for a feature:**

1. `spec-tasks` — decompose into ordered tasks with validation checkpoints
2. `spec-task` — detail each task (steps, requirements, verification scenarios)
3. `spec-validations` — derive feature-level validation scenarios from exit criteria

### Exec

Drives spec artifacts to shipped code.

```
Implement → Review → [loop if issues] → Validate → Finalize
```

| Step      | What happens                                                  | Skill             |
| --------- | ------------------------------------------------------------- | ----------------- |
| Implement | Write code and tests. Iterate until tests and lint are green. | `implement`       |
| Review    | Review changes. If issues found, loop back to Implement.      | `review`          |
| Validate  | Run validation scenarios against the built software.          | `run-validations` |
| Finalize  | Commit changes.                                               | `finalize`        |

`implement-tdd` is an alternative to `implement` that follows a red-green-refactor cycle.

## Reference Docs

- [project-management.md](project-management.md) — Artifact hierarchy, naming conventions, file layout, and status tracking template. Projects adopting this system should copy and adapt it. Skills embed the key PM facts they need inline — they do not read this file at runtime.
- [system-limits.md](system-limits.md) — Observed scaling behavior of the `run-plan` pipeline and project size guidelines.

## Plan Mutations

`update-plan` is an orchestrator skill that handles mutations to planning and spec artifacts after initial generation. It maps common changes (add/remove/update features, workstreams, roadmaps, tasks, validations) to the correct skill invocations and their cascade chains — what to touch, in what order, and what downstream (or upstream) artifacts to update.
