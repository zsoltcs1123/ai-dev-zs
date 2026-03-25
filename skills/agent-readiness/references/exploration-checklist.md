# Exploration Checklist

Systematic checklist of what to look for when assessing a repository. Organized by surface. For each indicator: what to check, common file paths/tools per ecosystem, and what "in place" vs. "gap" looks like.

Each indicator has **sub-checks** — binary pass/fail items that feed the scorecard. Record each sub-check as pass, fail, or skip (with reason). The sub-checks are evidence; the indicator-level assessment is interpretation.

Use subagents or parallel tool calls to explore efficiently. Read configs, count files, check directory structures — don't rely on assumptions.

## Contents

- [Information Surface](#information-surface) — I-1 through I-6
- [Feedback Surface](#feedback-surface) — F-1 through F-9
- [Constraint Surface](#constraint-surface) — C-1 through C-5
- [Skip Logic](#skip-logic)
- [Scorecard Pillar Mapping](#scorecard-pillar-mapping)
- [Monorepo Considerations](#monorepo-considerations)

---

## Information Surface

### I-1. Agent Entrypoint (Functional)

**Check:** AGENTS.md, CLAUDE.md, .github/copilot-instructions.md, or equivalent at repo root.

**In place:** Short entrypoint (<150 lines) with links to structured docs. Table of contents, not encyclopedia.
**Gap:** No entrypoint, or a monolithic instruction file that tries to contain everything.

**Sub-checks:**

- `agents_md` — AGENTS.md, CLAUDE.md, or equivalent exists at repo root
- `agents_md_validation` — CI job validates that documented commands still work. Skip if `agents_md` fails.

### I-2. Documentation Hierarchy (Functional)

**Check:** docs/ or similar directory. Look at depth, coverage, and structure. Also check for coding conventions in any form — docs/, AGENTS.md, cursor rules, CONTRIBUTING.md, wiki.

**In place:** Structured hierarchy (e.g., docs/project/, docs/conventions/, docs/decisions/, docs/knowledge-base/). Progressive disclosure from entrypoint. Agent skills directories (.factory/skills/, .claude/skills/) are a bonus signal of advanced agent optimization.
**Gap:** Flat docs/ with a few stale files, or docs scattered across the repo with no index. No documented conventions.

**Sub-checks:**

- `readme` — README.md exists with setup/usage instructions
- `documentation_freshness` — README or CONTRIBUTING updated within last 180 days (check git log)
- `conventions_documented` — Coding standards, naming rules, or style guides exist in any form (docs/, AGENTS.md, .cursor/rules/, CONTRIBUTING.md, etc.)
- `service_flow_documented` — Architecture diagrams present (.puml, .mermaid, docs/architecture\*)
- `automated_doc_generation` — Docs auto-generated via workflow or tool (build-docs, Swagger, Sphinx, TypeDoc)
- `api_schema_docs` — OpenAPI/Swagger specs or equivalent. Skip for non-API projects.

### I-3. Decision Records (Standardized)

**Check:** docs/decisions/, docs/adr/, or decisions embedded in architecture docs.

**In place:** Formal ADR directory with individually trackable records. Or: architecture doc with versioned, structured decision sections.
**Gap:** Decisions live in PR descriptions, Slack, or someone's head. Or: embedded in prose with no way to link to a specific decision.

### I-4. Context / Intent Documents (Standardized → Autonomous)

**Check:** PRINCIPLES.md, conventions docs, tradeoff hierarchies, escalation policies.

**In place:** Concrete tradeoff hierarchies ("if test coverage drops below X%, stop and escalate"), escalation triggers, "good enough" definitions.
**Gap:** No principles doc, or it says "use good judgment" instead of encoding concrete decision frameworks.

### I-5. Codebase Searchability (Functional → Standardized)

**Check:** Can an agent treat the repo as a queryable database? Deterministic file placement, named exports, absolute imports, consistent naming. This is the single highest-leverage category for agent effectiveness — it enables safe refactors, precise search, and better LLM retrieval.

**In place:** Deterministic file placement patterns. Named/explicit exports (no barrel files or re-export chains). Absolute imports (no deep relative paths). Consistent naming conventions. An agent can predict where any component, test, or module lives.
**Gap:** Inconsistent placement. Default exports or barrel files obscuring origins. Relative import spaghetti. Same type of file found in multiple locations with no pattern.

### I-6. Product Analytics (Standardized → Autonomous)

**Check:** Instrumentation that connects code changes to user impact.

**In place:** Error-to-issue automation, product analytics tracking user behavior. Agents can understand the impact of changes.
**Gap:** No telemetry. Code changes are disconnected from user outcomes.

**Sub-checks:**

- `error_to_insight_pipeline` — Error-to-issue automation (Sentry-GitHub integration, auto-created issues from errors)
- `product_analytics_instrumentation` — User behavior analytics (Mixpanel, Amplitude, PostHog, Heap, GA4)

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

**Sub-checks:**

- `pre_commit_hooks` — Pre-commit or Husky config exists and runs on commit

### F-2. Linters and Formatters (Functional)

**Check for config and rule breadth:**

- Python: `ruff.toml` / `pyproject.toml` [tool.ruff], `mypy.ini` / pyproject.toml [tool.mypy]
- JS/TS: `eslint.config.*`, `.prettierrc*`, `tsconfig.json` (strict flags)
- .NET: `.editorconfig`, `Directory.Build.props` (AnalysisLevel, TreatWarningsAsErrors, EnforceCodeStyleInBuild)
- Rust: `clippy.toml`, `rustfmt.toml`
- Go: `golangci-lint` config

**In place:** Linter with broad rule selection. Strict type checking enabled. Runs locally in seconds.
**Gap:** Default/minimal rules. Type checking disabled or not strict. Linter only runs in CI.

**Sub-checks:**

- `lint_config` — Linter configured (ESLint, Ruff, golint, Clippy, etc.)
- `formatter` — Code formatter configured (Prettier, Black, Ruff format, rustfmt, crlfmt)
- `type_check` — Static type checking configured (TypeScript, mypy, Go)
- `strict_typing` — Strict mode enabled (TS `strict: true`, mypy `strict = true`). Skip for untyped languages.
- `naming_consistency` — Naming convention rules enforced via linter (ESLint `naming-convention`, Ruff equivalents)
- `cyclomatic_complexity` — Complexity analysis configured (ESLint complexity rule, lizard, radon, gocyclo)
- `dead_code_detection` — Dead code detection tool (knip, vulture, ts-prune, unimported)
- `duplicate_code_detection` — Duplicate code detection (jscpd, PMD CPD, SonarQube)
- `large_file_detection` — File size checks (pre-commit `check-added-large-files`, LFS config, CI checks)
- `tech_debt_tracking` — TODO/FIXME scanner or tech debt tooling (SonarQube, linter rule enforcing `TODO(TICKET-123)`)

### F-3. Test Infrastructure (Functional → Standardized)

**Check:** Test framework config, test directories, markers/categories, test count, test-to-code ratio.

- Python: `pytest` config in pyproject.toml, markers (unit/integration/e2e/slow)
- JS/TS: `vitest.config.*`, `jest.config.*`
- .NET: xUnit/NUnit test projects, `WebApplicationFactory` usage
- Rust: `#[cfg(test)]` modules, integration tests in `tests/`
- Go: `*_test.go` files

**In place:** Multiple test categories. Good test-to-code ratio (>0.5:1). Tests run locally in seconds/minutes. Integration tests use realistic but fast setups (in-memory DB, test runners).
**Gap:** Few or no tests. No category separation. Tests only run in CI. Slow test suite.

**Sub-checks:**

- `unit_tests_exist` — Unit test files present in test directories
- `unit_tests_runnable` — Test command configured (npm test, pytest, go test) and tests pass collection
- `integration_tests_exist` — Integration/E2E tests present (test/acceptance/, Cypress, Playwright)
- `test_coverage_thresholds` — Coverage enforcement configured (--fail-under, Coveralls, Codecov gating)
- `test_naming_conventions` — Consistent test naming (pytest ini_options, Jest testMatch, Go \*\_test.go)
- `test_isolation` — Parallel/isolated execution supported (--parallel, matrix strategy, no forced serial)
- `test_performance_tracking` — Test timing output or analytics (--durations flags, benchmark CI workflows)
- `flaky_test_detection` — Flaky test handling (retry config, BuildPulse, quarantine workflows, --stress)

### F-4. CI/CD Pipeline (Functional → Standardized)

**Check:** `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, etc.

**Key questions:**

- Triggers: push/PR (good) vs. manual only (gap)
- What runs: lint + type check + test + build (good) vs. just build (gap)
- Coverage: reported? gated? (`--cov-fail-under`, Codecov with `fail_ci_if_error: true`)
- Fail behavior: strict or advisory?

**In place:** CI runs on push/PR. Lint + type check + test + coverage. Failures block merge.
**Gap:** CI is manual-trigger only, or missing, or runs but doesn't gate on failures.

**Sub-checks:**

- `fast_ci_feedback` — CI completes in reasonable time (<10 minutes for core checks)
- `build_performance_tracking` — Build caching or metrics (Turbo, Nx, Bazel caching, CI timing analytics)

### F-5. Observability (Standardized → Autonomous)

**Check:** Logging config (structured?), metrics (Prometheus, OpenTelemetry), tracing, dashboards. At Standardized+, observability should be per-worktree — ephemeral, isolated stacks agents can query independently (e.g., Vector → Victoria Logs/Metrics/Traces per worktree), not shared infrastructure that couples concurrent agent runs.

**In place:** Structured logging. Metrics and traces emitted. Agents could query via LogQL/PromQL/TraceQL or similar. Observability infra in compose/k8s config.
**Gap:** No structured logging. Rich output is human-facing only (e.g., Rich/chalk pretty printing with no machine-parseable alternative). No metrics or tracing. Or: shared observability that can't isolate per-agent output.

**Sub-checks:**

- `structured_logging` — Structured logging configured (debug, Python logging, pino, serilog, custom log package)
- `code_quality_metrics` — Coverage/quality tracking (Coveralls, CodeQL analysis, coverage workflows)
- `distributed_tracing` — Trace/request ID propagation (OpenTelemetry, X-Request-ID). Skip for libraries.
- `error_tracking_contextualized` — Error tracking service (Sentry, Bugsnag, Rollbar). Skip for libraries.
- `metrics_collection` — Metrics instrumentation (Prometheus, Datadog, New Relic). Skip for libraries.
- `alerting_configured` — Alerting rules defined (PagerDuty, OpsGenie, Prometheus alertmanager). Skip for libraries.
- `deployment_observability` — Deploy monitoring/dashboards (Grafana, deploy notifications). Skip for libraries.
- `health_checks` — Health/readiness endpoints (/health, /ready). Skip for libraries.
- `profiling_instrumentation` — CPU/memory profiling tools configured. Skip for libraries.
- `runbooks_documented` — Runbook/playbook references in docs. Skip for libraries.
- `circuit_breakers` — Circuit breaker pattern (opossum, resilience4j). Skip for projects without external service deps.

### F-6. Per-Worktree Bootability (Standardized)

**Check:** Can the app be booted in isolation? Fixed ports? Docker compose with parameterized ports?

**In place:** Documented boot process. Port parameterization or dynamic allocation. Multiple instances can run simultaneously.
**Gap:** Fixed ports. No isolation docs. Only one instance can run at a time.

**Sub-checks:**

- `devcontainer` — `.devcontainer/devcontainer.json` exists for reproducible dev environments
- `env_template` — `.env.example` or environment variables documented in README/AGENTS.md
- `database_schema` — DB schema management (migrations directory, schema files). Skip if no database.
- `local_services_setup` — Local dependency orchestration (docker-compose.yml for services). Skip if no external deps.

### F-7. E2E / Behavioral Tests (Standardized → Autonomous)

**Check:** Playwright, Cypress, Selenium configs. API-level test suites. Behavioral test runners.

**In place:** E2E tests exist and run in CI. Cover critical user flows.
**Gap:** No e2e tests. Only unit/integration coverage.

### F-8. External Scenario Validation (Autonomous)

**Check:** Holdout test sets stored outside the repo. Digital twin simulations. Agent-to-agent review setup.

**In place:** External scenarios agents can't overfit to. Simulations of external services.
**Gap:** All tests are in-repo (standard for most projects — this is an Autonomous-level indicator).

### F-9. Build & Release System (Functional → Standardized)

**Check:** Build tooling, dependency management, release pipeline, and developer onboarding friction.

**In place:** One-command setup, pinned dependencies, automated releases with notes. Agents can build, verify, and ship without tribal knowledge.
**Gap:** Multi-step setup with undocumented steps, unpinned dependencies, manual releases.

**Sub-checks:**

- `single_command_setup` — Repo can be set up with one command (documented in README or AGENTS.md)
- `build_cmd_doc` — Build command documented (README, AGENTS.md, or Makefile with help target)
- `deps_pinned` — Lockfile committed (package-lock.json, uv.lock, go.sum, Cargo.lock)
- `vcs_cli_tools` — GitHub CLI (or equivalent) available and authenticated
- `deployment_frequency` — Regular releases (check gh release list or equivalent)
- `release_automation` — Automated release pipeline (semantic-release, publish workflows, GitOps)
- `release_notes_automation` — Automated changelog/release notes (standard-version, changesets, latest-changes)
- `feature_flag_infrastructure` — Feature flag system (LaunchDarkly, Statsig, Unleash, custom cluster settings)
- `agentic_development` — Evidence of agent co-authorship (Co-authored-by in commits, agent workflow dirs)
- `automated_pr_review` — Automated PR review bots (danger.js, bot-generated review comments)

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

**Sub-checks:**

- `code_modularization` — Module boundary enforcement tool configured. Skip for small libraries.

### C-2. Security & Governance (Standardized)

**Check:** CodeQL, Bandit, Semgrep, Sonar, Snyk — in CI config or pre-commit. Also secrets management, access control, and data protection.

**In place:** SAST runs in CI. Secrets managed securely. Branch protection and code ownership defined.
**Gap:** Only `detect-secrets` or nothing. No injection/vulnerability scanning. No access control configuration.

**Sub-checks:**

- `automated_security_review` — SAST configured (CodeQL, Bandit, Semgrep, Sonar, Snyk in CI)
- `gitignore_comprehensive` — Gitignore covers .env, .DS_Store, .idea, .vscode, and other sensitive/IDE files
- `codeowners` — CODEOWNERS file exists (.github/CODEOWNERS or root) with team assignments
- `branch_protection` — Branch protection rules active (GitHub rulesets, protected branches). May require admin API.
- `secrets_management` — Secrets handled securely (cloud SDK integrations, no hardcoded secrets, gitignored env files)
- `unused_dependencies_detection` — Unused dep detection (depcheck, deptry, knip)
- `dependency_update_automation` — Automated dep update PRs (Dependabot, Renovate) active. Also covered by C-3.
- `log_scrubbing` — Log sanitization/redaction (pino redact, structlog processors, custom redaction). Skip for libraries without logging.
- `pii_handling` — PII protection (safe/unsafe data marking, redaction interfaces). Skip for libraries without user data.
- `dast_scanning` — Dynamic security testing. Skip for non-web projects.

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

## Skip Logic

Not all sub-checks apply to every project. Mark inapplicable checks as **skip** with a reason.

**Libraries vs. services:** Libraries without runtime deployment can skip: `distributed_tracing`, `error_tracking_contextualized`, `metrics_collection`, `alerting_configured`, `deployment_observability`, `health_checks`, `profiling_instrumentation`, `circuit_breakers`, `runbooks_documented`, `dast_scanning`, `deployment_frequency`, `feature_flag_infrastructure`.

**No database/ORM:** Skip `database_schema`, `n_plus_one_detection`.

**No user data:** Skip `pii_handling`, `product_analytics_instrumentation`.

**Untyped languages (JS without TS):** Skip `strict_typing`, `type_check`.

**Single-app repos:** Skip `code_modularization` for small projects, `monorepo_tooling`, `version_drift_detection`.

**Prerequisite failures:** Skip `agents_md_validation` if `agents_md` fails. Skip `dead_feature_flag_detection` if `feature_flag_infrastructure` fails.

---

## Scorecard Pillar Mapping

Maps sub-checks to scorecard pillars for computing pillar scores (pass count / applicable count).

- **Style & Validation**: `pre_commit_hooks`, `lint_config`, `formatter`, `type_check`, `strict_typing`, `naming_consistency`, `cyclomatic_complexity`, `dead_code_detection`, `duplicate_code_detection`, `large_file_detection`, `tech_debt_tracking`
- **Build & Release**: `fast_ci_feedback`, `build_performance_tracking`, `single_command_setup`, `build_cmd_doc`, `deps_pinned`, `vcs_cli_tools`, `deployment_frequency`, `release_automation`, `release_notes_automation`, `feature_flag_infrastructure`, `agentic_development`, `automated_pr_review`
- **Testing**: `unit_tests_exist`, `unit_tests_runnable`, `integration_tests_exist`, `test_coverage_thresholds`, `test_naming_conventions`, `test_isolation`, `test_performance_tracking`, `flaky_test_detection`
- **Documentation**: `agents_md`, `agents_md_validation`, `readme`, `documentation_freshness`, `conventions_documented`, `service_flow_documented`, `automated_doc_generation`, `api_schema_docs`
- **Dev Environment**: `devcontainer`, `env_template`, `database_schema`, `local_services_setup`
- **Observability**: `structured_logging`, `code_quality_metrics`, `distributed_tracing`, `error_tracking_contextualized`, `metrics_collection`, `alerting_configured`, `deployment_observability`, `health_checks`, `profiling_instrumentation`, `runbooks_documented`, `circuit_breakers`
- **Security & Governance**: `automated_security_review`, `gitignore_comprehensive`, `codeowners`, `branch_protection`, `secrets_management`, `unused_dependencies_detection`, `dependency_update_automation`, `log_scrubbing`, `pii_handling`, `dast_scanning`
- **Product & Analytics**: `error_to_insight_pipeline`, `product_analytics_instrumentation`

---

## Monorepo Considerations

When assessing a monorepo:

- **Repo-wide criteria** (AGENTS.md, CI config, CODEOWNERS, branch protection): evaluate once
- **App-scoped criteria** (linter config, tests, type checking, architectural rules): evaluate per app/package
- Note fractional coverage where relevant ("3/4 apps have strict type checking")
- Check workspace tooling: Nx, Turborepo, uv workspaces, Cargo workspaces, .NET solution structure
