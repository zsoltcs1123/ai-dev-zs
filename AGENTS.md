# AGENTS.md

Agent skills repo. Portable across Cursor, Codex, Copilot, Gemini, Cline, and other harnesses that read `.agents/skills/`.

## Authoring

Read [SKILL-DEV-GUIDE.md](./SKILL-DEV-GUIDE.md) first — primary guide for writing skills here.

Skills must also conform to the [Agent Skills specification](https://agentskills.io/specification).

External skills (marked in [skills/index.md](./skills/index.md)) are copied verbatim from upstream. They are exempt from this repo's SKILL-DEV-GUIDE principles; keep them unchanged unless syncing from source.

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
