# Scope prelude

Facet skills on a Compendium host follow these rules before running a command.

1. Confirm you are inside the host git work tree.
2. Load `scopes.yaml` from the workspace root.
3. Resolve the active scope from the user message. If more than one scope matches, ask once.
4. Resolve facet paths from `scopes[].facets` for that scope. Do not invent paths.
5. Read the facet skill for the command and [commits.md](commits.md) when committing.

## Vocabulary

- **Compendium** — the instance (this workspace).
- **Scope** — one taxonomy node under `loci/`.
- **Facet** — Library, Wiki, Academy, or Works on a scope.
- **Wiki** — one knowledge base at `wikis/<slug>/` inside a scope (not the whole Compendium).

## Invocation

Facet skills own commands. Use `wiki init`, not `compendium wiki init`.

## Cross-facet

- Library material worth compounding → `wiki ingest`.
- Wiki gap the user wants to learn → `academy teach`.
- Works ready to publish → update wiki pages and fact-check first.

## Data rules

- Record sources in Library; do not invent citations.
- Wiki pages compound from sources; mark gaps instead of guessing.
- Academy teaches; Wiki stores what is known.
- Works are user output; fact-check before treating them as wiki truth.