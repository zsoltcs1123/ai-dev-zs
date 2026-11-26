# AGENTS.md

Agent skills repo. Portable across Cursor, Codex, Copilot, Gemini, Cline, and other harnesses that read `.agents/skills/`.

## Authoring

Read [skills/new-skill/references/skill-dev-guide.md](./skills/new-skill/references/skill-dev-guide.md) first (or use `/new-skill`).

Skills must conform to the [Agent Skills specification](https://agentskills.io/specification).

External skills (marked in [skills/index.md](./skills/index.md)) live in [skills/external.lock](./skills/external.lock) and are fetched at install time — not vendored here. Do not edit upstream content; pin `ref` in the lock file for reproducible installs.

### Repo extensions

This repository adds install layout and frontmatter beyond the public spec:

- Standalone skills in `skills/` get `disable-model-invocation: true` when missing (slash-command only). [skills/install.sh](./skills/install.sh) enforces that for standalone and external installs.
- **Bundles** live under [bundles/](./bundles/). Install with `./skills/install.sh --bundle NAME`. Bundle-owned skills are not under `skills/` and cannot be installed with `--skill` alone. Bundle slash-command policy is set in each `bundles/*/bundle.yaml` (`patch_disable_model_invocation`).
- The `disable-model-invocation` field is outside the public spec today; `npx skills-ref validate` reports an unexpected field until upstream or the validator allowlists it.

## Install

Do not commit `.agents/skills/` — local install target (gitignored). Re-run install to refresh.

### Full curated set (local + external)

```bash
./skills/install.sh                    # current project → ./.agents/skills/
./skills/install.sh /path/to/app       # specific project
./skills/install.sh --global           # user → ~/.agents/skills/
./skills/install.sh --skip-external    # local skills only (skip upstream fetches)
./skills/install.sh --skill NAME       # one skill only (repeat --skill for several)
./skills/install.sh --bundle NAME      # install a bundle
./skills/install.sh --list             # list installable skills
```

Registers sources in the npx skills lock file (`~/.agents/.skill-lock.json` for `--global`, `skills-lock.json` for project installs) so `npx skills list` shows upstream repos.

### Local skills only (Node)

Uses [npx skills](https://github.com/vercel-labs/skills). Installs repo skills only — no externals, no install-time `disable-model-invocation` patch.

```bash
npx skills add zsoltcs1123/ai-dev-zs -a cursor -y                         # all local skills, project
npx skills add zsoltcs1123/ai-dev-zs --skill code-review -a cursor -y   # one skill
npx skills add zsoltcs1123/ai-dev-zs -g -a cursor -y                    # global
npx skills add zsoltcs1123/ai-dev-zs --list
npx skills update -y
```

## Git

Commits: `type: description` — `feat`, `fix`, `docs`, `chore`.

Hook (once per clone): `git config core.hooksPath .githooks`

## Key files

| File | Purpose |
| ---- | ------- |
| [skills/index.md](./skills/index.md) | Standalone skill catalog |
| [bundles/](./bundles/) | Skill bundles (install with `--bundle`) |
| [skills/external.lock](./skills/external.lock) | Upstream pointers for external skills |
| [skills/install.sh](./skills/install.sh) | Installer |
| [skills/new-skill/references/skill-dev-guide.md](./skills/new-skill/references/skill-dev-guide.md) | How to write skills (`new-skill`) |
