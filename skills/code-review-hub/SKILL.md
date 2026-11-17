---
name: code-review-hub
description: Hub for multi-dimension code review in one slash command. Maps user intent to dimensions, resolves the review target without guessing, runs one subagent per dimension, and merges one report. Use for "code-review-hub", "full review", "review my PR", or an explicit dimension list.
disable-model-invocation: true
compatibility: Default path uses the Cursor Task tool for subagents. Inline path when Task is unavailable or the user asks for in-chat review, no subagents, or review inline in this chat.
metadata:
  author: zs
  version: "0.3"
---

# Code review hub

## Outcome

Run selected dimensions against a resolved target, then deliver one merged report (step 5). Stop unless the user asks for more in chat.

Open a reference only at the step that names it.

## Dimensions

One dimension equals one subagent run.

| Dimension id     | Reference                                                                        |
| ---------------- | -------------------------------------------------------------------------------- |
| `implementation` | [references/dimension-implementation.md](references/dimension-implementation.md) |
| `intent`         | [references/dimension-intent.md](references/dimension-intent.md)                 |
| `conformance`    | [references/dimension-conformance.md](references/dimension-conformance.md)       |
| `security`       | [references/dimension-security.md](references/dimension-security.md)             |
| `testing`        | [references/dimension-testing.md](references/dimension-testing.md)               |
| `simplicity`     | [references/dimension-simplicity.md](references/dimension-simplicity.md)         |
| `structure`      | [references/dimension-structure.md](references/dimension-structure.md)           |

### Map user intent to dimensions

| User signal                                                                | Dimensions                                            |
| -------------------------------------------------------------------------- | ----------------------------------------------------- |
| Bare `code-review-hub`, "full review", "review my changes", "review my PR" | All seven, in parallel                                |
| Bugs, logic, regressions                                                   | `implementation`, `intent`                            |
| Spec, ticket, acceptance criteria, scope                                   | `intent`. Add `testing` when the user mentions tests. |
| Lint, style, conventions, principles                                       | `conformance`                                         |
| Security                                                                   | `security`                                            |
| Tests, coverage                                                            | `testing`                                             |
| Simplify, complexity, "can this be smaller"                                | `simplicity`                                          |
| Layout, naming, modules, boundaries, organization                          | `structure`                                           |
| Quality (vague)                                                            | `implementation`, `intent`, `conformance`, `testing` (omit `security`, `simplicity`, `structure` unless named) |
| Explicit dimension ids (for example `security structure`)                  | As given                                              |

## Coordinator spine

1. **Dimensions.** Pick rows from the intent table above.
2. **Target.** Read [references/target-resolution.md](references/target-resolution.md) and build one **Target brief** (copy spec fields from ticket, PR, or user when discoverable).
3. **Review runs (report-only).** Default: read [references/subagent.md](references/subagent.md), resolve **Hub skill directory** and **Reviewer model**, launch one Task per selected dimension (parallel when allowed). Set each Task `model` to the resolved slug. Do not read dimension references here; subagent prompts assign them.
   - **Inline path:** Read [references/shared-guardrails.md](references/shared-guardrails.md) once. Run dimensions in table order (top to bottom in **Dimensions**). For each selected id: read its dimension reference, produce one full **Report shape** block for that id, then move to the next. Do not merge dimension outputs until step 5.
4. **Wait and recover.** Wait for every subagent. On failure, classify it, fix that axis, and retry once per failed subagent: Task or tool error → check hub skill paths, repository path, and Task parameters in the prompt; empty or generic findings → enrich the Target brief (scope, spec fields, Notes); missing **Report shape** headings → resend the prompt template from [references/subagent.md](references/subagent.md). If it still fails, tell the user what blocked the run and offer the inline path.
5. **Merge and report.** Read [references/harmonization.md](references/harmonization.md). Run **Coordinator transform**, then dedup, sort, and present the merged report.

## Guardrails

- Subagents do not edit code.
- Large scope: follow [references/target-resolution.md](references/target-resolution.md) **Large diff** before step 3.

## Tools

- Git for scope: diff, default branch, checkout when the user names a PR or branch.
- GitHub CLI for **PR ticket discovery** in target-resolution when the user gave no spec.
- Task tool on the default path in step 3.
