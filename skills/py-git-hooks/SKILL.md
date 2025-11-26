---
name: py-git-hooks
description: Set up git pre-commit hooks to run ruff, mypy, and basedpyright before commits. Use when configuring automated quality checks in git workflow.
status: stable
---

# Python Git Hooks Setup

Configure git pre-commit hooks using the pre-commit framework to enforce code quality before commits.

## Objectives

1. Install pre-commit framework with Python quality hooks
2. Migrate any existing manual hooks to pre-commit framework
3. Configure Claude Code PostToolUse hooks for faster feedback
4. Ensure hooks run incrementally on changed files only
5. Auto-fix issues where possible, block on critical errors

## Required Tools

**Add to `[dependency-groups]` dev**: `"pre-commit"`, `"ruff"`, `"mypy"`, `"basedpyright"`

- **pre-commit**: Hook management framework (required)
- **ruff**: Fast linter with auto-fix capability
- **mypy**: Standard Python type checker
- **basedpyright**: Enhanced type analysis

## Setup Workflow

### Step 1: Check for Existing Hooks

```bash
# Check if manual hooks exist
ls -la .git/hooks/pre-commit 2>/dev/null

# If exists and not a pre-commit managed hook, migrate it (see Migration section)
```

### Step 2: Create Pre-commit Configuration

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.8.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.13.0
    hooks:
      - id: mypy
        additional_dependencies: []  # Add type stubs as needed

  - repo: local
    hooks:
      - id: basedpyright
        name: basedpyright
        entry: basedpyright
        language: system
        types: [python]
        pass_filenames: true
```

### Step 3: Install Hooks

```bash
# Install pre-commit to project venv
uv pip install pre-commit

# Install git hooks
pre-commit install

# Verify installation
ls -la .git/hooks/pre-commit
```

### Step 4: Test Hooks

```bash
# Run on all files (initial validation)
pre-commit run --all-files

# Or test on staged files only
git add some_file.py
pre-commit run
```

### Step 5: Configure Claude Code Hooks (Recommended)

**Strongly recommended**: Configure Claude Code PostToolUse hooks to run quality checks after every Edit, providing immediate feedback during development.

Check if hooks are configured:
```bash
cat ~/.claude/settings.json | grep -A 20 '"hooks"'
```

If not configured, add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "cd \"$PROJECT_DIR\" && source .venv/bin/activate 2>/dev/null && ruff check --fix \"$FILE_PATH\" && ruff format \"$FILE_PATH\""
          }
        ]
      }
    ]
  }
}
```

**Benefits of Claude Code hooks**:
- Immediate feedback on every edit (faster than waiting for commit)
- Auto-fix applied in real-time
- Reduces commit-time failures
- Catches issues before they accumulate

## Migration from Manual Hooks

If the project has an existing manual `.git/hooks/pre-commit` script:

### Step 1: Backup Existing Hook

```bash
cp .git/hooks/pre-commit .git/hooks/pre-commit.backup
```

### Step 2: Analyze Existing Hook

Read the existing hook to understand what checks it runs:
- Linting (ruff, flake8, pylint)?
- Type checking (mypy, pyright)?
- Formatting (black, isort)?
- Custom checks?

### Step 3: Map to Pre-commit Config

For each check in the manual hook, add equivalent to `.pre-commit-config.yaml`:

| Manual Hook Check | Pre-commit Equivalent |
|-------------------|----------------------|
| `ruff check` | `ruff-pre-commit` repo |
| `black` | `ruff-format` (ruff replaces black) |
| `isort` | `ruff` with isort rules (I) |
| `flake8` | `ruff` (replaces flake8) |
| `mypy` | `mirrors-mypy` repo |
| `basedpyright` | local hook |
| Custom script | local hook with `entry: ./script.sh` |

### Step 4: Install Pre-commit and Remove Manual Hook

```bash
pre-commit install  # This overwrites .git/hooks/pre-commit
pre-commit run --all-files  # Verify all checks pass
```

### Step 5: Verify and Clean Up

```bash
# Test that hooks work
git add .
git commit -m "test" --dry-run

# If successful, remove backup
rm .git/hooks/pre-commit.backup
```

## Hook Behavior

**Auto-fixable issues (ruff)**:
- Import sorting
- Trailing whitespace
- Simple style violations
- Many code quality issues

**Blocking issues**:
- Type errors (mypy/basedpyright)
- Syntax errors
- Complex linting violations that can't be auto-fixed

**Bypass (use sparingly)**:
```bash
git commit --no-verify
```

## Performance Optimization

**For large codebases**:
- Pre-commit runs on staged files only by default
- Use mypy incremental mode (cache in `.mypy_cache`)
- Consider running mypy/basedpyright in CI only for speed

**For monorepos**:
- Use `files:` pattern in hook config to limit scope
- Configure separate hooks per package

```yaml
- id: mypy
  files: ^src/mypackage/
```

## Troubleshooting

**Hook not running**:
```bash
pre-commit install --force  # Reinstall hooks
```

**Tools not found**:
```bash
# Ensure tools installed in venv
uv pip install ruff mypy basedpyright
```

**Hook too slow**:
- Profile: `pre-commit run --verbose`
- Consider removing mypy/basedpyright from pre-commit, run in CI instead
- Use `stages: [manual]` for slow hooks, run explicitly

**Update hook versions**:
```bash
pre-commit autoupdate
```

## Verification Checklist

- [ ] `.pre-commit-config.yaml` exists with ruff, mypy, basedpyright hooks
- [ ] `pre-commit install` has been run
- [ ] `pre-commit run --all-files` passes
- [ ] Any existing manual hooks have been migrated
- [ ] Claude Code PostToolUse hooks configured (recommended)
- [ ] Bypass with `--no-verify` works for emergencies

## Examples

**Example: New project setup**
```
1. Create venv: uv venv && source .venv/bin/activate
2. Install tools: uv pip install pre-commit ruff mypy basedpyright
3. Create .pre-commit-config.yaml with ruff, mypy, basedpyright
4. Install hooks: pre-commit install
5. Test: pre-commit run --all-files
6. Configure Claude Code PostToolUse hooks for real-time feedback
```

**Example: Migrate existing manual hook**
```
1. Backup: cp .git/hooks/pre-commit .git/hooks/pre-commit.backup
2. Read backup to identify checks (ruff, mypy, custom scripts)
3. Create .pre-commit-config.yaml mapping each check
4. Install: pre-commit install (overwrites manual hook)
5. Verify: pre-commit run --all-files
6. Clean up: rm .git/hooks/pre-commit.backup
```

**Example: Add to existing pre-commit config**
```
1. Edit .pre-commit-config.yaml
2. Add basedpyright local hook
3. Run: pre-commit run --all-files
4. Commit updated config
```

## Related Skills

- **Prerequisites**: py-quality-setup (tools must be configured before adding hooks)
- **Complements**: py-security (add bandit to pre-commit for security scanning)
- **See also**: All skills benefit from automated enforcement via hooks
