# Resolve Wiki Target

Before `ingest`, `lint`, `discard`, or a scoped `query`, determine which wiki root to operate on.

## Wiki Root Detection

A directory is a wiki root when it has **both**:

- `wiki/index.md`
- `raw/` (with `sources/`, `notes/`, and `reference/` subdirs)

Optional marker: `.wiki-root.yaml` (slug, name) — written by `init`, speeds resolution.

## Resolution Priority

Apply in order; stop at first match:

1. **Explicit `--path <dir>`** — must pass wiki root detection
2. **Explicit `--wiki <slug>`** — match `.wiki-root.yaml` slug or registry entry
3. **CWD walk-up** — if cwd is inside a wiki root, use that root
4. **Host registry** — read `wikis/AGENTS.md` if present; if user named a wiki in the message, match by slug
5. **Repo scan** — find all wiki roots under conventional paths:
   - `wikis/*/`
   - `wiki/` (submodule mount)
   - repo root (whole repo is one wiki)
6. **Disambiguate:**
   - exactly one found → use it
   - multiple found → ask user once; remember for session
   - none found → suggest `wiki init`

## Slug for Commits and Log

Use the `slug` field from `.wiki-root.yaml` when present. Otherwise use the wiki root directory name.

## Host Registry

Multi-wiki hosts may keep a thin `wikis/AGENTS.md` registry:

```markdown
# Wikis

| Slug | Path | Notes |
|------|------|-------|
| agentic-engineering | wikis/agentic-engineering/ | Agent software engineering |

Operations: `/wiki <command>`.
```

For single-wiki hosts (for example a codebase with `wiki/` submodule), registry is optional.
