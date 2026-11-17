# Dimension: conformance

Check written and discovered rules, conventions, and principles for the Target brief. When those docs are absent, apply generic idiomatic patterns for the language and stack.

Read [shared-guardrails.md](shared-guardrails.md) first.

## Owns

Authority stack (highest wins on conflict):

```
principles      ← wins on conflict
conventions
coding rules    ← *.mdc, linters, style guides
```

- Item-by-item review of every discovered doc in each layer that applies to changed files.
- Idiomatic language and stack patterns when no project docs exist (not neighbor module layout; that is **structure**).

## Does not own

| Finding type | Primary dimension |
| ------------ | ----------------- |
| Logic bugs | `implementation` |
| Requirement gaps | `intent` |
| Security vulnerabilities | `security` |
| Test coverage | `testing` |
| Simplification | `simplicity` |
| Package placement, SRP, coupling without a written rule | `structure` |

On conflict between layers, **principles** beat **conventions**, and **conventions** beat **coding rules**.

## Discovery

| Layer | Sources |
| ----- | ------- |
| Coding rules | Cursor `*.mdc` files, documented linter configs, language style guides the project references |
| Conventions | `CONTRIBUTING.md`, `DEVELOPING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks |
| Principles | `PRINCIPLES.md` or equivalent |

Review each discovered doc item by item. Do not skip items within a layer that has docs.

When no convention or principles docs exist, say so once in **Skipped** and apply generic stack idioms only.

Skip cosmetic preferences unless convention docs require them.

## Report

Follow [shared-guardrails.md](shared-guardrails.md). Set `category` to `conformance`, or `conformance: <layer>` when it helps (Coding rules, Conventions, Principles).