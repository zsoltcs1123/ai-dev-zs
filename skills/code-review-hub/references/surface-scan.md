# Surface scan

Run this after the target brief is ready. The inline path uses the same `launch` and `skip` split as the default path ([SKILL.md](../SKILL.md), step 3).

## Outcome

You split the selected dimensions into `launch` and `skip`. For each `skip` id, you emit a coordinator stub in [shared-guardrails.md](shared-guardrails.md) **Report shape**. Leave findings empty. Set **Skipped** to `surface-scan: <reason>`. You run Tasks and inline dimension reads only for `launch`.

## Inputs

Use git and the brief. Read diff hunks only when a bucket is borderline.

- Path list, renames, `git diff --stat`.
- Buckets: docs, tests, source, config or CI, manifests only.
- Brief fields: **Stated goal**, **Acceptance criteria**, **Notes**.
- Convention pointers (no deep search): `AGENTS.md`, `CONTRIBUTING.md`, `PRINCIPLES.md`, `**/.cursor/rules/*.mdc`, linter configs at or above changed paths.

When signals conflict, put the dimension on `launch`.

## Guardrails

- Never skip a dimension id the user named in the invocation.
- When the user says `no skip`, `all dimensions`, `full depth`, or `run every lens`, do not skip any selected dimension.
- When any source path changes, never skip `implementation`.
- List every skip in merged **Coverage** ([harmonization.md](harmonization.md)).

## Stub for each skipped dimension

```text
## Summary
Surface scan: no material signal for <dimension-id> in this diff.
## Findings

## Totals
Major 0 · Medium 0 · Minor 0
## Skipped
surface-scan: <one-line reason>
```

Example **Skipped** values: `docs-only diff`, `no stated intent; mechanical manifest bump`, `no production paths`, `no path or rename changes`, `no convention docs for touched stacks`.

## When you can skip a dimension

Every row below must hold for that id.

| Dimension | Safe to skip when |
| --------- | ----------------- |
| `intent` | The brief has no product intent to check: **Stated goal** is empty or purely technical, **Acceptance criteria** is `none supplied`, and **Notes** has no PR or ticket narrative. The diff is mechanical only (format, comments, lockfiles or manifests, version bumps with no project source). |
| `conformance` | No `*.mdc`, linter config, or convention or principles doc applies to the touched stacks. The diff is docs-only, generated-only, or a single isolated file type with no written rules to check. |
| `security` | The diff is docs-only, tests-only, or comment-only. No changed path touches auth, crypto, sessions, upload, deserialization, shell, SQL, workflow secrets, env templates, or a network boundary. |
| `testing` | No production or source path changed. Docs-only counts. CI-only counts only when the same diff does not touch app source. |
| `simplicity` | Fewer than about 20 net source lines changed, and the stat shows no new functions, classes, branches, or modules. Docs-only also qualifies. |
| `structure` | No new, deleted, or renamed path or directory. You only edited files in place. |

When runtime source or config changes, put `implementation` on `launch` unless the user disabled skip.

## When you must launch anyway

- The user aimed the review at that dimension.
- The user narrowed scope after [target-resolution.md](target-resolution.md) **Large diff**. You still launch the lenses they selected.
- A path is security-adjacent even if the `security` row would allow a skip.
- **Notes** or the PR claim new public API, migrations, feature flags, or behavior. Launch at least `intent`, `testing`, and `implementation`.
- The diff adds files or moves paths. Launch `structure`. Launch `conformance` when convention docs exist.