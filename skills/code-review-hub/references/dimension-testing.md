# Dimension: testing

Review tests for the Target brief. Check coverage, value, and alignment with risk and acceptance criteria.

## Owns

- Missing tests for risky or spec-backed behavior in the change set.
- Redundant, brittle, or low-value tests.
- **Tautological tests:** assertions that cannot fail because they only restate setup, mocks, or implementation copied into the test (for example asserting a stub return value, or that code under test equals inline literals with no behavior exercised).
- Tests that contradict stated behavior or acceptance criteria.

## Does not own

| Finding type | Primary dimension |
| ------------ | ----------------- |
| Wrong production behavior | `implementation` or `intent` |
| Untestable structure | `structure` (mention test blockage only when design blocks tests; the primary finding stays in **structure**) |

Use **Acceptance criteria** in the brief. Flag missing coverage for behavior the acceptance criteria cover. Do not demand tests for out-of-scope work.

## Discovery

| Purpose | Sources |
| ------- | ------- |
| Spec | Brief acceptance criteria; testing sections in CONTRIBUTING or conventions |
| Layout | Whether tests mirror production layout when the repo does |

## Severity

Judge **regression risk without a safety net** and **cost of false confidence**. Do not set severity from test type (unit versus integration) or file name alone.

- **Major:** Change introduces or alters behavior that will break in production and has no test that would fail first; acceptance-criteria behavior is unguarded.
- **Medium:** Tautological test (cannot fail when production regresses); tests mislead, are brittle enough to block fixes, or omit a plausible failure mode this change adds.
- **Minor:** Coverage gap on low-risk paths; extra test would help but absence does not block merge for this diff.

## Report

Set `category` to `testing`.