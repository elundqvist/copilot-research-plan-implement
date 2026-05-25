#!/bin/bash

# GitHub Copilot Research-Plan-Implement Framework — Update Script
# Wrapper around setup.sh that auto-selects update mode.

set -e

echo "🔄 Copilot Research-Plan-Implement Framework Update"
echo "===================================================="
echo ""

if [ -z "$1" ]; then
    if [ -d ".github/prompts" ] || [ -d ".github/agents" ]; then
        TARGET_DIR="."
        echo "📁 Updating framework in current directory"
    else
        read -p "Enter the path to your repository: " TARGET_DIR
    fi
else
    TARGET_DIR="$1"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

if [ ! -d "$TARGET_DIR/.github/prompts" ] && [ ! -d "$TARGET_DIR/.github/agents" ]; then
    echo "❌ Error: No framework installation found in '$TARGET_DIR'"
    echo "Run setup.sh first to install the framework."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Running update process..."
echo ""

# Auto-select update option (1) by piping it to setup.sh
echo "1" | "$SCRIPT_DIR/setup.sh" "$TARGET_DIR"
