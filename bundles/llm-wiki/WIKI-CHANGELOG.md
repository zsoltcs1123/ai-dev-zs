# Wiki skill changelog

Consumer-facing operate layer notes. This file lives in the dev repo only. Init does not copy it into wikis.

## 1.5

- `wiki/log.md` is newest-first. Operate commands **prepend** entries; see `log.md`.
- Playbook `1.4-to-1.5` adds the convention line and reverses legacy oldest-first logs.
- Source-page section order documented consistently (`source-page.md`, `model.md`); scaffold no longer ships empty `wiki/sources/reference/`.
- Playbook `1.3-to-1.4`: citations merge rule; mechanical merge matches unified layout (title → attribution → quick → summary → citations).

## 1.4

- Source ingest: one page per source (`quick-summarize`, `summarize`, `citations`; citations last). No `quick/` tree. Layout: `source-page.md`.
- Ingest response links every `wiki/` file created or updated in that run.
- Playbook `1.3-to-1.4`: merge legacy quick siblings into source pages; remove empty `quick/` dirs.

## 1.3

- `/wiki migrate` supports dry-run (default), `--apply`, and `--to`. Tier A adds missing scaffold files. Tier B runs versioned playbooks.
- `.wiki-root.yaml` `scaffold` records the last completed layout migration. If the key is missing, the wiki is version `1.0`.
- To upgrade from skill 1.4 or older: run `install.sh`, then `/wiki migrate` on each wiki. Playbooks may include steps through `1.4-to-1.5`.
- Optional: `skills/install.sh --check` compares installed skill copies to the source tree.

## 1.2

- `wiki/index.md` lists only concepts, entities, syntheses, and reference corpora.
- Large corpora use `raw/reference/` with stub ingest.

## 1.1

- Run migrate on legacy wikis to backfill `.wiki-root.yaml` `slug` when you upgrade past 1.0.