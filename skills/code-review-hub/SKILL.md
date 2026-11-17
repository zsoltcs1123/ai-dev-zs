---
name: code-review-hub
description: Hub for multi-dimension code review in one slash command. Maps user intent to dimensions, resolves the review target without guessing, runs one subagent per dimension, and merges one report. Use for "code-review-hub", "full review", "review my PR", or an explicit dimension list.
disable-model-invocation: true
compatibility: Default path uses the Cursor Task tool for subagents. Use the inline path when Task is unavailable or the user asks for in-chat review.
metadata:
  author: zs
  version: "3.0"
---

# Code review hub

## Outcome

Run the review dimensions you select against a resolved target. Publish one merged report. Stop when the report is delivered unless the user asks for more in chat.

Open a reference only at the step that names it.

## Dimensions

One dimension equals one subagent run.

| Dimension id | Reference |
| ------------ | --------- |
| `implementation` | [references/dimension-implementation.md](references/dimension-implementation.md) |
| `intent` | [references/dimension-intent.md](references/dimension-intent.md) |
| `conformance` | [references/dimension-conformance.md](references/dimension-conformance.md) |
| `security` | [references/dimension-security.md](references/dimension-security.md) |
| `testing` | [references/dimension-testing.md](references/dimension-testing.md) |
| `simplicity` | [references/dimension-simplicity.md](references/dimension-simplicity.md) |
| `structure` | [references/dimension-structure.md](references/dimension-structure.md) |

### Map user intent to dimensions

| User signal | Dimensions |
| ----------- | ---------- |
| Bare `code-review-hub`, "full review", "review my changes", "review my PR" | All seven, in parallel |
| Bugs, logic, regressions | `implementation`, `intent` |
| Spec, ticket, acceptance criteria, scope | `intent`. Add `testing` when the user mentions tests. |
| Lint, style, conventions, principles | `conformance` |
| Security | `security` |
| Tests, coverage | `testing` |
| Simplify, complexity, "can this be smaller" | `simplicity` |
| Layout, naming, modules, boundaries, organization | `structure` |
| Quality (vague) | `implementation`, `intent`, `conformance`, `testing` |
| Explicit dimension ids (for example `security structure`) | As given |

## Coordinator spine

1. **Dimensions.** Pick rows from the intent table above.
2. **Target.** Read [references/target-resolution.md](references/target-resolution.md). Build one **Target brief**. Copy **Stated goal**, **Acceptance criteria**, and **Out of scope** from the ticket, PR, or user when you can find them. If the invocation and chat context do not pin down the target, ask. Do not guess.
3. **Review runs (report-only).** Default: read [references/subagent.md](references/subagent.md) and launch one Task per selected dimension. Run them in parallel when the harness allows it. Set `model` to `grok-4.7-high` when the Task tool lists that model. Do not read dimension reference files yourself on this path; the subagent prompt assigns them.
   - **Inline path:** Read [references/shared-guardrails.md](references/shared-guardrails.md) once. Read only the dimension files you selected. Run report-only with the same Target brief and the report shape from shared guardrails.
4. **Wait and recover.** Wait for every subagent. On failure, fix the prompt or Target brief and retry once per failed subagent. If it still fails, tell the user what blocked the run and offer the inline path.
5. **Merge and report.** Read [references/harmonization.md](references/harmonization.md). Dedup, sort, and present the merged report.

## Guardrails

- Subagents do not edit code.
- When scope spans more than 20 files, ask for a full review or a focused scope before step 3.

## Tools

- Git for scope: diff, default branch, checkout when the user names a PR or branch.
- Task tool on the default path in step 3.