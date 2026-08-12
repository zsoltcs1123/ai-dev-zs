---
name: summarize
description: Summarizes articles, blog posts, papers, or any text input into a structured, scannable format. Use when the user asks to summarize, digest, extract key learnings, or get takeaways from content.
metadata:
  author: zs
  version: "1.1"
---

# Summarize

## Outcome

Structured, scannable summary of articles, blog posts, papers, or any text. Default output in chat; write to file only when asked (default path: `research/outputs/reports/`). Stay under 100 lines. Be concise and specific; do not miss important information.

See [references/output-template.md](references/output-template.md) for format, section rules, and edge cases.

## Guardrails

- Read full input before writing.
- Omit optional sections if nothing qualifies — no empty headings.
- Never fabricate metadata. Use `Author: Unknown` when unknown.
- No filler, no fluff, no AI-isms.
- Keep the language focused, clean and well-written. Avoid em dash and typical AI style.
