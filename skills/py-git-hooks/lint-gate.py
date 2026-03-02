#!/usr/bin/env python3
"""Stop hook lint gate for Claude Code.

Auto-fixes trivial issues (ruff --fix, ruff format) then runs the full
lint suite (ruff, mypy, basedpyright) on modified Python files before
Claude returns to the user. If unfixable errors remain, blocks the stop
with the error output so Claude can fix them first.

Install: copy to ~/.claude/hooks/lint-gate.py
Configure in ~/.claude/settings.json under hooks.Stop
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

MAX_LINES_PER_TOOL = 50
TOOL_TIMEOUT = 120

# Auto-fix pass: runs first, silently fixes trivial issues
FIXERS: list[tuple[str, list[str]]] = [
    ("ruff", ["check", "--fix"]),
    ("ruff", ["format"]),
]

# Check pass: runs after fixers, reports remaining errors
CHECKERS: list[tuple[str, list[str]]] = [
    ("ruff", ["check"]),
    ("mypy", []),
    ("basedpyright", []),
]


def get_modified_python_files(cwd: Path) -> list[str]:
    """Find Python files with uncommitted changes (staged, unstaged, untracked)."""
    commands = [
        ["git", "diff", "--name-only", "--diff-filter=d", "--", "*.py"],
        ["git", "diff", "--cached", "--name-only", "--diff-filter=d", "--", "*.py"],
        ["git", "ls-files", "--others", "--exclude-standard", "--", "*.py"],
    ]
    modified: set[str] = set()
    for cmd in commands:
        try:
            result = subprocess.run(
                cmd, capture_output=True, text=True, cwd=cwd, timeout=10
            )
            for f in result.stdout.strip().splitlines():
                if f and (cwd / f).is_file():
                    modified.add(f)
        except (subprocess.SubprocessError, OSError):
            pass
    return sorted(modified)


def find_venv_activate(cwd: Path) -> str:
    """Return shell source command for venv activation, or empty string."""
    for venv_dir in (".venv", "venv"):
        activate = cwd / venv_dir / "bin" / "activate"
        if activate.exists():
            return f"source '{activate}' && "
    return ""


def run_linter(
    tool: str, args: list[str], files: list[str], cwd: Path, venv_prefix: str
) -> str | None:
    """Run a linter on files. Return error output, or None if clean/unavailable."""
    file_args = " ".join(f"'{f}'" for f in files)
    cmd = f"{venv_prefix}{tool} {' '.join(args)} {file_args}"
    try:
        result = subprocess.run(
            ["bash", "-c", cmd],
            capture_output=True,
            text=True,
            cwd=cwd,
            timeout=TOOL_TIMEOUT,
        )
    except subprocess.TimeoutExpired:
        return f"(timed out after {TOOL_TIMEOUT}s)"
    except OSError:
        return None

    if result.returncode == 0:
        return None

    output = result.stdout.strip() or result.stderr.strip()
    if not output:
        return None

    # Skip "not found" errors — tool not installed, not a lint failure
    if "command not found" in output or "No module named" in output:
        return None

    lines = output.splitlines()
    if len(lines) > MAX_LINES_PER_TOOL:
        output = "\n".join(lines[:MAX_LINES_PER_TOOL]) + (
            f"\n... ({len(lines) - MAX_LINES_PER_TOOL} more lines)"
        )
    return output


def main() -> None:
    input_data = json.load(sys.stdin)

    # Prevent infinite loops: if already retrying after a block, allow stop
    if input_data.get("stop_hook_active"):
        json.dump({"decision": "stop"}, sys.stdout)
        return

    cwd = Path(input_data.get("cwd", ".")).resolve()
    files = get_modified_python_files(cwd)

    if not files:
        json.dump({"decision": "stop"}, sys.stdout)
        return

    venv_prefix = find_venv_activate(cwd)

    # Auto-fix pass: silently fix trivial issues (import sorting, formatting)
    for tool, args in FIXERS:
        run_linter(tool, args, files, cwd, venv_prefix)

    # Check pass: report remaining unfixable errors
    errors: list[str] = []
    for tool, args in CHECKERS:
        output = run_linter(tool, args, files, cwd, venv_prefix)
        if output:
            errors.append(f"=== {tool} ===\n{output}")

    if errors:
        reason = (
            "Fix these errors in modified files before returning:\n\n"
            + "\n\n".join(errors)
        )
        json.dump({"decision": "block", "reason": reason}, sys.stdout)
    else:
        json.dump({"decision": "stop"}, sys.stdout)


if __name__ == "__main__":
    main()
