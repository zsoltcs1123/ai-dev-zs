---
name: compendium
description: Compendium workspace lifecycle in a host git repository — init, upgrade, migrate, and scope operations. Use when the user says compendium init, compendium upgrade, compendium migrate, or compendium scope.
metadata:
  author: zs
  version: "0.1.1"
---

# Compendium

## Outcome

The host git repository holds one Compendium instance: `scopes.yaml`, optional `loci/`, and prek hooks under the chosen workspace root. Rules live in bundle skills (this skill and facets), not copied host markdown. After `init`, facet skills govern behavior; do not add a host `AGENTS.md` unless the user asks.

## Guardrails

- Refuse any operation outside a git work tree (`git rev-parse --is-inside-work-tree`).
- Require `git` and `prek` on `PATH` before `init`.
- At most one instance per repository. Refuse `init` when `scopes.yaml` already exists at the repo root or under `compendium/`.
- Facet work uses facet skills (`wiki init`, `academy teach`, …). Do not nest facet commands under `compendium` (reject `compendium wiki init`).
- Do not overwrite host content without explicit `--force` on commands that support it.
- Facet skills must follow [references/scope-prelude.md](references/scope-prelude.md) on the host.

## Commands

| Command | Status | Detail |
| ------- | ------ | ------ |
| `init` | Active | [references/init.md](references/init.md) |
| `upgrade` | Stub | [references/commands/upgrade.md](references/commands/upgrade.md) |
| `migrate` | Stub | [references/commands/migrate.md](references/commands/migrate.md) |
| `scope` | Stub | [references/commands/scope.md](references/commands/scope.md) |

## Tools

- Read [references/init.md](references/init.md) before `init`.
- Copy host files from [references/scaffold/](references/scaffold/) into the workspace root. Preserve paths and placeholders.
- Shared host rules: [references/scope-prelude.md](references/scope-prelude.md), [references/commits.md](references/commits.md). Wiki rules until the wiki skill ships: [references/facet-wiki.md](references/facet-wiki.md).
- After scaffold copy, run `prek install` from the workspace root when hooks are not installed yet.
- For upgrades, migration, and scope edits, read the matching file under [references/commands/](references/commands/).