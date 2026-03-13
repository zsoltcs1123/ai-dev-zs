#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <skill-name>"
    exit 1
fi

SKILL_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_PATH="$SCRIPT_DIR/../skills"
TARGET_PATH="$HOME/.cursor/skills/$SKILL_NAME"

SOURCE_PATH="$(find "$SKILLS_PATH" -type f -name "SKILL.md" -path "*/$SKILL_NAME/SKILL.md" -print -quit | xargs dirname 2>/dev/null)"

if [ -z "$SOURCE_PATH" ] || [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Skill not found: $SKILL_NAME" >&2
    exit 1
fi

mkdir -p "$TARGET_PATH"
cp -r "$SOURCE_PATH/." "$TARGET_PATH/"
echo "Installed '$SKILL_NAME' to $TARGET_PATH"
