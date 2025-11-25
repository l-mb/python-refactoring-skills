# Python Refactoring Skills for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Skills: 8](https://img.shields.io/badge/Skills-8-blue)](skills/)
[![Python: 3.13+](https://img.shields.io/badge/Python-3.13+-green)](https://www.python.org/)

A comprehensive collection of Claude Code skills for systematic Python code refactoring and quality improvement.

## 🎯 Overview

This repository provides 8 focused, modular skills that work together to improve Python code quality through automated analysis and guided refactoring. Each skill addresses a specific aspect of code quality, from security vulnerabilities to complexity reduction.

Code generation via LLM models and agents, such as Claude Code, is fast. Verification and validation
are not.

This is a well-known situation in computing - genetic, stochastic, probabilistic, heuristic, Monte Carlo algorithms have been around for many decades in almost all fields, and often provide surprising solutions.

The goal of these skills is to reduce generated slop automatically via tool use that *isn't* probabilistic, but deterministic (such as linters, dead code detection, de-duplication, type checkers). **If the hooks catch it, you don't have to.**

Improved compactness and complexity reduction helps make efficient use of limited context windows, in both the models and human readers.

Transforming code to well-known patterns where appropriate is one of those rare situations where LLM and stochastic modelling actually applies quite well.

A good prompt and skill aims to guide the model to yield something better than the median solution from the training data, and more towards the upper ends of its capabilities.

**However**, these do not absolve you of reading and understanding the code yourself. Agentic code generation rolls the dice with every prompt, and ever so often, the model *will* go completely off the rails. It's on **you** to apply this judgment.

## Skills

| Skill | Status | Purpose | Key Tools |
|-------|--------|---------|-----------|
| **[py-refactor](skills/py-refactor/)** | stable | Orchestrates comprehensive refactoring | All tools |
| **[py-security](skills/py-security/)** | stable | Detect & fix security vulnerabilities | bandit, ruff |
| **[py-complexity](skills/py-complexity/)** | stable | Reduce cyclomatic/cognitive complexity | radon, lizard, wily |
| **[py-test-quality](skills/py-test-quality/)** | wip | Improve coverage & test effectiveness | pytest-cov, mutmut |
| **[py-code-health](skills/py-code-health/)** | stable | Remove dead code & duplication | vulture, pylint |
| **[py-modernize](skills/py-modernize/)** | stable | Upgrade tooling & syntax | uv, pyupgrade |
| **[py-quality-setup](skills/py-quality-setup/)** | stable | Configure linters & type checkers | ruff, mypy, basedpyright |
| **[py-git-hooks](skills/py-git-hooks/)** | stable | Set up automated quality checks | pre-commit |

See [skills/README.md](skills/README.md) for detailed descriptions and decision tree.

## 🚀 Quick Start

### Prerequisites

- [Claude Code](https://docs.claude.com/claude-code) installed
- Python 3.13+ recommended
- [uv](https://github.com/astral-sh/uv) (optional, but recommended for faster installs)

### Installation

1. **Clone the repository**:

```bash
git clone https://github.com/l-mb/python-refactoring-skills.git
cd python-refactoring-skills
```

2. **Install to Claude Code**:

```bash
# Option A: Symlink approach (recommended - easier to update)
./scripts/install-symlinks.sh                    # Stable skills only (default)
./scripts/install-symlinks.sh --install-wip      # All skills including WIP

# Option B: Copy approach (standalone installation)
cp -r skills/py-refactor skills/py-security skills/py-complexity skills/py-quality-setup skills/py-git-hooks skills/py-code-health skills/py-modernize ~/.claude/skills/  # Stable only
cp -r skills/* ~/.claude/skills/                                                     # All skills
```

**Skill Status**: Skills are tagged as `stable` (mostly reviewed) or `wip` (work-in-progress, functional but may change). Default installation includes only stable skills.

3. **Install Python analysis tools** (per-project):

Skills install analysis tools into your project's virtual environment automatically.
Alternatively, pre-install them:

```bash
# Activate your project's venv
cd /path/to/your/project
source venv/bin/activate  # or: source .venv/bin/activate

# Install analysis tools (using uv - recommended)
uv pip install radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade

# Fallback if uv not available
# pip install radon vulture pylint bandit lizard pytest-cov mutmut wily xenon pyupgrade
```

**Note**: Tools are installed per-project, not globally. This ensures isolation and allows different projects to use different tool versions.

### Basic Usage

In Claude Code, invoke any skill:

```
# Quick security audit
Please use py-security to scan for vulnerabilities

# Reduce complexity in specific module
Use py-complexity to refactor the handlers.py module

# Comprehensive refactoring
Use py-refactor to systematically improve this codebase
```

See [docs/quick-start.md](docs/quick-start.md) for more examples.

## 📊 Success Metrics

These skills help you achieve:

- ✅ **Security**: Zero high/medium severity vulnerabilities
- ✅ **Testing**: 80%+ code coverage, 75%+ mutation score
- ✅ **Complexity**: No functions with complexity ≥C (11+)
- ✅ **Maintainability**: Maintainability index ≥65 for all modules
- ✅ **Code Health**: No dead code, no duplicate blocks >6 lines
- ✅ **Modernization**: Python 3.13+ syntax, uv-based tooling
- ✅ **Automation**: Pre-commit hooks enforce standards

## 🛠️ Tools Reference

### Complexity Analysis
- **radon** - Cyclomatic complexity and maintainability index
- **lizard** - Cognitive complexity (better for readability)
- **xenon** - Complexity threshold enforcement for CI/CD
- **wily** - Track complexity trends across git history

### Code Quality
- **vulture** - Dead/unused code detection (AST-based)
- **pylint** - Duplicate code detection
- **ruff** - Fast linter/formatter (includes isort, bandit rules)

### Security
- **bandit** - AST-based security vulnerability scanner
- **ruff --select S** - Built-in Bandit rules (faster alternative)

### Testing
- **pytest-cov** - Code coverage measurement
- **mutmut** - Mutation testing for test quality verification
- **cosmic-ray** - Advanced mutation testing (optional)

### Type Checking & Linting
- **mypy** - Standard Python type checker
- **basedpyright** - Enhanced type analysis
- **ruff** - Modern linter with auto-fix

### Modernization
- **uv** - Fast Python package installer (pip replacement)
- **pyupgrade** - Automatically upgrade syntax to newer Python

## 📖 Documentation

- **[Installation Guide](docs/installation.md)** - Detailed setup instructions
- **[Skills Reference](skills/README.md)** - Detailed skill descriptions & decision tree

## 📄 License

MIT License - See [LICENSE](LICENSE)

Copyright (c) 2025 Lars Marowsky-Brée

## 🔗 Links

- **GitHub Repository**: https://github.com/l-mb/python-refactoring-skills
- **Claude Code Documentation**: https://docs.claude.com/claude-code
- **Report Issues**: https://github.com/l-mb/python-refactoring-skills/issues

## ⭐ Star History

If you find these skills useful, please consider starring the repository!
