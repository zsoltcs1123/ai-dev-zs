# Review Layers

Evaluate the change set through all six. Apply standard engineering judgment where the repo has no written standard.

## Bottom-up stack (layers 1–3)

Most specific at the bottom, most authoritative at the top:

```
principles      ← layer 3: wins on conflict
conventions     ← layer 2
code quality    ← layer 1: bugs, performance, language/stack rules
```

Review each layer separately. On conflict between layers, higher levels win: **principles** over **conventions** over **coding rules**.

When any written standard in layers 1–3 conflicts with standard judgment on correctness, safety, or maintainability, flag the doc conflict (Medium). Do not treat the code as wrong for following good practice. In the fix phase, do not change code to satisfy a harmful written standard unless the user confirms.

## Discovery

Read what exists in the repo under review; skip what doesn't:

| Layer        | Sources                                                                                                                 |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Code quality | Cursor `*.mdc` rules, documented linter configs, language style guides referenced by the project                        |
| Conventions  | `CONTRIBUTING.md`, `DEVELOPING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks                       |
| Principles   | `PRINCIPLES.md` or equivalent                                                                                           |
| Security     | `**/security.md`, security sections in convention docs, plus general security judgment                                  |
| Spec         | User-supplied ticket/PRD/spec, linked issues, PR description, branch name, commit messages, referenced requirement docs |

For layers 1–3, review discovered docs item-by-item; do not skip items within a layer that has docs.

## Layer 1 — Code Quality

Apply standard language-specific judgment plus the discovered coding rules.
Check for:

1. Bugs
2. Behavioral regressions
3. Performance issues
4. Inappropriate use of language features
5. Violation of coding rules

## Layer 2 — Conventions

Project-based conventions. Read every discovered convention document that applies to the changed files. Review separately against **each** convention. Flag violations that affect behavior, maintainability, or could confuse future readers.

Skip this layer if no convention docs were found.

## Layer 3 — Principles

High-level engineering principles. Read every discovered principles document. Review separately against **each** principle. Flag violations even if unsure.

If none are found, apply best general engineering judgment.

## Layer 4 — Security

Audit against discovered security docs and general security best practices (injection, authz gaps, secret leakage, unsafe defaults, untrusted input).

## Layer 5 — Testing

Every unit and integration test must earn its keep: test real functionality and add significant value. Flag unnecessary or redundant tests and missing coverage.

## Layer 6 — Spec Conformance

If a spec, ticket, PRD, issue, or acceptance criteria is supplied by the user or discoverable from the change context, review the change set against it. Flag gaps, scope creep, or mismatches with stated requirements.

Skip this layer if nothing is supplied and nothing is discoverable.
