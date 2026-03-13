---
name: finalize
description: Commits changes. Use when asked to "commit", "finalize", or "submit changes".
metadata:
  version: "1.1.0"
---

# Finalize

Stages and commits changes.

## When to Use

- User asks to "commit", "finalize", or "submit changes"

## Procedure

1. **Stage** relevant changes.
2. **Compose commit message** — write a concise descriptive message.
3. **Commit.**

## Output Format

```markdown
## Finalize: {SUCCESS|FAILED}

- Branch: {branch-name}
- Commit: {hash}
```
