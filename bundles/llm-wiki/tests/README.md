# Wiki operate tests

Run all scenarios:

```bash
make wiki-test
./tests/run.sh
```

## Scenarios

| Name | Entry point | Checks |
| --- | --- | --- |
| init | [scenarios/init/run.sh](scenarios/init/run.sh) | Wiki root detection, resolve priority, init, `scaffold` on new wikis |
| migrate | [scenarios/migrate/run.sh](scenarios/migrate/run.sh) | `scaffold` read and write, playbook chain, tier A deny list, hub-only index |

## Library layout

| Path | Role |
| --- | --- |
| `lib/resolve-wiki.sh` | Executable mirror of `skills/wiki/references/resolve-wiki.md` |
| `lib/wiki-init.sh` | Init helper used by the init scenario |
| `lib/wiki-migrate.sh` | Tier A sync and mechanical playbook steps |
| `lib/skill-version.sh` | Reads `metadata.version` from `wiki/SKILL.md` |
| `fixtures/` | Multi-wiki hosts and migrate fixtures |

## Keep bash in sync

When `resolve-wiki.md` changes, update `lib/resolve-wiki.sh` and the init scenario.

When tier A rules in `migrate.md` change, update `lib/wiki-migrate.sh` and the migrate scenario.

When you add a semver playbook step, extend `WIKI_SCAFFOLD_STEPS` in `lib/wiki-migrate.sh`, add the playbook file, and adjust migrate scenario expectations if needed.
