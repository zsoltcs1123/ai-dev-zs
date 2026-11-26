# Architecture Decision Records (ADRs)

ADRs record significant technical decisions. They are short, scannable, and human-facing. Deep design detail belongs in a separate spec or architecture doc, with a link from the ADR.

## Numbering

Use `ADR-NNN` in the title, where NNN is the next number in the repo's ADR sequence. If the repo has no ADRs yet, start at `001`. When saving to disk, common patterns are `docs/decisions/NNN-short-slug.md` or `docs/adr/NNN-short-slug.md`. Match existing repo layout when present.

## Document structure

```markdown
# ADR-NNN: Short title

> **Status:** Accepted
> **Date:** YYYY-MM-DD
> **Scope:** (optional) area or change that triggered this
> **Supersedes:** ADR-NNN (optional)
> **Related:** ADR-NNN (optional)

## Context

## Decision

## Options considered

## Rationale

## Consequences

## Open questions

## References
```

### Metadata

| Field                | Required | Notes                                                         |
| -------------------- | -------- | ------------------------------------------------------------- |
| Status               | yes      | `Proposed`, `Accepted`, `Superseded by ADR-NNN`, `Deprecated` |
| Date                 | yes      | Decision date                                                 |
| Scope                | no       | What work or area surfaced the decision                       |
| Supersedes / Related | no       | Links to other ADRs                                           |

For superseded ADRs, set status to `Superseded by ADR-NNN` and link to the replacement. The replacement should list `Supersedes: ADR-NNN`.

### Sections

| Section            | Required    | Purpose                                                                                     |
| ------------------ | ----------- | ------------------------------------------------------------------------------------------- |
| Context            | yes         | Problem and forces. A few sentences or bullets.                                             |
| Decision           | yes         | What was chosen, stated directly.                                                           |
| Options considered | no          | Only when alternatives were genuinely weighed. Compact table: Option \| Verdict (one line). |
| Rationale          | recommended | Brief bullets on why. No paragraph-per-point walls.                                         |
| Consequences       | yes         | What changes, follow-ups, and tradeoffs. Fold tradeoffs here when they fit.                 |
| Open questions     | no          | Unresolved items that do not block the decision.                                            |
| References         | no          | Links to specs, architecture docs, or implementation paths.                                 |

Use `## Tradeoffs` only when consequences would become unreadable without a separate list.

## Writing rules

- **Record the decision, not a design doc.** If the topic needs many pages of detail, point to a separate spec in References.
- **Scannable.** Short paragraphs, bullets, tables where they help. A reader should grasp the decision in under two minutes.
- **No fluff.** Drop throat-clearing, repeated context, and exhaustive consequence lists. Keep what matters for someone implementing or revisiting the choice.
- **No em-dashes.** Use commas, parentheses, or separate sentences.
- **Human tone.** Direct, plain language. Avoid typical AI phrasing ("it's worth noting", "delve into", "landscape", "leverage").
- **Immutable history.** Do not rewrite accepted ADRs to reflect later reality. Supersede with a new ADR instead. Factual corrections to a superseded ADR may be noted briefly in that file.

## When to write an ADR

- Choosing between real alternatives with lasting impact (libraries, deployment models, auth flows, data models).
- Reversing or materially changing a prior ADR.
- A decision that multiple teams or future readers will need to understand without re-litigating.

Skip ADRs for obvious defaults, pure implementation detail, or choices already fully covered elsewhere with no decision to record.
