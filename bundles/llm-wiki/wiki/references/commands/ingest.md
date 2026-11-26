# Wiki Ingest

When new material is added to `raw/`, branch on input path. Read [model.md](../model.md) for the decision rule between `raw/sources/` and `raw/reference/`.

## `raw/sources/` or `raw/notes/`

1. Read the new file(s).
2. Create or update one page at `wiki/sources/{author}/{slug}.md` ([model.md](../model.md) author rule; [source-page.md](../source-page.md) layout). Same raw input: `#` title, `Source:` / `Author:` once, `## Quick summary`, `## Summary`, `## Citations` (replace on re-ingest). `Source:` points at the ingest path under `raw/`, not the upstream URL. Citations list in-body references only, not the article under ingest. No `quick/` files.
3. Identify contradictions, stale claims, overlap, or structural issues the new source exposes in existing `wiki/sources/`, `wiki/concepts/`, and `wiki/entities/`.
4. Update affected maintained pages to reflect disagreement, uncertainty, supersession, duplication, or unresolved tension when the new source changes the current understanding.
5. Update `wiki/syntheses/` only if the user explicitly asks for synthesis work and the new source materially changes an existing synthesis.
6. Update `wiki/index.md` only if this ingest created or changed a concept, entity, synthesis, or reference-corpus page.
7. Prepend an ingest entry to `wiki/log.md` per [log.md](../log.md); note contradiction handling when it occurred.
8. Commit the changes if files changed, using `wiki(<wiki-slug>) ingest: <summary>` per [commits.md](../commits.md).
9. Close with the [Response](#response) file list.

One source may update many wiki pages. That is expected.

## `raw/reference/`

Lightweight stub ingest for large verbatim corpora:

1. Read the new corpus files under `raw/reference/{corpus-slug}/`.
2. Create or update a stub at `wiki/sources/reference/{corpus-slug}.md` with `type: source` and `status: reference-corpus`. Include corpus title, scope, and file list or TOC pointers into `raw/reference/{corpus-slug}/`.
3. Add or update the **Reference Corpora** section in `wiki/index.md`.
4. Skip `summarize`, `quick-summarize`, and `citations` unless the user explicitly asks for full promotion.
5. Prepend a reference ingest entry to `wiki/log.md` per [log.md](../log.md).
6. Commit the changes if files changed, using `wiki(<wiki-slug>) ingest: <summary>` per [commits.md](../commits.md).
7. Close with the [Response](#response) file list.

## Response

End the run with markdown links to every `wiki/` file created or updated (source stubs, concepts, entities, `wiki/index.md`, `wiki/log.md`). Include the commit hash or subject when a commit was made. No-op: say so; link nothing.

## Before Starting

- Resolve target wiki per [resolve-wiki.md](../resolve-wiki.md).
- Read [model.md](../model.md) for structure, roles, and working rules.
