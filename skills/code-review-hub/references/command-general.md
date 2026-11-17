# Command: general

Six-layer review for the Target brief. Report only. Do not edit code.

## Guardrails

- Evaluate all six layers below.
- Do not flag pre-existing issues outside the diff unless they are Major and the change touches them directly.
- If correctness and simplicity conflict, correctness wins.
- Skip cosmetic preferences unless convention docs require them.
- Flag missing coverage and tests that do not earn their keep.

**Major:** correctness bugs, security vulnerabilities, data loss, missed spec requirement.

**Medium:** rule, convention, or principle violations that will cause problems; doc conflicts with sound judgment.

**Minor:** small violations, missed opportunities, cleanup.

## Layers

Evaluate the change set through all six. Apply standard engineering judgment where the repo has no written standard.

### Stack for layers 1–3

Most specific at the bottom, most authoritative at the top:

```
principles      ← layer 3: wins on conflict
conventions     ← layer 2
code quality    ← layer 1: bugs, performance, language/stack rules
```

On conflict between layers, higher levels win: **principles** over **conventions** over **coding rules**.

When a written standard in layers 1–3 conflicts with sound judgment on correctness, safety, or maintainability, flag the doc conflict (Medium). Do not treat the code as wrong for following good practice.

### Discovery

| Layer        | Sources                                                                                                                 |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Code quality | Cursor `*.mdc` rules, documented linter configs, language style guides referenced by the project                        |
| Conventions  | `CONTRIBUTING.md`, `DEVELOPING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks                       |
| Principles   | `PRINCIPLES.md` or equivalent                                                                                           |
| Security     | `**/security.md`, security sections in convention docs, plus general security judgment                                  |
| Spec         | User-supplied ticket, PRD, or spec; linked issues; PR description; branch name; commit messages; referenced requirement docs |

For layers 1–3, review discovered docs item by item. Do not skip items within a layer that has docs.

### Layer 1 — Code quality

Standard language judgment plus discovered coding rules. Check bugs, behavioral regressions, performance, inappropriate language features, and coding-rule violations.

### Layer 2 — Conventions

Read every discovered convention document that applies to changed files. Review against **each** convention. Flag violations that affect behavior, maintainability, or confuse readers. Skip when no convention docs exist.

### Layer 3 — Principles

Read every discovered principles document. Review against **each** principle. Flag violations even if unsure. When none exist, apply general engineering judgment.

### Layer 4 — Security

Audit against discovered security docs and general practice: injection, authz gaps, secret leakage, unsafe defaults, untrusted input.

### Layer 5 — Testing

Each unit and integration test must earn its keep. Flag unnecessary or redundant tests and missing coverage.

### Layer 6 — Spec conformance

When a spec, ticket, PRD, issue, or acceptance criteria is supplied or discoverable from context, check for gaps, scope creep, or mismatches. Skip when nothing is supplied or discoverable.

## Report

Three sections before you return to the coordinator:

1. **Summary.** One to three sentences on what the changes do. Not what is wrong.
2. **Findings by layer.** One line each: severity, clause, `file:line`. Note empty layers. Note skipped layers briefly.
3. **Totals.** `Major N · Medium N · Minor N`.

One clause per finding.

Return these headings:

- `## Summary`, `## Findings` (lines: `severity | category | file:line | clause`), `## Totals`, `## Skipped`

Set `category` to the layer name: Code quality, Conventions, Principles, Security, Testing, or Spec.