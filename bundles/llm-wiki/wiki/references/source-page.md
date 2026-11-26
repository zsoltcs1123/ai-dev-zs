# Source page layout

One file per source: `wiki/sources/{author}/{slug}.md`. No `quick/` siblings.

## Section order

Below frontmatter, in this order only:

1. **Title** — single document `#` heading from `summarize`
2. **Source** and **Author** — one `Source:` line and one `Author:` line from `summarize`; do not repeat in the quick or summary sections. **`Source:`** links the verbatim ingest file under `raw/` (relative from the wiki page: `../../../raw/sources/{author}/{slug}.md`), not an external URL. Keep `source_url` and similar provenance in `raw/` only.
3. **Quick summary** — `quick-summarize` under `## Quick summary` (no `#` title, no `Source:` / `Author:`)
4. **Summary** — `summarize` under `## Summary` (lede and sections only; no repeated title or attribution)
5. **Citations** — `citations`, always last

Do not use a horizontal rule between quick and summary blocks.

## Citations

```markdown
## Citations

- [bullet per citations skill]
```

Run on the same raw input as summarization; concrete references only. Do **not** cite the ingested article itself or its external origin URL (`source_url` in raw frontmatter is provenance, not a citation). If none qualify:

```markdown
## Citations

No citations found.
```

Nothing may follow `## Citations`. Re-ingest replaces that section.

## Frontmatter

```yaml
type: source
status: draft | maintained
updated: YYYY-MM-DD
source_org: optional
tags: [optional]
```

Preserve frontmatter; bump `updated` on re-ingest.

## Re-ingest

Replace quick summary, full summary, and citations from raw. No stale blocks; no `quick/` pages.
