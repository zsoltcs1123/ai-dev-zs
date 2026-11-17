# Subagents

Launch Task subagents for report-only dimension runs. This file is the only wiring between shared guardrails and dimension references on the default path.

## Defaults

Launch one Task subagent per selected dimension. Run all selected dimensions in parallel unless the harness limits concurrency. Set `run_in_background: false` unless the user asks for a background run.

## Model

Set `model` to `grok-4.7-high` when the Task tool lists that model. Otherwise omit `model` or use the harness default.

## Task parameters

- `subagent_type`: `generalPurpose`
- `description`: Short label, for example `code-review-hub intent`

## Prompt template

```text
You are running the code-review-hub "<dimension-id>" dimension. Report only. Do not edit code.

Repository: <absolute path>
Target brief:
<paste Target brief>

Read and follow:
1. <hub-skill-dir>/references/shared-guardrails.md
2. <hub-skill-dir>/references/dimension-<dimension-id>.md

Return your final message with exactly these headings (per shared-guardrails Report shape):

## Summary

## Findings
(one line per finding: Major|Medium|Minor | category | file:line | clause)

## Totals
Major N · Medium N · Minor N

## Skipped
(missing docs, unstated requirements, or "none")
```

Replace `<dimension-id>` with one of: `implementation`, `intent`, `conformance`, `security`, `testing`, `simplicity`, `structure`.