---
name: summarize
description: >
  Summarizes articles, blog posts, papers, or any text input into a structured,
  scannable format. Use when the user asks to summarize, digest, extract key
  learnings, or get takeaways from content.
---

# Summarize

Extract a structured summary from any input. Output to chat by default. Write to file only when the user explicitly requests it (default path: `research/outputs/reports/`).

## Instructions

1. Read the full input before writing anything.
2. Identify: core argument, key learnings, anything actionable, open questions, and sequential processes.
3. Produce output using the template below. Stay under 100 lines total.
4. Be concise and specific. No filler, no fluff, no AI-isms.
5. Omit optional sections entirely if nothing qualifies (don't include empty headings).

## Edge Cases

- **Very short input (< 1 paragraph):** Produce only Title + Summary + Key Learnings. Skip the horizontal rules and optional sections.
- **No URL or author available:** Use `Source: [title or description of origin]` and `Author: Unknown`. Never fabricate metadata.
- **Multiple sources in one request:** Produce one summary per source, each with its own heading hierarchy.
- **Non-article formats (transcripts, READMEs, threads):** Adapt the Source line to fit (e.g., `Source: GitHub README — repo-name`). The rest of the template still applies.

## Output Template

```markdown
# [Descriptive Title]

Source: [linked title](URL) (Date)
Author: [Name, Affiliation]

[2-4 sentence prose summary. What is this about, what did they do/claim, what's the key result.]

---

## Key Learnings

**1. [Bold claim or insight title.]**
[1-2 sentences explaining the learning with specifics from the source.]

**2. ...**

---

## Actionable Takeaways

- [Concrete action someone can take based on this content]
- ...

---

## Further Investigation

- [Question or topic raised that deserves deeper research]
- ...

---

## [Process/Workflow Title]

| Phase      | What | Why |
| ---------- | ---- | --- |
| **1. ...** | ...  | ... |
| **2. ...** | ...  | ... |
```

### Section Rules

| Section                  | Required | When to include                  |
| ------------------------ | -------- | -------------------------------- |
| Title + Source + Summary | Yes      | Always                           |
| Key Learnings            | Yes      | Always (minimum 3)               |
| Actionable Takeaways     | No       | Present or inferable from source |
| Further Investigation    | No       | Present or inferable from source |
| Step-by-Step Process     | No       | Present or inferable from source |
