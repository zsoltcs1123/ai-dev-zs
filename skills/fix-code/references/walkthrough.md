# Walkthrough

Follow **Interactive** or **Non-interactive** to match the invocation mode.

Use severity order when severities exist: Major, then Medium, then Minor. Otherwise use the normalized list order.

## Interactive

For each issue:

1. **Present.** Say whether verification still supports the row. Show impacted lines with minimal context (`file:line-range`). Do not dump whole files.
2. **Propose.** State the fix. For a move, rename, or split across files, include a move map (`old/path` → `new/path`).
3. **Ask.** Fix, Skip, or Discuss.
4. **Wait** for the user before the next issue.

When the list is done, summarize what you fixed and what you skipped.

## Non-interactive

1. Ask once whether to fix all listed issues. When any fix touches more than one file, name moves, renames, or splits in that question.
2. On yes, apply every issue in list order without waiting between rows.
3. On no, stop with no edits.
4. After edits, summarize what you fixed.

If the user names a subset, follow that subset.