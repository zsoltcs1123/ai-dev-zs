# Target resolution

Resolve the review target once. Fill a **Target brief** and pass that brief to every dimension (subagent or inline).

If the invocation and obvious chat context (open files, paths, linked PR) do not pin down the target, stop and ask. Do not guess.

## Target kinds

| Kind | Resolution |
| ---- | ---------- |
| File | One path. Read the full file. If the path sits outside the current diff, say so in the brief and still review when the user named the file. |
| Module | A bounded path set: user list, or one package or feature folder plus obvious neighbors. If the set is ambiguous, ask. |
| Feature or use case | Entry points and touched files from the description (routes, handlers, UI flows). If you cannot bound the file set, ask. |
| Worktree | Staged only, unstaged only, or both. Follow user wording. Default to both when they do not say. |
| Branch or PR | Named branch or PR. Check out when needed. Stash only after the user confirms if checkout blocks. Diff against the default base. |
| Service or app | Subtree root (for example `apps/api/`). If more than one service matches, ask which one. |

## Default base branch

Try `origin/HEAD`, then `main`, then `master`.

## Priority when signals conflict

1. User-named paths, module, feature, or service scope
2. User-named branch or PR
3. Worktree (staged, unstaged, or both)
4. Branch diverged from default: `git diff <default>...HEAD`

## Large diff

When scope spans more than 20 files, ask for a full review or a focus area before you launch subagents. If the user narrows scope afterward, update the brief to those paths only.

## Spec and context (required when discoverable)

Copy from ticket, PR, issue, or user message into the brief:

- **Stated goal.** One short paragraph.
- **Acceptance criteria.** Bullet list when present; otherwise `none supplied`.
- **Out of scope.** Stated items when present; otherwise `not stated`.

Paste links, ticket ids, and PR description excerpts into **Notes**. Dimensions use this block to avoid false positives.

## Target brief template

Paste this block into each subagent prompt:

```text
Repository path: <absolute path to git root>
Target kind: <file | module | feature | worktree | branch | service>
Paths or diff mode: <path list, or branch changes | uncommitted changes | path-scoped diff>
Base branch: <branch or PR diff only; omit otherwise>
Staged or unstaged: <worktree kind only>

Stated goal: <from user, PR, or ticket>
Acceptance criteria:
- <item>
- or: none supplied
Out of scope: <items or "not stated">

Notes: <PR link, ticket, constraints, copied PR description snippets>
```

## Diff modes

- **branch changes:** merge-base with the default branch, plus working tree changes when the kind requires them.
- **uncommitted changes:** staged, unstaged, or both per the brief.
- **path-scoped:** read and diff only listed paths. For the `structure` dimension, still read neighbors per [dimension-structure.md](dimension-structure.md).

## No git or empty scope

Ask for files, a patch, or a branch. Do not launch subagents until the brief is complete.