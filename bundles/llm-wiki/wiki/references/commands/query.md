# Wiki Query

When answering research questions against a wiki:

1. Start from `HOME.md`, relevant concept hubs, or `wiki/index.md`.
2. Read the relevant wiki pages first. Use `wiki/sources/{author}/` or backlinks when you need source evidence.
3. Check the **Reference Corpora** section in `wiki/index.md`. If the question may need corpus detail, grep or search `raw/reference/{corpus-slug}/` directly and read only matching sections.
4. Read other `raw/` material only when the wiki is insufficient or provenance needs checking.
5. Cite raw paths when answering from reference corpora.
6. By default, answer in chat only.
7. Only write to `wiki/syntheses/` if the user explicitly asks for a durable synthesis artifact.
8. Update `wiki/index.md` only if a curated hub page changed; prepend `wiki/log.md` per [log.md](../log.md) when a curated page was created or changed (concept, entity, synthesis, or reference corpus).
9. Commit the changes if files changed, using the standardized wiki commit format and the operation that best matches the work per [commits.md](../commits.md).

## Before Starting

- Resolve target wiki per [resolve-wiki.md](../resolve-wiki.md).
- Read [model.md](../model.md) for structure and writing style when creating pages.

## Default Route

When `/wiki` is invoked with a question and no explicit command, treat it as query.
