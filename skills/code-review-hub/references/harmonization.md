# Harmonization

Dedup, sort, and format command outputs into one merged report.

## Inputs

Each report-only run returns:

- `## Summary`
- `## Findings` with lines `severity | category | file:line | clause`
- `## Totals`
- `## Skipped` for layers, dimensions, or docs not found

## Dedup rules

1. **Same location.** Same `file:line`, or overlapping line range, and the same underlying issue → one row.
2. **Cross-command.** A general finding (for example Security) and a structural finding (for example Dependencies) that need one fix → one row with `source: both`. The clause should state both angles.
3. **Conflicting wording.** Prefer correctness or security wording over structural phrasing. Keep a second structural row only when the fix differs (for example rename versus logic bug).

For a single command, dedup lightly if needed.

## Sort order

1. Severity: Major, then Medium, then Minor.
2. Within one severity: `both` before single-source, then category alphabetically, then `file:line`.

## Merged report (present to user)

1. **Summary.** Combine run summaries into one to three sentences covering behavior and structure. Do not list issues here.
2. **Findings.** One line per issue: severity, `source` (`general`, `structural`, or `both`), category, clause, `file:line`. Group by severity by default. Mark empty categories as `none`. State missing discovery docs once.
3. **Totals.** `Major N · Medium N · Minor N`. Recompute globally after dedup. Do not sum per-run totals.

One clause per finding. Save detail for a separate fix pass if the user runs one later.

Produce one merged finding list. Do not split it back by command.