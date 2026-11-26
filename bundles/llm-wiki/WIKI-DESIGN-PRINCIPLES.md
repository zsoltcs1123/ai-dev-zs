# Wiki Design Principles

Design principles for the LLM Wiki system.

## Purpose

This is not a generic markdown vault. It is a set of focused, compounding knowledge bases for coherent question spaces.

The goal is not to collect everything adjacent to a topic into one place. The goal is to maintain the smallest set of focused wikis that can answer the important questions in each domain well.

## Core Principles

### 1. Strong Center of Gravity per Wiki

A good wiki has a clear conceptual center.

Each wiki should optimize for questions that orbit one coherent domain. Content is in-scope when it materially improves that wiki's ability to answer those questions.

Warning signs that a wiki's center of gravity is getting blurry:

- concept pages become broad and vague
- syntheses stop building on one another cleanly
- the same terms mean different things in different sections
- adjacent domains start dominating the index

### 2. One Wiki per Coherent Question Space

Do not create a new wiki for every narrow topic. Do not force all adjacent domains into one giant wiki either.

Use this rule:

> One wiki per coherent question space.

A separate wiki becomes justified when the new domain develops:

- its own recurring concepts and entities
- its own main questions
- syntheses that mostly depend on its own source set
- only partial overlap with the current wiki's core concepts

### 3. Absorb First, Split Later

Adjacent material should usually be absorbed into an existing wiki first, then split only when a new center of gravity clearly emerges.

This avoids premature fragmentation and duplicate plumbing.

### 4. Split Before the Domain Turns Muddy

Do not wait until a wiki is already incoherent.

Split when a topic starts generating:

- many source pages that rarely link back to the current core concepts
- entity pages that matter mostly in a different domain
- syntheses whose value is mostly independent of the current wiki
- navigation pressure to create a second index in practice

### 5. Role-Based Wiki Root, Author-Nested Sources

Each wiki root is organized by page role:

- `source` (under `wiki/sources/{author}/`)
- `concept`
- `entity`
- `synthesis`

Source pages are grouped by author under `wiki/sources/{author}/`, mirroring `raw/sources/`. Concepts, entities, and syntheses stay at the wiki root by role. Concepts remain the primary navigation hub; author folders aid provenance browsing and ingest alignment with `raw/`.

### 6. Concepts Are the Load-Bearing Layer

Source summaries are necessary, but concept pages are where a wiki starts compounding.

A concept page should exist when:

- the same idea appears in multiple sources
- the idea is used repeatedly in syntheses
- the concept helps compress future reasoning

If there is doubt, prefer creating a concept page earlier rather than later.

### 7. Entities Should Earn Their Page

Not every named thing deserves an entity page.

Create one when the entity:

- appears across multiple sources
- matters analytically, not just referentially
- acts as a stable node for future synthesis

### 8. Query Outputs Should Compound

Useful answers should become wiki artifacts.

If a query produces a durable insight, comparison, framework, or recommendation, it should usually be filed back into `wiki/syntheses/` rather than left in chat history.

### 9. Linting Is Part of Knowledge Work

Wiki maintenance is not cleanup after the real work. It is part of the real work.

Lint passes should look for:

- missing concept pages
- missing entity pages
- stale claims
- weak provenance
- orphan pages
- places where the center of gravity is being diluted

### 10. The Repo Is the Agent's Memory

If something matters to future reasoning, it should live in the repo.

That includes:

- source pages
- concept pages
- entity pages
- syntheses
- index/log history
- design principles like this document

## Boundary Policy

Use three labels mentally when deciding where content belongs:

### Core

Material that directly supports a wiki's main question space.

Keep it in that wiki.

### Adjacent

Material that is not central, but regularly helps answer core questions.

Usually keep it in the current wiki until it grows into its own cluster.

Large verbatim corpora (specifications, standards, long books) belong here when they support the wiki's question space. Keep them under `raw/reference/` with stub cataloging in `wiki/sources/reference/`. Compounding happens through query and explicit synthesis, not default full ingest.

### Separate Domain

Material with its own center of gravity, concepts, entities, and syntheses.

Create a separate wiki when this becomes substantial.

## Meta-Layer Direction

When multiple focused wikis exist, connect them with a thin meta layer rather than merging them into one mega-wiki.

The meta layer should stay lightweight:

- directory of related wikis
- shared conventions
- cross-wiki synthesis pages
- top-level map of major concepts and entities where needed

The meta layer should coordinate focused wikis, not replace them.

## System Shape

This dev repo provides:

- `bundles/llm-wiki/wiki/` — operate layer (init, ingest, query, lint, discard)
- `_scaffold/` — canonical wiki skeleton
- these design principles and the roadmap

Host repos install skills and create wikis in place. Domain-specific center of gravity stays local to each wiki.

## Working Heuristic

Use this default decision rule:

> Absorb adjacent material while it strengthens the current wiki's center of gravity. Split only when the adjacent material develops a stronger center of gravity of its own.
