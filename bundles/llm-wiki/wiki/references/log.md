# Wiki log

Operational history at `wiki/log.md`. Newest entries first.

## Format

```markdown
# Wiki Log

Newest entries first. Do not edit or remove prior entries.

## [YYYY-MM-DD] <operation> | <short summary>

- Outcome bullets
```

- `operation` matches commit verbs where possible: `init`, `ingest`, `lint`, `discard`, `migrate`, `query`, etc.
- One `##` block per workflow run. Do not merge unrelated runs.

## Write rule

**Prepend** each new block immediately after the convention line (or after `# Wiki Log` when that line is missing). Never insert below older entries. Never delete or rewrite prior blocks except during an explicit log-order migrate.

## Read rule

Recent activity is at the top. Do not scroll to the file bottom for latest entries.