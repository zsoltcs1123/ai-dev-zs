# AI Dev Tools

Collection of reusable AI development tools: skills, subagents, prompts, and related artifacts.

## Structure

```
skills/          # Agent skills (reusable instruction sets)
scripts/         # Installation scripts
subagents/       # Specialized subagent definitions
prompts/         # Prompt templates
```

## Install

### Windows (PowerShell)

```powershell
# Single skill
.\scripts\install-cursor-skill.ps1 -SkillName project-planner

# All skills
.\scripts\install-cursor-skills.ps1
```

### Linux/macOS (Bash)

```bash
# Single skill
./scripts/install-cursor-skill.sh project-planner

# All skills
./scripts/install-cursor-skills.sh
```

## Skills

See [skills/INDEX.md](./skills/INDEX.md) for the full list.

Skills install flat into `~/.cursor/skills/{skill-name}` regardless of how they're organized in this repo. Nested groups (e.g. `skills/project-management/plan/plan-vision/`) install as `~/.cursor/skills/plan-vision/`.

## Evals

Skills can include structured evaluations to test whether they produce good outputs reliably. Evals live in an `evals/` directory inside the skill folder.

### Structure

```
{skill}/
  SKILL.md
  evals/
    evals.json              # test cases with prompts, expected outputs, assertions
    files/                  # synthetic input files per test case
      {case-name}/
        ...
```

### Running an eval

Each test case runs twice: once **with the skill** and once **without it** (baseline). This tells you what the skill actually adds.

1. **Copy input files** to a clean working directory so the run doesn't pollute the eval source files.

2. **With-skill run** — start a fresh agent session (or subagent) and provide:

   ```
   Read and follow the skill at {path-to-skill}/SKILL.md.
   {prompt from evals.json}
   Input files are in {working-dir}/.
   Write all outputs to {working-dir}/.
   ```

3. **Baseline run** — same prompt and input files, no skill reference.

4. **Grade** — for each assertion in the test case, check the outputs and record PASS/FAIL with evidence. Save results in a `grading.json` alongside the outputs.

5. **Compare** — the delta between with-skill and baseline pass rates tells you the skill's value.

### Workspace layout for results

```
{skill}-workspace/
  iteration-1/
    eval-{case-name}/
      with_skill/
        outputs/            # files produced by the run
        grading.json        # assertion results
      without_skill/
        outputs/
        grading.json
    benchmark.json          # aggregated pass rates and delta
```

### Iterating

After grading, use failed assertions, human feedback, and execution transcripts to improve the skill. Rerun in a new `iteration-N/` directory. Stop when pass rates plateau and human review finds no issues.

See [agentskills.io/skill-creation/evaluating-skills](https://agentskills.io/skill-creation/evaluating-skills) for the full eval methodology.

### Skills with evals

| Skill | Test cases | What's tested |
| ----- | ---------- | ------------- |
| [run-plan](./skills/project-management/plan/run-plan/SKILL.md) | 3 (multi-ws, single-ws, minimal) | Pipeline sequencing, fan-out completeness, file system correctness, single-workstream simplification |
| [run-spec](./skills/project-management/spec/run-spec/SKILL.md) | 3 (multi, single, missing) | Pipeline sequencing, per-feature delegation, missing-input handling |
