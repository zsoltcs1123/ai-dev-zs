---
name: quick-summarize
description: Distills any text input into a brief, high-signal summary. Use when the user wants a quick digest, TL;DR, gist, or compact summary without full structure.
metadata:
  author: zs
  version: "1.1"
---

# Quick Summarize

## Outcome

Compact summary capturing the essence of any text. Max ~15 lines. Default output in chat. Every line must carry signal.

See [references/output-format.md](references/output-format.md) for format.

## Guardrails

- Read full input before writing.
- Never fabricate Source/Author — omit if unknown.
- No filler, no fluff.
