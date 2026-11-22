# Compendium bundle

Scoped knowledge system in git: workspace skill plus Library, Wiki, Academy, and Works facets. Roadmap: [ROADMAP.md](./ROADMAP.md). Background seed: [project-planner](https://github.com/zsoltcs1123/project-planner/blob/main/content/projects/compendium/SEED.md).

## Install

```bash
./skills/install.sh --bundle compendium
# host path:
./skills/install.sh /path/to/host/repo --bundle compendium
```

No `--global`. Shared members `summarize` and `quick-summarize` come from `skills/`; facet skills from this directory.

## After install

Run `compendium init` on the host (see `compendium` skill). Then use `scopes.yaml` and facet skills; shared rules live in the `compendium` skill references, not on the host.

Smoke tests: [tests/smoke/AGENTS.md](./tests/smoke/AGENTS.md).

## Bundle-owned skills (in progress)

| Skill | Role |
| ----- | ---- |
| `compendium` | Workspace lifecycle — `init` active; `upgrade` / `migrate` / `scope` stubs |
| `library` | Sources and references (planned) |
| `wiki` | Subject knowledge base (planned) |
| `academy` | Instruction and courses (planned) |
| `works` | User-produced output (planned) |