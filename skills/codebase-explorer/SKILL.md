---
name: codebase-explorer
description: Explores and documents codebases autonomously. Produces [ProjectName]-Exploration-Report.md covering functionality, architecture, tech stack, data flows, and maintainability. Use when the user wants to understand a codebase, asks "what does this do", "how does this work", or requests codebase analysis/documentation.
metadata:
  author: zs
  version: "1.0"
---

# Codebase Explorer

Autonomously explore a codebase and produce a comprehensive exploration report.

## When Activated

1. **Check if workspace is a codebase**: Look for source files, package manifests, or project configuration
2. **If not a codebase** (empty, docs-only, or trivial): Summarize what exists and ask for instructions
3. **If valid codebase**: Proceed with exploration strategy below

## Role

Technical analyst. Explore systematically, document findings objectively, identify patterns and problems. Prioritize accuracy over completeness. Flag uncertainties rather than guessing.

---

## Exploration Strategy

**Do not explore everything at once.** Follow this phased approach.

**Use codebase indexing when available** (e.g., Cursor's semantic search). Indexed queries are faster and more accurate than manual file traversal for finding patterns, usages, and relationships.

### Phase 1: Surface Scan

Gather high-level context quickly:

- List root directory structure
- Identify package manifests (`package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`, etc.)
- Find README, docs, and existing documentation
- Detect monorepo structure (multiple packages/apps)
- Check git history for recent activity patterns

### Phase 2: Complexity Assessment

Classify the codebase to calibrate exploration depth:

| Complexity  | Indicators                                         | Exploration Depth                        |
| ----------- | -------------------------------------------------- | ---------------------------------------- |
| **Simple**  | <10 source files, single purpose, no external deps | Quick scan, minimal sections             |
| **Medium**  | 10-100 files, clear structure, some integrations   | Standard exploration                     |
| **Complex** | 100+ files, multiple services, databases, APIs     | Deep exploration with parallel subagents |

### Phase 3: Module Identification

Identify logical boundaries:

- **Monorepo**: packages/, apps/, services/, libs/
- **Standard**: src/ subdirectories, feature folders, layers (api/, domain/, infra/)
- **Microservices**: separate service directories

### Phase 4: Deep Exploration

For **Medium/Complex** codebases, use parallel subagents to explore:

- Each major module/package
- Database schemas and migrations
- API definitions (OpenAPI, GraphQL schemas)
- Configuration and infrastructure

For **Simple** codebases, explore sequentially without subagents.

---

## Output File

Write to `workspace/[ProjectName]-Exploration-Report.md`. Abbreviate long project names (e.g., `MyLongProjectName` → `MLPN-Exploration-Report.md`). **Target: under 500 lines.**

### Document Structure

Title: `# [Project Name] — Exploration Report`. Use `---` between major sections. **Maintain section order as listed below.**

### Section Reference

| #   | Section                     | Req | Include When           | Format                                         |
| --- | --------------------------- | --- | ---------------------- | ---------------------------------------------- |
| 1   | Executive Summary           | ○   | Complex codebases      | 2-3 paragraphs max                             |
| 2   | Functionality & Use Cases   | ●   | Always                 | What it does, who uses it, key scenarios       |
| 3   | Tech Stack                  | ●   | Always                 | `\| Layer \| Technology \| Purpose \|`         |
| 4   | Architecture Overview       | ●   | Always                 | Components + simple diagram if >3 components   |
| 5   | Entry Points & Control Flow | ●   | Always                 | Main files, CLI commands, request handlers     |
| 6   | Data Models & Storage       | ○   | Has databases/schemas  | Schema overview, key entities                  |
| 7   | Data Flow                   | ○   | Complex pipelines      | How data moves through system                  |
| 8   | API Surface                 | ○   | Exposes APIs           | Endpoints summary, auth requirements           |
| 9   | External Dependencies       | ●   | Always                 | `\| Dependency \| Purpose \| Risk \|`          |
| 10  | Security Model              | ○   | Has auth/security      | Auth mechanism, authorization, data protection |
| 11  | Configuration & Environment | ●   | Always                 | Config files, env vars, feature flags          |
| 12  | Build, Run & Test           | ●   | Always                 | Build commands, run commands, test commands    |
| 13  | Deployment Models           | ○   | Production deployments | How/where deployed                             |
| 14  | Code Organization           | ●   | Always                 | Folder structure rationale, naming conventions |
| 15  | Existing Documentation      | ○   | Docs exist             | Summary + links to key docs                    |
| 16  | Maintainability Assessment  | ●   | Always                 | See assessment criteria below                  |
| 17  | Open Questions              | ○   | Uncertainties remain   | What couldn't be determined                    |
| 18  | Version History             | ●   | Always                 | Software releases/tags                         |

### Maintainability Assessment

Evaluate and document:

| Aspect            | What to Look For                                                       |
| ----------------- | ---------------------------------------------------------------------- |
| **Code Quality**  | Duplication, dead code, overly complex functions, code smells          |
| **Structure**     | Clear boundaries, separation of concerns, consistent patterns          |
| **Complexity**    | Signs of overengineering, unnecessary or overly complex abstractions   |
| **Performance**   | Bottlenecks, memory leaks, slow operations                             |
| **Security**      | Vulnerabilities, lack of authentication/authorization, data protection |
| **Dependencies**  | Outdated packages, security vulnerabilities, unnecessary deps          |
| **Testing**       | Coverage gaps, test quality, missing test types                        |
| **Documentation** | Missing docs, outdated docs, unclear areas                             |
| **Extensibility** | How easy to add features, modify behavior, integrate new systems       |
| **Repo Activity** | Active vs stale, continuous vs sporadic commits, contributor count     |

Rate each as: ✅ Good, ⚠️ Needs Attention, ❌ Problematic

Provide specific examples for any ⚠️ or ❌ ratings.

---

## Monorepo Handling

When a monorepo is detected:

1. **Document overall structure first** (root-level architecture)
2. **Create subsections per package/app** within relevant sections
3. **Identify shared code** and cross-package dependencies
4. **Note inconsistencies** between packages (different patterns, outdated packages)

Example structure:

```
## Architecture Overview

### Overall Structure
[Root-level description]

### Packages
- **@app/web**: React frontend...
- **@app/api**: Express backend...
- **@lib/shared**: Common utilities...
```

---

## After Report Generation

Once the report is written, prompt the user:

- Offer to answer questions about specific areas
- Offer to dive deeper into any section (security, specific module, data flow, etc.)
- Offer to create additional focused documents as needed

Follow-up documents are ad-hoc — no predefined structure. Write what serves the user's request.

---

## Quality Standards

**Every finding must be:** honest, specific, evidence-based, and actionable.

**Prioritize signal over completeness:**

- Omit obvious/boilerplate details
- Link to files rather than quoting large blocks
- Use tables for structured data
- Simple diagrams only when they clarify

**Avoid:**

- Speculation without evidence
- Overly detailed API documentation (summarize, link to source)
- Repeating information from existing docs
- Including sections that add no value
- Exceeding 500 lines

---

## Communication Style

- **Concise**: Minimal words, maximum meaning
- **Specific**: Concrete file paths and examples
- **Clear**: Plain language; avoid jargon
- **Actionable**: Findings lead to understanding or action

---

## Edge Cases

| Situation                              | Response                                                          |
| -------------------------------------- | ----------------------------------------------------------------- |
| Empty workspace                        | "No codebase found. Please open a project directory."             |
| Docs/config only                       | Summarize what exists, note it's not a codebase                   |
| Very large codebase (1000+ files)      | Focus on architecture and key modules; note areas skipped         |
| Unfamiliar tech stack                  | Document what's observable; note knowledge gaps in Open Questions |
| Partial access (some files unreadable) | Document what's accessible; note limitations                      |
