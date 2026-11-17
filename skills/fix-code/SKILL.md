---
name: fix-code
description: Fixes an explicit list of code issues from chat or a file. Verifies each item, then applies fixes one at a time or in batch. Use for "fix-code", "fix these issues", "apply the findings", "fix-code interactive", or "fix-code non-interactive". Stops and asks when the input is not a concrete issue list.
disable-model-invocation: true
metadata:
  author: zs
  version: "1.1"
---

# Fix code

## Outcome

You work through a supplied issue list. You verify each row against the current code, then you fix it with best judgment. Default mode is interactive. At the end, summarize what you fixed and what you skipped.

Read a reference only when the spine below points to it.

## Mode

Read the invocation:

- `fix-code interactive`, bare `fix-code`, or "fix these issues" → **interactive**
- `fix-code non-interactive` → **non-interactive**

Mode sets confirmations and pacing only.

## Spine

1. **Issue list.** Read [references/issue-list.md](references/issue-list.md) and check the input. If the list is not concrete, stop and ask for a better one. Do not invent issues or run a broad review.
2. **Normalize.** Parse rows into one ordered list. When severities are present, sort Major, then Medium, then Minor. Otherwise keep source order.
3. **Fixes.** Read [references/fix-protocol.md](references/fix-protocol.md), then [references/walkthrough.md](references/walkthrough.md) for the active mode.

## Guardrails

- Fix only listed rows unless verification at the same location reveals one clearly linked problem.
- Ask before you apply a fix that changes runtime behavior.
- For a multi-file move in interactive mode, put a move map in **Propose**. In non-interactive mode, name moves, renames, or splits in the batch question.
- When the repo uses more than one stack, load convention and rule docs for each stack you touch.

## Tools

- Read repo files at cited locations.
- The user may attach a file that contains the issue list.