---
name: tighten
description:
  Tightens existing prose by cutting redundancy, restatement, and narrative fat while keeping every important fact. Use when the user says tighten, tighten-text, cut verbosity, raise signal-to-noise,
  edit for clarity, or wants a chat passage or file shortened without losing information.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.0"
---

# Tighten

## Outcome

The same text, denser. High signal. Fat gone. Every important fact still present.

This is an edit, not a summary. Do not outline, digest, or turn the source into a new artifact.

**Target:** the named file, the pasted passage, or the last substantial text in the thread. If unclear, ask.

**Output:** chat target → tightened text in chat. File target → write the tightened text back to that file.

Done when:

- Every fact, constraint, number, name, decision, exception, and distinction from the original still has a home.
- **one fact - one home, do not restate**
- Unnecessary content is gone: restatement, throat-clearing, preview/recap, duplicate examples, narrative that proves a point already made.

If the text is already tight, say so. Do not churn.

## Guardrails

Do not remove any important information. Only trim the fat. When unsure, keep it.

- Keep meaning. Do not invent, soften, or strengthen claims.
- Keep the author's voice, register, and structure. Drop or merge a heading only when it restates the next block.
- Leave code, commands, identifiers, quotes, URLs, numbers, units, and dates intact.
- Do not run unslop, caveman, or style-gdocs unless the user loaded that skill.
- Language of the rewrite: focused, clean, well-written. Avoid em dash and typical AI style.

## Keep vs cut

Keep (information):

- Claims, decisions, constraints, exceptions
- Names, numbers, dates, units, links
- A reason that is itself a fact
- Examples that each teach a different thing

Cut (fat):

- The same fact in a second sentence
- Intros that preview the body; outros that recap it
- "It is important to note", "as mentioned above", "this means that"
- Extra examples of a point already shown
- Narrative that sells or proves a point the text already states

## Example

Before:

> It is important to note that the cache expires after 5 minutes. As mentioned above, entries older than 5 minutes are evicted. This matters because stale reads would otherwise be served.

After:

> The cache expires after 5 minutes. Stale reads would otherwise be served.

## Tools

- Read the named file in full before editing.
- Write the tightened text back to that file.
