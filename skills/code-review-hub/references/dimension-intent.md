# Dimension: intent

Check requirements fit for the Target brief. Compare spec, ticket, acceptance criteria, scope, and the stated change narrative to what the code actually does.

## Owns

- Gaps against a supplied spec, ticket, PRD, or acceptance criteria.
- Scope creep or work listed under **Out of scope** in the brief.
- Silent behavior change when Notes or the PR say refactor-only or no user-visible change.
- Internal goal drift: half-finished feature flags, dead paths tied to stated goals, public API that contradicts the described feature.

## Does not own

| Finding type | Primary dimension |
| ------------ | ----------------- |
| Pure logic bugs with no requirement angle | `implementation` |
| Security issues | `security` |
| Missing tests for acceptance criteria | `testing` (you may note a **Major** or **Medium** AC gap here; **testing** owns the missing-test row) |
| Style and conventions | `conformance` or `structure` |

## Evidence order

1. Target brief **Acceptance criteria**, **Stated goal**, **Out of scope**.
2. User-supplied ticket, PRD, or spec in **Notes** (pasted or linked).
3. Linked issues, PR description, commit messages (the coordinator should copy these into the brief).
4. If nothing states intent, run a **contract check** only. Compare public API, defaults, flags, migrations, and user-visible outputs in the diff against base to any narrative in **Notes**. Do not invent product requirements.

If you have no stated intent and no narrative, skip speculative critique. In **Skipped**, write `no stated requirements; contract-only check`. Report only clear narrative mismatches (for example the PR says "fix login" but the diff only reformats unrelated files).

Spec sources: brief acceptance criteria and goal; ticket or PRD in Notes; linked issues; PR description; requirement docs in the repo.

## Severity

Judge **stakeholder surprise** and **delivery risk** if this merges as-is. Do not set severity from the kind of gap (spec versus scope versus narrative).

- **Major:** Stated acceptance criteria or committed scope will fail in production; work clearly violates **Out of scope**; users or integrators get different behavior than **Notes** or the PR promise.
- **Medium:** Requirement is partly met; scope bleeds in ways that will confuse the next change; story in the brief no longer matches what shipped.
- **Minor:** Doc or comment drift; thin brief so impact is unclear; fix is tracking polish, not product risk.

## Report

Set `category` to `intent`.