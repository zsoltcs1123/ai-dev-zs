---
name: new-skill
description:
  Creates a portable Agent Skill from a user description. Use when the user wants a new skill, says "new skill", "create a skill", "author a skill", or wants a SKILL.md written from a workflow or set
  of rules.
metadata:
  author: zs
  version: "1.2"
---

# New Skill

## Outcome

A new Agent Skill directory at `.agents/skills/<name>/` unless the user names another path. Matches the user's description.

## Guardrails

Follow the live [Agent Skills spec](https://agentskills.io/specification) and [references/skill-dev-guide.md](references/skill-dev-guide.md). Do not copy spec text into generated skills.

## Tools

- Fetch [agentskills.io/specification](https://agentskills.io/specification) before write.
- Read [references/skill-dev-guide.md](references/skill-dev-guide.md).
- Write the skill directory.
