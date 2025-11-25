# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-05

### Added

#### Skills
- **py-refactor**: Orchestrator skill for comprehensive refactoring workflows
- **py-security**: Security vulnerability detection and remediation
- **py-complexity**: Complexity reduction (cyclomatic and cognitive)
- **py-test-quality**: Code coverage and mutation testing
- **py-code-health**: Dead code and duplication removal
- **py-modernize**: Codebase modernization (pip→uv, Python 3.13+ syntax)
- **py-quality-setup**: Linter and type checker configuration
- **py-git-hooks**: Pre-commit hook automation

#### Tools Integration
- radon: Cyclomatic complexity and maintainability metrics
- lizard: Cognitive complexity analysis
- vulture: Dead code detection
- bandit: Security vulnerability scanning
- pylint: Duplicate code detection
- pytest-cov: Code coverage measurement
- mutmut: Mutation testing
- wily: Complexity tracking over time
- xenon: CI/CD complexity thresholds
- uv: Fast package management
- pyupgrade: Syntax modernization

#### Refactoring Patterns
- Extract function for complexity reduction
- Guard clauses over nested conditionals
- Lookup tables over if/elif chains
- Polymorphism over type conditionals
- Magic number extraction to configuration
- Repetitive field operations to loops
- Complex type alias extraction
- Coverage-guided refactoring workflow

#### Documentation
- Comprehensive README with quick start
- Detailed installation guide
- Tool comparison and selection guide
- Contributing guidelines
- Skills decision tree

#### Automation
- Installation script for all tools
- GitHub Actions workflow for skill validation
- Symlink installation script

### Success Criteria

Skills enable achieving:
- Zero security vulnerabilities
- 80%+ test coverage
- No functions with complexity ≥C (11+)
- No dead code or duplicates
- Modern Python 3.13+ syntax
- Automated quality enforcement

[1.0.0]: https://github.com/l-mb/python-refactoring-skills/releases/tag/v1.0.0
