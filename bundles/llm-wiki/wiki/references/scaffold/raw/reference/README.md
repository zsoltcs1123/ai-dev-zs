# Reference Corpora

Large verbatim markdown corpora live here: specifications, standards, long books, and other material that would be expensive to summarize but should remain searchable on demand.

## When to Use

- **Use `raw/reference/{corpus-slug}/`** for corpus-scale material that agents should grep and read selectively during queries.
- **Use `raw/sources/`** for normal-sized sources that should go through full ingest into `wiki/sources/{author}/`.

## Layout

```
raw/reference/{corpus-slug}/
  ... chunked markdown files ...
```

After adding a corpus, run `/wiki ingest` to create a stub at `wiki/sources/reference/{corpus-slug}.md` and catalog it in `wiki/index.md`.

Full promotion into summarized source pages requires an explicit request.
