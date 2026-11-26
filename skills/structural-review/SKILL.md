---
name: structural-review
description: Reviews code organization — file layout, naming, module responsibilities, dependencies, public surface, and structural oddities. Produces a brief report, then fixes issues interactively or in batch. Use for "structural review", "review structure", "check organization", "review naming and layout", "module boundaries", "structural-review interactive", "structural-review non-interactive", or "/structural-review".
disable-model-invocation: true
metadata:
  author: zs
  version: "1.0"
---

# Structural review

## Outcome

Review the change set on six dimensions ([references/dimensions.md](references/dimensions.md)). Write a short report, fix issues highest severity first ([references/workflow.md](references/workflow.md)). Default: interactive. After the last issue, summarize fixed vs skipped.

## Mode

- `structural-review interactive`, bare `structural-review`, or "review structure of my PR" → **interactive**
- `structural-review non-interactive` → **non-interactive**

Mode changes confirmations and fix pacing only.

## Guardrails

- Evaluate all six dimensions in [references/dimensions.md](references/dimensions.md).
- **Interactive:** confirm each issue before fixing.
- **Non-interactive:** ask once, then apply every listed issue. See [references/workflow.md](references/workflow.md) for batch and move-map rules.
- Do not flag pre-existing issues outside the diff unless **Major** and the change worsens them.
- Out of scope: correctness, security, performance, tests, spec conformance. Mention briefly if you spot them; do not expand into that review.
- Diff over 20 files: ask full review or focus.
- Skip cosmetic naming unless ambiguous or inconsistent with siblings.
- Structural fixes: no behavior change without user confirmation.

## Tools

Pick review scope in this order:

1. User-named folders, features, files, or paths
2. User-named branch → diff vs default branch
3. Working tree (staged, unstaged, or both)
4. Branch diverged from default → `git diff <default>...HEAD`

If none apply, ask what to review. Default branch: `origin/HEAD`, then `main`, then `master`.
