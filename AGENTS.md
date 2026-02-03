# AGENTS.md

## Overview

Repository for creating AI development artifacts: skills, subagents, rules, and orchestration patterns. Portable across Cursor, Claude Code, Codex, Gemini, and other markdown-reading agents.

## Primary Task

Support creation of:

- **Skills** — Reusable workflows in `SKILL.md` format
- **Subagents** — Thin wrappers that delegate to skills
- **Rules** — Coding conventions and standards
- **Orchestration patterns** — Multi-agent workflows

## Resources

- [agentskills.io](https://agentskills.io/) — Official Agent Skills specification
- `create-skill` skill — Use for skill authoring guidance

## Constraints

- Skills must follow [agentskills.io specification](https://agentskills.io/specification)
- SKILL.md files: max 500 lines, description max 1024 chars
- Descriptions: third-person, include WHAT and WHEN
- Use progressive disclosure (reference files for detailed content)

## Key Files

- `agentic-dev-system.md` — Full architecture and design
- `skills/INDEX.md` — Skill catalog
- `workspace/` — Temporary files, load on demand only
