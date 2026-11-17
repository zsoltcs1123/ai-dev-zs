# Harmonization

Dedup, sort, and format dimension outputs into one merged report.

## Inputs

Each report-only run returns:

- `## Summary`
- `## Findings` with lines `severity | category | file:line | clause`
- `## Totals`
- `## Skipped`

## Primary owner (dedup)

When two dimensions flag the same `file:line` (or overlapping range) for one fix, keep one row. Use this table:

| Topic | Primary dimension |
| ----- | ----------------- |
| Spec or AC gap, scope creep, narrative mismatch | `intent` |
| Logic bug, wrong semantics, regression | `implementation` |
| Exploit or security control | `security` |
| Written rule or principle violation | `conformance` |
| Missing or weak test | `testing` |
| Simplifiable code without behavior loss | `simplicity` |
| Layout, naming, SRP, dependencies, abstraction, oddities | `structure` |

When spec-named behavior is wrong, **`intent`** is primary. Drop the duplicate **`implementation`** row if the fix is the same.

When you see an injection or authorization flaw, **`security`** is primary over **`implementation`**.

When a convention doc names the violation, **`conformance`** is primary. Drop the **`structure`** duplicate unless the fix differs (rename versus move module).

When SRP fails and no doc applies, **`structure`** is primary.

When fixes differ (for example a logic fix and a module move), keep two rows and set `source` to both dimension ids.

## Dedup rules

1. **Same location.** Same underlying issue gets one row per primary owner above.
2. **Multi-dimension.** Use one row with `source: dim1, dim2` when both angles matter and one clause can state the fix.
3. **Conflicting wording.** Use the primary owner clause. Keep a second row only when the fix differs.

Deduplicate lightly within a single dimension when needed.

## Sort order

1. Severity: Major, then Medium, then Minor.
2. Within one severity: multi-source before single-source, then category alphabetically, then `file:line`.

## Merged report (present to user)

1. **Summary.** Combine dimension summaries into one to three sentences. Cover behavior, intent, and structure as needed. Do not list issues here.
2. **Findings.** One line per issue: severity, `source` (dimension id or comma-separated ids), category, clause, `file:line`. Group by severity by default. Add a short **Coverage** line with `none` for empty dimensions when that helps. State missing discovery docs once.
3. **Totals.** `Major N · Medium N · Minor N`. Recompute after dedup. Do not sum per-dimension totals.

Write one clause per finding. Save detail for a fix pass when the user runs one later.

Produce one merged finding list. Do not split it back by dimension.