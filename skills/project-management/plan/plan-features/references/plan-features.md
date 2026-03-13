# Plan Features — Output Reference

Structure, format, and quality standards for the feature map output.

## Output Format

```markdown
# Feature Map

## Workstreams

| Code | Workstream | Features |
| ---- | ---------- | -------- |
| {WS} | {name}     | {count}  |

## {WS} — {Workstream Name}

| Code   | Feature | Goal            |
| ------ | ------- | --------------- |
| [{WS}-1]({WS}/{WS}-1/{WS}-1.md) | {name}  | {one-line goal} |
| [{WS}-2]({WS}/{WS}-2/{WS}-2.md) | {name}  | {one-line goal} |
```

## Section Details

### Heading

`# Feature Map` — always the same. No project name in the heading; the document lives within a project context.

### Workstreams Table

Summary table listing all workstreams with their short codes and feature counts. Provides a quick overview before the detail sections.

- **Code** — short uppercase identifier (2-4 chars). Derived from the workstream's domain (e.g., `PLT` for Platform, `IDX` for Indexing, `API` for API).
- **Workstream** — human-readable name.
- **Features** — number of features in the workstream.

For single-workstream projects, the table has one row. Still include it for consistency.

### Workstream Sections

One `## {WS} — {Workstream Name}` section per workstream, each containing a feature table:

- **Code** — `{WS}-{N}`, sequential within the workstream. Linked to the feature spec file at `{WS}/{WS}-{N}/{WS}-{N}.md`. The target file may not exist yet (created later by `plan-feature`); the link is forward-looking.
- **Feature** — concise name (2-5 words). Noun-phrase preferred (e.g., "User Authentication", "Search Index Pipeline").
- **Goal** — one sentence: what this feature achieves and why it matters. Outcome-oriented, not implementation-oriented.

## Quality Standards

**Workstream sizing:**

- A workstream should contain 2-8 features. Fewer than 2 — consider merging into another workstream. More than 8 — consider splitting the workstream.
- Workstream boundaries should align with architectural component boundaries where possible.

**Feature sizing:**

- A feature should be decomposable into 2-10 deliverables (validated when `plan-feature` specs it fully). At this stage, use judgment: if a feature clearly covers only one deliverable, it's probably a task. If it covers a dozen distinct concerns, it should split.
- Features within a workstream should be roughly similar in scope.

**Goals:**

- One sentence. What + why.
- Outcome-oriented: "Enable users to search documents by content" not "Build a search API endpoint".
- No implementation detail: no tech names, no component names, no architecture references.

**Avoid:**

- Overlapping features — if two features deliver the same thing, merge or clarify boundaries.
- Catch-all features ("Miscellaneous", "Other improvements") — every feature needs a clear goal.
- Features that are really milestones (grouping other features) — that's `plan-workstream-roadmap`'s job.
- Features that are really tasks (single concrete action) — too granular for this level.
