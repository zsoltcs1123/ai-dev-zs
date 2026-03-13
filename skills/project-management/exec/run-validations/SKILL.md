---
name: run-validations
description: Runs validation scenarios against running software. Use when asked to "run validations", "validate this feature", "run the acceptance checks", or "execute validation scenarios".
metadata:
  version: "1.0.0"
---

# Run Validations

Executes a validation suite against running software and reports per-scenario results.

## When to Use

- User asks to "run validations", "validate this feature", or "execute the scenarios"
- After implementation and review, before finalize

## Input

Validation scenarios produced by `spec-validations`. Must contain scenarios tagged **(A)** (agent-executable) or **(H)** (human-only).

Input can come from any source: pasted in chat, conversation context, or a file reference provided by the user or an orchestrator.

### Input Validation

- **No scenarios provided**: ask the user for the validation scenarios to run.
- **Input has no parseable scenarios**: report nothing to validate. **STOP.**

## Procedure

1. **Parse scenarios** from the provided input.
2. **Execute (A) scenarios** — run each agent-executable scenario, capture the result. Apply **Proactive Diagnosis** guidelines when interacting with services.
3. **Skip (H) scenarios** — log as SKIP with a note that manual verification is needed.
4. **Report results** in the output format below.
5. **Cleanup** — after reporting, remove any artifacts created solely by the validation run. See **Cleanup** section.

If any (A) scenario fails, report the failure details (expected vs actual) so the user can decide whether to loop back to implement.

## Proactive Diagnosis

When executing scenarios against running services, do NOT blindly poll health checks. Apply these rules:

**Startup failures:** If a service stays in starting/unhealthy beyond its expected startup time, immediately inspect service logs before waiting further. Look for:

- Crash-loops (repeated startup messages)
- Error-level log lines
- Stack traces

Diagnose and fix the root cause rather than polling health status repeatedly.

**Stuck steps:** If any validation step blocks for more than 2 minutes without progress, stop waiting and investigate:

- Check service logs (last ~50 lines)
- Inspect service/process state
- Check restart count

**Poll limit:** Never poll the same health check more than 3 times without examining the underlying cause. After 3 failed polls, shift to diagnosis mode (logs, process state, restart count) and attempt to fix or report the root cause.

**General principle:** Prefer diagnosing over waiting. The goal is to surface actionable failure information, not to retry until a timeout expires.

## Cleanup

After reporting results, undo any side-effects that exist only to support the validation run:

- **Temporary files**: delete test fixtures, seed data files, temporary configs, or helper scripts created during validation.
- **Containers & processes**: stop and remove any containers, services, or background processes started solely for validation (e.g. docker compose stacks, disposable databases, mock servers, etc).
- **Test data**: remove records, users, or other data inserted into running services if they were created only for validation and the service supports cleanup (API delete calls, DB rollback).
- **Environment changes**: revert any environment variables, port overrides, or config tweaks applied for validation.

**Do not** remove artifacts that existed before the validation run or that the user/project needs to keep.

If cleanup fails for any item, report it in the **Cleanup** section of the output rather than silently ignoring it.

## Output Format

The report has a fixed structure. Adapt section content to what actually happened; omit sections that have no content (e.g. no defects → omit Defects, no cleanup → omit Cleanup, no skipped → omit Skipped Scenarios).

```markdown
# Validation Report: {feature-code} {feature-title}

**Date:** {YYYY-MM-DD}
**Environment:** {OS, runtime, tooling versions — whatever is relevant}
**Stack at end of run:** {state of services/containers at report time}

## Summary

{Total (A) scenarios} agent-executable **(A)** scenarios across {n} validation groups — **{all PASS | n PASS, n FAIL}**.

{One-liner on defects found/fixed, if any.}

{One-liner on skipped (H) scenarios and why.}

## Results

| Scenario | Description | Result |
|----------|-------------|--------|
| [VS1](#anchor) | {group title} | **PASS** ({n}/{n}) |
| [VS2](#anchor) | {group title} | **FAIL** ({n}/{n}) |
| ...      | ...         | ...    |

## Detailed Results

### {FEATURE}-VS{n}. {group title}

| # | Scenario | Result |
|---|----------|--------|
| 1 | {step description} | PASS |
| 2 | {step description} | FAIL — {expected vs actual} |

> **Note:** {optional observations, caveats, or corrections discovered during this group}

{Repeat per validation group.}

## Defects

### {short defect title}

**Severity:** {High | Medium | Low}
**Symptom:** {what was observed}
**Root cause:** {why it happened}
**Fix:** {what was changed}
**Verified:** {confirmation the fix works}

{Repeat per defect. Omit section if none.}

## Skipped Scenarios (Human-Only)

| Group | Scenarios | Reason |
|-------|-----------|--------|
| VS{n} | {description} | {why it requires human execution} |

{Omit section if no (H) scenarios.}

## Cleanup

| Action | Status | Notes |
|--------|--------|-------|
| {what was cleaned up} | DONE | |
| {what was cleaned up} | FAILED | {why it failed} |

{Omit section if no cleanup was needed.}
```
