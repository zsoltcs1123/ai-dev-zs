---
name: quick-summarize
description: >
  Distills any text input into a brief, high-signal summary. Use when the user
  wants a quick digest, TL;DR, gist, or compact summary without full structure.
---

# Quick Summarize

Produce a compact summary that captures the essence of the input. Output to chat. Max ~15 lines of output.

## Instructions

1. Read the full input first.
2. Output using the format below. Omit Source/Author if unknown — never fabricate.
3. No filler, no fluff. Every line must carry signal.

## Output Format

```markdown
# [Descriptive Title]

Source: [linked title](URL) | Author: [Name]

[2-3 sentence core summary. What is it, what matters, why.]

## Key Takeaways

- [Insight or actionable point — be specific]
- ...
- (3-5 bullets max)
```
