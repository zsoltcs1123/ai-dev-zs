# LinkCheck — Architecture

## System Overview

LinkCheck is a CLI tool that scans markdown files, extracts links, checks their targets, and reports broken ones. It has three stages: scan, check, report.

```
Markdown files → Scanner → Link Extractor → Checker → Reporter → stdout
```

**Core principle:** Do one thing well. Scan, check, report. No fixing, no caching, no server.

---

## Technology Stack

| Layer | Technology | Rationale |
| --- | --- | --- |
| Language | Python | Fast to develop; rich ecosystem for HTTP and file handling; acceptable performance for this scope |
| CLI framework | argparse | Standard library; no external dependency needed |
| Markdown parsing | regex-based extraction | Full AST parsing is overkill — link syntax is regular enough for regex |
| HTTP checking | httpx | Async HTTP client; supports HEAD requests with timeouts |
| Async runtime | asyncio | Built-in; needed for concurrent external link checks |
| Testing | pytest | Standard Python test framework |

---

## Components & Responsibilities

### Scanner

Recursively walks a directory, yields markdown files (`.md`). Respects `.gitignore` patterns if present.

### Link Extractor

Parses each markdown file line by line. Extracts inline links `[text](target)` and reference links `[text][ref]`. Records file path, line number, and link target for each.

### Checker

Two sub-checkers:

| Type | How it checks | Notes |
| --- | --- | --- |
| Internal links | Resolve relative path from source file; check file exists; check anchor exists if present | Fast, synchronous |
| External links | HTTP HEAD request with 5-second timeout; follow redirects; treat 2xx as valid | Async, batched (up to 20 concurrent) |

### Reporter

Formats results for stdout. Two modes:

- **Summary** (default): grouped by file, one line per broken link with line number and target
- **JSON**: structured output for programmatic consumption

---

## Key Decisions & Tradeoffs

| Decision | Rationale | Tradeoff |
| --- | --- | --- |
| Python over Rust/Go | Development speed; scope is small; performance is acceptable | Slower than compiled languages for very large doc sets |
| Regex over AST for link extraction | Simpler; covers standard markdown link syntax | May miss edge cases in non-standard markdown extensions |
| HEAD requests for external links | Faster than GET; less server load | Some servers reject HEAD; fallback to GET on 405 |
| No caching of external results | Stateless; simple | Repeated runs re-check all external links |

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 1.0 | 2026-03-11 | Initial version |
