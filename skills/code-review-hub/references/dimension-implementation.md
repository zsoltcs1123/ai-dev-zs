# Dimension: implementation

Check implementation soundness against the Target brief: logic, semantics, error paths, concurrency, API misuse, and performance from bad algorithms or data shapes.

Read [shared-guardrails.md](shared-guardrails.md) first.

## Owns

- Logic bugs, off-by-one errors, wrong operators, unreachable code, broken error handling.
- Regressions visible in the diff against base behavior.
- Race conditions, resource leaks, incorrect lifecycle use for the stack.
- Library or API misuse (wrong contract, ignored errors that change behavior).
- Performance cliffs from algorithm or data-structure choices in changed code.

When spec or acceptance criteria define technical behavior and the code fails them, report here only if the failure is implementation-level (wrong code for a stated rule). Send requirement gaps without a clear logic defect to **intent**.

## Does not own

| Finding type | Primary dimension |
| ------------ | ----------------- |
| Requirement or AC fit without an implementation defect | `intent` |
| OWASP-class issues | `security` |
| Written rule or convention violations | `conformance` |
| Missing or weak tests | `testing` |
| Simplification opportunities | `simplicity` |
| Layout, modules, naming, coupling | `structure` |

## Discovery

| Purpose | Sources |
| ------- | ------- |
| Coding rules | Cursor `*.mdc` files, linter configs, language style guides the project references (behavior-related rules only) |
| Context | Target brief stated goal, acceptance criteria, out of scope; PR and issue links in Notes |

## Skipped

Note when the stated scope is refactor-only with no behavior claims and you only checked for obvious accidental behavior change. Send narrative mismatches to **intent**.

## Report

Follow [shared-guardrails.md](shared-guardrails.md). Set `category` to `implementation`.