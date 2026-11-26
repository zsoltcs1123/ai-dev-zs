# Wiki Migrate

Bring an existing wiki up to date with the installed wiki skill layout and conventions. You do not re-run init, and you do not copy the whole scaffold over the wiki.

## Upgrade a wiki after you install skills

1. From the host repo, run `path/to/llm-wiki/skills/install.sh .`
2. Resolve the wiki (see [resolve-wiki.md](../resolve-wiki.md)).
3. Run `/wiki migrate` and read the plan.
4. Run `/wiki migrate --apply` when the plan looks right.
5. If you changed files, prepend `wiki/log.md` per [log.md](../log.md) and commit once per [commits.md](../commits.md).

You can run `/wiki lint` after apply.

```text
/path/to/llm-wiki/skills/install.sh .
/wiki migrate
/wiki migrate --apply
```

## When you need migrate

Run migrate when `WIKI-CHANGELOG.md` or release notes say the layout or conventions changed, or when `.wiki-root.yaml` `scaffold` is older than the installed wiki skill version.

If the release only changes operate behavior (commands, guardrails, lint rules) and no playbook applies, run `install.sh` only.

## Flags and resolution

| Input | What happens |
| --- | --- |
| Default (dry-run) | Reports skill version, wiki `scaffold`, version gap, missing additive files, playbook chain, and whether `--apply` is warranted |
| `--apply` | Runs tier A additive sync, then tier B playbooks in order until `scaffold` reaches the target |
| `--to <ver>` | Stops at the named version instead of the latest skill version |
| `--path`, `--wiki` | Resolves the wiki root per [resolve-wiki.md](../resolve-wiki.md) |

In a multi-wiki host repo, a dry-run at the repo root may list each wiki root using the same discovery rules as resolve. `--apply` updates one resolved wiki per run unless you explicitly ask to loop all wikis.

You can track versions in the host copy of [WIKI-SYSTEM.md](../../../../WIKI-SYSTEM.md) at `wikis/WIKI-SYSTEM.md`.

## Version fields

| Field | Where | Meaning |
| --- | --- | --- |
| Skill version | Installed `wiki` skill `SKILL.md` `metadata.version` | Target operate contract |
| `scaffold` | `.wiki-root.yaml` | Last completed layout or convention migration |

If `scaffold` is missing, treat the wiki as version `1.0`. The default target is the installed skill version unless you pass `--to`.

## Tier A: additive sync

Copy paths from [scaffold/](../scaffold/) only when the destination file does not exist yet.

The sync never overwrites these paths when they already exist:

- `wiki/index.md`, `wiki/log.md`, `README.md`, `HOME.md`
- Any file under `wiki/sources/`, `wiki/concepts/`, `wiki/entities/`, or `wiki/syntheses/`
- Any existing file under `raw/sources/` or `raw/notes/`

Common additions include `OBSIDIAN.md`, `raw/reference/README.md`, and missing layout directories.

With `--accept-scaffold-overwrites`, you may replace boilerplate outside that deny list (for example `OBSIDIAN.md`). The flag is off by default. Do not use it on the index, maintained wiki pages, or raw capture.

## Tier B: playbooks

Walk from the current `scaffold` value to the target using [migrations/](../migrations/) in semver order:

1. `1.0-to-1.1.md`
2. `1.1-to-1.2.md`
3. `1.2-to-1.3.md`
4. `1.3-to-1.4.md`
5. `1.4-to-1.5.md`

Show the diff for `.wiki-root.yaml` and `wiki/index.md` before you write. Get confirmation during `--apply`.

## Tier C: breaking changes

Breaking playbooks need explicit user sign-off. Do not run them by default.

## Dry-run checklist

1. Resolve the wiki root.
2. Read the installed skill version and wiki `scaffold`.
3. Pick the target (`--to` or skill version).
4. If the wiki is already at the target, report a no-op and stop.
5. List additive paths that would be created.
6. List the playbook files in order.
7. Say whether `--apply` is appropriate.

## Apply checklist

1. Build the dry-run plan and confirm where the playbook requires it.
2. Run tier A additive sync (honor the deny list and `--accept-scaffold-overwrites`).
3. Run each playbook in order. Set `scaffold` in `.wiki-root.yaml` after each completed step.
4. Set `scaffold` to the final reached version.
5. Prepend `wiki/log.md` per [log.md](../log.md).
6. Create one commit: `wiki(<slug>) migrate: <summary>`.