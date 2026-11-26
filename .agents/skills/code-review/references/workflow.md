# Review Workflow

## Layers

Evaluate the change set through all five. Apply standard engineering judgment where the repo has no written standard.

### Layer 1 — General Code Quality

Review separately against each category:

1. Bugs
2. Behavioral regressions
3. Performance issues

### Layer 2 — Conventions

Read every discovered convention document that applies to the changed files. Review separately against **each** convention. Flag violations that affect behavior, maintainability, or could confuse future readers.

### Layer 3 — Principles

Read every discovered principles document. Review separately against **each** principle. Flag violations even if unsure.

### Layer 4 — Security

Audit against discovered security docs and general security best practices (injection, authz gaps, secret leakage, unsafe defaults, untrusted input).

### Layer 5 — Testing

Every unit and integration test must earn its keep: test real functionality and add significant value. Flag unnecessary or redundant tests and missing coverage.

## Report

Glanceable overview. Three sections:

1. **Summary** — 1-3 sentences describing what the changes do (not what's wrong with them).
2. **Findings by layer** — each issue as one short line: severity tag, brief description, location (`file:line`). If a layer has no issues, say so.
3. **Totals** — one line with counts per severity.

Keep descriptions to a single clause. Full explanations come in the fix phase.

If no convention or principles docs were found, say so in the report and proceed on general judgment.

## Fix Protocol

When applying fixes (either mode), respect discovered repo conventions, principles, and rules; where those docs are silent, apply best general engineering judgment.

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
- **Mixed stacks:** load convention docs for every stack touched; don't apply one stack's rules to another.
- **User names specific files after a large-diff prompt:** review only those.
