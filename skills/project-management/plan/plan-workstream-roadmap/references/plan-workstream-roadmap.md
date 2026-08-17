# Plan Workstream Roadmap — Output Reference

Structure, format, and quality standards for workstream roadmap output.

## Document Header

```markdown
# {Workstream Name} — Roadmap

> **Status:** Draft vX.Y
> **Date:** YYYY-MM-DD
> **Parent:** [ROADMAP](relative/path/to/ROADMAP.md)
```

- **Status** — `Draft vX.Y` while iterating; change to a release label when finalized.
- **Date** — last meaningful edit.
- **Parent** — link to the project roadmap if this is part of a multi-workstream project. Omit for single-workstream projects.

## Status Icons

| Icon | Meaning     |
| ---- | ----------- |
| ✅   | Done        |
| 🔄   | In Progress |
| ⏳   | Pending     |

## Section Reference

Start with the Document Header. Use `---` between sections. Required ●, optional ○.

| #   | Section              | Req | Include When                           | Format                                                                                                  |
| --- | -------------------- | --- | -------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| 1   | Overview             | ●   | Always                                 | 1-2 paragraphs: workstream scope, sequencing rationale                                                  |
| 2   | Milestones           | ●   | Always                                 | Summary table (see format below) linking milestone IDs to features with status icons                    |
| 3   | Dependency Graph     | ○   | Features have non-trivial dependencies | ASCII art showing feature execution order; one-line rationale                                           |
| 4   | Risk & Mitigation    | ○   | High-stakes features with known risks  | `\| Risk \| Feature \| Likelihood \| Impact \| Mitigation \|`                                          |
| 5   | Learning Points      | ○   | Features inform subsequent decisions   | `\| Feature \| What We Learn \| Informs \|`                                                            |
| 6   | Version History      | ●   | Always                                 | `\| Version \| Date \| Changes \|` — latest on top                                                     |

## Milestone Summary Table

Links every milestone and feature to its heading or file using `[icon ID](#anchor)` or `[icon ID](path)` syntax. Features include status icons. Multiple features in a cell separated with `<br>`.

```markdown
| Milestone                                 | Name             | Features                                                                          | Key Outcomes                        |
| ----------------------------------------- | ---------------- | --------------------------------------------------------------------------------- | ----------------------------------- |
| 🔄 [MS-{WS}-1](#ms-ws-1-name)            | {Name}           | ✅ [{WS}-0]({path}) <br> 🔄 [{WS}-1]({path}) <br> ⏳ [{WS}-2]({path})            | {what this milestone achieves}      |
| ⏳ [MS-{WS}-2](#ms-ws-2-name)             | {Name}           | ⏳ [{WS}-3]({path})                                                               | {what this milestone achieves}      |
```

Features link to their feature spec files (when files exist) or to in-document anchors.

## Dependency Graph

ASCII art showing feature execution order. Follow with a one-line rationale.

```markdown
{WS}-0: {Name}
    │
    ▼
{WS}-1: {Name}
    ├──────────────┐
    ▼              ▼
{WS}-2: {Name}    {WS}-3: {Name}

**Rationale:** {Why this order.}
```

For parallel features, use branching arrows. Keep it simple.

## Quality Standards

**Each milestone must have:** a goal (in the table's Key Outcomes column) and a list of features with status icons.

**Each feature referenced must already be defined** with goal, deliverables, and exit criteria (via `plan-feature`). The roadmap references features — it does not define them.

**Avoid:**

- Defining features inline — the roadmap groups and sequences, it doesn't spec
- Features too large (>10 deliverables) or too small (<2 deliverables)
- Milestones with too many features (>5) — consider splitting
- Over-documenting simple workstreams
- Risks without mitigation
- Ignoring parallelization opportunities
