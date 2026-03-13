# Log Analysis — Roadmap

> **Status:** Draft v1.0
> **Date:** 2026-03-11

---

## Overview

LogLens is a single-workstream project delivering a CLI log analysis tool with a streaming pipeline architecture. All features belong to the LOG workstream and build on the foundational log parsing capability.

The roadmap sequences features in two milestones. The first establishes the core pipeline: parsing, querying, and output formatting — enough to ship a useful tool. The second adds higher-level analysis: request correlation and frequency analysis, which require the core pipeline to be functional.

---

## Milestones

| Milestone | Name | Features | Key Outcomes |
| --------- | ---- | -------- | ------------ |
| ⏳ [MS-LOG-1](#ms-log-1-core-pipeline) | Core Pipeline | ⏳ [LOG-1](LOG/LOG-1/LOG-1.md) <br> ⏳ [LOG-2](LOG/LOG-2/LOG-2.md) <br> ⏳ [LOG-5](LOG/LOG-5/LOG-5.md) | Auto-detect and parse 3+ log formats; filter by level, time, request ID, field, and pattern; output as table, JSON, or plain text |
| ⏳ [MS-LOG-2](#ms-log-2-analysis) | Analysis | ⏳ [LOG-3](LOG/LOG-3/LOG-3.md) <br> ⏳ [LOG-4](LOG/LOG-4/LOG-4.md) | Correlate entries by request ID to reconstruct request lifecycles; count and rank entries by level, pattern, or field for trend analysis |

---

## MS-LOG-1: Core Pipeline

**Features:** [LOG-1](LOG/LOG-1/LOG-1.md), [LOG-2](LOG/LOG-2/LOG-2.md), [LOG-5](LOG/LOG-5/LOG-5.md)

Delivers the end-to-end streaming pipeline: file reading, format detection, structured parsing, composable filtering, and multi-format output. This milestone produces a usable tool — developers can parse a log file, filter entries, and see results in their preferred format.

**Key outcomes:**

- 3+ log formats auto-detected and parsed without configuration
- All filter types (level, time, request ID, field, pattern) functional and composable
- Table, JSON, and plain text output modes available
- Files up to 10 GB processed without full-file loading

---

## MS-LOG-2: Analysis

**Features:** [LOG-3](LOG/LOG-3/LOG-3.md), [LOG-4](LOG/LOG-4/LOG-4.md)

Adds request correlation and frequency analysis on top of the core pipeline. Developers can reconstruct the full lifecycle of a single request and identify the most common errors or trends — the two key capabilities for incident investigation.

**Key outcomes:**

- Request correlation isolates all entries for a given request ID in under 10 seconds
- Frequency analysis ranks entries by level, pattern, or field
- Both features compose with existing filters

---

## Version History

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2026-03-11 | Initial version |
