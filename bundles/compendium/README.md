# Compendium bundle

Scoped knowledge system in git: workspace skill plus Library, Wiki, Academy, and Works facets. Spec and vocabulary live in the [project seed](https://github.com/zsoltcs1123/project-planner/blob/main/content/projects/compendium/SEED.md).

## Install

From an ai-dev-zs checkout (host project path optional):

```bash
./skills/install.sh --bundle compendium
# or into a specific repo:
./skills/install.sh /path/to/host/repo --bundle compendium
```

Bundles do not install with `--global`.

Shared skills `summarize` and `quick-summarize` copy from `skills/`; facet skills copy from this directory as they land in the repo.

## After install

1. Run `compendium init` in the host git repository (facet skill; body still stub).
2. Read host `AGENTS.md`, `scopes.yaml`, and `contracts/` once init exists.

## Bundle-owned skills (in progress)

| Skill | Role |
| ----- | ---- |
| `compendium` | Workspace lifecycle (`init`, `upgrade`, `migrate`, `scope …`) |
| `library` | Sources and references (planned) |
| `wiki` | Subject knowledge base (planned) |
| `academy` | Instruction and courses (planned) |
| `works` | User-produced output (planned) |