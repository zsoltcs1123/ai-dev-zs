---
name: review
description: Reviews code changes against project standards, task spec, and documentation requirements. Use when asked to "review code", "check my changes", "review my PR", or "quality check".
metadata:
  version: "1.0.0"
---

# Review

Reviews code changes across three dimensions: code quality, task adherence, and documentation. Produces actionable findings with severity and suggestions.

## When to Use

- User asks to "review my changes", "review the code", or "quality check"
- After implementation, before finalize

## Input

- **Changes to review**: staged/uncommitted changes or a diff.
- **Task spec or plan** (optional but recommended): the spec that was implemented. Required for task adherence checks — without it, that dimension is skipped with a warning.

Input can come from any source: pasted in chat, conversation context, or a file reference.

## Procedure

1. **Get changes**: staged/uncommitted changes or diff.
2. **Resolve task spec**: find the task spec or plan in conversation context or input. If not found, warn that task adherence will be skipped.
3. **Review** across three dimensions (below).
4. **Produce findings** in the output format.

## Review Dimensions

### 1. Code Quality

Review changes against project conventions found in the codebase — linter configs, existing patterns, naming conventions, and documentation standards. If no project-specific conventions are discoverable, review against general best practices (naming, structure, error handling, test coverage).

### 2. Task Adherence

Compare the changes against the task spec or plan. Look for:

- **Missing requirements** — implementation requirements from the spec that aren't satisfied by the changes.
- **Skipped steps** — plan steps that have no corresponding changes.
- **Scope creep** — changes that go beyond what the spec calls for without justification.

Minor adaptations are expected — the `implement` skill documents these as deviations. Deviations noted in the implementation output are not findings unless they indicate a deeper problem.

Skip this dimension entirely if no task spec is available.

### 3. Documentation

Verify that documentation was updated where needed. Flag when:

- Changes touch public API or user-facing behavior but no docs were updated.
- Project conventions require documentation updates and none were made.
- Existing documentation is now stale or contradicted by the changes.

## Severity

- **High** — must fix before commit (broken behavior, violated requirement, missing deliverable)
- **Medium** — should fix (standards violation, missing docs, unclear code)
- **Low** — suggestion (style nit, minor improvement)

## Verdict

- **PASS** — no high or medium findings.
- **ISSUES** — one or more high or medium findings.

## Output Format

```markdown
## Review: {PASS|ISSUES}

### Summary

{Brief description of what was reviewed and which dimensions were evaluated}

### Findings

1. **High** `{path}:{line}` — {what's wrong}. Fix: {how to fix}
2. **Medium** `{path}:{line}` — {what's wrong}. Fix: {how to fix}
3. **Low** `{path}` — {what's wrong}. Fix: {how to fix}

{If PASS: "No blocking issues found."}
```
