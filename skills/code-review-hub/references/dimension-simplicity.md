# Dimension: simplicity

Ask whether changed code in the Target brief can shrink a lot without losing behavior, spec, or acceptance criteria.

Read [shared-guardrails.md](shared-guardrails.md) first.

## Owns

- Redundant branches, dead code, duplicate logic in the diff, unnecessary indirection or wrappers.
- Over-abstraction you can fold without behavior change.
- Complexity that does not buy correctness, spec coverage, or a clear boundary (per **Notes** and acceptance criteria).

## Does not own

| Finding type                                   | Primary dimension |
| ---------------------------------------------- | ----------------- |
| File or module splits, SRP, package boundaries | `structure`       |
| Deleting or consolidating tests                | `testing`         |
| Logic bugs                                     | `implementation`  |

Do not flag simplification when acceptance criteria or security require the complexity. Note justified complexity in **Skipped**.

When correctness, security, or spec conflict with simplification, do not flag simplification.

## Discovery

| Purpose | Sources                                              |
| ------- | ---------------------------------------------------- |
| Scope   | Brief stated goal, acceptance criteria, out of scope |

## Report

Follow [shared-guardrails.md](shared-guardrails.md). Set `category` to `simplicity`.
