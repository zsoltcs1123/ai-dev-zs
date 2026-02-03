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
