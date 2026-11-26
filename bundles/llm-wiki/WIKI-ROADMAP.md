# LLM Wiki Roadmap

System development priorities for the LLM Wiki project. Not a wiki artifact.

## Completed

- explicit `raw/` vs `wiki/` separation inside each focused wiki
- role-based wiki organization (`source`, `concept`, `entity`, `synthesis`)
- minimal frontmatter on maintained wiki pages
- `wiki/index.md` as top-level navigation within each wiki
- `wiki/log.md` as operational history within each wiki
- operate layer shipped as routed `wiki` skill (init, migrate, ingest, query, lint, discard)
- consumer migrate (`scaffold`, playbooks, `make test`)
- vendored `summarize`, `quick-summarize`, and `citations` skills for ingest
- `_scaffold/` canonical skeleton for `/wiki init`
- design principles and this roadmap in the dev repo
- Karpathy gist attribution and lineage documented
- `raw/reference/` convention for large verbatim corpora with grep-first query and stub ingest

## Current Gaps

### 1. Maintenance rhythm is still forming

The structure and skill delivery exist. Still early on:

- automatic backlink density
- contradiction tracking
- stale-claim detection
- regular gap-finding and promotion passes
- cross-wiki coordination once more wikis exist

### 2. Durable synthesis is explicit, not default

By design the system does not create or update synthesis pages unless explicitly asked. Compounding through synthesis is available but user-driven.

### 3. Retrieval is still human-readable indexing

Reference corpora provide grep-first retrieval for large verbatim material. No purpose-built lint scripts, stronger orphan discovery, or lightweight cross-wiki navigation tooling yet.

### 4. Browsing layer is underdeveloped

Obsidian-friendly structure exists but the system does not yet lean into graph-view density, Dataview metadata, or alternative outputs.

## Next Priorities

### 1. Dogfood and harden the wiki skill

- exercise all commands on real wikis
- tighten resolve-wiki disambiguation from field use
- bump skill version when operate semantics change

### 2. Continue recurring lint passes on live wikis

### 3. Strengthen concept hubs deliberately

## Later Priorities

### 4. Lightweight search when index-driven navigation strains

### 5. Richer output modes (slides, diagrams, charts) where a query benefits

### 6. Image-aware ingestion for visually rich domains

### 7. Meta-layer after multiple focused wikis exist

Thin coordination: wiki registry, cross-wiki synthesis, federated map.

## Guardrails

### 1. Do not generalize a wiki's domain too early

### 2. Do not overbuild search or metadata before the wiki needs it

### 3. Do not force a rigid ontology

## Sequencing

### Now

- dogfood the wiki skill on live wikis
- improve Obsidian usability inside focused wikis
- run regular lint/promotion passes
- create syntheses only when explicitly requested

### Next

- standardize Obsidian conventions if useful
- add lightweight search when index navigation strains
- improve multi-wiki registry patterns in host repos

### Later

- meta-layer for cross-wiki coordination
- optional lint/discovery tooling over wiki content

## Summary

Structure and operate delivery are in place. The roadmap is now about **skill hardening, maintenance rhythm, Obsidian usability, and eventual federation** — not folder reshuffles.
