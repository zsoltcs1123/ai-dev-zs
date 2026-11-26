# Documentation formatting

Load this file when producing documentation: README, design doc, procedure, API notes. Voice and grammar stay in SKILL.md.

## Headings

- Use sentence case.
- Task headings start with a bare infinitive: "Create an instance", not "Creating an instance".
- Conceptual headings are noun phrases: "Migration to Google Cloud", not "Migrating to Google Cloud".
- Avoid a leading *-ing* verb. Gerunds are fine when they are the topic itself (*Billing*, *Pricing*).
- Prefix optional sections with `Optional:`.
- Do not put links in headings. Do not number headings to show sequence.
- Do not skip heading levels. Do not leave a heading with no content under it.
- One unique `h1` per page. Mixed task and conceptual headings on one page are fine.

## Lists

- Numbered lists for sequences. Bulleted lists otherwise. Description lists for a term plus an explanation.
- Do not make a list of one item.
- Introduce a list with a complete sentence, usually ending in a colon. Do not use a partial sentence that the items complete.
- Keep items parallel.
- Start each item with a capital letter.
- End with a period if the item has a verb. No end punctuation for a single word, a phrase without a verb, code-only items, or a document title.

## Procedures

- Use numbered steps.
- The first sentence of each step includes an imperative verb.
- Put the condition or goal before the action.
- Prefix optional steps with `Optional:`.
- Sub-steps: lowercase letters, then lowercase Roman numerals.

## Code and UI

- Put code-related text in backticks: filenames, paths, commands, methods, flags, types, env vars, HTTP verbs and status codes, placeholders.
- Put UI labels in **bold**. If a UI element is also a code value, use both: select **`my-net-2`**.
- Do not inflect a code identifier as an English word. Add a noun after it and inflect that noun: "send a `POST` request", not "`POST` the data".
- Do not put product names, ordinary domain names, or browser URLs in code font.

## Links

- Use short, unique, descriptive link text: the page title, or a phrase that names the destination.
- Do not use *click here*, *this document*, or a raw URL as link text.
- Introduce a dedicated cross-reference with "For more information, see…" or "For more information about…, see…". Use *about*, not *on*.
- Prefer a brief explanation on the page over a link. Do not duplicate the same link on a short page.

## Other

- Write dates unambiguously (for example, `January 5, 2026` or `2026-01-05`).
- Provide alt text for images.
- Do not pre-announce unreleased features.
