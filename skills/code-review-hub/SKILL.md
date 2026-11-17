---
name: code-review-hub
description: Standalone hub for general six-layer and six-dimension structural review in one slash command. Maps intent to commands, resolves the review target without guessing, runs each command in a subagent, and publishes a merged report. Use for "code-review-hub", "full review", "review my PR", or explicit general or structural lists.
disable-model-invocation: true
compatibility: Default path uses the Cursor Task tool for subagents. Use the inline path when Task is unavailable or the user asks for in-chat review.
metadata:
  author: zs
  version: "2.0"
---

# Code review hub

## Outcome

Run one or both review commands on a resolved target. Publish a merged report. The run ends there unless the user asks for something else in chat.

Read a reference only when the spine below points to it.

## Commands

v1 supports only `general` and `structural`:

| Command | Reference |
| ------- | --------- |
| `general` | [references/command-general.md](references/command-general.md) |
| `structural` | [references/command-structural.md](references/command-structural.md) |

### Map intent to commands

| User signal | Commands |
| ----------- | -------- |
| Bare `code-review-hub`, "full review", "review my changes", "review my PR" | `general`, `structural` |
| Quality, bugs, security, tests, spec, conventions | `general` |
| Layout, naming, module boundaries, organization, structure | `structural` |
| Explicit `general`, `structural`, or both (for example `general structural`) | As given |

## Coordinator spine

1. **Commands.** Use the intent table above.
2. **Target.** Read [references/target-resolution.md](references/target-resolution.md). Build one **Target brief**. If the invocation and obvious chat context do not pin down the target, ask. Do not guess.
3. **Review runs (report-only).** Default: read [references/subagent.md](references/subagent.md) and launch one Task subagent per command (parallel when both). Set `model` to `grok-4.7-high` when Task lists it.
   - **Inline path:** Task unavailable or user wants in-chat review → read the command reference(s) for each selected command, run report-only with the same Target brief.
4. **Wait and recover.** Wait for every subagent. On failure, fix the prompt or Target brief and retry once per failed subagent. If it still fails, tell the user what blocked the run and offer the inline path.
5. **Merge and report.** Read [references/harmonization.md](references/harmonization.md). Dedup, sort, and present the merged report to the user.

## Guardrails

- Subagents do not edit code.
- **Major:** correctness bugs, security, data loss, missed spec, misleading boundaries or layering.
- **Medium:** convention or principle breaks, coupling, neighbor inconsistency.
- **Minor:** cleanup, small naming or placement wins.
- More than 20 files in scope: ask for a full review or a focused scope before step 3.
- Do not flag pre-existing issues outside scope unless they are Major and the change makes them worse (per command guardrails).

## Tools

- Git for scope: diff, default branch, checkout when the user names a PR or branch.
- Task tool when using the default path in step 3.