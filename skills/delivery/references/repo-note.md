# Repo note

Durable path: `delivery.sh repo-note` (under `${XDG_DATA_HOME:-~/.local/share}/delivery/<repo-key>/repo.md`).

Write markdown for agents. No required headings. Suggested content:

- **Last surveyed** — date and which files you read (README, CI, package scripts, etc.)
- **Install** — command(s) if needed before build or test
- **Build / lint** — obvious deterministic commands
- **Tests** — unit and integration; say which package or directory they cover
- **Optional runtime** — api, e2e, manual flows only when documented; mark optional
- **PR / branch** — only if this repo differs from feat/fix/chore or non-main default
- **Env / infra** — only what the repo documents; who owns shared stacks in worktree mode
- **Left out** — commands you considered but skipped and why

Refresh when setup docs or CI change. On rewrite, keep still-accurate prose and fix what broke.

Do not invent ports, seeds, or verify scripts. If the repo does not document something, say so under **Left out**.
