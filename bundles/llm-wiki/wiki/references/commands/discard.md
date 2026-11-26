# Wiki Discard

When wiki content should be removed:

1. Classify the discard:
   - `supersede`: content is folded into another page that now carries the claim.
   - `merge`: two or more pages collapse into one.
   - `out-of-scope`: page should not have been promoted into `wiki/`; the raw input may still be valid.
   - `retract-source`: the underlying source itself is wrong, withdrawn, or was wrongly captured.
2. Decide scope:
   - Wiki page only (default for `supersede`, `merge`, `out-of-scope`). `raw/` stays untouched.
   - Both wiki and raw (only for `retract-source`, and only when the raw material itself is the problem).
   - Raw only is rare and should be justified explicitly in the log entry.
3. Find dependents before deleting: inbound links from other `wiki/sources/`, `wiki/concepts/`, `wiki/entities/`, `wiki/syntheses/`, and `wiki/index.md`.
4. Update dependents:
   - For `supersede` / `merge`: repoint links to the surviving page and add a brief supersession note where the claim now lives.
   - For `out-of-scope`: remove links and any claims that only existed because of this page.
   - For `retract-source`: revisit every page that cited the retracted source and remove or qualify claims that depended on it. Do not silently leave orphaned claims standing.
5. Remove the file(s).
6. Update `wiki/index.md` if the discarded page was listed there (concept, entity, synthesis, or reference corpus).
7. Prepend a `wiki/log.md` entry per [log.md](../log.md) with classification, scope, reason, and the surviving page (if any).
8. Commit the changes if files changed, using `wiki(<wiki-slug>) discard: <summary>` per [commits.md](../commits.md).

Discard is not a normal lint outcome. A lint pass may *propose* discards, but the discard itself must run through this workflow.

## Before Starting

- Resolve target wiki per [resolve-wiki.md](../resolve-wiki.md).
