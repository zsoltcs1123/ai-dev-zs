# Bundles

Skills that ship and install together. Standalone skills live in [`skills/`](../skills/).

| Bundle | Install |
| ------ | ------- |
| [compendium](./compendium/) | `./skills/install.sh [TARGET] --bundle compendium` |

Bundle-owned skills install only via `--bundle`. They are not listed under `skills/` and cannot be selected with `--skill`.

Some bundle members are **shared**: they live in `skills/` for standalone install and are pulled in by `ref:` entries in `bundle.yaml`.