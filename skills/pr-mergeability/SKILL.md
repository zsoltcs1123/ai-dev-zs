---
name: pr-mergeability
description: >
  Score a GitHub pull request for operational risk, impact, and maintainability risk;
  output a fixed review action (matrix plus maintainability bump). Requires a
  github.com pull request URL. Use for pr-mergeability, mergeability, "can we merge
  this PR", or /pr-mergeability.
disable-model-invocation: true
compatibility: Requires git, GitHub CLI (gh), and network access to github.com.
metadata:
  author: zs
  version: "1.2.3"
---

# PR mergeability

## Outcome

Short mergeability report using [references/scales.md](references/scales.md). Not line-by-line code review or exhaustive diff commentary.

## Input

Only a GitHub pull request URL: `https://github.com/<owner>/<repo>/pull/<number>`, or the same path without a scheme or with `http://`.

Reject branch names, commit SHAs, local diffs, issue links, non-GitHub hosts, and prose with no PR URL. Ask for `github.com/.../pull/<n>`.

## Guardrails

- Do not merge, approve, or push. Recommend an action only.
- Do not invent CI status, approvals, or deployment rules. Report what `gh` and the repo show.
- Thin evidence → score toward **medium** and say what you could not see.
- CI and branch policy: follow **CI and policy overrides** in [references/scales.md](references/scales.md).

## Context to gather

`gh` on parsed owner, repo, and PR number; read the local repo when it matches the PR repo (clone or fetch if needed).

Minimum:

1. PR metadata: title, body, labels, draft, author, base and head branches.
2. Checks and reviews: `gh pr checks`, `gh pr view --json reviews,statusCheckRollup`.
3. Diff scope: file count, lines changed, path roll-up.
4. Description and linked issues: intent, rollout, flags, migrations.
5. Touchpoints: from `gh pr diff` paths, read changed files and neighbors needed to judge auth, data, APIs, concurrency, and shared infrastructure.

Stop only on invalid URL or inaccessible PR; say what failed.

## Procedure

1. Validate URL; fetch metadata, checks, and diff (`gh pr view`, `gh pr diff`, `gh pr checks`, `gh pr view --json` as needed).
2. Read [references/scales.md](references/scales.md) fully.
3. When the local git remote matches the PR repo: `git fetch origin pull/<number>/head` and inspect at `FETCH_HEAD` (or checkout the PR head branch if already present); map critical paths from the diff; score three bands using the hunt list; set **base action** from the matrix; apply the maintainability bump (canonical action strings only).
4. Emit the report below.

## Report

Each **Level** cell is exactly one word: `low`, `medium`, or `high`. **Base action** and **Recommended action** use canonical strings from scales (verbatim).

```markdown
## Mergeability

**[<PR title>](<url>)**

| Dimension | Level | Rationale |
| --------- | ----- | --------- |
| Operational risk | <low\|medium\|high> | <short why> |
| Impact | <low\|medium\|high> | <short why> |
| Maintainability risk | <low\|medium\|high> | <short why> |
| Base action | — | <canonical matrix cell> |

### Verdict

**Recommended action:** <canonical, after maintainability bump>

<Optional: one line if recommended ≠ base, or CI/reviews block merge. Omit when identical and merge-ready.>

### Operational risk signals
- …

### Impact signals
- …

### Maintainability risk signals
- …

### CI and reviews
- …

### Review focus
- … (paths, themes, or roles; omit section when recommended action is `Merge if CI passes` and nothing stands out)
```

Plain technical prose. Name real paths and checks.

### Example (shape only)

```markdown
## Mergeability

**[Add rate limit to login](https://github.com/acme/api/pull/42)**

| Dimension | Level | Rationale |
| --------- | ----- | --------- |
| Operational risk | medium | Auth hot path; retries changed without new tests on lockout path |
| Impact | high | Default login flow for all users |
| Maintainability risk | low | Matches existing middleware pattern |
| Base action | — | Full code review and architecture review |

### Verdict

**Recommended action:** Full code review and architecture review

### Operational risk signals
- `internal/auth/login.go` — fail-open on Redis error

### Review focus
- Rollout flag default and rollback plan
```