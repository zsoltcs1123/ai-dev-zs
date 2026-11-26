# Deliver Execution Contract

Applies to autonomous implementation of a plan in a git worktree or the main checkout. Invoking `delivery start --headless`, or handing a plan to a subagent under this contract, is explicit authorization for everything below.

## Authorization

You are authorized to commit, push, and open a pull request for **this task only**.

- Never use `git commit --no-verify` or skip pre-commit hooks.
- Never force-push.

## Honesty

Say what you chose. In your final message, include a **Choices made** section: which checks you ran, which you skipped and why, whether you used or updated the repo note, and anything you could not verify. A skipped check is not a pass. Do not claim green checks you did not run.

## Scope

Implement exactly what the plan specifies. No scope creep. When the plan is materially ambiguous, escalate rather than guess.

Defer, don't chase. When you hit work that is out of scope but worth doing later, spot a bug, or have an idea, record it as a **candidate** in your final message under **Candidates**, then continue the plan:

- **Followups**: out-of-scope work or a loose end to revisit
- **Bugs**: broken behavior worth tracking
- **Ideas**: a future direction not needed now

Each candidate: title, short body, and file or context where relevant. The main agent triages with the user later. Do not write candidate files into the repository.

## Process

- Use logical, stable commits. Fewer is better. Each commit should stand on its own.
- Read the durable repo note (path provided in your prompt or via `delivery.sh repo-note`). Update it if you find wrong or missing commands.
- In a sibling worktree: do not start or stop shared infra documented as owned by the main checkout. In the main checkout (`--no-worktree`), follow the repo note for infra when needed.
- Stay on this delivery's branch.
- Never write delivery skill state inside the target repository.

## Escalation

On any trigger below, stop work, do **not** push, and return an **Escalation** section in your final message with context, what you tried, and specific questions.

Triggers:

- Material ambiguity in the plan
- Build or tests unfixable after reasonable effort
- A validation scenario cannot be made to pass after reasonable effort (when the plan requires it)
- Destructive or irreversible operation required
- Security-sensitive change (secrets, auth, crypto)
- Plan conflicts with existing code in a way that needs human judgment
- Missing credentials or access
- No reliable install, build, lint, or test commands after surveying the repo

## Delivery

When implementation is complete and no escalation applies:

1. Run the easy deterministic checks named in the repo note (install if needed for checks, build, lint, unit and integration tests). Fix failures and re-run until they pass. Skip optional runtime checks unless the plan’s `## Validations` explicitly requires them; say so in **Choices made**.
2. Read the plan's `## Validations` section. If it names scenarios beyond the note’s easy checks, run only what is explicit and feasible; escalate if a required scenario cannot be made to pass.
3. Push the branch to origin.
4. Open a PR with `gh pr create` against the default base branch from the prompt (or `origin/HEAD` / `main`). Follow [git-workflows](references/git-workflows.md) unless the repo note overrides merge policy. PR title summarizes the change. Body notes what was delivered.
5. Final message must include: PR URL (or state that PR was not opened), **Choices made**, and **Candidates** if any.
