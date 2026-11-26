---
name: delivery
description: >
  Deliver an approved plan end-to-end in an isolated git worktree or the main
  checkout: discover repo commands, provision, implement, commit, push, open a PR.
  Repo facts are cached in a durable markdown note outside the repo. Use when asked
  to "deliver this", "ship this plan", "implement in a worktree", or "/delivery".
disable-model-invocation: true
compatibility: Requires git and bash. Headless mode requires cursor-agent.
metadata:
  author: zs
  version: "2.1.0"
---

# Delivery

Implement a plan under an execution contract and land it as a pull request. Default: isolated sibling worktree (`../<repo-name>-<slug>`). Use `--no-worktree` to run in the main checkout instead.

The skill does **not** write files into the target repository. Per-run state (plan copy, headless log) lives under tmp. Durable repo facts live in a markdown note outside the repo.

## Outcome

The plan is delivered on its own branch via a pull request, or a clean escalation returned in the worker’s final message. In worktree mode, shared infra (when documented in the repo note) stays on the main checkout.

Success means: repo note current, delivery provisioned, plan implemented per contract, easy deterministic checks from the note green before push, commits pushed, PR opened (or escalation documented with context). Out-of-scope discoveries come back as **candidates** in the final message for triage.

## Repo note

Path: run `bash <skill-dir>/scripts/delivery.sh repo-note` from the repo (prints the path and creates the parent directory).

Typically `${XDG_DATA_HOME:-~/.local/share}/delivery/<repo-key>/repo.md`. `<repo-key>` is derived from `origin` (`host/org/repo`); without origin, `local/<hash>`.

No fixed schema. Write markdown for the next agent: install, build, lint, unit and integration tests, optional runtime checks (api, e2e) only when well documented, branch/PR conventions if non-default, env or infra notes only when the repo documents them.

Before each delivery:

1. Read the note if it exists.
2. Check whether setup instructions changed (README, CONTRIBUTING, AGENTS.md, manifests, CI, task runners).
3. If missing or stale, survey the repo again and rewrite the note. State what you reused, what you changed, and what you left out.

Record only obvious commands. If something needs a running stack or feels painful, skip it or mark it optional. Do not invent commands. Required gate before push: easy deterministic checks only. Optional runtime checks run only when the plan’s `## Validations` explicitly requires them.

## Guardrails

- **Honesty**: Say what you chose, in plain language: note reused or rewritten, checks you will run, skips and why, anything you could not find. A skip is not a pass. Do not record unclear commands. The note states what was verified and what was left out. The worker’s final message includes **Choices made** with the PR URL, candidates, or escalation.
- **Repo note**: primary source for install, build, lint, and test commands. Fix the note when a recorded command is wrong.
- **No repo pollution**: never write delivery skill state into the target repository.
- **Shared infra**: in worktree mode, do not start or stop shared infra unless the repo note says you are operating in the main checkout.
- **Branch naming**: derive from the task. Default prefixes are `feat/`, `fix/`, `chore/` unless the note records another convention.
- **Contract authority**: `contract.md` authorizes commits, push, and PR for this task only.
- **Verification**: run the note’s easy checks before push.
- **Cleanup**: non-destructive only. Use `scripts/delivery.sh remove`, never `rm -rf`.
- **Defer, don't chase**: candidates belong in the final message, not in repo files (see `contract.md` Scope).

## Kickoff (main agent)

1. Confirm plan scope with the user when unclear.
2. Run `repo-note`, refresh the repo note per above, and tell the user your note and check choices.
3. Locate or produce a plan (`~/.cursor/plans/*.plan.md`, or `--prompt` for ad-hoc text).

## Completion (main agent)

After the subagent finishes (PR opened or escalation):

1. Read **Candidates** from the worker’s final message (or headless log via `watch`).
2. Triage each candidate with the user: act now, backlog, or discard.

## Modes

Both modes provision via `scripts/delivery.sh` and implement the plan under `contract.md`. They differ only in who runs the implementing agent. **Default to subagent mode. Use headless only when the user explicitly asks** (for example "fire and forget", "detached", "headless").

Add `--no-worktree` to run in the main checkout instead of a sibling worktree.

Resolve `<skill-dir>` from the copy you loaded (`~/.agents/skills/delivery` or `<repo>/.agents/skills/delivery`).

### Subagent (default, native UI monitoring)

A `composer-2.5` Task subagent implements in the delivery directory. You stay in the main window.

1. Provision: `bash <skill-dir>/scripts/delivery.sh start feat/<slug> --plan <name> [--no-worktree]` (prints delivery path, repo note path, and tmp run dir; plan copy in tmp).
2. Launch a background Task subagent (`subagent_type: generalPurpose`, `model: composer-2.5`, `readonly: false`, `run_in_background: true`) with a prompt that: follows `<skill-dir>/contract.md`, reads the repo note, implements the plan from `<run-dir>/plan.md` or the plan text you pass, operates at the delivery directory’s **absolute path**, and returns PR URL, **Choices made**, **Candidates**, or **Escalation** in the final message.
3. The subagent commits, pushes, and opens the PR per the contract.

In worktree mode, the subagent inherits the **main checkout** as its workspace context (indexing and the diff tree reflect main, not the worktree). The prompt must give the delivery directory’s **absolute path**.

### Headless (fire-and-forget, watched)

A detached `cursor-agent` CLI runs in the delivery directory. The main chat agent narrates it.

```bash
bash <skill-dir>/scripts/delivery.sh start feat/<slug> --plan <name> [--no-worktree] --headless
```

Runs `cursor-agent` in the background (log under the tmp run dir). Requires `cursor-agent login`.

**Watch:** monitor with `scripts/delivery.sh watch <branch|path>` (add `--follow` to stream). Report notable activity, escalations, and completion. Run `watch` on demand. The agent keeps running if this chat ends. The log is the signal for completion and for **Choices**, **Candidates**, and **Escalation** sections.

## Tools

- `scripts/delivery.sh` — `repo-note`, `start <branch> [--plan|--prompt] [--no-worktree] [--headless] [--model]`, `watch <branch|path> [-f]`, `list`, `remove`, `doctor`. `delivery.sh` in the skill root forwards to the script.
- `contract.md` — execution contract (authorization, process, escalation, delivery)
- [git-workflows](references/git-workflows.md) — default branch and PR rules when the repo note does not override them
- [repo-note guide](references/repo-note.md) — what to discover and how to write the note

## Coordination

Single agent per delivery directory. Shared infra is a human concern unless the plan and repo note make ownership explicit.
