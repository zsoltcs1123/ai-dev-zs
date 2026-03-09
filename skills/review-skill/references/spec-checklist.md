# Agent Skills Specification Checklist

Source: [agentskills.io/specification](https://agentskills.io/specification)

## Frontmatter

- [ ] YAML frontmatter present (delimited by `---`)
- [ ] `name` field present and non-empty
- [ ] `description` field present and non-empty
- [ ] No unrecognized frontmatter fields (recognized: `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`)

## Name Rules

- [ ] 1-64 characters
- [ ] Lowercase alphanumeric and hyphens only (`a-z`, `0-9`, `-`)
- [ ] No uppercase letters
- [ ] No consecutive hyphens (`--`)
- [ ] Does not start or end with a hyphen
- [ ] Matches the parent directory name

## Description Rules

- [ ] 1-1024 characters
- [ ] Describes WHAT the skill does (capabilities)
- [ ] Describes WHEN to use it (trigger scenarios / keywords)
- [ ] Written in third person (not "I can..." or "You can...")
- [ ] Includes specific trigger terms agents can match on

## Body

- [ ] SKILL.md body is under 500 lines
- [ ] Body under ~5000 tokens (recommended)
- [ ] No "When to Use" sections in the body (belongs in the description)
- [ ] Instructions use imperative/infinitive form

## Directory Structure

- [ ] Skill directory contains a `SKILL.md` file
- [ ] No extraneous files (README.md, CHANGELOG.md, INSTALLATION_GUIDE.md, etc.)
- [ ] Optional subdirectories limited to: `scripts/`, `references/`, `assets/`

## File References

- [ ] All file references use relative paths from skill root
- [ ] References are one level deep from SKILL.md (no nested chains)
- [ ] Referenced files actually exist
- [ ] Forward-slash paths (not backslash)

## Progressive Disclosure

- [ ] Metadata (name + description) is concise (~100 tokens)
- [ ] Detailed/domain-specific content lives in reference files, not SKILL.md body
- [ ] Reference files are loaded on demand, not assumed to be in context
- [ ] Longer reference files (>100 lines) include a table of contents

## Scripts (if present)

- [ ] Handle edge cases gracefully
- [ ] Include helpful error messages
- [ ] Are self-contained or clearly document dependencies
- [ ] SKILL.md states whether agent should execute or read each script
