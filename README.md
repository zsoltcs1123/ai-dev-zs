# AI Dev Skills

Small curated set of agent skills plus a universal installer for `.agents/skills/`.

Works with Cursor 2.4+, Codex, Copilot, Gemini, Cline, and other harnesses that read `.agents/skills/` natively.

## Install

Recommended — [npx skills](https://github.com/vercel-labs/skills) (works with Cursor, Codex, Copilot, Gemini, Cline, and 70+ other agents):

```bash
npx skills add zsoltcs1123/ai-dev-zs -a cursor -y                    # all skills, project
npx skills add zsoltcs1123/ai-dev-zs --skill code-review -a cursor -y  # one skill
npx skills add zsoltcs1123/ai-dev-zs -g -a cursor -y                   # global (→ ~/.cursor/skills/)
npx skills add zsoltcs1123/ai-dev-zs --list                            # list available skills
npx skills update -y                                                   # refresh installed skills
```

Fallback — no Node required:

```bash
./skills/install.sh              # current project → .agents/skills/
./skills/install.sh /path/to/app # specific project
./skills/install.sh --global     # ~/.agents/skills/
./skills/install.sh --list       # list skills
```

Re-run either method to update installed copies.

## Skills

See [skills/index.md](./skills/index.md).
