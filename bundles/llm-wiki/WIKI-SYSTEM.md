# Wiki system tracker (host)

Optional host-repo file. Copy to `wikis/WIKI-SYSTEM.md` when you want a single place to record skill installs and wiki `scaffold` versions. This is not a wiki page.

## Install

```bash
/path/to/ai-dev-zs/skills/install.sh . --bundle llm-wiki
```

Last install: _YYYY-MM-DD_

Pinned wiki skill version: _for example 1.3_

## Wikis

| Slug | Path | scaffold |
| --- | --- | --- |
| my-topic | wikis/my-topic/ | _run `/wiki migrate` dry-run to refresh_ |

Update this table after `/wiki migrate` or when you add a wiki.
