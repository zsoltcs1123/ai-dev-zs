# LinkCheck — Vision

## Problem Statement

**Who:** Documentation maintainers who manage markdown files with many internal and external links.

**Current state:** Broken links in markdown documentation are discovered by readers, not authors. There is no quick way to verify that all links in a set of markdown files point to valid targets.

**Pain points:**

- Broken internal links (wrong file path, renamed file) go unnoticed until someone clicks them
- Broken external links (dead URLs, moved pages) accumulate silently
- Manual checking is tedious and unreliable

---

## Vision & Success

**Vision:** A CLI tool that scans markdown files, extracts all links, and reports which ones are broken — so documentation authors can fix link rot before readers encounter it.

**Success looks like:** Run one command, get a list of broken links with file and line number. Fix them. Done.

**Metrics:**

| Metric | Target |
| --- | --- |
| Scan speed | > 500 files/second for internal links |
| False positive rate for external links | < 5% |

---

## Scope

### In Scope (v1)

- Scan markdown files in a directory (recursive)
- Check internal links (relative file paths and anchors)
- Check external links (HTTP HEAD requests with timeout)
- Report broken links with file path, line number, and link target

### Out of Scope

- Fixing broken links automatically
- Checking non-markdown file formats
- CI integration or GitHub Action (future)

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 1.0 | 2026-03-11 | Initial version |
