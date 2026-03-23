# Exploration Checklist

Systematic checklist of what to look for when assessing a repository. Organized by surface. For each indicator: what to check, common file paths/tools per ecosystem, and what "in place" vs. "gap" looks like.

Use subagents or parallel tool calls to explore efficiently. Read configs, count files, check directory structures — don't rely on assumptions.

## Contents

- [Information Surface](#information-surface) — I-1 through I-7
- [Feedback Surface](#feedback-surface) — F-1 through F-8
- [Constraint Surface](#constraint-surface) — C-1 through C-5
- [Monorepo Considerations](#monorepo-considerations)

---

## Information Surface

### I-1. Agent Entrypoint (Functional)

**Check:** AGENTS.md, CLAUDE.md, .github/copilot-instructions.md, or equivalent at repo root.

**In place:** Short entrypoint (<150 lines) with links to structured docs. Table of contents, not encyclopedia.
**Gap:** No entrypoint, or a monolithic instruction file that tries to contain everything.

### I-2. Documentation Hierarchy (Functional)

**Check:** docs/ or similar directory. Look at depth, coverage, and structure.

**In place:** Structured hierarchy (e.g., docs/project/, docs/conventions/, docs/decisions/, docs/knowledge-base/). Progressive disclosure from entrypoint.
**Gap:** Flat docs/ with a few stale files, or docs scattered across the repo with no index.

### I-3. Agent Instruction Files (Functional)

**Check:** .cursor/rules/*.mdc, .cursorrules, .github/copilot-instructions.md, .agents/ directory.

**In place:** Coding standards, conventions, module-specific guidance accessible to agents.
**Gap:** No agent-specific instruction files beyond README.

### I-4. Feature / Task Specs (Standardized)

**Check:** Look for spec files, feature directories, task breakdowns.

**Spec quality (five primitives):**
1. Self-contained problem statement (no implicit context)
2. Acceptance criteria (verifiable by an independent observer)
3. Constraint architecture (musts, must-nots, preferences, escalation triggers)
4. Decomposition into subtasks with clear I/O boundaries
5. Evaluation design (known-good outputs, recurring test cases)

**In place:** Specs exist with most primitives covered. Linked from a feature map or index.
**Gap:** Specs are just titles/goals, or don't exist at all. Or: feature map references specs that don't exist on disk.

### I-5. Decision Records (Standardized)

**Check:** docs/decisions/, docs/adr/, or decisions embedded in architecture docs.

**In place:** Formal ADR directory with individually trackable records. Or: architecture doc with versioned, structured decision sections.
**Gap:** Decisions live in PR descriptions, Slack, or someone's head. Or: embedded in prose with no way to link to a specific decision.

### I-6. Context / Intent Documents (Standardized → Autonomous)

**Check:** PRINCIPLES.md, conventions docs, tradeoff hierarchies, escalation policies.

**In place:** Concrete tradeoff hierarchies ("if test coverage drops below X%, stop and escalate"), escalation triggers, "good enough" definitions.
**Gap:** No principles doc, or it says "use good judgment" instead of encoding concrete decision frameworks.

### I-7. File Placement Determinism (Functional → Standardized)

**Check:** Can you predict where a new component/module/test would go based on existing patterns? Is there a naming convention doc?

**In place:** Deterministic patterns. An agent can infer file placement from conventions.
**Gap:** Inconsistent placement. Same type of file found in multiple locations with no pattern.

---

## Feedback Surface

### F-1. Pre-commit Hooks (Functional)

**Check for config:**
- Python: `.pre-commit-config.yaml`
- JS/TS: `.husky/`, `lint-staged` in package.json
- .NET: custom scripts or `dotnet format` in git hooks
- Rust: `.cargo/husky/`, `rusty-hook`
- Go: `pre-commit-config.yaml` or custom hooks

**In place:** Hooks run on every commit: formatting, linting, type checking, and ideally fast tests.
**Gap:** No hooks, or hooks only run formatting.

### F-2. Linters and Formatters (Functional)

**Check for config and rule breadth:**
- Python: `ruff.toml` / `pyproject.toml` [tool.ruff], `mypy.ini` / pyproject.toml [tool.mypy]
- JS/TS: `eslint.config.*`, `.prettierrc*`, `tsconfig.json` (strict flags)
- .NET: `.editorconfig`, `Directory.Build.props` (AnalysisLevel, TreatWarningsAsErrors, EnforceCodeStyleInBuild)
- Rust: `clippy.toml`, `rustfmt.toml`
- Go: `golangci-lint` config

**In place:** Linter with broad rule selection. Strict type checking enabled. Runs locally in seconds.
**Gap:** Default/minimal rules. Type checking disabled or not strict. Linter only runs in CI.

### F-3. Test Infrastructure (Functional → Standardized)

**Check:** Test framework config, test directories, markers/categories, test count, test-to-code ratio.

- Python: `pytest` config in pyproject.toml, markers (unit/integration/e2e/slow)
- JS/TS: `vitest.config.*`, `jest.config.*`
- .NET: xUnit/NUnit test projects, `WebApplicationFactory` usage
- Rust: `#[cfg(test)]` modules, integration tests in `tests/`
- Go: `*_test.go` files

**In place:** Multiple test categories. Good test-to-code ratio (>0.5:1). Tests run locally in seconds/minutes. Integration tests use realistic but fast setups (in-memory DB, test runners).
**Gap:** Few or no tests. No category separation. Tests only run in CI. Slow test suite.

### F-4. CI/CD Pipeline (Functional → Standardized)

**Check:** `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, etc.

**Key questions:**
- Triggers: push/PR (good) vs. manual only (gap)
- What runs: lint + type check + test + build (good) vs. just build (gap)
- Coverage: reported? gated? (`--cov-fail-under`, Codecov with `fail_ci_if_error: true`)
- Fail behavior: strict or advisory?

**In place:** CI runs on push/PR. Lint + type check + test + coverage. Failures block merge.
**Gap:** CI is manual-trigger only, or missing, or runs but doesn't gate on failures.

### F-5. Observability (Standardized → Autonomous)

**Check:** Logging config (structured?), metrics (Prometheus, OpenTelemetry), tracing, dashboards.

**In place:** Structured logging. Metrics and traces emitted. Agents could query via LogQL/PromQL/TraceQL or similar. Observability infra in compose/k8s config.
**Gap:** No structured logging. Rich output is human-facing only (e.g., Rich/chalk pretty printing with no machine-parseable alternative). No metrics or tracing.

### F-6. Per-Worktree Bootability (Standardized)

**Check:** Can the app be booted in isolation? Fixed ports? Docker compose with parameterized ports?

**In place:** Documented boot process. Port parameterization or dynamic allocation. Multiple instances can run simultaneously.
**Gap:** Fixed ports. No isolation docs. Only one instance can run at a time.

### F-7. E2E / Behavioral Tests (Standardized → Autonomous)

**Check:** Playwright, Cypress, Selenium configs. API-level test suites. Behavioral test runners.

**In place:** E2E tests exist and run in CI. Cover critical user flows.
**Gap:** No e2e tests. Only unit/integration coverage.

### F-8. External Scenario Validation (Autonomous)

**Check:** Holdout test sets stored outside the repo. Digital twin simulations. Agent-to-agent review setup.

**In place:** External scenarios agents can't overfit to. Simulations of external services.
**Gap:** All tests are in-repo (standard for most projects — this is an Autonomous-level indicator).

---

## Constraint Surface

### C-1. Architectural Boundary Enforcement (Standardized)

**Check for configured tools:**
- Python: `import-linter`, `importlib-guard`
- JS/TS: `@nx/enforce-module-boundaries`, custom ESLint import rules
- .NET: `NetArchTest`, `ArchUnitNET`, `BannedApiAnalyzers`, custom Roslyn analyzers
- Rust: `cargo-deny`, workspace dependency rules
- Go: `depguard`, custom linter rules
- Monorepo: Nx/Turborepo project boundaries, workspace-level constraints

**In place:** Tool configured and enforced in CI/pre-commit. Architecture doc's dependency rules have mechanical backing.
**Gap:** Architecture describes layers/boundaries, but nothing prevents violations. Advisory only.

### C-2. SAST (Standardized)

**Check:** CodeQL, Bandit, Semgrep, Sonar, Snyk — in CI config or pre-commit.

**In place:** SAST runs in CI. Covers the project's relevant attack surfaces (SQL injection, XSS, command injection, etc.).
**Gap:** Only `detect-secrets` or nothing. No injection/vulnerability scanning.

### C-3. Dependency Update Automation (Functional → Standardized)

**Check:** `.github/dependabot.yml`, `renovate.json`, or equivalent. Active or manual-trigger?

**In place:** Automated PR creation for dependency updates. Active and running.
**Gap:** Manual dependency updates only, or automation exists but is disabled/manual-trigger.

### C-4. Advisory-to-Executable Ratio (Standardized)

**Check:** Compare guidelines in AGENTS.md / .cursor/rules / docs/conventions against what's mechanically enforced.

**In place:** Most documented conventions have a backing lint rule, test, or hook. Agents get failures, not suggestions.
**Gap:** Conventions are documented but not enforced. Agents can (and will) ignore them without triggering a failure.

### C-5. Drift Cycle Maturity (Standardized → Autonomous)

**Check:** Evidence of the observe → codify → surface → remediate → prevent cycle.

Indicators:
- Custom lint rules created from observed anti-patterns
- Batch remediation PRs
- Rules on pre-commit hot path (not just CI)
- Background agents that scan for drift on a cadence
- Quality grades or health scores tracked over time

**In place (Standardized):** Some custom rules exist. Remediation happens but ad hoc.
**In place (Autonomous):** Full cycle operates continuously. Background agents, quality tracking.
**Gap:** No evidence of codifying observed issues into rules. Issues are fixed one-off in review.

---

## Monorepo Considerations

When assessing a monorepo:
- **Repo-wide criteria** (AGENTS.md, CI config, CODEOWNERS, branch protection): evaluate once
- **App-scoped criteria** (linter config, tests, type checking, architectural rules): evaluate per app/package
- Note fractional coverage where relevant ("3/4 apps have strict type checking")
- Check workspace tooling: Nx, Turborepo, uv workspaces, Cargo workspaces, .NET solution structure
