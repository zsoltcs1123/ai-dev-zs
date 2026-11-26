# Git workflows

Default branch and pull-request rules. A repo note may override these (document overrides in prose, not a schema).

## Branch naming

| Type | Pattern | Example |
| --- | --- | --- |
| Feature | `feat/{slug}` | `feat/add-export` |
| Fix | `fix/{slug}` | `fix/gateway-routing` |
| Chore | `chore/{slug}` | `chore/update-ci` |

One path segment after the prefix unless the repo note says otherwise.

## Pull request

`gh pr create` against the default base branch (`origin/HEAD`, else `main`). Title summarizes the change. Body notes what was delivered and which checks ran.
