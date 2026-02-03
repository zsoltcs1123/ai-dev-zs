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
for skill_dir in "$SKILLS_PATH"/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        target_path="$TARGET_BASE/$skill_name"
        
        if [ -d "$target_path" ]; then
            rm -rf "$target_path"
        fi
        
        cp -r "$skill_dir" "$target_path"
        echo "Installed '$skill_name' to $target_path"
        ((count++))
    fi
done

echo ""
echo "Installed $count skill(s)"
