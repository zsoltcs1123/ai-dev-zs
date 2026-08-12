---
name: code-review
description: Reviews code changes against five layers — general quality, project conventions, engineering principles, security, and testing. Produces a brief report then walks through issues interactively. Use when asked to "review code", "check my changes", "review my PR", "review this branch", or "quality check".
metadata:
  author: zs
  version: "1.0"
---

# Code Review

## Outcome

Review a change set through five layers. Produce a brief report, then walk through issues interactively (highest severity first). After the last issue, summarize what was fixed and what was skipped.

See [references/workflow.md](references/workflow.md) for layer criteria, report format, and walkthrough protocol.

## Guardrails

- Evaluate all five layers. Review discovered conventions and principles item-by-item; do not skip.
- Never fix and move on without user confirmation.
- Don't flag pre-existing issues outside the diff unless they're P0 and directly affected by the change.
- If correctness and simplicity conflict, correctness wins.
- If the diff is large (>20 files), ask whether to review everything or focus.
- Skip purely cosmetic preferences unless the project's convention docs explicitly require them.
- Flag both missing coverage and tests that don't earn their keep.

Severity: **Major** (correctness bugs, security vulnerabilities, data loss), **Medium** (principle/convention violations that will cause problems), **Minor** (minor violations, missed opportunities, cleanup).

## Tools

Determine review scope, in priority order:

1. User-specified folders, features, files, or paths
2. User-mentioned branch → diff against the default branch
3. Working tree changes (staged and/or unstaged)
4. Current branch diverges from default → `git diff <default>...HEAD`

If nothing qualifies, ask what to review. Resolve the default branch from `origin/HEAD`; fall back to `main`, then `master`.

Discover project standards from the repo under review. Read what exists; skip what doesn't:

- Conventions — `CONTRIBUTING.md`, `AGENTS.md`, `**/conventions.md`, docs next to changed stacks
- Principles — `PRINCIPLES.md` or equivalent
- Security — `**/security.md`, security sections in convention docs, plus general security judgment
