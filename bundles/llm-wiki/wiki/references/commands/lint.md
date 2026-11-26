# Wiki Lint

Periodically health-check the wiki for:

- stale claims superseded by newer sources
- orphan concept/entity pages
- repeated concepts/entities that lack their own page
- missing links
- overlapping or duplicate pages
- raw notes that should be promoted into the wiki
- `raw/reference/` corpora missing a stub or index entry
- reference stubs pointing at missing raw corpora

Prepend lint passes to `wiki/log.md` per [log.md](../log.md).

If the pass changes files, commit them using `wiki(<wiki-slug>) lint: <summary>` per [commits.md](../commits.md).

## Standard Wiki Lint Pass

Use a bounded pass instead of trying to redesign the whole wiki at once.

1. Inspect orphaned or weakly linked pages first.
2. Inspect source pages with low inbound links before touching well-connected hubs.
3. Identify repeated ideas or named actors that now deserve promotion into `concept` or `entity` pages.
4. Strengthen links between existing pages before creating many new pages.
5. Promote only 1-3 high-confidence gaps per pass.
6. Do not create or update `wiki/syntheses/` during a normal lint pass unless the user explicitly asks for synthesis work.
7. Do not auto-promote reference corpora to full source pages during a normal lint pass.
8. When the pass changes the wiki, update `wiki/index.md` only if concept, entity, synthesis, or reference-corpus pages changed; prepend a concise entry to `wiki/log.md` per [log.md](../log.md).
9. Commit the changes if files changed, using `wiki(<wiki-slug>) lint: <summary>` per [commits.md](../commits.md).

A lint pass may *propose* discards but must not execute them. Use [discard.md](discard.md) for removals.

## Before Starting

- Resolve target wiki per [resolve-wiki.md](../resolve-wiki.md).
- Read [model.md](../model.md) for page roles and working rules.
