# Success Metrics & Tool Reference

Quality targets and tool guidance for Python refactoring.

## Success Metrics by Dimension

| Dimension | Target | Tool | Command |
|-----------|--------|------|---------|
| **Security** | Zero high/medium vulnerabilities | bandit, ruff | `ruff check . --select S` |
| **Testing** | ≥80% coverage, ≥75% mutation score | pytest-cov, mutmut | `pytest --cov=. --cov-fail-under=80` |
| **Complexity** | No functions ≥C (11+) | radon | `radon cc . -n C` |
| **Maintainability** | Index ≥65 all modules | radon | `radon mi . -n B` |
| **Code Health** | No dead code, no duplicates >6 lines | vulture, pylint | `vulture . --min-confidence 80` |
| **Modernization** | Python 3.13+ syntax, uv tooling | pyupgrade | `pyupgrade --py313-plus` |
| **Automation** | Pre-commit hooks pass | pre-commit | `pre-commit run --all-files` |

## Tool Reference

### Complexity Analysis

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **radon** | Cyclomatic complexity, maintainability index | Primary complexity measurement |
| **lizard** | Cognitive complexity | Readability-focused analysis |
| **xenon** | CI/CD threshold enforcement | Automated quality gates |
| **wily** | Complexity trends over git history | Track improvement over time |

### Code Quality

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **vulture** | Dead/unused code detection (AST-based) | Remove unused code |
| **pylint** | Duplicate code detection | Find copy-paste code |
| **ruff** | Fast linter/formatter | Primary linting |

### Security

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **bandit** | AST-based vulnerability scanner | Comprehensive security audit |
| **ruff --select S** | Built-in Bandit rules | Quick security check |

### Testing

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **pytest-cov** | Code coverage measurement | Identify untested code |
| **mutmut** | Mutation testing | Verify test effectiveness |

### Type Checking

| Tool | Purpose | When to Use |
|------|---------|-------------|
| **mypy** | Standard type checker | General type checking |
| **basedpyright** | Enhanced type analysis | Stricter checking |
| **ruff** | Fast linting with auto-fix | Code style enforcement |

## Engineering Charter Alignment

These skills implement Engineering Charter principles:

| Charter Principle | Skill Implementation |
|-------------------|---------------------|
| Maintainable, idiomatic code | py-complexity, py-code-health |
| Self-documenting code | py-complexity (reduce need for comments) |
| Update callers, no shims | py-modernize (direct upgrades) |
| Consolidate similar code | py-code-health (deduplication) |
| Never commit secrets | py-security, py-git-hooks |
| Run linters incrementally | py-quality-setup, py-git-hooks |
| Code must pass ruff, mypy, basedpyright | py-quality-setup |
| Pre-commit hooks for linting | py-git-hooks |

## Validation Commands

Quick validation suite after refactoring:

```bash
# All quality checks
ruff check . && ruff format --check .
mypy . && basedpyright .
ruff check . --select S
radon cc . -n C
vulture . --min-confidence 80
pytest --cov=. --cov-fail-under=80

# Track improvement
wily diff HEAD~1
wily report .
```
