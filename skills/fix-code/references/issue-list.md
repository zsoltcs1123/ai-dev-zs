# Issue list

## Valid row

Each row must name one code issue:

| Field | Requirement |
| ----- | ------------- |
| Location | `file:line`, `file:line-range`, or a repo path plus a region the reader can open. A whole repo or vague area alone is not enough. |
| Problem | What is wrong or what should change, in one clause or short sentence. |

Optional: severity, category, tag.

## Accepted sources

- Bullets or table rows (for example from an earlier report in chat)
- A markdown or text file of findings
- Pasted lines with `path:line` and a problem on the same row or the next line

## Reject and ask

Do not start fixes. Tell the user what is missing. Reject when you see:

- Vague goals with no rows ("fix my code", "clean this up", "improve quality")
- Only a PR link, branch name, or module name with no per-issue locations
- A narrative summary with no locators ("the auth flow is messy")
- Rows with no path and no resolvable path in the workspace

## Ask format

Say that `fix-code` needs one row per issue with location and problem. Give this example:

```text
src/foo.ts:42: missing null check before parse
src/bar.ts:10-18: duplicate helper; use shared util from lib/x
```

When the user attached a file, name the file and the rows that failed validation.