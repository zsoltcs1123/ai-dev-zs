# Dimension: simplicity

Ask whether changed code in the Target brief can shrink a lot without losing behavior, spec, or acceptance criteria.

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

Do not flag simplification when acceptance criteria, security, correctness, or spec require the complexity; note justified complexity in **Skipped**.

## Discovery

| Purpose | Sources                                              |
| ------- | ---------------------------------------------------- |
| Scope   | Brief stated goal, acceptance criteria, out of scope |

## Severity

Judge **ongoing cost to understand and change** this code. Do not set severity from construct type (wrapper, branch, helper). Prefer **Medium** when unsure.

- **Major:** Duplication or indirection will reliably cause the next bug or bad merge; large removable chunk with no behavior or acceptance-criteria loss (rare).
- **Medium:** Readers will repeatedly misread control flow; fold removes real mental load or defect surface without changing contracts.
- **Minor:** Cosmetic tidy; saves a few lines; merge is fine without the simplification.

## Report

Set `category` to `simplicity`.
