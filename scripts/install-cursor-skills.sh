#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_PATH="$SCRIPT_DIR/../skills"
TARGET_BASE="$HOME/.cursor/skills"

if [ ! -d "$SKILLS_PATH" ]; then
    echo "Error: Skills directory not found: $SKILLS_PATH" >&2
    exit 1
fi

mkdir -p "$TARGET_BASE"

count=0
while IFS= read -r skill_file; do
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    target_path="$TARGET_BASE/$skill_name"

    mkdir -p "$target_path"
    cp -r "$skill_dir/." "$target_path/"
    echo "Installed '$skill_name' to $target_path"
    ((count++))
done < <(find "$SKILLS_PATH" -name "SKILL.md" -type f)

echo ""
echo "Installed $count skill(s)"
