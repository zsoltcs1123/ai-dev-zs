# Wiki Git Commits

Use standardized commit subjects for wiki-changing workflows:

`wiki(<wiki-slug>) <operation>: <summary>`

- `<wiki-slug>` is the wiki identifier from `.wiki-root.yaml` or the directory name (for example `agentic-engineering`).
- Use `wiki(system)` for shared wiki-system changes that are not specific to one wiki.
- Standard operations: `ingest`, `cleanup`, `lint`, `discard`, `contract`, `migrate`.
- Keep `<summary>` short and outcome-oriented. Describe what changed in the wiki, not the mechanics.
- Commit once per completed wiki-changing workflow.
- Do not create a commit for a no-op run.
- If one run modifies multiple wikis, create separate commits per wiki.
- Keep the subject line sufficient in normal cases. Add a short body only when it materially helps, such as discard classification, unusual scope, or a broad structural pass.
- Keep the commit operation label aligned with the corresponding `wiki/log.md` entry where applicable.

## Examples

- `wiki(agentic-engineering) ingest: add Karpathy software 3.0 source`
- `wiki(agentic-engineering) lint: strengthen weak source cluster`
- `wiki(agentic-engineering) cleanup: normalize backlinks and frontmatter`
- `wiki(agentic-engineering) discard: remove out-of-scope market-analysis pages`
- `wiki(system) contract: require post-change wiki commits`
