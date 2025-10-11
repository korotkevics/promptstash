#!/bin/bash
set -e

# PromptStash Claude Code Integration Setup Script
# This script configures Claude Code to work seamlessly with PromptStash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   PromptStash Claude Code Integration Setup${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

# Check if PROMPTSTASH_DIR is set
if [ -z "$PROMPTSTASH_DIR" ]; then
    echo -e "${RED}✗ Error: PROMPTSTASH_DIR environment variable is not set${NC}"
    echo "Please run the PromptStash installer first or set PROMPTSTASH_DIR manually."
    exit 1
fi

# Detect Claude Code config directory
CLAUDE_CONFIG_DIR="$HOME/.claude"
CLAUDE_JSON="$CLAUDE_CONFIG_DIR/config.json"
CLAUDE_MD="$CLAUDE_CONFIG_DIR/CLAUDE.md"

# Create Claude config directory if it doesn't exist
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo "Creating Claude Code config directory at $CLAUDE_CONFIG_DIR..."
    mkdir -p "$CLAUDE_CONFIG_DIR"
    echo -e "${GREEN}✓ Created directory${NC}"
fi

# Function to update Claude JSON config
update_claude_json() {
    local json_file="$1"
    local promptstash_path="$PROMPTSTASH_DIR/.promptstash"

    # If config.json doesn't exist, create it with our permissions
    if [ ! -f "$json_file" ]; then
        echo "Creating new config.json with PromptStash permissions..."
        cat > "$json_file" << EOF
{
  "permissions": {
    "additionalDirectories": [
      "$promptstash_path/**"
    ]
  }
}
EOF
        echo -e "${GREEN}✓ Created config.json${NC}"
        return 0
    fi

    # Config exists - check if we need to update it
    echo "Checking existing config.json..."

    # Check if jq is available for JSON manipulation
    if command -v jq &> /dev/null; then
        # Check if our path is already in the config
        if jq -e --arg path "$promptstash_path/**" '.permissions.additionalDirectories[]? | select(. == $path)' "$json_file" &> /dev/null; then
            echo -e "${YELLOW}⚠ PromptStash directory is already in Claude Code config${NC}"
            return 0
        fi

        # Add our path to the additionalDirectories array
        echo "Adding PromptStash directory to config.json..."
        tmpfile=$(mktemp)
        jq --arg path "$promptstash_path/**" \
           '.permissions.additionalDirectories //= [] | .permissions.additionalDirectories += [$path] | .permissions.additionalDirectories |= unique' \
           "$json_file" > "$tmpfile" && mv "$tmpfile" "$json_file"
        echo -e "${GREEN}✓ Updated config.json${NC}"
    else
        # Fallback: Python-based JSON editing without jq
        echo -e "${YELLOW}⚠ jq not found - using Python fallback${NC}"

        # Check if our path already exists
        if grep -F -q "$promptstash_path/**" "$json_file" 2>/dev/null; then
            echo -e "${YELLOW}⚠ PromptStash directory appears to be in Claude Code config${NC}"
            return 0
        fi

        # Try Python-based JSON manipulation
        if command -v python3 &> /dev/null; then
            echo "Adding PromptStash directory to config.json using Python..."
            python3 << EOF
import json
import sys

try:
    with open("$json_file", "r") as f:
        config = json.load(f)

    # Ensure permissions and additionalDirectories exist
    if "permissions" not in config:
        config["permissions"] = {}
    if "additionalDirectories" not in config["permissions"]:
        config["permissions"]["additionalDirectories"] = []

    # Add our path if not already present
    path = "$promptstash_path/**"
    if path not in config["permissions"]["additionalDirectories"]:
        config["permissions"]["additionalDirectories"].append(path)

    with open("$json_file", "w") as f:
        json.dump(config, f, indent=2)

    print("success")
except Exception as e:
    print(f"error: {e}", file=sys.stderr)
    sys.exit(1)
EOF
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Updated config.json${NC}"
                return 0
            else
                echo -e "${RED}✗ Python update failed${NC}"
            fi
        fi

        # Final fallback: manual instructions
        echo -e "${YELLOW}⚠ Automatic update unavailable (missing jq and python3)${NC}"
        echo "Please manually add the following to your $json_file:"
        echo ""
        echo '  "permissions": {'
        echo '    "additionalDirectories": ['
        echo "      \"$promptstash_path/**\""
        echo '    ]'
        echo '  }'
        echo ""
        return 1
    fi
}

# Function to update CLAUDE.md
update_claude_md() {
    local md_file="$1"

    # Content to add
    # Use the resolved path for PROMPTSTASH_DIR to avoid assuming Claude Code expands environment variables.
    local content=$(cat <<EOF
# User Memory

## Global Workflow Instructions

Always reference all workflow documentation from the prompt stash directory:

@${PROMPTSTASH_DIR}/.promptstash
EOF
)

    # If CLAUDE.md doesn't exist, create it with our content
    if [ ! -f "$md_file" ]; then
        echo "Creating new CLAUDE.md with PromptStash instructions..."
        echo "$content" > "$md_file"
        echo -e "${GREEN}✓ Created CLAUDE.md${NC}"
        return 0
    fi

    # Check if our content already exists
    if grep -Fq "@${PROMPTSTASH_DIR}/.promptstash" "$md_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠ PromptStash instructions are already in CLAUDE.md${NC}"
        return 0
    fi

    # Append our content to the existing file
    echo "Updating existing CLAUDE.md..."
    echo "" >> "$md_file"
    echo "$content" >> "$md_file"
    echo -e "${GREEN}✓ Updated CLAUDE.md${NC}"
}

# Main execution
echo "Setting up Claude Code integration..."
echo ""

# Update config.json
update_claude_json "$CLAUDE_JSON"
echo ""

# Update CLAUDE.md
update_claude_md "$CLAUDE_MD"
echo ""

echo -e "${GREEN}✓ Claude Code integration setup complete!${NC}"
echo ""
echo "Files configured:"
echo "  • $CLAUDE_JSON"
echo "  • $CLAUDE_MD"
echo ""
echo "Claude Code will now have access to your PromptStash workflows."
echo "Restart Claude Code if it's currently running."
echo ""

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Setup Complete!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
