#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <skill-name>"
    exit 1
fi

SKILL_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PATH="$SCRIPT_DIR/../skills/$SKILL_NAME"
TARGET_PATH="$HOME/.cursor/skills-cursor/$SKILL_NAME"

if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Skill not found: $SOURCE_PATH" >&2
    exit 1
fi

mkdir -p "$(dirname "$TARGET_PATH")"

if [ -d "$TARGET_PATH" ]; then
    rm -rf "$TARGET_PATH"
fi

cp -r "$SOURCE_PATH" "$TARGET_PATH"
echo "Installed '$SKILL_NAME' to $TARGET_PATH"
