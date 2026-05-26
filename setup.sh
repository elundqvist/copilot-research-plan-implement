#!/bin/bash

# GitHub Copilot Research-Plan-Implement Framework — Setup Script
# Installs the framework into a target repository so it works with both
# VS Code Copilot and the Copilot CLI.

set -e

echo "🚀 Copilot Research-Plan-Implement Framework Setup"
echo "==================================================="
echo ""

# Resolve the framework source directory (where this script lives)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Resolve target directory
if [ -z "$1" ]; then
    read -p "Enter the path to your repository: " TARGET_DIR
else
    TARGET_DIR="$1"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

TARGET_DIR="$( cd "$TARGET_DIR" && pwd )"

if [ "$TARGET_DIR" = "$SCRIPT_DIR" ]; then
    echo "❌ Error: Target directory must be different from the framework source directory"
    exit 1
fi

# Detect existing installation
UPDATE_MODE="false"
if [ -d "$TARGET_DIR/.github/prompts" ] || [ -d "$TARGET_DIR/.github/agents" ]; then
    echo "📦 Found existing framework installation in $TARGET_DIR/.github/"
    echo ""
    echo "What would you like to do?"
    echo "  1) Update framework (overwrite .github/prompts/ and .github/agents/ with latest)"
    echo "  2) Skip existing files (only add new ones)"
    echo "  3) Cancel"
    read -p "Choose option (1/2/3): " INSTALL_OPTION

    case $INSTALL_OPTION in
        1) UPDATE_MODE="true"; echo "📥 Updating framework to latest version..." ;;
        2) UPDATE_MODE="false"; echo "🔀 Adding new files only, keeping existing ones..." ;;
        *) echo "Setup cancelled"; exit 0 ;;
    esac
fi

# Confirm merging if thoughts/ exists
if [ -d "$TARGET_DIR/thoughts" ]; then
    echo ""
    echo "ℹ️  thoughts/ directory already exists in $TARGET_DIR — will merge."
fi

echo ""
echo "📁 Creating directory structure..."

mkdir -p "$TARGET_DIR/.github/prompts"
mkdir -p "$TARGET_DIR/.github/agents"
mkdir -p "$TARGET_DIR/thoughts/shared/research"
mkdir -p "$TARGET_DIR/thoughts/shared/plans"
mkdir -p "$TARGET_DIR/thoughts/shared/sessions"
mkdir -p "$TARGET_DIR/thoughts/shared/cloud"

copy_one() {
    # $1 = source file, $2 = destination directory
    local src="$1"
    local dest_dir="$2"
    local filename
    filename=$(basename "$src")
    if [ -f "$dest_dir/$filename" ]; then
        if [ "$UPDATE_MODE" = "true" ]; then
            cp "$src" "$dest_dir/"
            echo "    🔄 Updated $filename"
        else
            echo "    ⚠️  $filename already exists, skipping..."
        fi
    else
        cp "$src" "$dest_dir/"
        echo "    ✅ Installed $filename"
    fi
}

