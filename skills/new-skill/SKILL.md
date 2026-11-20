---
name: new-skill
description:
  Creates a portable Agent Skill from a user description. Use when the user wants a new skill, says "new skill", "create a skill", "author a skill", or wants a SKILL.md written from a workflow or set
  of rules.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.3"
---

# New Skill

## Outcome

A new Agent Skill directory at `.agents/skills/<name>/` unless the user names another path. Matches the user's description.

## Guardrails

Follow the live [Agent Skills spec](https://agentskills.io/specification) and [references/skill-dev-guide.md](references/skill-dev-guide.md).

**Self-contained by default.** The new skill must not name, invoke, or link to any other Agent Skill (slash commands, skill names, or paths outside its own directory). Put everything the agent needs under that skill root (`SKILL.md`, `references/`, `scripts/`, `assets/`). Only break this rule when the user explicitly asks to depend on or defer to another skill.

## Tools

- Fetch [agentskills.io/specification](https://agentskills.io/specification) before write.
- Read [references/skill-dev-guide.md](references/skill-dev-guide.md).
- Write the skill directory.
