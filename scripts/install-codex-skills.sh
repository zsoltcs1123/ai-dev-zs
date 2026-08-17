#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [--wsl] [skill1 skill2 ...]"
    echo "  --wsl          Install to Codex on Windows (from within WSL)"
    echo "  skill1 ...     Install only the listed skills (default: all)"
    echo ""
    echo "Environment:"
    echo "  CODEX_HOME     Override the Codex home directory (target is CODEX_HOME/skills)"
    exit 1
}

WSL=false
SKILL_LIST=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --wsl) WSL=true; shift ;;
        --help|-h) usage ;;
        -*) echo "Unknown option: $1" >&2; usage ;;
        *) SKILL_LIST+=("$1"); shift ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_PATH="$SCRIPT_DIR/../skills"

if [ ! -d "$SKILLS_PATH" ]; then
    echo "Error: Skills directory not found: $SKILLS_PATH" >&2
    exit 1
fi

if [ -n "${CODEX_HOME:-}" ]; then
    TARGET_BASE="${CODEX_HOME%/}/skills"
elif $WSL; then
    WIN_USER="$(cmd.exe /C "echo %USERNAME%" 2>/dev/null | tr -d '\r')"
    if [ -z "$WIN_USER" ]; then
        echo "Error: Could not determine Windows username" >&2
        exit 1
    fi
    TARGET_BASE="/mnt/c/Users/$WIN_USER/.codex/skills"
else
    TARGET_BASE="$HOME/.codex/skills"
fi

mkdir -p "$TARGET_BASE"

install_skill() {
    local skill_dir="$1"
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local target_path="$TARGET_BASE/$skill_name"

    mkdir -p "$target_path"
    cp -r "$skill_dir/." "$target_path/"
    echo "Installed '$skill_name' to $target_path"
}

count=0

if [ ${#SKILL_LIST[@]} -gt 0 ]; then
    for name in "${SKILL_LIST[@]}"; do
        source_path="$(find "$SKILLS_PATH" -type f -name "SKILL.md" -path "*/$name/SKILL.md" -print -quit | xargs dirname 2>/dev/null)"
        if [ -z "$source_path" ] || [ ! -d "$source_path" ]; then
            echo "Warning: Skill not found: $name" >&2
            continue
        fi
        install_skill "$source_path"
        count=$((count + 1))
    done
else
    while IFS= read -r skill_file; do
        install_skill "$(dirname "$skill_file")"
        count=$((count + 1))
    done < <(find "$SKILLS_PATH" -name "SKILL.md" -type f)
fi

echo ""
echo "Installed $count skill(s)"
