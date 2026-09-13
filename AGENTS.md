# AGENTS.md

Agent skills repo. Portable across Cursor, Codex, Copilot, Gemini, Cline, and other harnesses that read `.agents/skills/`.

## Authoring

Read [SKILL-DEV-GUIDE.md](./SKILL-DEV-GUIDE.md) first — primary guide for writing skills here.

Skills must also conform to the [Agent Skills specification](https://agentskills.io/specification).

External skills (marked in [skills/index.md](./skills/index.md)) are copied verbatim from upstream. They are exempt from this repo's SKILL-DEV-GUIDE principles; keep them unchanged unless syncing from source.

## Install

Recommended:

```bash
npx skills add zsoltcs1123/ai-dev-zs -a cursor -y
npx skills add zsoltcs1123/ai-dev-zs --skill <name> -a cursor -y
npx skills add zsoltcs1123/ai-dev-zs --list
npx skills update -y
```

Fallback (no Node):

```bash
./skills/install.sh          # project: ./.agents/skills/
./skills/install.sh --global   # user: ~/.agents/skills/
./skills/install.sh --list     # list installable skills
```

Re-run either method to refresh after updates. Do not commit `.agents/skills/` — it is a local install target (gitignored).

Commits: `type: description` — `feat`, `fix`, `docs`, `chore`.
Hook: `git config core.hooksPath .githooks` (once per clone).

## Key files

- [skills/index.md](./skills/index.md) — skill catalog
- [SKILL-DEV-GUIDE.md](./SKILL-DEV-GUIDE.md) — how to write skills
- [skills/install.sh](./skills/install.sh) — copy skills into `.agents/skills/`
