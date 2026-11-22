# Compendium roadmap

Living plan for the Compendium bundle in ai-dev-zs. Background: [project-planner …/compendium/SEED.md](https://github.com/zsoltcs1123/project-planner/blob/main/content/projects/compendium/SEED.md). Seed is guidance only; **locked decisions below override seed** where they differ.

Compendium is intentionally thin: install facet skills, create a compendium directory at a path the user chooses, let facet skills work there. Taxonomy, scopes, and repo hygiene belong to higher layers or the host project, not this bundle.

## Maintenance

When a **phase is complete** (verified, not just checked off in chat), **delete that entire phase section** from this file. Do not leave empty headings. Update [AGENTS.md](./AGENTS.md) or the seed in project-planner only if something needs to stay canonical elsewhere.

---

## Locked decisions (keep until re-lit)

| Topic | Choice |
| ----- | ------ |
| Unit | **Compendium** — a directory on disk where facet skills read and write; not a taxonomy or scope registry |
| Facets | **Library**, **Wiki**, **Academy**, **Works** |
| Bundle | Single **`compendium`** bundle; ships everything; no `compendium-wiki` variant |
| Bundle install | `./skills/install.sh --bundle compendium`; **not** `--global` |
| Bundle-only skills | Under `bundles/compendium/`; install only via `--bundle`, not `--skill` |
| Shared skills | `summarize`, `quick-summarize` stay in `skills/`; pulled via `bundle.yaml` `include` |
| Repo layout | `bundles/` beside `skills/`; bundle docs = `AGENTS.md` (not `README.md`) |
| Workspace skill | `compendium` — `init` first; `upgrade` / `migrate` stubs until needed |
| Facet API | Two levels only (`wiki init`, not `compendium wiki init`); facet skills are the API |
| **Init** | Create the compendium at the target path only (e.g. repo root or `compendium/`). Stub may be `.gitkeep` or empty tree; **no** `scopes.yaml`, **no** `loci/`, **no** host rules markdown, **no** git or hook setup |
| **Organizing knowledge** | **Out of scope** for the bundle — no scopes, loci, prelude registry, or `compendium scope` |
| **Which compendium?** | Facet skills resolve the active compendium root from workspace layout and **user context** (open files, stated path, chat intent). If several compendium roots exist, ask or infer; do not maintain a central index file in V0 |
| Default layout | Subdir `compendium/` when the repo is mixed; root-level compendium when the repo is knowledge-first — user picks at `init` |
| Invoke | No `disable-model-invocation` on bundle skills (harness may auto-pick facets) |
| Teaching | `academy teach`; no host skill named `teach` (external `teach` in index stays separate) |
| Tooling | **No** required `git`, `prek`, or pre-commit for `init` or daily use |
| Tests | `fixture-init.sh` → browsable hosts under `compendium-host/`; `run.sh` smoke on fixtures |

---

## Phase 1 — Thin foundation

**Goal:** Bundle installs; `compendium init` only drops a compendium directory; smoke matches.

- [x] Top-level `bundles/compendium/`, `install.sh --bundle`, bundle-only skill guardrails
- [ ] Rework `compendium init` and scaffold: target path + minimal stub (`.gitkeep`); remove `scopes.yaml`, `loci/`, prek/pre-commit from scaffold and references
- [ ] Skill references: compendium discovery (one vs many roots); drop scope-prelude / scope command from the workspace API
- [ ] `tests/smoke/fixture-init.sh` + `run.sh` assert thin layout only; strip POC scope/loci data from fixtures
- [x] Gitignore `compendium-host/`

**Exit:** `./fixture-init.sh` and `./run.sh` green; init needs no git or prek; host is just an empty compendium path.

---

## Phase 2 — POC vertical slice

**Goal:** Wiki and academy work end-to-end against a fixture compendium path (no scope registry).

- [ ] Port **wiki** from llm-wiki into `bundles/compendium/wiki/`; drop `facet-wiki.md` staging when done
- [ ] Port **academy** from learning into `bundles/compendium/academy/` (`academy teach`, not skill `teach`)
- [ ] `wiki init` → content under chosen paths inside the active compendium root
- [ ] `wiki query` (prelude/rules live in wiki skill, not host yaml)
- [ ] `academy teach` on one course tree under the fixture compendium
- [ ] `compendium migrate` stub (dry-run plan only)
- [ ] Smoke or fixture extended so facet paths are exercised

**Exit:** Agent picks `wiki` / `academy` by intent; query + teach succeed on a single compendium directory. Discovery picks that directory when it is the only root or user points at it.

---

## Phase 3 — MVP

**Goal:** Second compendium path or second project in smoke, remaining facets stubbed or minimal, upstream repos archived.

- [ ] **library** and **works** skills in bundle (stubs → minimal MVP)
- [ ] `compendium upgrade` (refresh bundle-owned references only; do not clobber user content under compendium roots)
- [ ] Smoke covers **multiple** compendium roots in one workspace; skills pick the right root from context
- [ ] `compendium migrate` from `ai-research-zs` wikis (or documented manual path)
- [ ] Archive **learning** and **llm-wiki** repos after cutover
- [ ] Bundle + smoke documented in [AGENTS.md](./AGENTS.md); seed in project-planner updated only if vocabulary changed

**Exit:** Compendium bundle is the skills source for facets; real use on at least two hosts or two roots without a scope file.

---

## Phase 4 — V1

**Goal:** Library compounding and stable daily use; optional discovery helpers.

- [ ] Library manifest / RAG direction; **library → wiki** via `wiki ingest`
- [ ] Optional: convention doc or light marker file for compendium root (only if discovery-by-context is not enough)
- [ ] Resolve open items: `.wiki-root.yaml` vs paths-only, `fact-check` placement, wiki submodule

**Out of V1:** Multi-user ACLs, SaaS, mandatory taxonomy layer, default submodule-per-topic.

**Exit:** Personal single-user compendium stable for daily use.

---

## Open questions (not blocking current phase)

| Question | Notes |
| -------- | ----- |
| `.wiki-root.yaml` | Per-wiki marker vs infer from compendium root + paths |
| Multiple roots | Heuristics order before asking the user |
| Summarize | Shared skills in `skills/` (decided); wiki ingest may reference them |
| Library MVP | Manifest vs ingest |
| Wiki submodule | `wiki init --submodule` |
| Archive upstream | README pointers, smoke after archive |
| fact-check | Own skill vs `academy` / `wiki` subcommand |