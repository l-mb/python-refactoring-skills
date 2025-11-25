# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Claude Code skills collection for Python refactoring. Eight modular skills that analyze and improve Python code quality: security, complexity, testing, code health, modernization, quality setup, and git hooks.

## Project Structure

- `skills/py-*/SKILL.md` - Individual skill definitions (YAML frontmatter + markdown instructions)
- `scripts/install-symlinks.sh` - Installs skills to `~/.claude/skills/` via symlinks
- `docs/` - User-facing documentation
- Skills tagged `stable` or `wip` in frontmatter; default install includes only stable

## Development Commands

```bash
# Validate skill structure (CI check)
./.github/workflows/validate-skills.yml  # Runs automatically on push/PR

# Install skills locally
./scripts/install-symlinks.sh           # Stable only
./scripts/install-symlinks.sh --install-wip  # All skills

# Verify installation
ls -la ~/.claude/skills/
```

## Skill File Format

Each skill directory must contain `SKILL.md` with:
```yaml
---
name: skill-name
description: One-line description
status: stable  # or wip
---
```
Followed by markdown instructions for Claude Code.

## Validation Requirements (CI)

- Every `skills/*/` directory must have `SKILL.md`
- Frontmatter must include `name:`, `description:`, `status:` fields
- Status must be `stable` or `wip`
- All `scripts/*.sh` must be executable

## Shell Scripts

Scripts must pass shellcheck. Format with shfmt.
