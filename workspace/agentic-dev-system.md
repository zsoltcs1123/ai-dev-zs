# Agentic Dev System — Design

A portable, composable system for AI-assisted development workflows. Works with Cursor, Claude Code, Codex, Gemini, or any agent that can read markdown.

## Architecture

```
project-root/
│
├── AGENTS.md                     # Brief context + pointers to rules/skills
├── CLAUDE.md                     # Symlink → AGENTS.md (for Claude Code)
│
├── .agents/                      # SINGLE SOURCE OF TRUTH
│   ├── skills/                   # Workflows (logic lives here)
│   │   ├── project-planner/
│   │   ├── phase-breakdown/
│   │   ├── code-review/
│   │   ├── code-verification/
│   │   ├── documentation-update/
│   │   └── dev-loop/             # Orchestrator (invokes subagents)
│   │
│   ├── agents/                   # Subagent definitions (thin wrappers)
│   │   ├── reviewer.md           # → code-review skill
│   │   └── verifier.md           # → code-verification skill
│   │
│   └── rules/                    # Coding conventions (portable)
│       ├── general.md            # SOLID, DRY, clean code
│       ├── csharp.md             # C# specific rules
│       ├── typescript.md         # TS specific rules
│       └── testing.md            # Testing conventions
│
├── .cursor/
│   ├── skills/                   # Symlinks → .agents/skills/*
│   └── agents/                   # Symlinks → .agents/agents/*
│
├── .claude/
│   ├── skills/                   # Symlinks → .agents/skills/*
│   └── agents/                   # Symlinks → .agents/agents/*
│
├── .gemini/skills/               # Symlinks → .agents/skills/*
│
├── phases/                       # Task breakdowns (output of phase-breakdown)
│   ├── phase-00-setup.md
│   └── phase-01-core.md
│
├── plans/                        # Saved agent plans (for verification)
│   └── task-001-plan.md
│
└── projects/                     # Subdirectories with their own AGENTS.md
    └── feature-x/
        └── AGENTS.md             # Feature-specific context
```

## Core Principles

1. **Single source of truth** — Skills and rules live in `.agents/`, agent-specific folders use symlinks
2. **Portable** — No vendor lock-in; any agent that reads markdown works
3. **Lean context** — `AGENTS.md` files are brief; details live in skills/rules
4. **Composable** — Skills work standalone or chained via orchestrator
5. **State in files** — Plans, phases, tasks are markdown (visible, versionable)
6. **Standards-based** — Uses `AGENTS.md` convention (60k+ repos, Linux Foundation stewardship)

## AGENTS.md Convention

Root and subdirectory `AGENTS.md` files contain:

- Brief project/feature description
- Known limitations and constraints
- Pointers to rules and skills (not duplicated instructions)

Keep under ~50 lines. Rules and skills are pointers, not inline content.

```markdown
# AGENTS.md (example)

## Overview

[1-2 sentences about this project/feature]

## Constraints

- [Hard limits, known issues]

## Rules

Coding conventions in `.agents/rules/`:

- `general.md` — SOLID, DRY, naming
- `csharp.md` — C# specific (if applicable)
- `testing.md` — Test conventions

Read relevant rule files based on the code you're working with.

## Skills

Workflows in `.agents/skills/`. Read SKILL.md in each folder when needed.
```

Agents see the pointers and read files on demand based on context. No forced loading.

## Rules Convention

Rules in `.agents/rules/` define coding standards that apply across projects or to specific languages/contexts.

### Rule Categories

| Rule File       | Scope              | Examples                                    |
| --------------- | ------------------ | ------------------------------------------- |
| `general.md`    | All code           | SOLID, DRY, naming, error handling          |
| `csharp.md`     | C# projects        | No `var`, nullable handling, async patterns |
| `typescript.md` | TS projects        | Strict mode, type patterns, imports         |
| `testing.md`    | All tests          | AAA pattern, naming, coverage expectations  |
| `security.md`   | Security-sensitive | Auth, secrets, input validation             |

### Rule File Structure

```markdown
# [Language/Topic] Rules

## [Category]

- [Rule]: [Brief rationale]

## Anti-patterns

- [What to avoid]: [Why]
```

Keep rules actionable and concise. Avoid essays — agents have limited context.

## Skills

| Skill                  | Purpose            | Input               | Output                            |
| ---------------------- | ------------------ | ------------------- | --------------------------------- |
| `project-planner`      | Strategic planning | Requirements        | FOUNDATION, ARCHITECTURE, ROADMAP |
| `phase-breakdown`      | Roadmap → Tasks    | ROADMAP phase       | `phases/phase-XX.md`              |
| `code-review`          | Quality gate       | Code diff           | Pass / Issues                     |
| `code-verification`    | Plan compliance    | Diff + saved plan   | Pass / Issues                     |
| `documentation-update` | Keep docs in sync  | Diff + project docs | Updated docs                      |
| `dev-loop`             | Orchestrator       | Task reference      | Completed commit                  |

## Subagents

Subagents are thin wrappers that delegate to skills. They provide:

- **Context isolation** — verbose intermediate output stays in subagent context
- **Parallelism** — independent tasks run concurrently
- **Cost efficiency** — use faster models for focused tasks

| Subagent   | Delegates To        | Model  | Tools                  | Purpose                       |
| ---------- | ------------------- | ------ | ---------------------- | ----------------------------- |
| `reviewer` | `code-review` skill | `fast` | Read, Grep, Glob       | Quality gate (read-only)      |
| `verifier` | `code-verification` | `fast` | Read, Grep, Glob, Bash | Plan compliance + test runner |

### Subagent File Format

