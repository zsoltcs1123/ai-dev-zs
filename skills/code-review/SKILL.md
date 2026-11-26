---
name: code-review
description: Reviews code changes against six layers — code quality, project conventions, engineering principles, security, testing, and spec conformance. Produces a brief report then fixes issues interactively or in batch. Use when asked to "review code", "check my changes", "review my PR", "review this branch", "quality check", "code-review interactive", or "code-review non-interactive".
disable-model-invocation: true
metadata:
  author: zs
  version: "1.5"
---

# Code Review

## Outcome

Review a change set through six layers. Produce a brief report, then address issues (highest severity first). Default mode is interactive; use non-interactive when invoked explicitly. After the last issue, summarize what was fixed and what was skipped.

- [references/layers.md](references/layers.md) — layer criteria, discovery, bottom-up stack
- [references/workflow.md](references/workflow.md) — report format, fix protocols, edge cases

## Mode

Parse the invocation:

- `code-review interactive` or bare `code-review` (and phrases like "review my PR") → **interactive**
- `code-review non-interactive` → **non-interactive**

Mode affects confirmation and fix pacing only. Review scope, layers, and report format are the same.

## Guardrails

- Evaluate all six layers per [references/layers.md](references/layers.md).
- **Interactive:** confirm each issue before fixing.
- **Non-interactive:** confirm once before applying all fixes; then apply every listed issue without further asks.
- Don't flag pre-existing issues outside the diff unless they're P0 and directly affected by the change.
- If correctness and simplicity conflict, correctness wins.
- If the diff is large (>20 files), ask whether to review everything or focus.
- Skip purely cosmetic preferences unless the project's convention docs explicitly require them.
- Flag both missing coverage and tests that don't earn their keep.

Severity: **Major** (correctness bugs, security vulnerabilities, data loss, spec requirement missed), **Medium** (rule/convention/principle violations that will cause problems), **Minor** (minor violations, missed opportunities, cleanup).

## Tools

Determine review scope, in priority order:

1. User-specified folders, features, files, or paths
2. User-mentioned branch → diff against the default branch
3. Working tree changes (staged and/or unstaged)
4. Current branch diverges from default → `git diff <default>...HEAD`

If nothing qualifies, ask what to review. Resolve the default branch from `origin/HEAD`; fall back to `main`, then `master`.
