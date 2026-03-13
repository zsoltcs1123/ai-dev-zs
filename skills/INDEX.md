# Skills Index

| Skill | Description | Source | Version |
| ----- | ----------- | ------ | ------- |
| [codebase-explorer](./codebase-explorer/SKILL.md) | Explores and documents codebases autonomously, producing EXPLORATION-REPORT.md with architecture, tech stack, and maintainability assessment | Original | 1.0 |
| [project-planner](./project-planner/SKILL.md) | Guides through creating project planning documents (VISION.md, ARCHITECTURE.md, ROADMAP.md, EVALUATION.md) | Original | 1.5 |
| [humanizer](./humanizer/SKILL.md) | Removes signs of AI-generated writing from text based on Wikipedia's "Signs of AI writing" guide | [blader/humanizer](https://github.com/blader/humanizer) | 2.1.1 |
| [pdf](./pdf/SKILL.md) | PDF manipulation toolkit for extracting text/tables, creating PDFs, merging/splitting documents, and handling forms | [anthropics/skills](https://github.com/anthropics/skills) | - |
| [pptx](./pptx/SKILL.md) | Presentation creation, editing, and analysis for .pptx files | [anthropics/skills](https://github.com/anthropics/skills) | - |
| [xlsx](./xlsx/SKILL.md) | Spreadsheet creation, editing, analysis, and formula recalculation for .xlsx files | [anthropics/skills](https://github.com/anthropics/skills) | - |
| [summarize](./summarize/SKILL.md) | Summarizes articles, blog posts, papers, or any text input into a structured, scannable format | Original | 1.0 |
| [quick-summarize](./quick-summarize/SKILL.md) | Distills any text input into a brief, high-signal summary without full structure | Original | 1.0 |
| [edit](./edit/SKILL.md) | Reviews and edits text for grammar, tone, structure, and factual accuracy with improvement suggestions | Original | 1.0 |
| [draft-to-article](./draft-to-article/SKILL.md) | Turns messy or incomplete drafts into structured, audience-appropriate articles while preserving the author's voice | Original | 1.0 |
| [review-skill](./review-skill/SKILL.md) | Reviews Agent Skills for spec conformance, agent usability, token efficiency, instruction structure, and scope cohesion | Original | 1.0 |

## Project Management

20 skills — idea-to-shipped-code pipeline. Ported from [anneal](https://github.com/AiDev-Zs/anneal). See [project-management/docs/README.md](./project-management/docs/README.md) for pipeline docs.

| Skill | Description | Layer |
| ----- | ----------- | ----- |
| [capture-idea](./project-management/idea/capture-idea/SKILL.md) | Captures an idea from freeform input or conversation as concise bullet points | Idea |
| [vibe-plan](./project-management/idea/vibe-plan/SKILL.md) | Refines an idea into a high-level vibe plan through guided conversational exploration | Idea |
| [plan-vision](./project-management/plan/plan-vision/SKILL.md) | Produces the vision document for a project through guided conversation | Plan |
| [plan-architecture](./project-management/plan/plan-architecture/SKILL.md) | Produces the architecture document for a project | Plan |
| [plan-features](./project-management/plan/plan-features/SKILL.md) | Decomposes VISION + ARCHITECTURE into workstreams and features | Plan |
| [plan-feature](./project-management/plan/plan-feature/SKILL.md) | Defines or updates a feature with goal, deliverables, and exit criteria | Plan |
| [plan-workstream-roadmap](./project-management/plan/plan-workstream-roadmap/SKILL.md) | Produces a workstream roadmap by grouping pre-defined features into milestones | Plan |
| [plan-roadmap](./project-management/plan/plan-roadmap/SKILL.md) | Produces a project roadmap that aggregates workstream roadmaps into project milestones | Plan |
| [run-plan](./project-management/plan/run-plan/SKILL.md) | Runs the full planning pipeline from VISION + ARCHITECTURE to project roadmap | Plan |
| [update-plan](./project-management/plan/update-plan/SKILL.md) | Updates planning and spec artifacts — identifies skill invocations and cascade chain for any mutation | Plan |
| [spec-tasks](./project-management/spec/spec-tasks/SKILL.md) | Specifies the task list for a feature or milestone by decomposing into logically ordered tasks | Spec |
| [spec-task](./project-management/spec/spec-task/SKILL.md) | Details a single task into implementation steps, requirements, test coverage, and verification scenarios | Spec |
| [spec-validations](./project-management/spec/spec-validations/SKILL.md) | Derives behavioral validation scenarios from a feature or milestone's goals and exit criteria | Spec |
| [run-spec](./project-management/spec/run-spec/SKILL.md) | Runs the full spec pipeline for one or more features — tasks, detailing, and validation suite | Spec |
| [implement](./project-management/exec/implement/SKILL.md) | Implements code from a task spec or plan | Exec |
| [implement-tdd](./project-management/exec/implement-tdd/SKILL.md) | Implements code using test-driven development (red-green-refactor) | Exec |
| [refactor](./project-management/exec/refactor/SKILL.md) | Analyzes a codebase to identify refactoring opportunities, classified by severity, effort, and impact | Exec |
| [review](./project-management/exec/review/SKILL.md) | Reviews code changes against project standards, task spec, and documentation requirements | Exec |
| [run-validations](./project-management/exec/run-validations/SKILL.md) | Runs validation scenarios against running software | Exec |
| [finalize](./project-management/exec/finalize/SKILL.md) | Commits changes | Exec |
