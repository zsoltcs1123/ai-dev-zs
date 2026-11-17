# Fix protocol

For each issue:

1. **Verify.** Open the cited location with minimal surrounding context. Decide whether the problem still holds. If the row is stale, overstated, or wrong, say so and skip or downgrade before you propose a fix.
2. **Fix.** Use repo docs and best judgment. When docs conflict, prefer principles, then conventions, then coding rules. When docs are silent, match neighbors in the touched area, then sound engineering judgment. If neighbors present obvious bad patterns, don't copy blindly, raise the problem.

Do not change code to match a harmful written standard unless the user confirms.

## Edit limits

- Change only listed rows unless verification finds one clearly linked problem at the same location.
- Ask before a fix changes runtime behavior.
- After renames or moves, update imports and leave no broken references.
- For large cross-repo reshaping, choose **Discuss**, skip, or a follow-up plan. Do not do partial moves.

## Edge cases

- More than one stack: load rules and convention docs for each stack you touch.
- The user removes rows mid-run: follow the reduced list.
- Requirement text in a row is ambiguous: flag it. Do not invent requirements.
