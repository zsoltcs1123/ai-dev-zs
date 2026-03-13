# System Limits

Observed scaling behavior of the `run-plan` pipeline. Degradation is per-stage, not a single threshold.

## Stage Bottlenecks

### Stage 1 — Feature Inventory (primary bottleneck)

Runs in a single context window reading VISION + ARCHITECTURE. Must hold the full system to identify non-overlapping features.

| Combined input size | Behavior |
| --- | --- |
| ~1,500 lines | Reliable |
| ~3,000–4,000 lines | Feature map gets sloppy — misses edge cases and cross-cutting concerns |
| ~6,000+ lines | Unreliable — anchors on prominent sections, underrepresents the rest |

### Stage 2 — Feature Specs

Each subagent is independent (VISION + ARCHITECTURE + FEATURES). Scales well unless combined docs exceed ~5,000 lines, at which point specs become generic. Mitigation: pass only the relevant workstream section.

### Stage 3 — Workstream Roadmaps

Each workstream is independent. Typical input ~500 lines. No scaling issues observed.

### Stage 4 — Project Roadmap (secondary bottleneck)

Reads VISION + all workstream roadmaps. With 10+ workstreams the cross-workstream scheduling (dependency analysis, parallel-opportunity detection) degrades.

## Project Size Guidelines

| Project size | Features | Workstreams | Expected quality |
| --- | --- | --- | --- |
| Small | 2–5 | 1 | Excellent — nearly final quality |
| Medium | 6–15 | 1–3 | Good — minor iteration needed |
| Large | 15–30 | 3–5 | Solid starting point — expect 1–2 review passes |
| Very large | 30–60 | 5–8 | Noisy — feature map and roadmap need heavy editing |
| Enterprise | 60+ | 8+ | Breaks down — Stage 1 can't produce a coherent feature map in one pass |

## Scaling Beyond "Large"

The fix is hierarchical decomposition, not a bigger context window:

1. Domain decomposition — split the project into 3–5 sub-projects
2. Independent pipeline runs — each sub-project gets its own VISION/ARCHITECTURE
3. Top-level aggregation — merge sub-project roadmaps into a program roadmap

This implies a `plan-program` or `plan-portfolio` orchestrator above `run-plan`. Not yet implemented — the current pipeline targets single projects up to ~30 features.
