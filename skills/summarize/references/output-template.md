# Summarize Output Template

## Template

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

## [Process/Workflow Title]

| Phase      | What | Why |
| ---------- | ---- | --- |
| **1. ...** | ...  | ... |
| **2. ...** | ...  | ... |

---

## Further Investigation

- [Question or topic raised that deserves deeper research]
- ...
```

## Section Rules

| Section                  | Required | When to include                  |
| ------------------------ | -------- | -------------------------------- |
| Title + Source + Summary | Yes      | Always                           |
| Key Learnings            | Yes      | Always (minimum 3)               |
| Actionable Takeaways     | No       | Present or inferable from source |
| Step-by-Step Process     | No       | Present or inferable from source |
| Further Investigation    | No       | Present or inferable from source |

## Edge Cases

- **Very short input (< 1 paragraph):** Title + Summary + Key Learnings only. Skip horizontal rules and optional sections.
- **No URL or author available:** `Source: [title or description of origin]` and `Author: Unknown`. Never fabricate.
- **Multiple sources:** One summary per source, each with its own heading hierarchy.
- **Non-article formats (transcripts, READMEs, threads):** Adapt Source line (e.g. `Source: GitHub README — repo-name`).
