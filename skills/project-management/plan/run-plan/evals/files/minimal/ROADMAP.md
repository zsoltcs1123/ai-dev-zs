# Link Checking — Roadmap

> **Status:** Draft v1.0
> **Date:** 2026-03-11

---

## Overview

LinkCheck is a single-workstream project delivering a CLI tool that scans markdown files and reports broken links. All features belong to the LCK workstream.

The roadmap sequences features in two milestones. The first delivers scanning and link checking — the core capability. The second delivers reporting, which depends on check results from the first milestone.

---

## Milestones

| Milestone | Name | Features | Key Outcomes |
| --------- | ---- | -------- | ------------ |
| ⏳ [MS-LCK-1](#ms-lck-1-scan-and-check) | Scan and Check | ⏳ [LCK-1](LCK/LCK-1/LCK-1.md) <br> ⏳ [LCK-2](LCK/LCK-2/LCK-2.md) <br> ⏳ [LCK-3](LCK/LCK-3/LCK-3.md) | Recursive markdown scanning; internal link validation (path + anchor); external link validation (HTTP with timeout and redirect following) |
| ⏳ [MS-LCK-2](#ms-lck-2-reporting) | Reporting | ⏳ [LCK-4](LCK/LCK-4/LCK-4.md) | Broken link report with file path, line number, and target; summary and JSON output modes; exit code signaling |

---

## MS-LCK-1: Scan and Check

**Features:** [LCK-1](LCK/LCK-1/LCK-1.md), [LCK-2](LCK/LCK-2/LCK-2.md), [LCK-3](LCK/LCK-3/LCK-3.md)

Delivers the scanning and checking pipeline: recursive markdown discovery, link extraction, internal path/anchor resolution, and external HTTP validation. After this milestone, the tool can identify all broken links — it just needs a reporting layer.

---

## MS-LCK-2: Reporting

**Features:** [LCK-4](LCK/LCK-4/LCK-4.md)

Delivers the user-facing report: aggregated broken-link list grouped by file, JSON output for tooling, and exit code signaling for CI integration.

---

## Version History

| Version | Date | Changes |
| ------- | ---- | ------- |
| 1.0 | 2026-03-11 | Initial version |
