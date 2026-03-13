# Plan Roadmap — Output Reference

Structure, format, and quality standards for project (cross-workstream) roadmap output.

## Document Header

```markdown
# {Project Name} — Roadmap

> **Status:** Draft vX.Y
> **Date:** YYYY-MM-DD
> **Kickoff:** YYYY-MM-DD
```

- **Status** — `Draft vX.Y` while iterating; change to a release label when finalized.
- **Date** — last meaningful edit.
- **Kickoff** — project start date (optional, useful for timeline context).

## Status Icons

| Icon | Meaning     |
| ---- | ----------- |
| ✅   | Done        |
| 🔄   | In Progress |
| ⏳   | Pending     |

## Section Reference

Start with the Document Header. Use `---` between sections. Required ●, optional ○.

| #   | Section                 | Req | Include When                              | Format                                                                        |
| --- | ----------------------- | --- | ----------------------------------------- | ----------------------------------------------------------------------------- |
| 1   | Overview                | ●   | Always                                    | Scope, key principles, workstream table linking to sub-roadmaps               |
| 2   | Schedule                | ●   | Always                                    | Cross-workstream schedule table (see format below)                            |
| 3   | Milestones              | ●   | Always                                    | Per-milestone detail: goal, workstream activities, success criteria            |
| 4   | Development Constraints | ○   | Team size, estimation units matter        | Team size, estimation unit, buffer policy                                     |
| 5   | Parallel Opportunities  | ○   | Team can work on multiple things at once  | `\| Activity \| Can Run Parallel With \|`                                     |
| 6   | External Dependencies   | ○   | Blockers outside your control             | `\| Dependency \| Needed By \| Risk \|`                                       |
| 7   | Risk & Mitigation       | ○   | High-stakes items with known risks        | `\| Milestone \| Risk \| Likelihood \| Mitigation \|`                         |
| 8   | Learning Points         | ○   | Milestones inform subsequent decisions    | `\| Milestone \| What We Learn \| Informs \|`                                 |
| 9   | Future Work             | ○   | Known work deferred beyond current scope  | `\| Focus \| Trigger \|`                                                      |
| 10  | Version History         | ●   | Always                                    | `\| Version \| Date \| Changes \|` — latest on top                            |

## Overview: Workstream Table

```markdown
| Workstream   | Scope                          | Detailed Roadmap                       |
| ------------ | ------------------------------ | -------------------------------------- |
| **{Name}**   | {brief scope description}      | [{Name} Roadmap]({path})               |
| **{Name}**   | {brief scope description}      | TBD                                    |
```

Include key principles and development constraints inline when they set important context for the schedule.

## Schedule Table

Cross-workstream schedule showing what runs in parallel. One column per workstream plus milestone metadata. Effort estimates are NOT included — those live in workstream roadmaps. The project roadmap owns wall-clock timeline only.

```markdown
| Milestone                    | Duration | Team     | {WS-1}                           | {WS-2}                     | {WS-3}          |
| ---------------------------- | -------- | -------- | --------------------------------- | --------------------------- | ---------------- |
| 🔄 [MS-1](#ms-1-name): Name | ~X mo    | N devs   | 🔄 [MS-{WS}-1][] <br> ⏳ [MS-{WS}-2][] | {activity description}      | {activity}       |
| ⏳ [MS-2](#ms-2-name): Name  | ~Y mo    | N devs   | ⏳ [MS-{WS}-3][]                  | {activity}                  | {activity}       |
```

Workstream cells reference workstream milestones (link to sub-roadmap) with status icons. When a workstream has no formal milestones for a period, use a brief activity description instead.

## Milestone Detail

Per project milestone:

```markdown
### {icon} MS-{N}: {Name}

**Goal:** {One sentence: what this project milestone achieves as a cross-workstream gate.}

**Wall-clock estimate:** ~{N} sprints ({N} weeks)

| Workstream | Activity |
| ---------- | -------- |
| {Name}     | [MS-{WS}-{N}][]: {description} |

**Success criteria:**

- {Criterion spanning all workstreams involved}
- {Another criterion}
```

Success criteria must span workstreams — they are the union of the relevant workstream milestones' success criteria, plus any cross-cutting requirements.

## Quality Standards

**Each project milestone must have:** goal, wall-clock estimate, workstream activity table, success criteria.

**The project roadmap must NOT:**

- Define features (those live in workstream roadmaps)
- Own effort estimates (those live in workstream roadmaps)
- Duplicate workstream-level detail — reference it instead

**Avoid:**

- Project milestones that aggregate too many workstream milestones (keep it scannable)
- Timelines without buffer (include ~50% headroom for unknowns)
- Risks without mitigation
- Missing cross-workstream dependencies
