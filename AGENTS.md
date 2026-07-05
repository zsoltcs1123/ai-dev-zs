# AGENTS.md

Agent skills repo. Portable across Cursor, Codex, Copilot, Gemini, Cline, and other harnesses that read `.agents/skills/`.

## Authoring

Read [SKILL-DEV-GUIDE.md](./SKILL-DEV-GUIDE.md) first — primary guide for writing skills here.

Skills must also conform to the [Agent Skills specification](https://agentskills.io/specification).

## Install

```bash
./skills/install.sh          # project: ./.agents/skills/
./skills/install.sh --global   # user: ~/.agents/skills/
./skills/install.sh --list     # list installable skills
```

Re-run to refresh after updates.

## Key files

- [skills/index.md](./skills/index.md) — skill catalog
- [SKILL-DEV-GUIDE.md](./SKILL-DEV-GUIDE.md) — how to write skills
- [skills/install.sh](./skills/install.sh) — copy skills into `.agents/skills/`
