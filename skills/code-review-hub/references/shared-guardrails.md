# Shared guardrails

Every review dimension follows these rules. Report only. Do not edit code.

## Spec and scope

Read **Notes**, **Stated goal**, **Acceptance criteria**, and **Out of scope** in the Target brief before you write findings.

- Do not flag missing work, alternate designs, or polish outside stated scope unless the issue is **Major** (correctness, security, data loss, or misleading boundaries that the change makes worse).
- When spec and code disagree, cite the spec clause or acceptance-criteria line in the finding when you can.
- When the user supplies no requirements, do not invent product goals. See [dimension-intent.md](dimension-intent.md).

## Pre-existing issues

Do not flag pre-existing issues outside the diff unless they are **Major** and the change touches them directly or makes them worse (per the dimension file you are running).

## Severity

- **Major:** Correctness bugs, security vulnerabilities, data loss, missed spec or acceptance criteria, misleading boundaries or layering.
- **Medium:** Broken conventions or principles, coupling, neighbor inconsistency, maintainability problems that will bite later.
- **Minor:** Cleanup, small naming or placement wins, optional simplification.

When correctness and simplicity conflict, correctness wins.

## Doc conflicts

When a written standard conflicts with sound judgment on correctness, safety, or maintainability, flag the doc conflict as **Medium**. Do not mark the code wrong for following good practice.

## Report shape

Every dimension returns these sections:

- `## Summary`. What the change does for this dimension. Do not list problems here.
- `## Findings`. One line each: `severity | category | file:line | clause`
- `## Totals`. `Major N · Medium N · Minor N`
- `## Skipped`. Missing docs, unstated requirements, or `none`

Set `category` to the dimension id (for example `implementation`, or `structure: Layout` for structure sub-checks).

Write one clause per finding.