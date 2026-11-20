---
name: pr-mergeability
description: >
  Judge a GitHub pull request on operational risk, impact, and maintainability risk,
  then recommend a review action from a fixed matrix plus a maintainability bump rule.
  Requires a github.com pull request URL. Use for "pr-mergeability", "mergeability",
  "can we merge this PR", or "/pr-mergeability".
disable-model-invocation: true
compatibility: Requires git, GitHub CLI (gh), and network access to github.com.
metadata:
  author: zs
  version: "1.2.1"
---

# PR mergeability

## Outcome

Short mergeability report with evidence from [references/scales.md](references/scales.md). Not line-by-line code review or exhaustive diff commentary.

## Input

Only a GitHub pull request URL: `https://github.com/<owner>/<repo>/pull/<number>`, or the same path without a scheme or with `http://`.

Reject branch names, commit SHAs, local diffs, issue links, non-GitHub hosts, and prose with no PR URL. Ask for `github.com/.../pull/<n>`.

## Guardrails

- Do not merge, approve, or push. Recommend an action only.
- Do not invent CI status, approvals, or deployment rules. Report what `gh` and the repo show.
- Thin evidence → score toward **medium** and say what you could not see.
- **CI passing** is required for "merge if CI passes". Red or missing required checks → not merge-ready.

## Context to gather

`gh` on parsed owner, repo, and PR number; read the local repo when it matches the base repo (clone or fetch if needed).

Minimum:

1. PR metadata: title, body, labels, draft, author, base and head branches.
2. Checks and reviews: `gh pr checks`, `gh pr view --json reviews,statusCheckRollup`.
3. Diff scope: file count, lines changed, path roll-up.
4. Description and linked issues: intent, rollout, flags, migrations.
5. Touchpoints: enough of changed files and neighbors for auth, data, APIs, concurrency, shared infrastructure.

Stop only on invalid URL or inaccessible PR; say what failed.

## Procedure

1. Validate URL; fetch metadata, checks, and diff (`gh pr view`, `gh pr diff`, `gh pr checks`, `gh pr view --json` as needed).
2. Map scope, read critical paths, align workspace head with `git` when same repo; search for risk drivers in scales.
3. Read [references/scales.md](references/scales.md) fully; score three bands with top signals; **base action** from matrix; apply maintainability bump.
4. Emit the report below.

## Report

Scannable shape:

```markdown
## Mergeability

**PR:** <link>
**Operational risk:** low | medium | high — <one-line why>
**Impact:** low | medium | high — <one-line why>
**Maintainability risk:** low | medium | high — <one-line why>
**Base action:** <matrix cell only>
**Recommended action:** <after maintainability bump>

### Operational risk signals
- …

### Impact signals
- …

### Maintainability risk signals
- …

### CI and reviews
- …

### Review focus
- … (paths, themes, or roles; omit section when action is "merge if CI passes" and nothing stands out)
```

Plain technical prose. Name real paths and checks.