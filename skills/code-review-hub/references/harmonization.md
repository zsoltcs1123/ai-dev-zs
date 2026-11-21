# Harmonization

Dedup, sort, and format dimension outputs into one merged report.

## Inputs

Dimension outputs follow [shared-guardrails.md](shared-guardrails.md) **Report shape**. Severity labels are comparable: each run used its dimension **Severity** bands with the shared scale there. Do not re-rank when merging.

## Coordinator transform

Do not paste per-dimension **Findings** lines into the merged report as-is.

For each row under a dimension's `## Findings`, parse `severity | category | file:line | clause`. Set `source` to that dimension id (the Task you launched, or the dimension file you ran on the inline path). Apply **Primary owner**, **Dedup rules**, and **Sort order** below. Hold the normalized fields internally (`severity`, `source`, `category`, `clause`, `location`). Emit the user-facing **Finding block format** only.

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

When the fix is the same but dimensions disagree: wrong spec-named behavior → **`intent`** over **`implementation`**; injection or auth flaw → **`security`** over **`implementation`**; convention doc names the violation → **`conformance`** over **`structure`** unless fixes differ (rename versus move).

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

Optional first line when reviewer model is not default: `Reviewer model: <slug>`.

Write for a human reader in chat or on a PR, not for log parsers.

1. **Summary.** Combine dimension summaries into one to three sentences. Cover behavior, intent, and structure as needed. Do not list issues here.
2. **Findings.** Group under `### Major`, `### Medium`, and `### Minor` (omit empty buckets). One **finding block** per issue; blank line between blocks.
3. **Coverage.** Short paragraph when useful: [surface-scan.md](surface-scan.md) skips (reason per id), subagent **Skipped** `none`, missing discovery docs once.
4. **Totals.** `Major N · Medium N · Minor N`. Recompute after dedup. Do not sum per-dimension totals.

### Finding block format

```markdown
**{Lens}**
[{filename}:{line}]({url})
{clause}
```

Blank line before the next block. Line 2 is always a link or `` `{filename}:{line}` `` fallback (`{url}` still uses the full `path`). Path stays off the lens line and out of the clause. Clause: actionable text only; ticket or AC refs inline when relevant.

**Lens** (from `source`, not raw `category`):

| `source` | Lens label |
| -------- | ---------- |
| Single dimension id | Title Case id (`Intent`, `Testing`, `Structure`, …) |
| `dim1, dim2` | `Dim1, dim2` in title case, comma-separated |
| `structure: Subcheck` | `Structure (Naming)` style: subcheck in parentheses |

**Link text:** `{filename}:{line}` only (last path segment). If two findings share the same filename, use `{parent}/{filename}:{line}` for the colliding rows only.

### Location links

Resolve mode once per report; reuse `{url}` pattern for every finding. Split dimension `file:line` into `path` and `line`.

| **Local** `vscode://file/...` | **Remote** GitHub / GHE blob |
| ----------------------------- | ---------------------------- |
| Kind `file`, `worktree`, or `module` / `feature` without PR in **Notes** | PR URL in **Notes** or `gh pr view` for current branch |
| Diff `uncommitted changes`, staged-only, or `path-scoped` | Kind `branch` and explicit PR review (user named or linked PR) |
| User asked local / unstaged / “my changes” | Shared PR link or off-machine reviewer context |

Branch plus open PR: **local** if the brief includes staged or unstaged scope; else **remote**.

**Remote:** `https://{host}/{org}/{repo}/blob/{ref}/{path}#L{line}`. `{ref}` = PR head branch or `headRefOid` from **Notes** / GitHub CLI, else branch name or `HEAD`. `host`, `org`, `repo` from `origin` or the PR URL.

**Local:** `abs` = **Repository path** from the Target brief joined with `path` (normalize slashes; no `..`). URL = `vscode://file/{abs}:{line}:1`. Cursor and VS Code accept this; if the harness blocks custom schemes, use `file://{abs}` with the same link text. WSL POSIX vs Windows open path: match the workspace root form when you know the mapping.

Remote mode with no `origin` but **Repository path** set: use **local**. Else line 2 is backticks only.

Save detail for a later fix pass. One merged finding list; do not split back by dimension.