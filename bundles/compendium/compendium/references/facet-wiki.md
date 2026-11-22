# Wiki facet (staging)

Moves into the `wiki` bundle skill when ported. Until then, facet behavior references this file from the compendium skill.

## Location

Each wiki is `<scope-path>/wikis/<slug>/` with the llm-wiki layout (`raw/`, `wiki/`, `.wiki-root.yaml`). Register slugs in `scopes.yaml` under the scope’s `wiki.slugs` list.

## Scope walk for query

When `wiki query` runs for scope `S`:

1. Collect wiki trees registered on `S`.
2. Walk to parent scopes in `scopes.yaml` and include their registered wikis.
3. Stop at the root scope.

Do not read wikis outside the ancestor chain of the active scope.

## Commands

Owned by the `wiki` skill: `init`, `ingest`, `query`, `lint`, `discard`.