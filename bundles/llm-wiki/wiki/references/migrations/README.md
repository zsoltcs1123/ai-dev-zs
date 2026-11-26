# Wiki migrations

Reference index for tier B of [migrate.md](../commands/migrate.md). Each playbook advances `.wiki-root.yaml` `scaffold` by one semver step.

## Playbook chain

| From | To | File |
| --- | --- | --- |
| 1.0 | 1.1 | [1.0-to-1.1.md](1.0-to-1.1.md) |
| 1.1 | 1.2 | [1.1-to-1.2.md](1.1-to-1.2.md) |
| 1.2 | 1.3 | [1.2-to-1.3.md](1.2-to-1.3.md) |
| 1.3 | 1.4 | [1.3-to-1.4.md](1.3-to-1.4.md) |
| 1.4 | 1.5 | [1.4-to-1.5.md](1.4-to-1.5.md) |

If `.wiki-root.yaml` has no `scaffold` key, treat the wiki as version `1.0`.

A full migrate normally ends at the installed wiki skill `metadata.version`. `--to` on `/wiki migrate` can stop earlier.

## Ship a release that changes layout

1. Bump `metadata.version` in `wiki/SKILL.md` (bundle `bundles/llm-wiki/wiki/`).
2. Update `wiki/references/scaffold/`. Set template `scaffold:` to the new version.
3. Add `X.Y-to-X.Z.md` with preconditions, tier A notes, steps, verification, and log wording.
4. If the bash mirror needs the new step, extend `WIKI_SCAFFOLD_STEPS` in `tests/lib/wiki-migrate.sh`.
5. Run `make wiki-test`.
6. Add a consumer note in [WIKI-CHANGELOG.md](../../../../WIKI-CHANGELOG.md).

## Playbook sections

Each playbook file uses the same headings:

1. Preconditions (`scaffold` equals the *from* version)
2. Tier A (when additive sync belongs in that step)
3. Steps (confirm before you edit the index or yaml)
4. Verification
5. Log line and commit subject