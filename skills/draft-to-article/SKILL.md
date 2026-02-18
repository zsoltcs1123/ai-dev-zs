---
name: draft-to-article
description: >
  Turns messy, unstructured, or incomplete drafts into polished articles suited to
  a target audience/platform. Organizes the draft into a logical structure first,
  then offers to fill gaps while preserving the author's voice and intent. Activates
  when the user has a rough draft, brain dump, notes, or incomplete write-up they
  want shaped into a publishable article.
---

# Draft to Article

Transform raw drafts into structured, audience-appropriate articles in two phases: organize first, then complete.

## Inputs

1. **Draft** — file or freeform text. Accept anything: bullet points, stream of consciousness, half-finished paragraphs, voice-transcription dumps.
2. **Target audience/platform** — e.g. X (Twitter), LinkedIn, personal blog, Substack, Facebook, newsletter, Medium, etc. If not stated and cannot be inferred from context, ask the user before proceeding.

## Phase 1: Structure

This is the primary deliverable. Do NOT write the full article yet.

### Steps

1. Read the entire draft. Identify the core thesis or message.
2. Determine the platform/audience constraints:

   | Platform              | Typical constraints                                                                        |
   | --------------------- | ------------------------------------------------------------------------------------------ |
   | X (Twitter)           | 280 chars per post; thread format for longer pieces; punchy, conversational                |
   | LinkedIn              | ~3000 chars sweet spot; professional but personal; hook-first; line breaks for readability |
   | Substack / newsletter | Long-form OK; personal voice expected; sections with headers                               |
   | Personal blog         | Flexible length; author's natural voice; can be technical or casual                        |
   | Facebook              | Conversational; shorter paragraphs; emotional hooks work well                              |
   | Medium                | 5-8 min reads; clear structure; subheadings; accessible prose                              |

   Adapt to other platforms as needed using common sense.

3. Reorganize the draft into a logical outline:
   - Group related ideas
   - Establish a narrative arc or argument flow
   - Identify what's already strong and should stay as-is
   - Mark gaps, underdeveloped points, and missing transitions

4. Output the structured draft using this format:

```
## Structured Draft

**Platform:** [target]
**Core message:** [one sentence]

---

[Reorganized content with the following markers:]

<!-- GAP: [description of what's missing] -->
<!-- UNDERDEVELOPED: [what needs expansion] -->
<!-- TRANSITION NEEDED: [between which sections] -->

---

### Notes
- [Any observations about tone, structure decisions, things moved/cut and why]
```

### Rules for Phase 1

- Preserve the author's original wording wherever possible. Move paragraphs around, but don't rewrite them.
- Fix only obvious grammar/spelling errors and minor structural issues (e.g. a sentence clearly in the wrong section).
- Do NOT add new content, opinions, or filler.
- Do NOT change the author's voice or register.
- Placeholders must be specific about what's missing — not just "add more here."

## Phase 2: User Decision

After presenting the structured draft, ask the user:

> The structure is ready. You can:
>
> 1. **Walk me through it** — We go issue by issue; I suggest, you decide
> 2. **Let me complete it** — I'll fill the gaps and polish, keeping your voice and intent intact
>
> Which do you prefer?

If the user picks option 1, proceed to Phase 2a (Guided Refinement).

If the user picks option 2, proceed to Phase 3.

## Phase 2a: Guided Refinement

Walk the user through every issue (GAP, UNDERDEVELOPED, TRANSITION NEEDED) one at a time.

### Process

1. Compile a numbered list of all issues from the structured draft. Show the list to the user so they see the full scope upfront.
2. For each issue, in order:
   a. **Present** — Quote the surrounding context and state the issue clearly.
   b. **Suggest** — Offer a concrete fix or draft text that the user could accept as-is.
   c. **Ask** — Offer three choices:
      - Accept the suggestion (apply it)
      - Edit the suggestion (user provides an alternative or adjustment)
      - Skip (leave it for later)
   d. If the user discusses, pushes back, or asks for changes, keep iterating on that single issue until the user is satisfied or explicitly skips.
   e. Once resolved or skipped, move to the next issue.
3. After the last issue, present the updated draft incorporating all accepted/edited changes, with any skipped items still marked.

### Rules for Phase 2a

- One issue at a time. Never batch multiple issues into a single message.
- Suggestions must follow the same voice-preservation and anti-slop rules as Phase 3.
- Don't rush the user. If they want to rethink an earlier decision, allow backtracking.
- Keep a running count (e.g. "Issue 3 of 7") so the user knows where they are.

## Phase 3: Complete the Article

Fill gaps and polish the structured draft into a finished article.

### Writing rules

**Voice preservation is the top priority.** Before writing anything new:

- Note the author's sentence length patterns, vocabulary level, and tone
- Check if they use first person, rhetorical questions, humor, jargon
- Match all of these in any new content

**Content rules:**

- Keep every original sentence that works. Rephrase only when grammatically necessary or when a sentence clearly doesn't fit the new structure.
- New content should be the minimum needed to fill a gap. Don't pad.
- If a placeholder requires knowledge or opinions you don't have, flag it and ask rather than inventing.
- Stay specific. If the draft mentions specifics (names, numbers, examples), lean into them. Don't generalize.

**Anti-slop rules:**
Load [references/ai-writing-signs.md](references/ai-writing-signs.md) and actively avoid every pattern listed there. Specifically:

- No inflated significance or legacy language
- No superficial -ing analyses
- No promotional/ad-copy tone
- No vague attributions
- No AI vocabulary clusters (delve, landscape, tapestry, etc.)
- No copula avoidance (use "is"/"has" not "serves as"/"boasts")
- No rule-of-three forcing
- No em dash overuse
- No mechanical boldface or emoji decoration
- No filler phrases or excessive hedging
- No generic positive conclusions
- No chatbot residue

**If the result sounds like it could have come from ChatGPT, rewrite it.**

### Output

Present the completed article in a fenced code block. Below it, list:

- Sections that are entirely new (so the user can review closely)
- Any flags where you weren't sure about the author's intent

## Edge Cases

- **Very short draft** (a few sentences or bullet points) — Phase 1 may just be reordering bullets and identifying the 2-3 gaps. That's fine.
- **Draft is already well-structured** — Skip to noting any gaps. Don't reorganize for the sake of it.
- **Multiple possible audiences** — Ask. Don't guess.
- **Draft contradicts itself** — Flag the contradiction in Phase 1 notes. Don't resolve it silently.
- **Non-English draft** — Work in the draft's language. Note this in the output.
