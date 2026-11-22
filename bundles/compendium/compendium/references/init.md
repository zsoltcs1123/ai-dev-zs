# Compendium init

Create a new Compendium instance in the host git repository.

## Preconditions

1. Current directory is inside a git work tree.
2. `git` and `prek` are on `PATH`.
3. No existing instance: no `scopes.yaml` at the repository root and no `compendium/scopes.yaml`.
4. The Compendium bundle is installed on the host (`.agents/skills/compendium`).

## Choose workspace root

Ask once if the user did not say:

| Layout | Workspace root | Use when |
| ------ | -------------- | -------- |
| **Root** | Repository root | The repo is dedicated to knowledge, or Compendium owns the top level. |
| **Subdir** | `compendium/` under the repository root | The repo is mostly code; Compendium lives in a subdirectory. |

All scaffold paths are relative to the workspace root. For **subdir**, run facet skills from `compendium/` (or open that folder in the harness).

## Steps

1. Set `WORKSPACE` to the chosen root (`.` or `compendium/`). Create `WORKSPACE` if it is missing and layout is subdir.
2. Copy every file and directory from [scaffold/](scaffold/) into `WORKSPACE`.
3. Replace `{{WORKSPACE}}` in `scopes.yaml` with `.` for root layout or `compendium` for subdir layout.
4. Run `prek install` from the workspace root (same directory as `.pre-commit-config.yaml`).
5. Tell the user the workspace root, that rules live in installed bundle skills (start with this skill’s [scope-prelude.md](../scope-prelude.md)), and the next step: define scopes in `scopes.yaml`, then facet commands such as `wiki init`.

The scaffold ships empty `scopes: []` and no `loci/`. Taxonomy and directories appear when the user or facet skills add scopes.

## Flags (convention)

| Flag | Purpose |
| ---- | ------- |
| `--layout root\|subdir` | Skip the layout question when the user already chose. |
| `--force` | Not supported on `init`. Refuse and tell the user to remove the old instance or pick `upgrade` later. |

## Success

- `scopes.yaml` exists under `WORKSPACE`.
- `prek install` succeeded.
- No host `AGENTS.md` or `contracts/` tree is created.