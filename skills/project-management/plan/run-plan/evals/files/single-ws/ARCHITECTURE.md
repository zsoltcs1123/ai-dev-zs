# LogLens — Architecture

## System Overview

LogLens is a single-binary CLI tool with a streaming pipeline architecture. Log files flow through a parser, then through a query/filter stage, then to an output formatter. Each stage processes entries one at a time — no full-file loading.

```
File(s) → Reader → Parser → Filter/Query → Aggregator → Formatter → stdout
```

**Core principle:** Stream everything. Never load an entire file into memory. Each pipeline stage processes one log entry at a time and passes it downstream.

---

## Technology Stack

| Layer | Technology | Rationale |
| --- | --- | --- |
| Language | Rust | Performance-critical (100 MB/s target); single binary distribution; no runtime dependency |
| CLI framework | clap | Standard Rust CLI parser; derive-based API for ergonomic command definitions |
| JSON parsing | serde_json | De facto Rust JSON library; streaming-compatible |
| Regex | regex crate | Fast, safe, no backtracking; used for pattern-based format detection and message grouping |
| Date/time | chrono | Mature timestamp parsing across multiple formats |
| Output | tabled (tables), serde_json (JSON output) | Clean terminal tables for human-readable output; JSON for piping to other tools |
| Testing | built-in (cargo test) | No external test framework needed |

---

## Components & Responsibilities

### Reader

Reads files sequentially, line by line. Handles gzip-compressed files transparently. Accepts file paths or stdin.

### Parser

Auto-detects log format from the first N lines, then parses each line into a structured `LogEntry`:

| Field | Type | Notes |
| --- | --- | --- |
| timestamp | DateTime (optional) | Parsed from detected format |
| level | Enum (optional) | DEBUG, INFO, WARN, ERROR, FATAL |
| message | String | Raw message content |
| request_id | String (optional) | Extracted from known field names (request_id, trace_id, X-Request-ID) |
| fields | Key-value map | All structured fields (from JSON logs) or empty |

Supported formats: JSON lines, syslog (RFC 3164 / RFC 5424), Common Log Format, and a fallback plain-text mode.

### Filter/Query

Applies user-specified filters to each `LogEntry`. Filters are composable:

- By level: `--level error,warn`
- By time range: `--after "2026-03-01" --before "2026-03-02"`
- By request ID: `--request abc123`
- By field value: `--where "status=500"`
- By message pattern: `--grep "timeout"`

### Aggregator

Operates in two modes:

- **Pass-through** (default): entries flow directly to formatter
- **Aggregation**: groups and counts entries by a specified key (level, message pattern, field value). Used for frequency analysis commands.

### Formatter

Renders output in the requested format:

- **Table**: aligned columns for terminal readability
- **JSON**: one JSON object per entry for piping
- **Plain**: raw message text, one per line

---

## Data Architecture

No persistent storage. All data flows through the pipeline and is discarded after output. The only state is the auto-detected log format (determined from the first N lines and reused for the remainder of the file).

---

## Key Decisions & Tradeoffs

| Decision | Rationale | Tradeoff |
| --- | --- | --- |
| Rust for single-binary performance | Meets throughput target; easy distribution | Higher development effort than Python/Go for a CLI tool |
| Streaming pipeline (no indexing) | Simple; handles arbitrary file sizes; no write operations | Repeated queries re-scan the file; no random access |
| Auto-detect format | Zero-config for common cases | Ambiguous files may misdetect; override flag needed |
| No persistent index | Simplicity; tool is stateless | Large-file queries are always O(n); acceptable for v1 |

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 1.0 | 2026-03-11 | Initial version |