echo "📝 Installing workflow prompts (.github/prompts/)..."
for f in "$SCRIPT_DIR"/.github/prompts/*.prompt.md; do
    [ -e "$f" ] || continue
    copy_one "$f" "$TARGET_DIR/.github/prompts"
done

echo "🤖 Installing custom subagents (.github/agents/)..."
for f in "$SCRIPT_DIR"/.github/agents/*.agent.md; do
    [ -e "$f" ] || continue
    copy_one "$f" "$TARGET_DIR/.github/agents"
done

# AGENTS.md — append framework section if file exists, else copy as-is
echo "📝 Configuring AGENTS.md..."
FRAMEWORK_MARKER="<!-- copilot-research-plan-implement: framework section -->"
if [ -f "$TARGET_DIR/AGENTS.md" ]; then
    if grep -q "$FRAMEWORK_MARKER" "$TARGET_DIR/AGENTS.md"; then
        if [ "$UPDATE_MODE" = "true" ]; then
            # Strip old framework section between markers, then re-append
            awk -v marker="$FRAMEWORK_MARKER" '
                BEGIN { skip = 0 }
                $0 ~ marker { skip = !skip; next }
                !skip { print }
            ' "$TARGET_DIR/AGENTS.md" > "$TARGET_DIR/AGENTS.md.tmp"
            mv "$TARGET_DIR/AGENTS.md.tmp" "$TARGET_DIR/AGENTS.md"
            {
                echo ""
                echo "$FRAMEWORK_MARKER"
                cat "$SCRIPT_DIR/AGENTS.md"
                echo "$FRAMEWORK_MARKER"
            } >> "$TARGET_DIR/AGENTS.md"
            echo "    🔄 Updated framework section in AGENTS.md"
        else
            echo "    ℹ️  Framework section already present in AGENTS.md, skipping..."
        fi
    else
        echo ""
        read -p "    AGENTS.md already exists. Append framework section? (Y/n): " APPEND_AGENTS
        if [ "$APPEND_AGENTS" = "n" ] || [ "$APPEND_AGENTS" = "N" ]; then
            echo "    ℹ️  Skipped AGENTS.md modification"
        else
            {
                echo ""
                echo "$FRAMEWORK_MARKER"
                cat "$SCRIPT_DIR/AGENTS.md"
                echo "$FRAMEWORK_MARKER"
            } >> "$TARGET_DIR/AGENTS.md"
            echo "    ✅ Appended framework section to AGENTS.md"
        fi
    fi
else
    cp "$SCRIPT_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
    # Wrap the copied content with markers so future updates can replace it cleanly
    {
        echo "$FRAMEWORK_MARKER"
        cat "$TARGET_DIR/AGENTS.md"
        echo "$FRAMEWORK_MARKER"
    } > "$TARGET_DIR/AGENTS.md.tmp"
    mv "$TARGET_DIR/AGENTS.md.tmp" "$TARGET_DIR/AGENTS.md"
    echo "    ✅ Installed AGENTS.md"
fi

# PLAYBOOK.md — install if missing, prompt to update otherwise
echo "📝 Configuring PLAYBOOK.md..."
if [ -f "$TARGET_DIR/PLAYBOOK.md" ]; then
    if [ "$UPDATE_MODE" = "true" ]; then
        cp "$SCRIPT_DIR/PLAYBOOK.md" "$TARGET_DIR/PLAYBOOK.md"
        echo "    🔄 Updated PLAYBOOK.md"
    else
        echo ""
        read -p "    PLAYBOOK.md already exists. Update it? (y/N): " UPDATE_PLAYBOOK
        if [ "$UPDATE_PLAYBOOK" = "y" ] || [ "$UPDATE_PLAYBOOK" = "Y" ]; then
            cp "$SCRIPT_DIR/PLAYBOOK.md" "$TARGET_DIR/PLAYBOOK.md"
            echo "    🔄 Updated PLAYBOOK.md"
        else
            echo "    ℹ️  Kept existing PLAYBOOK.md"
        fi
    fi
else
    cp "$SCRIPT_DIR/PLAYBOOK.md" "$TARGET_DIR/PLAYBOOK.md"
    echo "    ✅ Installed PLAYBOOK.md"
fi

# Sample templates for thoughts/
echo "📚 Creating sample templates..."

if [ ! -f "$TARGET_DIR/thoughts/shared/research/TEMPLATE.md" ]; then
cat > "$TARGET_DIR/thoughts/shared/research/TEMPLATE.md" << 'EOF'
---
date: YYYY-MM-DD HH:MM:SS
researcher: GitHub Copilot
topic: "Research Topic"
tags: [research, codebase]
status: complete
---

# Research: [Topic]

## Research Question
[What we're investigating]

## Summary
[High-level findings]

## Detailed Findings
[Specific discoveries with code references — file:line]

## Architecture Insights
[Patterns and design decisions]

## Open Questions
[Areas needing further investigation]
EOF
fi

if [ ! -f "$TARGET_DIR/thoughts/shared/plans/TEMPLATE.md" ]; then
cat > "$TARGET_DIR/thoughts/shared/plans/TEMPLATE.md" << 'EOF'
# Implementation Plan Template

## Overview
[What we're building and why]

## Current State Analysis
[What exists now]

## Desired End State
[What success looks like]

## What We're NOT Doing
[Out-of-scope items]

## Phase 1: [Name]

### Changes Required:
- [File]: [Changes needed]

### Success Criteria:
#### Automated:
- [ ] Tests pass
- [ ] Linting passes

#### Manual:
- [ ] Feature works as expected

## Testing Strategy
[How we'll verify this works]
EOF
fi

echo ""
if [ "$UPDATE_MODE" = "true" ]; then
    echo "🎉 Framework Updated Successfully!"
    echo "==================================="
    echo ""
    echo "Framework updated in: $TARGET_DIR"
    echo ""
    echo "📋 Update Summary:"
    echo "  - .github/prompts/  — workflow prompts overwritten"
    echo "  - .github/agents/   — custom subagents overwritten"
    echo "  - Your thoughts/ documents preserved"
    echo ""
    echo "💡 To revert: git checkout -- .github/ AGENTS.md PLAYBOOK.md"
else
    echo "🎉 Setup Complete!"
    echo "=================="
    echo ""
    echo "Framework installed in: $TARGET_DIR"
    echo ""
    echo "📖 Next Steps:"
    echo "  1. Review $TARGET_DIR/PLAYBOOK.md for usage instructions"
    echo "  2. Open the repo in VS Code (or run \`copilot\` from the repo root)"
    echo "  3. In Copilot Chat, type \`/\` to see the workflow prompts:"
    echo "       /1_research_codebase"
    echo "       /2_create_plan"
    echo "       /3_implement_plan"
    echo ""
    echo "🔄 To update the framework later:"
    echo "    ./setup.sh $TARGET_DIR     # choose option 1"
    echo "  or:"
    echo "    ./update.sh $TARGET_DIR"
fi
echo ""
echo "Happy coding! 🚀"
