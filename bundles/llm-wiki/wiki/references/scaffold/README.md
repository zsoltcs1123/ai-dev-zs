# Wiki Guide

`wiki/` is the maintained knowledge layer. `raw/` is for collecting material.

## Start Here

1. Start from [HOME.md](./HOME.md) or [wiki/index.md](./wiki/index.md)
2. Open the most relevant `concept` or `synthesis`
3. Drop into `source` pages for detail or provenance
4. Check [wiki/log.md](./wiki/log.md) for recent changes

## What Lives Here

- `sources/{author}/`: one-source summaries, grouped by author (mirrors `raw/sources/`)
- `sources/{author}/`: one page per source (quick + full summary + citations)
- `sources/reference/`: lightweight stubs for large corpora in `raw/reference/`
- `concepts/`: recurring ideas across sources
- `entities/`: recurring named actors, companies, tools, people
- `syntheses/`: comparisons, frameworks, assessments, filed answers

## How to Work With the Wiki

Typical loop:

1. Add source material or rough notes to `raw/`
2. Run `/wiki ingest`
3. Let ingest update concepts and entities if the new source changes the picture
4. Only file an answer into `wiki/syntheses/` when you explicitly want it as a durable artifact

Inside `raw/`, keep the distinction sharp:

- `raw/sources/` = verbatim captures of exact sources
- `raw/notes/` = non-verbatim raw material such as repo reports, extracted analyses, and your own notes
- `raw/reference/` = large verbatim corpora kept for grep-first search on demand

For reference corpora, ingest creates a stub and index entry only. Full promotion requires an explicit request.

You can also run `/wiki lint` when you want the graph tightened up without adding new source material.

Good rule:

- `raw/` collects
- `wiki/` compounds

## Page Types

- `source`: summary of one source
- `concept`: an idea that keeps recurring
- `entity`: a named thing worth tracking
- `synthesis`: a cross-source answer, comparison, or framework

Synthesis pages are opt-in. Do not create them unless explicitly asked.

## Scope

Define this wiki's center of gravity here. What question space does it serve? What is in scope and out of scope?

This is a focused wiki, not a general vault.

## Operations

Use the installed `wiki` skill: `/wiki ingest`, `/wiki query`, `/wiki lint`, `/wiki discard`.
