---
name: code-review-hub
description: Multi-dimension code review hub. Maps intent to dimensions, resolves target, surface-scans empty lenses, runs one subagent per remaining dimension (default Grok; override model in prompt), merges one report. Use for code-review-hub, full review, review my PR, or explicit dimension list.
disable-model-invocation: true
compatibility: Default path uses the Cursor Task tool for subagents. Inline path when Task is unavailable or the user asks for in-chat review, no subagents, or review inline in this chat.
metadata:
  author: zs
  version: "0.8"
---

# Code review hub

## Outcome

Run selected dimensions against a resolved target, then deliver one merged report (step 6). Stop unless the user asks for more in chat.

Open a reference only at the step that names it.

## Dimensions

One **launch** dimension equals one subagent run; **skip** ids use surface-scan stubs.

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
| Bare `code-review-hub`, "full review", "review my changes", "review my PR" | All seven; may surface-skip empty lenses |
| Bugs, logic, regressions                                                   | `implementation`, `intent`                            |
| Spec, ticket, acceptance criteria, scope                                   | `intent`. Add `testing` when the user mentions tests. |
| Lint, style, conventions, principles                                       | `conformance`                                         |
| Security                                                                   | `security`                                            |
| Tests, coverage                                                            | `testing`                                             |
| Simplify, complexity, "can this be smaller"                                | `simplicity`                                          |
| Layout, naming, modules, boundaries, organization                          | `structure`                                           |
| Quality (vague)                                                            | `implementation`, `intent`, `conformance`, `testing` (omit `security`, `simplicity`, `structure` unless named) |
| Explicit dimension ids (for example `security structure`)                  | As given (never surface-skipped)                      |
| Reviewer model in prompt (`with sonnet`, slug, etc.)                       | Unchanged dimension set; see [references/subagent.md](references/subagent.md) |
| `no skip`, `all dimensions`, `full depth`                                  | Same dimensions; disable surface skip                 |

## Coordinator spine

1. **Dimensions.** Pick rows from the intent table above.
2. **Target.** Read [references/target-resolution.md](references/target-resolution.md) and build one **Target brief** (copy spec fields from ticket, PR, or user when discoverable).
3. **Surface scan.** [references/surface-scan.md](references/surface-scan.md) → **launch** / **skip**, stub per **skip**.
4. **Review runs (report-only).** Default: [references/subagent.md](references/subagent.md); resolve hub dir and **Reviewer model**; one Task per **launch** dimension (parallel when allowed). Do not read dimension references here.
   - **Inline path:** [references/shared-guardrails.md](references/shared-guardrails.md) once; **launch** ids in **Dimensions** table order; full **Report shape** each. Combine with step 3 stubs at step 6.
5. **Wait and recover.** Wait for every subagent. On failure, classify it, fix that axis, and retry once per failed subagent: Task or tool error → check hub skill paths, repository path, and Task parameters in the prompt; empty or generic findings → enrich the Target brief (scope, spec fields, Notes); missing **Report shape** headings → resend the prompt template from [references/subagent.md](references/subagent.md). If it still fails, tell the user what blocked the run and offer the inline path.
6. **Merge and report.** Read [references/harmonization.md](references/harmonization.md). **Coordinator transform**, dedup, sort, then present the merged report (**Finding block format**, **Location links**).

## Guardrails

- Subagents do not edit code.
- Large scope: follow [references/target-resolution.md](references/target-resolution.md) **Large diff** before step 4.

## Tools

- Git for scope: diff, default branch, checkout when the user names a PR or branch.
- GitHub CLI for **PR ticket discovery** in target-resolution when the user gave no spec.
- Task tool on the default path in step 4.
