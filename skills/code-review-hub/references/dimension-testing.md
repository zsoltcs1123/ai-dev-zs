# Dimension: testing

Review tests for the Target brief. Check coverage, value, and alignment with risk and acceptance criteria.

Read [shared-guardrails.md](shared-guardrails.md) first.

## Owns

- Missing tests for risky or spec-backed behavior in the change set.
- Redundant, brittle, or low-value tests.
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

## Report

Follow [shared-guardrails.md](shared-guardrails.md). Set `category` to `testing`.