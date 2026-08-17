# Output Template

Follow this structure exactly.

## Progress Bars

Use these exact bars in the Maturity Summary and After All Three Waves sections:

| Level                     | Bar              |
| ------------------------- | ---------------- |
| Baseline                  | `████░░░░░░░░░░` |
| Functional                | `██████░░░░░░░░` |
| Functional → Standardized | `████████░░░░░░` |
| Standardized              | `████████████░░` |
| Autonomous                | `██████████████` |

For transition levels (e.g., "Baseline → Functional"), use the bar of the lower level. Annotate the transition in the text label beside the bar.

## Structure

~~~markdown
# [Project Name] — Agent Readiness Assessment

[One-line description: what's being assessed, against what framework.]

Context: [Tech stack / team size / project state — inferred from exploration.]

---

## Current State

### 1. Information Surface — [Maturity Level]

**Overview:** [2-3 sentence interpretation — what's strong, what's weak, what it means for agents.]

**Sub-checks:**

| Check | Status | Evidence |
|-------|--------|----------|
| `agents_md` | pass/fail/skip | [one-line evidence] |
| ... | ... | ... |

### 2. Feedback Surface — [Maturity Level]

**Overview:** [2-3 sentence interpretation.]

**Sub-checks:**

| Check | Status | Evidence |
|-------|--------|----------|
| ... | ... | ... |

### 3. Constraint Surface — [Maturity Level]

**Overview:** [2-3 sentence interpretation.]

**Sub-checks:**

| Check | Status | Evidence |
|-------|--------|----------|
| ... | ... | ... |

---

## Scorecard

| Pillar | Pass | Total | % |
|--------|------|-------|---|
| Style & Validation | | | |
| Build & Release | | | |
| Testing | | | |
| Documentation | | | |
| Dev Environment | | | |
| Observability | | | |
| Security & Governance | | | |
| Product & Analytics | | | |
| **Total** | | | |

---

## Maturity Summary

```
Information [bar] [Level]
Feedback    [bar] [Level]
Constraints [bar] [Level]
```

[1-2 paragraph interpretation — what's strong, what's limiting agent effectiveness, where the biggest delta is.]

---

## Path to Three-Surface Coverage

Deliverables grouped by surface and ordered by impact. Each deliverable is scoped to be completable independently.

### [Surface] Surface

#### [ID]. [Title]

**What:** [one paragraph]

**Why:** [one paragraph]

**Scope:** [effort estimate]

[Repeat for each deliverable per surface]

---

## Recommended Sequencing

### Wave 1 — Fast wins ([timeframe])

| #   | Deliverable | Surface | Effort |
| --- | ----------- | ------- | ------ |
| ... | ...         | ...     | ...    |

[1-2 sentence summary of why these come first.]

### Wave 2 — Structural improvements ([timeframe])

| #   | Deliverable | Surface | Effort |
| --- | ----------- | ------- | ------ |

[1-2 sentence summary.]

### Wave 3 — Infrastructure for scale

| #   | Deliverable | Surface | Effort |
| --- | ----------- | ------- | ------ |

[1-2 sentence summary.]

---

## After All Three Waves

```
Information [projected bar] [Projected Level]
Feedback    [projected bar] [Projected Level]
Constraints [projected bar] [Projected Level]
```

[Remaining gaps to full Autonomous — what's left and why it's acceptable for now.]
~~~

## Quality Checklist

Before outputting the report, verify:

- [ ] Every sub-check has a status (pass/fail/skip) and one-line evidence
- [ ] Skipped checks include a reason
- [ ] Overviews interpret findings (the "so what"), not just restate them
- [ ] Scorecard totals match sub-check counts (Total column excludes skipped checks)
- [ ] Maturity levels are consistent with the framework definitions
- [ ] Progress bars match assigned maturity levels
- [ ] Deliverables reference specific failing sub-checks from the assessment (not generic advice)
- [ ] Wave sequencing puts config-only changes first, implementation work second
- [ ] The "After All Three Waves" section shows realistic projected levels, not automatic full Autonomous
- [ ] Report reads as specific to THIS repo, not a generic template
