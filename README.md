# AI Dev Skills

Small curated set of agent skills plus a universal installer for `.agents/skills/`.

Works with Cursor 2.4+, Codex, Copilot, Gemini, Cline, and other harnesses that read `.agents/skills/` natively.

## Install

```bash
./skills/install.sh              # current project → .agents/skills/
./skills/install.sh /path/to/app # specific project
./skills/install.sh --global     # ~/.agents/skills/
./skills/install.sh --list       # list skills
```

Re-run to update installed copies.

## Skills

See [skills/index.md](./skills/index.md).

| Skill | Purpose |
| ----- | ------- |
| capture-idea | Distill freeform input into bullet points |
| project-seed | Explore an idea into a seed document that bootstraps a new repo |
| project-vision | Produce a VISION.md through guided conversation |
| project-architecture | Produce an ARCHITECTURE.md through guided conversation |
| summarize | Structured summary of articles and long text |
| quick-summarize | Brief TL;DR without full structure |
| new-skill | Create a portable Agent Skill from a user description |
| review-skill | Audit a SKILL.md for spec and quality |
| code-review | Review a diff against quality, conventions, principles, security, and testing |

## Authoring

New skills follow [SKILL-DEV-GUIDE.md](./SKILL-DEV-GUIDE.md) and the [Agent Skills spec](https://agentskills.io/specification). Agents working in this repo should read [AGENTS.md](./AGENTS.md).
