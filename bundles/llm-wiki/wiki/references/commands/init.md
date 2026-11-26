# Wiki Init

Create the initial wiki structure in the current directory or a target path.

## Modes

### In-repo (default)

```bash
/wiki init
/wiki init --path wikis/my-topic
/wiki init --path wikis/my-topic --slug my-topic
```

Use when the wiki lives in the same git repo as its host (multi-wiki research repo, new topic folder, etc.).

### Submodule (optional)

```bash
/wiki init --path wiki --submodule git@github.com:you/my-service-wiki.git
/wiki init --path wiki --submodule <url> --slug my-service
```

Use when the wiki should live in a separate repo, mounted beside a codebase (for example `my-service/wiki/`).

## Steps

1. Target = cwd or `--path <dir>` (create parent dirs if missing).
2. If `--submodule <url>` is set:
   - Run `git submodule add <url> <path>` (fail clearly if path exists and is not already a submodule).
   - Target becomes the submodule mount path.
3. Refuse if target already looks like a wiki root (`wiki/index.md` + `raw/`) unless `--force`.
4. Copy scaffold from [scaffold/](../scaffold/) into target (all files and directories).
5. Write or update `.wiki-root.yaml`:

```yaml
slug: my-topic
name: optional human label
scaffold: "1.5"
```

Set `slug` from `--slug` or the target directory name. Set `scaffold` to the `metadata.version` value in this skill's `SKILL.md`.

1. Customize `README.md` scope section with the wiki's center of gravity.
2. Seed `wiki/log.md` from scaffold ([log.md](../log.md)): convention line plus a bootstrap entry with init date and slug.
3. If host has `wikis/AGENTS.md`, append a registry row for the new wiki.

## Flags

| Flag | Default | Purpose |
| --- | --- | --- |
| `--path <dir>` | cwd | Where to create wiki root |
| `--slug <slug>` | dir name | Slug for `.wiki-root.yaml` and registry |
| `--submodule <url>` | none | Add git submodule before scaffold |
| `--force` | false | Re-init over existing empty/partial dir |

## After Init

- Open the wiki directory as an Obsidian vault (see `OBSIDIAN.md`).
- Install wiki skills if not already present: `llm-wiki/skills/install.sh .`
- Add normal source material to `raw/sources/` or `raw/notes/`, then run `/wiki ingest`.
- Add large verbatim corpora to `raw/reference/{corpus-slug}/`, then run `/wiki ingest` for stub cataloging.