```markdown
---
name: reviewer
description: Code quality review. Use after implementation to check for issues.
model: fast
tools: Read, Grep, Glob
---

You are a code reviewer. Read and follow `.agents/skills/code-review/SKILL.md`.

Return a structured report:

- PASS or ISSUES
- If issues: list each with file, line, severity, description
```

Subagents reference skills via path. The skill contains the logic; the subagent provides execution context.

## Workflow

### Full Orchestration (invoke `dev-loop`)

```
dev-loop orchestrator
        │
        ├── Plan (main context)
        ├── Implement (main context)
        │
        ├── [PARALLEL SUBAGENTS]
        │   ├── reviewer ──→ code-review skill ──→ Pass/Issues
        │   └── verifier ──→ code-verification skill ──→ Pass/Issues
        │
        ├── (fix if needed, re-run failed gate only)
        │
        ├── Document (main context)
        └── Commit
```

The quality gate phase runs review and verification in parallel. If either fails:

1. Fix the issues in main context
2. Re-run only the failed gate (don't re-plan)
3. Proceed when both pass

### Manual Step-by-Step (invoke skills individually)

```
"break down phase 1"           → phase-breakdown
"implement task-001"           → Cursor/Claude plan mode
"review my changes"            → code-review (or /reviewer subagent)
"verify against the plan"      → code-verification (or /verifier subagent)
"update the docs"              → documentation-update
```

## Symlink Setup

Skills and agents need symlinks for auto-discovery. Rules work via AGENTS.md pointers.

```bash
# Cursor
ln -s ../../.agents/skills .cursor/skills
ln -s ../../.agents/agents .cursor/agents

# Claude Code
ln -s ../../.agents/skills .claude/skills
ln -s ../../.agents/agents .claude/agents

# CLAUDE.md convention
ln -s AGENTS.md CLAUDE.md
```

**Windows (PowerShell):**

```powershell
# Create .cursor directory if needed
New-Item -ItemType Directory -Force -Path .cursor
New-Item -ItemType Directory -Force -Path .claude

# Cursor symlinks (directory junctions)
cmd /c mklink /J .cursor\skills .agents\skills
cmd /c mklink /J .cursor\agents .agents\agents

# Claude Code symlinks
cmd /c mklink /J .claude\skills .agents\skills
cmd /c mklink /J .claude\agents .agents\agents

# CLAUDE.md (file symlink, requires admin or dev mode)
cmd /c mklink CLAUDE.md AGENTS.md
```

## Implementation Phases

### Phase 1: Foundation

- [ ] Create `.agents/` directory structure (skills, agents, rules)
- [ ] Migrate existing `project-planner` skill to `.agents/skills/`
- [ ] Create initial rule files in `.agents/rules/`
- [ ] Set up symlinks for Cursor and Claude Code
- [ ] Create `phase-breakdown` skill
- [ ] Define `phases/` folder convention
- [ ] Create root `AGENTS.md` with rule/skill pointers

### Phase 2: Quality Gates

- [ ] Create `code-review` skill
- [ ] Create `code-verification` skill
- [ ] Create `reviewer` subagent (thin wrapper → code-review)
- [ ] Create `verifier` subagent (thin wrapper → code-verification)
- [ ] Define `plans/` folder convention

### Phase 3: Completion

- [ ] Create `documentation-update` skill
- [ ] Optional: commit convention rule

### Phase 4: Orchestration

- [ ] Create `dev-loop` orchestrator skill (invokes subagents for quality gate)
- [ ] Test full workflow end-to-end
- [ ] Verify parallel execution of review + verification

### Phase 5: Integration (Optional)

- [ ] MCP integration for GitHub/Asana task sync
- [ ] CLI automation scripts
- [ ] Symlink setup script for new agents

## Portability Matrix

| Agent                  | Context File                | Rules              | Skills                      | Subagents                       |
| ---------------------- | --------------------------- | ------------------ | --------------------------- | ------------------------------- |
| Cursor                 | `AGENTS.md`                 | Reads from pointer | Symlink → `.agents/skills/` | Symlink → `.agents/agents/`     |
| Claude Code            | `CLAUDE.md` (→ `AGENTS.md`) | Reads from pointer | Symlink → `.agents/skills/` | Symlink → `.agents/agents/`     |
| Codex                  | `AGENTS.md`                 | Reads from pointer | Reads from pointer          | `.codex/agents/` (if supported) |
| Gemini CLI             | `AGENTS.md` (configurable)  | Reads from pointer | Reads from pointer          | TBD                             |
| Aider                  | `AGENTS.md` (via config)    | Reads from pointer | Reads from pointer          | Not supported                   |
| VS Code, Zed, Windsurf | `AGENTS.md`                 | Reads from pointer | Reads from pointer          | Varies by agent                 |

**Key:** All agents read `AGENTS.md`. Cursor and Claude Code need symlinks for skills/agents (auto-discovery). Rules work via pointers for all agents. Subagent support varies—fallback is invoking skills directly.

## Open Items (TBD)

- Plan storage: gitignore vs. commit
- Phase breakdown output format (flat/hierarchical/table)
- Verification failure handling (auto-retry vs. stop)
- Code review scope (security, performance, patterns)
- Documentation update scope (README, API docs, architecture)
- MCP integration priority

## Version History

| Version | Date       | Changes                                                 |
| ------- | ---------- | ------------------------------------------------------- |
| 0.4     | 2026-02-02 | Added subagents layer for orchestration + quality gates |
| 0.3     | 2026-02-02 | Simplified: rules via pointers, not symlinks            |
| 0.2     | 2026-02-02 | Added rules convention, portability matrix              |
| 0.1     | 2026-02-02 | Initial design                                          |
