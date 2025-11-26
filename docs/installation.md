# Installation Guide

Complete installation instructions for Python Refactoring Skills.

## Prerequisites

- **Claude Code** installed (see [docs.claude.com/claude-code](https://docs.claude.com/claude-code))
- **Python 3.13+** recommended (skills target Python 3.13, but should work with 3.10+)
- **Git** for cloning repository
- **uv** (optional, recommended for faster tool installation)

## Step 1: Install uv (Recommended)

**Recommended**: Install via your Linux distribution's package manager:

```bash
# openSUSE Tumbleweed
sudo zypper install uv

# Fedora/RHEL (check COPR repositories)
# Check: https://copr.fedorainfracloud.org/

# Debian/Ubuntu (via pip as user package)
pip install --user uv

# Verify installation
uv --version
```

If your distribution doesn't package `uv`, install as user package:

```bash
pip install --user uv
```

**Note**: While `uv` provides a curl installer, package manager installation is preferred for system-wide tools to ensure proper integration and updates.

## Step 2: Clone Repository

```bash
# Clone to your preferred location
git clone https://github.com/l-mb/python-refactoring-skills.git
cd python-refactoring-skills
```

## Step 3: Install Skills to Claude Code

You have two options:

### Option A: Symlink Installation (Recommended)

**Benefits**:
- Easy to update (git pull in repo)
- No duplication

```bash
# Install all skills
./scripts/install-symlinks.sh

# Verify symlinks created
ls -la ~/.claude/skills/
```

**Note**: All 8 skills are now `stable` (thoroughly reviewed and optimized).

### Option B: Copy Installation

**Benefits**:
- Standalone installation
- No dependency on repository location

```bash
# Copy skills
cp -r skills/* ~/.claude/skills/

# Verify files copied
ls ~/.claude/skills/
```

### Option C: Fork the repository

In case you want to have your own improvements, consider forking the repository
and following Option A with your own account.

This will make it easier to merge later changes and to selectively contribute
your best improvements back upstream!

## Step 4: Install Python Analysis Tools

**Recommended**: Install tools per-project into virtual environments.

Skills use various Python tools for code analysis. Each skill will automatically check for and install required tools into your project's virtual environment when needed.

### Recommended: Per-Project Installation (Default)

Add tools to your project's `pyproject.toml` dev dependencies (PEP 735):

```toml
[dependency-groups]
dev = [
    "ruff>=0.8.0",
    "mypy>=1.0",
    "basedpyright>=1.0",
    "pytest>=8.0",
    "pytest-cov>=4.0",
    "pre-commit>=3.0",
    # Add analysis tools as needed:
    "radon", "vulture", "pylint", "bandit", "lizard",
    "mutmut", "wily", "xenon", "pyupgrade", "coverage",
]
```

Then install with uv:

```bash
cd /path/to/your/project
uv sync                      # Creates venv and installs dev group automatically
source .venv/bin/activate    # Activate for manual tool use
```

**Alternative: Quick install** (doesn't persist to pyproject.toml):

```bash
uv venv && source .venv/bin/activate
uv pip install radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade ruff mypy basedpyright pre-commit coverage
```

**Benefits**:
- **Isolation**: Different projects can use different tool versions
- **No conflicts**: Tools don't interfere with system Python
- **Project-specific**: Tool versions tracked in pyproject.toml
- **Reproducible**: Other developers get same tools via `uv sync`

### Alternative: Global Installation

Only use global installation if you have a single Python version across all projects:

```bash
# Install globally with uv (faster, recommended)
uv pip install radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade ruff mypy basedpyright pre-commit coverage

# Fallback with pip
# pip install --user radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade ruff mypy basedpyright pre-commit coverage

# Or via your Linux distribution's package manager (best for global install)
# e.g., on openSUSE: sudo zypper install python3-pytest python3-ruff python3-mypy
```

**Drawbacks**:
- Version conflicts between projects
- System-wide modifications
- Harder to maintain project-specific requirements

## Step 5: Verify Installation

### Verify Skills

```bash
# Check Claude Code can see skills
ls ~/.claude/skills/

# Should show all 8 skills:
# py-code-health/
# py-complexity/
# py-git-hooks/
# py-modernize/
# py-quality-setup/
# py-refactor/
# py-security/
# py-test-quality/
```

### Verify Tools

Tools should be installed in your project's venv when you use the skills.
To verify tools are available:

```bash
# Activate your project's venv
cd /path/to/your/project
source venv/bin/activate  # or: source .venv/bin/activate

# Check tools installed
radon --version
vulture --version
bandit --version
lizard --version
pytest --version
ruff --version
mypy --version
basedpyright --version
mutmut --version
wily --version
```

All commands should print version numbers without errors. If tools aren't installed yet, they will be installed automatically when you invoke the corresponding skills.

## Step 6: Test in Claude Code

Open Claude Code and try:

```
Please list available Python refactoring skills
```

You should see all 8 skills.

### Remove Skills

```bash
# Remove symlinks or copied files
rm -rf ~/.claude/skills/py-*
```

### Remove Tools

If you've installed the tools globally and no longer require them:

```bash
uv pip uninstall radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade
# OR
pip uninstall radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade
# OR
# Refer to your Linux distribution manual.
```

## Next Steps

- Read [Quick Start Guide](quick-start.md) for usage examples
- See [Tool Comparison](tool-comparison.md) to understand tool selection
- Browse [Skills README](../skills/README.md) for detailed skill descriptions

## Support

- **Issues**: [GitHub Issues](https://github.com/l-mb/python-refactoring-skills/issues)
- **Claude Code Help**: Run `/help` in Claude Code
