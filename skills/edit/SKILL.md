---
name: edit
description: >
  Reviews and edits text for grammar, tone, structure, factual accuracy, and signs
  of AI-generated writing. Produces a form review followed by a content rating with
  improvement suggestions. Use when the user asks to edit, review, proofread, or
  critique writing.
---

# Edit

Act as an editor/reviewer for a piece of input text. Analyze form and content separately, then offer to apply fixes. Output to chat. Keep total output under 100 lines.

## Audience

If the input specifies a target audience, calibrate all feedback to that audience. Otherwise default to: general professional audience, English, neutral-to-formal register.

## Workflow

1. Read the full input.
2. Determine target audience (explicit or default).
3. Analyze **form** (grammar, tone & style, structure).
4. Analyze **content** (factual accuracy, originality, completeness, AI writing signs).
5. Output the review using the template below.
6. Offer to apply form fixes automatically.

## Form Analysis

Check these three dimensions:

**Grammar** — spelling, punctuation, subject-verb agreement, tense consistency, article usage, comma splices, dangling modifiers. List each issue with its location and the fix.

**Tone & Style** — register consistency, audience fit, wordiness, passive voice overuse, jargon accessibility, sentence variety. Flag mismatches; suggest concrete rewrites only for significant issues.

**Structure** — logical flow, paragraph cohesion, missing transitions, redundant sections, heading hierarchy (if applicable). Note structural problems and suggest reordering or consolidation where needed.

## Content Analysis

**Factual accuracy** — flag any claims that are demonstrably wrong, unsupported, or misleading. Cite what's wrong and why. If you cannot verify a claim, say so explicitly rather than guessing.

**Originality** — assess whether the core idea is fresh, distinctive, or offers a new angle. Flag if the piece rehashes well-worn arguments without adding value. Give honest feedback on whether the idea is worth writing about as-is, or what twist/depth would make it worthwhile.

**Completeness & clarity** — note gaps, ambiguities, or areas where the argument is weak. Suggest additions only if they would meaningfully improve the piece.

**AI writing signs** — scan for patterns that signal AI-generated text. Load the full checklist from `references/ai-writing-signs.md`. Report each detected pattern with its location and the specific checklist item number. Do not rewrite — flag only.

## Output Template

```
## Form Review

### Grammar
- [issue]: "[original]" → "[fix]"
- ...
(or: No issues found.)

### Tone & Style
- [observation + suggestion]
- ...
(or: Consistent and appropriate for [audience].)

### Structure
- [observation + suggestion]
- ...
(or: Well-structured.)

## Content Review

Rating: [Strong | Adequate | Needs Work]

[2-3 sentences on factual accuracy, originality, and completeness.]

### AI Writing Signs
- [#N pattern name]: "[flagged text]" — [brief explanation]
- ...
(or: No AI writing patterns detected.)

### Suggestions
- [improvement suggestion]
- ...
(Omit section if rating is Strong and nothing to add.)

---

Apply form fixes automatically? (say "yes" to apply)
```

## Applying Fixes

When the user accepts:

1. Apply all grammar fixes from the form review.
2. Apply tone & style rewrites that were explicitly proposed.
3. Do **not** apply structural or content changes automatically — those require user judgment.
4. Output the corrected text in a fenced code block.

## Edge Cases

- **Very short input** (single sentence or a few words) — skip structure analysis; focus on grammar and tone only.
- **Non-English text** — review in the input's language. Note in the output that the review is in that language.
- **Non-prose formats** (tables, bullet lists, code comments, log messages) — adapt grammar and tone checks to the format's conventions; skip structure analysis unless the user explicitly asks for it.
