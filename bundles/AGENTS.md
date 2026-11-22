# Bundles

Skills that ship and install together. Standalone skills live in [`skills/`](../skills/).

| Bundle | Install |
| ------ | ------- |
| [compendium](./compendium/) | `./skills/install.sh [TARGET] --bundle compendium` |

Bundle-only skills: `--bundle` only (not `--skill` alone). Repo rules: [AGENTS.md](../AGENTS.md) § Repo extensions.

Some bundle members are **shared**: they live in `skills/` for standalone install and are pulled in by `ref:` entries in `bundle.yaml`.