# Skills Reference

Detailed descriptions and usage guide for Python refactoring skills.

## Skill Descriptions

### py-refactor (Orchestrator)
**Purpose**: Coordinates comprehensive refactoring across multiple dimensions
**Use when**: Need systematic quality improvement with multiple issues
**Tools**: All tools from other skills
**Output**: Measurable improvement in security, testing, complexity, code health
**Priority**: Security → Testing → Code Health → Complexity → Modernization

**Example invocation**:
```
Use py-refactor to systematically improve this codebase
```

---

### py-security
**Purpose**: Detect and fix security vulnerabilities
**Use when**: Security audit, CVE fixes, pre-release security check
**Tools**: bandit, ruff --select S
**Finds**: SQL injection, hardcoded secrets, weak crypto, shell injection
**Output**: Zero high/medium severity vulnerabilities
**Priority**: Critical (always run first)

**Example invocation**:
```
Use py-security to scan for vulnerabilities
```

---

### py-complexity
**Purpose**: Reduce cyclomatic and cognitive complexity
**Use when**: Code is hard to understand, functions have high complexity ranks
**Tools**: radon, lizard, xenon, wily
**Patterns**: Extract function, guard clauses, lookup tables, polymorphism
**Output**: All functions complexity rank A or B, cognitive complexity ≤15
**Priority**: Medium (after security and tests)

**Example invocation**:
```
Use py-complexity to refactor the handlers.py module
```

---

### py-test-quality
**Purpose**: Measure and improve test coverage and test effectiveness
**Use when**: Low test coverage (<80%), need confidence before refactoring
**Tools**: pytest-cov, mutmut, cosmic-ray
**Approach**: Coverage-guided refactoring - write tests before refactoring
**Output**: ≥80% coverage, ≥75% mutation score
**Priority**: High (enables safe refactoring)

**Example invocation**:
```
Use py-test-quality to improve test coverage
```

---

### py-code-health
**Purpose**: Remove dead code and consolidate duplicates
**Use when**: Accumulated dead code, duplicate code blocks
**Tools**: vulture (dead code), pylint (duplicates)
**Patterns**: Consolidate to parametrized functions, remove obsolete code
**Output**: No dead code (>80% confidence), no duplicates (>6 lines), reduced LOC
**Priority**: High (reduces noise for other refactoring)

**Example invocation**:
```
Use py-code-health to remove dead code and consolidate duplicates
```

---

### py-modernize
**Purpose**: Upgrade tooling and syntax to modern standards
**Use when**: Legacy codebase, using pip instead of uv, old Python syntax
**Tools**: uv (pip replacement), pyupgrade, ruff --select UP
**Updates**: pip→uv, Python 3.13+ syntax, modern type hints, pyproject.toml
**Output**: Modern tooling, current Python patterns, faster CI/CD
**Priority**: Low (optional upgrade)

**Example invocation**:
```
Use py-modernize to upgrade this codebase to modern Python
```

---

### py-quality-setup
**Purpose**: Configure linters and type checkers
**Use when**: New project, missing quality tool configuration
**Tools**: ruff, mypy, basedpyright
**Output**: Configured pyproject.toml with all quality tools
**Priority**: Setup (run first for new projects)

**Example invocation**:
```
Use py-quality-setup to configure quality tools
```

---

### py-git-hooks
**Purpose**: Set up automated quality checks before commits
**Use when**: Need enforcement of quality standards
**Tools**: pre-commit hooks (runs ruff, mypy, basedpyright)
**Output**: Quality checks run automatically on each commit
**Priority**: Automation (run last to enforce standards)

**Example invocation**:
```
Use py-git-hooks to set up pre-commit quality checks
```

## Decision Tree

Use this flow chart to decide which skill to invoke:

```
┌─────────────────────────────────┐
│   Need Python refactoring?      │
└────────────┬────────────────────┘
             │
             ▼
    ┌────────────────────┐
    │  New project with  │──YES──▶ py-quality-setup
    │  no quality tools? │         (30 min)
    └────────┬───────────┘
             │ NO
             ▼
    ┌────────────────────┐
    │ Security vuln      │──YES──▶ py-security
    │ found or audit?    │         (CRITICAL, 15min-2hr)
    └────────┬───────────┘
             │ NO
             ▼
    ┌────────────────────┐
    │ Test coverage      │──YES──▶ py-test-quality
    │ < 80%?             │         (HIGH, 4-12hr)
    └────────┬───────────┘         Write tests BEFORE refactoring
             │ NO
             ▼
    ┌────────────────────┐
    │ Dead code or       │──YES──▶ py-code-health
    │ duplicates?        │         (HIGH, 2-4hr)
    └────────┬───────────┘
             │ NO
             ▼
    ┌────────────────────┐
    │ Complex functions  │──YES──▶ py-complexity
    │ (C+ rank)?         │         (MEDIUM, 2-6hr)
    └────────┬───────────┘
             │ NO
             ▼
    ┌────────────────────┐
    │ Using old patterns │──YES──▶ py-modernize
    │ or pip?            │         (LOW, 1-3hr)
    └────────┬───────────┘
             │ NO
             ▼
    ┌────────────────────┐
    │ Need automated     │──YES──▶ py-git-hooks
    │ enforcement?       │         (15-30min)
    └────────┬───────────┘
             │ NO
             ▼
    ┌────────────────────┐
    │ Multiple issues    │──YES──▶ py-refactor
    │ across dimensions? │         (Orchestrates all, 4-24hr)
    └────────────────────┘
```

