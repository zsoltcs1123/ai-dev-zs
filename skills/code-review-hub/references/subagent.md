# Subagents

Launch Task subagents for report-only dimension runs. This file is the only wiring between shared guardrails and dimension references on the default path.

## Defaults

Launch one Task subagent per selected dimension. Run all selected dimensions in parallel unless the harness limits concurrency. Set `run_in_background: false` unless the user asks for a background run.

## Model

Same Task `model` slug on every dimension run. Precedence: user override, then default.

**User override:** Map the user's slug or natural name (Claude, Opus, Sonnet, Composer, GPT, Gemini, Grok; e.g. `claude-sonnet-5-5-high`) to a slug in this turn's Task allowlist. If unmapped or not allowed, list available models and hold Tasks until they pick a valid slug or drop the override.

**Default:** `grok-4.7-high` when listed; else omit `model` or use harness default.

Non-default slug: optional `Reviewer model:` line in merged report ([harmonization.md](harmonization.md)).

## Task parameters

- `subagent_type`: `generalPurpose`
- `description`: Short label, for example `code-review-hub intent`

## Hub skill directory

Before you fill the prompt template, set `<hub-skill-dir>` to the absolute path of this skill root (the directory that contains `SKILL.md` for `code-review-hub`).

Resolve it in this order:

1. Path from the skill attachment or invocation metadata when the harness provides it.
2. Project install: `<workspace>/.agents/skills/code-review-hub`
3. Repo checkout: `<workspace>/skills/code-review-hub` when that directory exists.

Substitute the absolute path for every `<hub-skill-dir>` in each Task prompt. Do not leave the placeholder in the prompt you send.

## Prompt template

```text
You are running the code-review-hub "<dimension-id>" dimension. Report only. Do not edit code.

Repository: <absolute path>
Target brief:
<paste Target brief>

Read and follow:
1. <hub-skill-dir>/references/shared-guardrails.md
2. <hub-skill-dir>/references/dimension-<dimension-id>.md

Return your final message using the Report shape in shared-guardrails.md (exact headings and finding line format).
```

Replace `<dimension-id>` with one of: `implementation`, `intent`, `conformance`, `security`, `testing`, `simplicity`, `structure`.
