# Operational risk, impact, maintainability risk, and review actions

## Definitions

Three independent bands (low | medium | high):

- **Operational risk:** harm or costly recovery soon after merge (correctness, security, operability, rollback).
- **Impact:** who feels the change when it lands (users, revenue, compliance, teams, shared runtime).
- **Maintainability risk:** cost of future change (clarity, coupling, tests, conventions).

**Operational risk** and **impact** set **base action** in the matrix. **Maintainability risk** may bump one ladder step or floor at full code review. Disagreeing signals on one axis → **higher** band; name what forced it.

## Operational risk scale

| Band | Meaning | Typical signals |
| ---- | ------- | ---------------- |
| **Low** | Failure would likely stay local, cheap to fix, or caught before production. | Small diff; isolated module; mechanical change (format, rename, copy); tests cover touched behavior; no auth, payments, PII, or schema migration; familiar pattern in the repo. |
| **Medium** | Failure is plausible in production or recovery takes meaningful effort. | Moderate diff or several services; shared library or hot path; new dependency or behavior change; partial test gap on touched logic; config or flag with non-obvious defaults; error handling or retries change. |
| **High** | Failure can cause security incident, data loss, outage, or hard rollback. | Authn or authz, crypto, secrets, injection surface; migrations or destructive data work; concurrency or distributed timing; breaking public API or contract; large refactor without strong tests; infrastructure or deploy pipeline change; "disable safety check" patterns. |

Any clear high-band signal → high operational risk even if the diff is small.

## Maintainability risk scale

| Band | Meaning | Typical signals |
| ---- | ------- | ---------------- |
| **Low** | The change should stay easy to read and extend. | Matches nearby repo patterns; clear names and boundaries; complexity has tests; no new deep coupling; docs or types explain non-obvious parts. |
| **Medium** | Future edits are likelier to be slow or error-prone. | Shared or central module touched without extra care; partial test gap on branching logic; duplication or mixed concerns; abstractions that do not match the rest of the tree; large functions or files added without structure. |
| **High** | The merge materially raises long-term ownership cost. | Broad refactor with weak safety net; new cross-cutting pattern without adoption plan; dead or misleading code left behind; tight coupling across layers; "clever" logic without tests; public surface expanded without clear ownership. |

Does not by itself trigger architecture review; use it to deepen code review or **Review focus**.

## Impact scale

| Band | Meaning | Typical signals |
| ---- | ------- | ---------------- |
| **Low** | Few people or systems depend on the outcome. | Docs, comments, dev-only tooling, tests-only, internal UI with no customer path; telemetry or logging with no product behavior change. |
| **Medium** | A defined product area or team depends on it. | Single feature or service; behind a flag or limited rollout; admin or support tooling; localized UX change; non-breaking API addition. |
| **High** | Core journeys, many users, or org-wide dependencies. | Default user flows (signup, pay, login, create, publish); org-wide config; shared platform all apps use; release blocker; compliance or billing; multi-region or multi-tenant behavior; removes or rewrites a public contract. |

Use PR description, labels, and linked tickets when the diff understates rollout.

## Canonical review actions

Report **Base action** and **Recommended action** using **only** these four strings (exact spelling and casing):

1. `Merge if CI passes`
2. `Targeted review`
3. `Full code review`
4. `Full code review and architecture review`

| Action | When to use |
| ------ | ----------- |
| **Merge if CI passes** | Land without a dedicated review pass beyond automation. Honor branch protection and required reviewers when the repo enforces them. |
| **Targeted review** | One reviewer or owning team checks named paths or themes; list them in **Review focus**. |
| **Full code review** | Normal PR review: logic, tests, conventions, security smell, intent match. |
| **Full code review and architecture review** | Full code review plus system-context review: boundaries, data flow, contracts, migration and rollback, cross-service effects. |

Automation does not replace mandatory human reviewers when the repo or matrix requires them.

## Base action matrix

Row = **operational risk**, column = **impact**. Cell = **base action** (canonical string only).

| Operational risk \\ Impact | Low impact | Medium impact | High impact |
| ------------------------- | ---------- | ------------- | ----------- |
| **Low** | Merge if CI passes | Merge if CI passes | Targeted review |
| **Medium** | Targeted review | Full code review | Full code review and architecture review |
| **High** | Full code review | Full code review and architecture review | Full code review and architecture review |

### Matrix notes

- **Low operational risk, high impact:** Customer-facing paths and rollback plan go in **Review focus**; domain owner confirms behavior and rollout.
- **Medium operational risk, low impact:** Small blast radius; **Review focus** on risk drivers (security, data, concurrency).
- **Medium operational risk, high impact:** Architecture review when boundaries or contracts change; say so in **Review focus** or verdict line when unclear from the diff.
- **High operational risk, low impact:** Do not merge on size alone. **Review focus** on scary parts even when few users touch them.
- **High operational risk, medium impact:** Architecture review when the change is structural; name triggers in **Review focus**.
- **High operational risk, high impact:** Release gate; architecture review is mandatory.

## Apply maintainability risk

Ladder (lowest to highest; same strings as canonical actions):

1. Merge if CI passes
2. Targeted review
3. Full code review
4. Full code review and architecture review

| Maintainability risk | Rule |
| -------------------- | ---- |
| **Low** | Use the base action. |
| **Medium** | Bump **one** ladder step. Stop at step 4 if base action is already step 4. |
| **High** | At least **Full code review**. If base action is step 4, keep step 4. |

Report **Base action** (matrix only) and **Recommended action** (after bump). When they differ, one-line why.

## Signals to check in the diff

Hunt list while reading; band tables set scores. Not a mechanical checklist.

- **Security:** new inputs, SQL, shell, HTML, deserialization, permissions, token handling.
- **Data:** migrations, backfills, deletes, idempotency, dual-write.
- **Reliability:** timeouts, retries, circuit breakers, feature-flag defaults, fail-open vs fail-closed.
- **Coupling:** shared packages, generated code, cross-repo contracts.
- **Operability:** deploy order, config keys, observability, runbooks mentioned or missing.
- **Testing:** test files in the diff, coverage of failure paths, integration vs unit only.
- **Maintainability:** layering and module boundaries, naming, duplication, abstraction fit, test support for complex branches, match to neighboring files.

## CI and policy overrides

- Red or pending required checks: **not merge-ready** regardless of matrix cell.
- Draft PR: score risk and impact; merge is premature until marked ready.
- Required reviewers or CODEOWNERS on touched paths: mention under **Review focus** even when the matrix says `Merge if CI passes`.