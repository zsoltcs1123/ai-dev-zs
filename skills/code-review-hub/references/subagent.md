# Subagents

Task launch for report-only command runs.

## Defaults

One Task subagent per selected command. Launch both in parallel when the user selects `general` and `structural`. Use `run_in_background: false` unless the user asks for a background run.

## Model

- Set `model` to `grok-4.7-high` when the Task tool lists it.
- Otherwise omit `model` or use the harness default.

## Task parameters

- `subagent_type`: `generalPurpose`
- `description`: short label, for example `code-review-hub general`

## Prompt template

```text
You are running the code-review-hub "<command>" command. Report only. Do not edit code.

Repository: <absolute path>
Target brief:
<paste Target brief>

Read and follow <hub-skill-dir>/references/command-<command>.md.

Return your final message with exactly these headings:

## Summary

## Findings
(one line per finding: Major|Medium|Minor | category | file:line | clause)

## Totals
Major N · Medium N · Minor N

## Skipped
(layers or dimensions or docs not found, or "none")
```

Replace `<command>` with `general` or `structural`.