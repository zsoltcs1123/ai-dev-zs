# LLM Wiki bundle

Canonical home for the LLM Wiki operate layer. Based on [Karpathy's LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

## Install

From [ai-dev-zs](https://github.com/zsoltcs1123/ai-dev-zs) repo root:

```bash
./skills/install.sh <host> --bundle llm-wiki
./skills/install.sh --global --bundle llm-wiki   # optional
```

Bundle-owned: `wiki`. Shared from `skills/`: `summarize`, `quick-summarize`, `citations`.

## Documents

| Doc | Purpose |
| --- | --- |
| [WIKI-DESIGN-PRINCIPLES.md](WIKI-DESIGN-PRINCIPLES.md) | Boundary, scope, growth |
| [WIKI-ROADMAP.md](WIKI-ROADMAP.md) | System priorities |
| [WIKI-CHANGELOG.md](WIKI-CHANGELOG.md) | Operate releases |
| [wiki/SKILL.md](wiki/SKILL.md) | Route and guardrails |

Wiki skeleton for `/wiki init`: [wiki/references/scaffold/](wiki/references/scaffold/).

## Layout or convention changes

1. Update [wiki/references/scaffold/](wiki/references/scaffold/). Set template `scaffold:` in migration playbooks to the new skill version.
2. Update [wiki/references/commands/init.md](wiki/references/commands/init.md) when init steps change.
3. Add a playbook under [wiki/references/migrations/](wiki/references/migrations/) when hosts must migrate.
4. Document in [WIKI-CHANGELOG.md](WIKI-CHANGELOG.md).
5. Update [tests/lib/wiki-migrate.sh](tests/lib/wiki-migrate.sh) when tier A rules or semver steps change.

Bump `metadata.version` in [wiki/SKILL.md](wiki/SKILL.md) when operate semantics change.

## Tests

```bash
make -C bundles/llm-wiki wiki-test
```

See [tests/README.md](tests/README.md).

## Commits (this bundle)

Lightweight [Conventional Commits](https://www.conventionalcommits.org/): `feat(wiki):`, `fix(wiki):`, `docs(wiki):`, `chore(wiki):`. Wiki **content** commits in host repos follow [wiki/references/commits.md](wiki/references/commits.md).