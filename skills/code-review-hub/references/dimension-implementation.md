# Dimension: implementation

Check implementation soundness against the Target brief: logic, semantics, error paths, concurrency, API misuse, and performance from bad algorithms or data shapes.

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

## Severity

Judge **likelihood** once the change is merged and **harm** if the code is wrong. Do not set severity from the defect type (off-by-one, race, API misuse, and so on).

- **Major:** Wrong outcomes on paths this change makes common; data corruption or loss is plausible; hard failure or clear behavior regression versus base for the touched flow.
- **Medium:** Failure needs a realistic production trigger (input, load, timing) but is not exotic; users get wrong results or silent failures without an obvious crash; noticeable perf hit on a path this change uses.
- **Minor:** Narrow trigger, easy workaround, or hardening that does not change behavior users already rely on.

When two defects look similar on paper, rank by who gets hurt and how often, not by which line of the checklist they matched.

## Report

Set `category` to `implementation`.
