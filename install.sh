#!/bin/bash
set -e

# PromptStash Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
# or: wget -qO- https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation directory (customizable via environment variable)
INSTALL_DIR="${PROMPTSTASH_INSTALL_DIR:-${HOME}/.promptstash}"
REPO_URL="https://github.com/korotkevics/promptstash.git"

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   PromptStash Installation Script${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Error: git is not installed${NC}"
    echo "Please install git and try again."
    exit 1
fi

# Clone or update repository
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}⚠ PromptStash is already installed at $INSTALL_DIR${NC}"
    echo "Updating to the latest version..."
    cd "$INSTALL_DIR"
    git fetch --tags
    git pull origin main
    echo -e "${GREEN}✓ Updated successfully!${NC}"
else
    echo "Installing PromptStash to $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    echo -e "${GREEN}✓ Cloned repository successfully!${NC}"
fi

# Make the CLI executable
if [ -f "$INSTALL_DIR/bin/promptstash" ]; then
    chmod +x "$INSTALL_DIR/bin/promptstash"
fi

# Detect shell and rc file
detect_shell() {
    local shell_name=$(basename "$SHELL")
    local rc_file=""
    
    case "$shell_name" in
        bash)
            if [ -f "$HOME/.bashrc" ]; then
                rc_file="$HOME/.bashrc"
            elif [ -f "$HOME/.bash_profile" ]; then
                rc_file="$HOME/.bash_profile"
            elif [ -f "$HOME/.bash_login" ]; then
                rc_file="$HOME/.bash_login"
            elif [ -f "$HOME/.profile" ]; then
                rc_file="$HOME/.profile"
            fi
            ;;
        zsh)
            rc_file="$HOME/.zshrc"
            ;;
        fish)
            rc_file="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo -e "${YELLOW}⚠ Unknown shell: $shell_name${NC}"
            echo "Please manually add the following to your shell's rc file:"
            echo ""
            echo "  export PROMPTSTASH_DIR=\"$INSTALL_DIR/.promptstash\""
            echo "  export PATH=\"\$PATH:$INSTALL_DIR/bin\""
            echo ""
            return 1
            ;;
    esac
    
    echo "$rc_file"
}

# Add to shell rc file
add_to_rc() {
    local rc_file="$1"
    local shell_name="$2"

    if [ -z "$rc_file" ]; then
        return 1
    fi

    # Create rc file if it doesn't exist
    if [ ! -f "$rc_file" ]; then
        touch "$rc_file"
    fi

    # Determine the correct syntax based on shell
    local export_line=""
    local path_line=""

    if [ "$shell_name" = "fish" ]; then
        export_line="set -gx PROMPTSTASH_DIR \"$INSTALL_DIR/.promptstash\""
        path_line="set -gx PATH \$PATH \"$INSTALL_DIR/bin\""
    else
        export_line="export PROMPTSTASH_DIR=\"$INSTALL_DIR/.promptstash\""
        path_line="export PATH=\"\$PATH:$INSTALL_DIR/bin\""
    fi

    # Check if already added (idempotent)
    if grep -q "PROMPTSTASH_DIR.*\.promptstash" "$rc_file"; then
        echo -e "${YELLOW}⚠ PROMPTSTASH_DIR is already configured in $rc_file${NC}"
    else
        echo "" >> "$rc_file"
        echo "# PromptStash" >> "$rc_file"
        echo "$export_line" >> "$rc_file"
        echo -e "${GREEN}✓ Added PROMPTSTASH_DIR to $rc_file${NC}"
    fi

    # Check if PATH is already added
    if grep -q "PATH.*promptstash/bin" "$rc_file"; then
        echo -e "${YELLOW}⚠ PromptStash bin is already in PATH in $rc_file${NC}"
    else
        echo "$path_line" >> "$rc_file"
        echo -e "${GREEN}✓ Added PromptStash bin to PATH in $rc_file${NC}"
    fi
}

# Detect and configure shell
echo ""
echo "Configuring shell environment..."
shell_name=$(basename "$SHELL")
rc_file=$(detect_shell)
if [ $? -eq 0 ] && [ -n "$rc_file" ]; then
    add_to_rc "$rc_file" "$shell_name"
    echo ""
    echo -e "${GREEN}✓ Installation complete!${NC}"
    echo ""
    echo "To start using PromptStash:"
    echo "  1. Reload your shell: source $rc_file"
    echo "  2. Or start a new terminal session"
    echo ""
    echo "Then you can use:"
    echo "  • promptstash self-update    - Update to the latest version"
    echo "  • \$PROMPTSTASH_DIR/commit.md - Access prompts directly"
    echo ""
else
    echo ""
    echo -e "${YELLOW}⚠ Could not automatically configure shell${NC}"
    echo "Please manually add to your shell's rc file:"
    echo ""
    echo "  export PROMPTSTASH_DIR=\"$INSTALL_DIR/.promptstash\""
    echo "  export PATH=\"\$PATH:$INSTALL_DIR/bin\""
    echo ""
fi

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Thank you for installing PromptStash!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
