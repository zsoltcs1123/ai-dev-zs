# Bundles

Skills that ship and install together. Standalone skills live in [`skills/`](../skills/).

Each bundle is a subdirectory with `bundle.yaml` and one or more skill folders (`<name>/SKILL.md`). Install with:

```bash
./skills/install.sh [TARGET] --bundle ID
```

Run `./skills/install.sh --list` to see bundle IDs once they are added.

Bundle-only skills: `--bundle` only (not `--skill` alone). Repo rules: [AGENTS.md](../AGENTS.md) § Repo extensions.

Some bundle members are **shared**: they live in `skills/` for standalone install and are pulled in by `ref:` entries in `bundle.yaml`.