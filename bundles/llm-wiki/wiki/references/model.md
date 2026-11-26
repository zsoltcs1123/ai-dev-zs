# Wiki Model

Each wiki is a focused knowledge base with its own conceptual center of gravity. Use the local `README.md`, `HOME.md`, and content itself to understand that wiki's domain.

A wiki may live at the repo root, under `wikis/<slug>/`, or at another path (for example `wiki/` as a git submodule beside a codebase). The slug used in commits and `.wiki-root.yaml` identifies the wiki regardless of path.

## Consumer updates

Run `llm-wiki/skills/install.sh` to refresh operate behavior under `.agents/skills/`. Install does not change files inside an existing wiki tree.

Layout and convention drift uses two version signals:

| Signal | Location | Meaning |
| --- | --- | --- |
| Skill version | `wiki/SKILL.md` `metadata.version` | Installed operate contract |
| Scaffold version | `.wiki-root.yaml` `scaffold` | Last completed layout or convention migration |

If `scaffold` is missing, treat the wiki as version `1.0`. `/wiki init` writes `scaffold` from the skill version at init time. When the dev repo ships layout changes, run `/wiki migrate` (dry-run, then `--apply`) on each affected wiki. See [How to migrate a wiki](commands/migrate.md) and the [migration playbook index](migrations/README.md).

## Two Layers

### `raw/`

Immutable or mostly-immutable input material.

The raw layer has three distinct input classes:

- `raw/sources/`: verbatim source capture and local source assets tied to an exact external source
- `raw/notes/`: non-verbatim raw material such as human or LLM-authored source reports, extracted repo analyses, and original notes that still belong below the maintained wiki
- `raw/reference/`: large verbatim corpora (specifications, standards, long books) that are expensive to summarize but should remain searchable on demand

`raw/sources/` and `raw/reference/` must remain verbatim capture only: do not mix in LLM summaries, normalization, restructuring, or interpretation there.

Do not rewrite `raw/` as part of normal wiki maintenance. Read from it. Add to it when ingesting new material. Promote from it into `wiki/` when useful.

### Reference Corpora

A **reference corpus** is a large verbatim markdown collection kept under `raw/reference/{corpus-slug}/`. It may span multiple chunked `.md` files. Use reference corpora when full ingest would be too expensive and the primary need is grep-first search during queries, with synthesis filed only when explicitly asked.

Decision rule:

- normal-sized sources → `raw/sources/` + full ingest into `wiki/sources/{author}/`
- corpus-scale material → `raw/reference/{corpus-slug}/` + stub ingest into `wiki/sources/reference/{corpus-slug}.md`

Reference corpus stubs use `type: source` and `status: reference-corpus`. A stub should include the corpus title, scope, and file list or TOC pointers back into `raw/reference/{corpus-slug}/`. Do not run `summarize`, `quick-summarize`, or `citations` for reference corpora unless the user explicitly asks for full promotion.

### `wiki/`

Maintained knowledge base owned by the LLM.

- `wiki/sources/{author}/`: source pages by author (mirror `raw/sources/`); each file is quick + full summary + citations per [source-page.md](source-page.md).
- `wiki/sources/reference/`: lightweight stubs for `raw/reference/` corpora
- `wiki/concepts/`: durable ideas that accumulate evidence across sources
- `wiki/entities/`: recurring named actors, tools, companies, frameworks, people
- `wiki/syntheses/`: cross-source analyses, comparisons, reports, durable query outputs
- `wiki/index.md`: curated catalog of concept, entity, synthesis, and reference-corpus pages
- `wiki/log.md`: operational history, newest first ([log.md](log.md))

The wiki root is organized by page role (`concepts/`, `entities/`, `syntheses/`). Source pages are author-nested under `wiki/sources/{author}/` to mirror `raw/sources/` and keep provenance browsable. Use the author folder name from `raw/sources/{author}/` when it exists; otherwise use the filename prefix before the first `--`. When the raw folder and filename prefix differ (for example `mem0/` vs `mem0ai--`), prefer the raw folder name.

## Page Roles

Use a light content schema:

- `source`: one source distilled into a durable page
- `concept`: a recurring idea or thesis that spans sources
- `entity`: a named thing worth tracking across pages
- `synthesis`: cross-source analysis, comparison, or filed answer

## Frontmatter

Use minimal frontmatter on wiki pages:

```yaml
type: source | concept | entity | synthesis
status: draft | maintained | reference-corpus
updated: YYYY-MM-DD
source_org: optional
tags: [optional]
```

For `concept` pages, do not generate an `Implications for This Repo` section.

## Writing Style for Concept and Synthesis Pages

Concept and synthesis pages are read by humans. Optimize for that:

- **Readability first.** Good flow and a logical structure that reads as a narrative, not a pile of sections.
- **No unnecessary verbosity.** Clean, focused language. Cut filler, hedging, and throat-clearing.
- **Specific, focused, complete.** Convey maximum meaning in the fewest words. Prefer concrete claims over vague ones.
- **No redundancy.** Do not repeat the same information in multiple places on the page. State it once, in the place it belongs.
- **High information density.** State a claim once, then build on it with additional detail and examples.

## Working Rules

- Prefer starting from `HOME.md`, concept hubs, or `wiki/index.md` before deep-diving into a wiki.
- Treat `wiki/` as the maintained artifact.
- During normal maintenance, do not edit files in `raw/`.
- When a wiki-changing operation completes, prepend a log entry per [log.md](log.md).
- Update `wiki/index.md` only when concept, entity, synthesis, or reference-corpus pages change. Do not list routine source pages in `wiki/index.md`; they live under `wiki/sources/{author}/` and are reachable via links, search, and concept hubs.
- When a wiki-changing workflow completes and files changed, create a git commit for that wiki's changes.
- Keep the schema light. Do not invent rigid ontologies or heavy metadata unless there is a clear need.
- Prefer role-based organization and links over extra folders.
- During ingest, explicitly surface contradictions, stale claims, overlap, and structural issues exposed by new material instead of silently merging them away.
- Do not create or update `wiki/syntheses/` unless the user explicitly asks for a synthesis, comparison, assessment, or other durable filed answer.
- Deletion is a wiki operation, not a filesystem operation. Use the Discard workflow rather than removing files and relying on a later lint pass to reconcile.
- Do not promote a note into `wiki/sources/` unless the underlying raw note is preserved in `raw/notes/` (or the source is captured verbatim in `raw/sources/`). Provenance must remain reachable from the wiki page.
- Reference corpora default to stub ingest only. Full promotion from `raw/reference/` requires an explicit user request.
- Reference corpus stubs must point to reachable paths under `raw/reference/{corpus-slug}/`.
