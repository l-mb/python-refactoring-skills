# Quick Workflows

Targeted workflows for specific refactoring scenarios. For comprehensive refactoring, see SKILL.md.

## Security-Only Sweep

**Use case**: Quick security audit before release

```
1. Run: ruff check . --select S
2. If issues found:
   → Invoke: py-security
3. Verify: All critical vulnerabilities fixed
4. Run tests
5. Commit: "Security: fix vulnerabilities"
```

## Complexity Reduction Sprint

**Use case**: Reduce technical debt in complex module

```
1. Ensure adequate test coverage (≥80%)
   If not: → Invoke: py-test-quality first

2. Run: radon cc module/ -n C -s
3. Identify most complex functions
4. → Invoke: py-complexity
5. After each refactoring:
   - pytest --cov=module/
   - wily diff HEAD~1
6. Continue until all functions rank A or B
```

## Pre-Release Quality Check

**Use case**: Ensure code quality before major release

```
1. → Invoke: py-security (fix all vulnerabilities)
2. → Invoke: py-test-quality (achieve ≥80% coverage)
3. → Invoke: py-code-health (remove dead code, duplicates)
4. → Invoke: py-complexity (reduce complex functions)
5. Final validation: All quality checks pass
6. Tag release with confidence
```

## New Project Bootstrap

**Use case**: Set up quality tools for new project

```
1. → Invoke: py-quality-setup
   - Configure ruff, mypy, basedpyright

2. → Invoke: py-modernize
   - Set up uv instead of pip
   - Ensure pyproject.toml configured

3. → Invoke: py-git-hooks
   - Set up pre-commit hooks

4. Initialize tracking:
   - wily build .

5. Document in README:
   - Development setup using uv
   - Quality standards (coverage ≥80%, etc.)
```

## Legacy Codebase Modernization

**Use case**: Bring old codebase up to modern standards

```
1. → Invoke: py-test-quality
   - Establish test baseline (may be <50% initially)
   - Write tests for critical paths first
   - Target: ≥60% as minimum for refactoring

2. → Invoke: py-security
   - Fix all high-severity issues
   - Document accepted risks for false positives

3. → Invoke: py-code-health
   - Remove accumulated dead code
   - Significant LOC reduction possible

4. → Invoke: py-complexity
   - Focus on most complex functions first
   - Incremental improvement over time

5. → Invoke: py-modernize
   - Upgrade to Python 3.13+ syntax
   - Migrate to uv for faster CI/CD
   - Consolidate configs to pyproject.toml

6. → Invoke: py-quality-setup + py-git-hooks
   - Enforce standards going forward

7. Track progress:
   - wily reports show trend improvements
   - Coverage increases over time
   - Complexity decreases over time
```

---

## Examples

### Example: Complete Refactoring Session

**Scenario**: 5000-line Python project, no recent quality work

```
1. Setup (one-time):
   → py-quality-setup: Configure ruff, mypy, basedpyright
   Add tools to [dependency-groups] dev: radon, vulture, pylint, bandit, lizard, pytest-cov, mutmut, wily
   Install: uv sync && source .venv/bin/activate

2. Baseline analysis:
   Run all scanners, save to reports/
   Results: 12 security issues, 45% coverage, avg complexity C, 400 dead LOC

3. Critical first - Security:
   → py-security: Fix 12 vulnerabilities
   Result: All security checks pass

4. Enable safe refactoring - Tests:
   → py-test-quality: Write tests for critical paths
   Result: Coverage 45% → 82%

5. Clean up - Code health:
   → py-code-health: Remove dead code, consolidate duplicates
   Result: 400 dead LOC removed, 3 duplicate blocks consolidated
   Net: 450 lines removed

6. Simplify - Complexity:
   → py-complexity: Refactor 8 complex functions (D/E rank)
   Result: All functions now A/B rank, maintainability 65 → 78

7. Modernize - Optional:
   → py-modernize: Upgrade to uv, Python 3.13 syntax
   Result: CI 30% faster with uv, modern syntax throughout

8. Automate - Git hooks:
   → py-git-hooks: Pre-commit hooks
   Result: Quality enforced automatically

Results:
- 5000 lines → 4550 lines (9% reduction)
- 0 security vulnerabilities (was 12)
- 82% test coverage (was 45%)
- Complexity: all A/B (was avg C, several D/E)
- Maintainability: 78 (was 65)
- CI: 30% faster builds
- Future: Automatic quality enforcement via hooks

ROI: Every future change is now safer, faster to review, easier to modify
```

### Example: Target Specific Issue

**Scenario**: Security audit found SQL injection vulnerability

```
Don't invoke orchestrator - too heavyweight
→ Invoke: py-security directly
   Fix SQL injection
   Run security checks
   Commit
Done in 15 minutes vs hours for full refactoring
```
