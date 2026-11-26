---
name: citations
description: >-
  Pull concrete cited sources from input text: papers, reports, URLs, DOIs,
  named standards, and similar evidence. Use when the user says /citations,
  asks what a text cites, or wants sources extracted without guessing.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.1"
---

# Citations

## Outcome

List concrete references in the input. Default output in chat; write to a file only when the user asks.

If nothing qualifies, reply with exactly:

```text
No citations found.
```

Do not pad the list, infer metadata, or add references the text does not support.

## What counts as concrete

Include a reference only when the text identifies a specific work or artifact:

- Paper or preprint: title, authors, year, venue, or ID (DOI, arXiv, PubMed, ISBN)
- Report, standard, or specification: RFC, ISO identifier, versioned doc title
- URL that targets a specific page, document, or dataset (not a generic home page used only as rhetoric)
- Book, chapter, or official publication from a named publisher or body
- Court filing, patent, or government document with an identifier
- Dataset or model card with a version or canonical link

## What does not count

Skip vague pointers:

- Hand-waving ("studies show", "research suggests", "experts say") with no named work
- Institution or role alone ("the FDA", "a university team") with no document
- "According to" with no title, link, or ID after it
- Internal paths unless the user treats them as cited artifacts in context

When in doubt, omit. Do not guess.

## Output format

One bullet per reference. Add a short quote or paraphrase from the input when it anchors the item; otherwise list minimal identifying fields only.

Optional per bullet (omit when absent): **Kind**, **Title or name**, **Authors or body**, **Year**, **ID or URL**, **Where in input** (section or brief locator on long inputs).

Do not summarize the source unless the user asks.

## Wiki ingest

On `/wiki ingest`, append bullets under final `## Citations` per **Output format**. If none qualify, section body is exactly `No citations found.` Nothing may follow. See host wiki `references/source-page.md`.

## Guardrails

- Read the full input before listing.
- Never fabricate titles, authors, years, or links.
- One reference per bullet; do not merge.
- List only what the input states or links, not bibliography lines from general knowledge.
- No "possible" or "related" citations.