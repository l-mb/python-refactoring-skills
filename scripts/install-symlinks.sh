#!/bin/bash
set -e

echo "=========================================="
echo "Python Refactoring Skills - Symlink Installer"
echo "=========================================="
echo ""

# Parse command line arguments
INSTALL_WIP=false
if [[ "$1" == "--install-wip" ]]; then
	INSTALL_WIP=true
	echo "Mode: Installing ALL skills (including WIP)"
else
	echo "Mode: Installing STABLE skills only"
	echo "      Use --install-wip to include work-in-progress skills"
fi
echo ""

# Get repository root directory
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${REPO_DIR}/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"

echo "Repository: ${REPO_DIR}"
echo "Target: ${CLAUDE_SKILLS_DIR}"
echo ""

# Check if skills directory exists in repo
if [[ ! -d "${SKILLS_DIR}" ]]; then
	echo "✗ Error: Skills directory not found at ${SKILLS_DIR}"
	exit 1
fi

# Backup existing skills if they exist and aren't symlinks
if [[ -d "${CLAUDE_SKILLS_DIR}" && ! -L "${CLAUDE_SKILLS_DIR}" ]]; then
	BACKUP_DIR="${HOME}/.claude/skills.backup.$(date +%Y%m%d_%H%M%S)"
	echo "→ Backing up existing skills to: ${BACKUP_DIR}"
	mv "${CLAUDE_SKILLS_DIR}" "${BACKUP_DIR}"
	echo "  (You can remove this backup once you verify everything works)"
	echo ""
fi

# Create .claude directory if it doesn't exist
mkdir -p "${HOME}/.claude"

# Remove existing skills directory if it's a symlink or empty
if [[ -L "${CLAUDE_SKILLS_DIR}" || -d "${CLAUDE_SKILLS_DIR}" ]]; then
	echo "→ Removing existing skills directory/symlink"
	rm -rf "${CLAUDE_SKILLS_DIR}"
fi

# Create skills directory
mkdir -p "${CLAUDE_SKILLS_DIR}"

# Function to get skill status from frontmatter
get_skill_status() {
	local skill_md="$1"
	if [[ ! -f "${skill_md}" ]]; then
		echo "stable"
		return
	fi
	# Extract status from frontmatter (between first two --- markers)
	local status
	status=$(sed -n '/^---$/,/^---$/p' "${skill_md}" | grep '^status:' | cut -d: -f2 | tr -d ' ' || true)
	# Default to 'stable' if not specified
	echo "${status:-stable}"
}

echo "→ Creating symlinks..."
echo ""

# Create symlinks for each skill directory
STABLE_COUNT=0
WIP_SKIPPED_COUNT=0

for skill_dir in "${SKILLS_DIR}"/py-*; do
	if [[ -d "${skill_dir}" ]]; then
		skill_name=$(basename "${skill_dir}")
		skill_md="${skill_dir}/SKILL.md"
		status=$(get_skill_status "${skill_md}")

		# Skip WIP skills unless flag set
		if [[ "${status}" == "wip" && "${INSTALL_WIP}" == "false" ]]; then
			echo "  ⊘ ${skill_name} (wip - skipped)"
			((WIP_SKIPPED_COUNT++))
			continue
		fi

		ln -s "${skill_dir}" "${CLAUDE_SKILLS_DIR}/${skill_name}"
		if [[ "${status}" == "wip" ]]; then
			echo "  ✓ ${skill_name} [wip]"
		else
			echo "  ✓ ${skill_name}"
			((STABLE_COUNT++))
		fi
	fi
done

echo ""
echo "=========================================="
echo "✓ Symlinks installed successfully!"
echo "=========================================="
echo ""
if [[ "${WIP_SKIPPED_COUNT}" -gt 0 ]]; then
	echo "Installed: ${STABLE_COUNT} stable skills"
	echo "Skipped: ${WIP_SKIPPED_COUNT} WIP skills"
	echo ""
	echo "To install WIP skills: ${REPO_DIR}/scripts/install-symlinks.sh --install-wip"
	echo ""
fi

# Verify symlinks
echo "Verifying symlinks:"
echo ""
found_symlinks=false
for item in "${CLAUDE_SKILLS_DIR}"/*; do
	if [[ -L "${item}" ]]; then
		ls -la "${item}"
		found_symlinks=true
	fi
done
if [[ "${found_symlinks}" == "false" ]]; then
	echo "  No symlinks found (unexpected)"
fi

echo ""
echo "Next steps:"
echo "1. Test in Claude Code: 'Please list available Python refactoring skills'"
echo "2. Read quick start: ${REPO_DIR}/docs/quick-start.md"
echo "3. Start refactoring!"
echo ""
echo "Note: Skills are now linked to the repository."
echo "To update: cd ${REPO_DIR} && git pull"
echo ""
