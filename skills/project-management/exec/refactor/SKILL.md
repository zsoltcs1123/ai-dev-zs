---
name: refactor
description: Analyzes a codebase across architectural, testing, readability, and code health dimensions to identify refactoring opportunities. Classifies findings by severity, effort, and impact, then presents a prioritized report. Use when asked to "find refactoring opportunities", "analyze code health", "what should I refactor", or "spot code smells".
metadata:
  version: "1.0.0"
---

# Refactor

Analyzes a target application or code library to spot refactoring opportunities. Classifies each finding by severity, effort, and impact, and presents the top priorities as an actionable report (max 7 findings).

## When to Use

- User asks to find refactoring opportunities, code smells, or technical debt
- Before a major feature push, to identify structural risks
- When onboarding to an unfamiliar codebase and want a health check

## Input

- **Scope**: directory, module, or entire repository to analyze. If not specified, ask.
- **Focus** (optional): subset of dimensions to prioritize. Default: all dimensions.

## Procedure

1. **Resolve scope** — confirm what code to analyze. If the user didn't specify, ask.
2. **Explore structure** — map the codebase: directory layout, entry points, key modules, tech stack.
3. **Assess maturity** — determine project status (early prototype, active development, mature/stable). Calibrate expectations accordingly: don't flag missing abstractions in a proof-of-concept, don't tolerate them in a production system.
4. **Analyze** each dimension (below). Use parallel exploration where possible. Weight findings against the maturity assessment — what matters now vs what can wait.
5. **Classify** each finding using the classification scheme.
6. **Present** the report in the output format.

## Analysis Dimensions

### 1. Architecture

SRP violations, duplicated code, unnecessary layers or indirection, leaky abstractions, god classes/modules, circular dependencies, poor module boundaries.

### 2. Structural Test Analysis

Are the right things tested? Tests coupled to implementation details rather than behavior? Gaps at integration boundaries? Redundant or low-value tests that add maintenance cost without catching real bugs?

### 3. Naming and Readability

Misleading names, cryptic abbreviations, inconsistent naming conventions across the codebase. Identifiers that don't match what the code actually does.

### 4. Control Flow Complexity

Deep nesting, god functions, convoluted branching, long method chains, functions doing too many things. High cyclomatic complexity.

### 5. Dead Code and Unused Exports

Unreferenced imports, functions, types, files, or exports that nothing consumes. Feature flags for long-shipped features.

### 6. Error Handling Consistency

Mixed error patterns (try/catch vs result types vs callbacks), swallowed errors, missing error boundaries, inconsistent error propagation.

### 7. Type Safety Gaps

`any` casts, loose types, stringly-typed APIs, missing discriminated unions, overly permissive generics. Skip this dimension for untyped languages.

### 8. Performance Anti-Patterns

N+1 queries, unbounded loops, missing memoization, synchronous blocking in async contexts. Structural issues only — not a full performance audit.

### 9. API Surface Hygiene

Over-exposed internals, inconsistent naming across public APIs, missing or misleading contracts, barrel files re-exporting everything.

## Classification

Rate each finding on three axes:

| Axis | Values |
|------|--------|
| **Severity** | Critical — actively causes bugs or blocks progress; Major — significant maintainability or correctness risk; Minor — code smell, friction |
| **Effort** | Low — hours; Medium — days; High — weeks+ |
| **Impact** | High — large maintainability/correctness gain; Medium — moderate improvement; Low — marginal benefit |

## Output Format

**Max 7 findings.** Report only the highest-priority opportunities. Compress related instances into one finding when they share a root cause.

Sort by priority: highest-impact, lowest-effort first.

Each finding must fit in **5 lines max**:
- Line 1: what's wrong (one sentence) + where (`path`)
- Line 2: brief context if needed (one sentence — skip if line 1 is self-explanatory)
- Line 3: classification tags
- Line 4: what to do about it (one sentence — no code, no paragraphs)
- Line 5: blank separator

This is a scan report, not an implementation plan. Keep it tight enough to discuss in conversation. Details and code samples belong in the implementation phase.

```markdown
## Refactor Analysis

### Summary

{Scope, maturity, tech stack, overall health — 2-3 sentences.}

### Findings

1. {One-sentence problem statement} — `{path(s)}`
   **{Dimension}** · {Severity} · Effort {E} · Impact {I}
   → {One-sentence fix direction}

### Where to Start

{2-3 sentences: what to tackle first, why, and any design patterns that address root causes. Not a rehash of findings.}
```
