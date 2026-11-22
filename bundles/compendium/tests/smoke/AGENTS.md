# Compendium smoke tests

Two steps: **fixture hosts** (browse) and **smoke** (assert).

## 1. Fixture-init (browse real layout)

```bash
./bundles/compendium/tests/smoke/fixture-init.sh
```

Wipes `bundles/compendium/compendium-host/`, then builds:

| Path | Real usage |
| ---- | ---------- |
| `compendium-host/root/` | Git repo; workspace at root; bundle, POC scopes + `loci/` |
| `compendium-host/subdir/` | Git repo; `.agents/skills` at repo root; workspace in `compendium/` |

Re-run `fixture-init.sh` to reset to latest scaffold.

## 2. Smoke (tests)

```bash
./bundles/compendium/tests/smoke/run.sh
```

Requires fixture hosts. Clears only `_scratch/` each run. Tests check `root/` and `subdir/`; destructive cases use temp repos under `_scratch/`.

## Requirements

`git`, `bash`, `python3`; `prek` for the prek scenario.