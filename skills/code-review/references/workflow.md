# Review Workflow

## Report

Glanceable overview. Three sections:

1. **Summary** — 1-3 sentences describing what the changes do (not what's wrong with them).
2. **Findings by layer** — each issue as one short line: severity tag, brief description, location (`file:line`). If a layer has no issues, say so. For skipped layers (no conventions found, no spec found), say so briefly.
3. **Totals** — one line with counts per severity.

Keep descriptions to a single clause. Full explanations come in the fix phase.

If no convention, principles, or coding-rules docs were found, say so in the report for those layers and proceed on general judgment.

## Fix Protocol

When applying fixes (either mode), respect discovered docs. On conflict between layers 1–3, prefer principles over conventions over coding rules. Where those docs are silent, apply best general engineering judgment. Do not change code to satisfy a written standard that conflicts with standard judgment unless the user confirms.

### Interactive

Walk through issues one at a time, highest severity first across all layers.

For each issue:

1. **Present** — explain the problem. Show only the impacted lines plus a few lines of context (`file:line-range`). Don't dump entire functions.
2. **Propose** — describe the fix concisely.
3. **Ask** — Fix (apply immediately) / Skip (move on) / Discuss (refine, then re-ask)
4. **Wait** — wait for the user to respond before the next issue.

After the last issue, summarize what was fixed and what was skipped.

### Non-interactive

After the report:

1. If no issues → stop.
2. Ask once: fix all listed issues? (yes/no)
3. **Yes** → apply every issue in sequence, highest severity first. No per-issue wait.
4. **No** → stop. Report already delivered.
5. After applying → summarize what was fixed.

If the user answers with a subset instead of yes/no, follow that reply.

## Edge Cases

- **No git repo / no diff:** ask the user to name files, a patch, or a branch.
- **Mixed stacks:** load coding-rules and convention docs for every stack touched; don't apply one stack's rules to another.
- **User names specific files after a large-diff prompt:** review only those.
- **Spec ambiguity:** flag mismatches clearly; don't invent requirements the spec doesn't state.
