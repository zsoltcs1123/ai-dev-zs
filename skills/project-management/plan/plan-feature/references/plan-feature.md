# Plan Feature — Output Reference

Structure, format, and quality standards for feature spec output.

## Output Format

The feature spec must match the project management system's feature file format. This is the exact structure a feature file (`{feature-code}.md`) uses.

```markdown
# {WS}-{N}: {Feature Name}

**Goal:** {One sentence: what this feature achieves and why it matters.}

**Status:** {icon} {label}

## Deliverables

| Deliverable | Description                   |
| ----------- | ----------------------------- |
| {name}      | {what it is and what it does} |

## Dependencies

- [{DEP-CODE}](relative-path) — {optional brief note}

## Exit Criteria

- {Concrete observable condition that proves the feature is done}
- {Another condition}

## Notes

> Optional — include only when there are open questions, options under consideration, known risks, or anything that doesn't fit above. Omit the section entirely if empty.
```

## Section Details

### Heading

`# {WS}-{N}: {Feature Name}` — uses the project's workstream code and feature number.

### Goal

One sentence. What this feature achieves and why it matters. Not a description of the implementation.

### Status

Status icon + label, placed directly below Goal:

| Icon | Label       |
| ---- | ----------- |
| ✅   | Done        |
| 🔄   | In Progress |
| ⏳   | Pending     |

New features default to ⏳ Pending unless the user indicates otherwise.

### Deliverables

Table with two columns: Deliverable and Description. Each row is a concrete output — something that can be pointed at and verified.

### Dependencies

List of feature IDs this feature depends on (must be complete before this feature can start). Use relative links when the target file exists. Omit the section if there are no dependencies.

### Exit Criteria

Bullet list of concrete conditions that prove the feature is done. Each criterion must be:

- **Observable** — you can check it against running software or the codebase
- **Specific** — not "it works" but "all health checks return 200"
- **Complete** — covering all deliverables

Exit criteria drive the validation suite (produced by `spec-validations`).

### Notes

Optional. Open questions, options under consideration, known risks, or context that doesn't fit above. Omit entirely if empty.

## Quality Standards

**Each feature must have:** goal, status, deliverables (2–10 rows), exit criteria (observable outcomes).

**Avoid:**

- Features too large (>10 deliverables) — split them
- Features too small (<2 deliverables) — that's a task, not a feature
- Code snippets, file names, directory paths, version numbers
- Vague or unmeasurable deliverables ("improve performance")
- Exit criteria phrased as tasks ("write tests") — must be observable outcomes
- Features that overlap significantly with other features
