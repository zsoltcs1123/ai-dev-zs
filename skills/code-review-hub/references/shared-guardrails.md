# Shared guardrails

Report-only dimension runs: coordinator loads this on the inline path; subagents load it via [subagent.md](subagent.md) on the default path. Do not edit code.

## Spec and scope

Read **Notes**, **Stated goal**, **Acceptance criteria**, and **Out of scope** in the Target brief before you write findings.

- Do not flag missing work, alternate designs, or polish outside stated scope unless the issue is **Major** under this dimension's severity rules and the change makes it worse.
- When spec and code disagree, cite the spec clause or acceptance-criteria line in the finding when you can.
- When the user supplies no requirements, do not invent product goals.

## Pre-existing issues

Do not flag pre-existing issues outside the diff unless they are **Major** under this dimension's severity rules and the change touches them directly or makes them worse.

## Severity

Use **Major**, **Medium**, and **Minor** on every finding. Band definitions live in the dimension file for this run.

Set severity from **consequence if this ships** and **how likely the failure is**, not from the finding label, doc layer, or check category.

Shared scale across dimensions:

- **Major:** Block merge or ship for this dimension's concern.
- **Medium:** Fix before merge when practical; accept only with a clear reason.
- **Minor:** Optional follow-up.

Do not apply another dimension's criteria when you set severity.

## Report shape

Return these sections:

- `## Summary`. What the change does for this dimension. Do not list problems here.
- `## Findings`. One line each: `severity | category | file:line | clause`
- `## Totals`. `Major N · Medium N · Minor N`
- `## Skipped`. Missing docs, unstated requirements, or `none`

Set `category` to the dimension id (for example `implementation`, or `structure: Layout` for structure sub-checks).

Write one clause per finding.