## Skill Dependencies

### Layer Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    py-git-hooks (enforcement)                   │
├─────────────────────────────────────────────────────────────────┤
│                    py-modernize (optional)                      │
├───────────────┬───────────────┬───────────────┬─────────────────┤
│  py-security  │ py-code-health│ py-complexity │ py-test-quality │
│   (critical)  │    (high)     │   (medium)    │     (high)      │
├───────────────┴───────────────┴───────────────┴─────────────────┤
│               py-quality-setup (foundation)                     │
└─────────────────────────────────────────────────────────────────┘
```

### Recommended Order

```
py-quality-setup (prerequisite for new projects)
         ↓
py-test-quality (establishes safety net - HIGH PRIORITY)
         ↓
py-security (fix vulnerabilities - CRITICAL PRIORITY)
         ↓
py-code-health (reduce noise)
         ↓
py-complexity (improve maintainability)
         ↓
py-modernize (optional upgrade)
         ↓
py-git-hooks (enforce standards going forward)
```

**Key principle**: Always ensure adequate test coverage BEFORE major refactoring.

## Quick Selection Guide

| Scenario | Recommended Skill | Reason |
|----------|------------------|---------|
| Pre-release security audit | py-security | Critical priority |
| Legacy codebase takeover | py-refactor | Systematic approach needed |
| Code review flagged complexity | py-complexity | Focused complexity reduction |
| Low test coverage before refactor | py-test-quality | Safety net first |
| Codebase accumulating cruft | py-code-health | Clean up dead code |
| Moving from Python 3.8 to 3.13 | py-modernize | Syntax upgrade |
| Starting new Python project | py-quality-setup | Configure tools |
| Team needs enforcement | py-git-hooks | Automated checks |

## Skill Combinations

### Common Workflows

**New Project Bootstrap**:
```
1. py-quality-setup (configure tools)
2. py-git-hooks (set up automation)
→ Result: Quality standards enforced from day one
```

**Legacy Codebase Rescue**:
```
1. py-test-quality (establish coverage baseline)
2. py-security (fix vulnerabilities)
3. py-code-health (remove dead code)
4. py-complexity (reduce complexity)
5. py-modernize (upgrade syntax)
6. py-git-hooks (prevent regressions)
→ Result: Modern, maintainable codebase
```

**Pre-Release Quality Gate**:
```
1. py-security (security audit)
2. py-test-quality (verify coverage ≥80%)
3. py-code-health (clean up)
4. py-complexity (ensure maintainability)
→ Result: Production-ready code
```

**Focused Refactoring**:
```
Single issue? Use specific skill directly:
- CVE fix → py-security only
- Complex module → py-complexity only
- Duplicate code → py-code-health only
```

## Success Metrics by Skill

| Skill | Success Criteria |
|-------|------------------|
| py-security | Zero high/medium severity vulnerabilities (bandit clean) |
| py-complexity | All functions rank A/B, cognitive complexity ≤15 |
| py-test-quality | Coverage ≥80%, mutation score ≥75% |
| py-code-health | No dead code (>80% confidence), no duplicates >6 lines |
| py-modernize | Python 3.13+ syntax, uv-based, pyproject.toml |
| py-quality-setup | Configured ruff, mypy, basedpyright in pyproject.toml |
| py-git-hooks | Pre-commit hooks run and pass |
| py-refactor | All of the above + measurable improvement in LOC, maintainability |

## Tool Requirements

Each skill uses specific tools. See `docs/installation.md` if you want to install
them ahead of time and not let the skills handle it.

## Further Reading

- [Installation Guide](../docs/installation.md) - Detailed setup instructions
- [Tool Comparison](../docs/tool-comparison.md) - When to use which tool
- [Contributing](../docs/contributing.md) - Add new patterns or skills
- [Examples](../examples/) - Before/after code samples

## Support

- **Issues**: [GitHub Issues](https://github.com/l-mb/python-refactoring-skills/issues)
- **Claude Code Docs**: [docs.claude.com/claude-code](https://docs.claude.com/claude-code)
