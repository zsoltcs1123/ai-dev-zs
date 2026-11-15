# Structural review workflow

## Report

Three sections:

1. **Summary.** One to three sentences: where code lives, how modules grew. No problems.
2. **Findings by dimension.** One line each: severity, clause, `file:line`. Headings: Layout, Naming, Responsibility, Dependencies, Surface and abstraction, Oddities. Empty dimension → `none`. Missing discovery docs → say once.
3. **Totals.** `Major N · Medium N · Minor N`.

One clause per finding; detail in fix phase. Over ~10 findings: optional dimension×severity table; default totals only.

## Fix protocol

Follow discovered convention and principles docs. Silent docs → match neighbors and judgment. No behavior change for a structural split without user confirm. If a fix may change correctness, flag it; do not fix correctness here.

### Structural refactor guardrails

- Fix listed findings only.
- **Interactive multi-file move/rename/split:** move map in **Propose** (`old/path` → `new/path`).
- **Non-interactive:** batch confirm must mention moves, renames, or splits when any fix touches >1 file.
- Update imports for renames; no broken references.
- Large cross-repo reshaping → **Discuss**, skip, or follow-up plan; no partial moves.

### Interactive

Highest severity first. Per issue: **Present** (problem + `file:line-range`, no full files) → **Propose** (fix + move map if needed) → **Ask** Fix / Skip / Discuss → **Wait**. End: summarize fixed vs skipped.

### Non-interactive

No issues → stop. Else ask once (note multi-file moves in the question). Yes → apply all, severity order, no per-issue wait. No → stop. Subset reply → follow it. End: summarize fixed.

## Edge cases

- No git/diff → ask for files, patch, or branch.
- Mixed stacks → convention docs per stack; no cross-stack layout rules.
- Diff over 20 files → ask full review or focus.
- User narrows after large-diff prompt → those files only.
- Correctness or security → brief mention only; do not hunt bugs or audit security.
- Ambiguous domain names → **Medium**; propose neighbor vocabulary; no invented definitions.

## Example report skeleton

```markdown
## Summary

Adds invoice export: new files under `features/invoicing/` and a shared CSV helper in `lib/csv/`.

## Findings by dimension

**Layout** — Medium: export UI logic in `lib/csv/write.ts` (src/lib/csv/write.ts:42)
**Naming** — Minor: file `doThing.ts` (src/features/invoicing/doThing.ts:1)
**Responsibility** — none
**Dependencies** — Major: feature imports `internal/db` (src/features/invoicing/export.ts:3)
**Surface and abstraction** — none
**Oddities** — none

## Totals

Major 1 · Medium 1 · Minor 1
```