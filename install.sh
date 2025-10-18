#!/bin/bash
set -e

# PromptStash Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
# or: wget -qO- https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
# Dry run: curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash -s -- --dry-run

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=true
            ;;
    esac
done

# Installation directory (customizable via environment variable)
INSTALL_DIR="${PROMPTSTASH_INSTALL_DIR:-${HOME}/.promptstash}"
REPO_URL="https://github.com/korotkevics/promptstash.git"

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   PromptStash Installation Script${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}🔍 DRY RUN MODE - No changes will be made${NC}"
    echo ""
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Error: git is not installed${NC}"
    echo "Please install git and try again."
    exit 1
fi

# Check Git version for sparse checkout compatibility (requires Git 2.25+)
check_git_version() {
    local git_version=$(git --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
    local major=$(echo "$git_version" | cut -d. -f1)
    local minor=$(echo "$git_version" | cut -d. -f2)

    if [ "$major" -lt 2 ] || ([ "$major" -eq 2 ] && [ "$minor" -lt 25 ]); then
        echo -e "${YELLOW}⚠ Warning: Git version $git_version detected. Sparse checkout requires Git 2.25+ (March 2020).${NC}"
        echo -e "${YELLOW}  Falling back to full repository clone.${NC}"
        return 1
    fi
    return 0
}

USE_SPARSE_CHECKOUT=false
if check_git_version; then
    USE_SPARSE_CHECKOUT=true
fi

# Clone or update repository
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}⚠ PromptStash is already installed at $INSTALL_DIR${NC}"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would update to the latest version:"
        echo "[DRY RUN]   cd $INSTALL_DIR"

        # Check for uncommitted changes
        if ! (cd "$INSTALL_DIR" && git diff-index --quiet HEAD -- 2>/dev/null); then
            echo "[DRY RUN]   ⚠ Warning: Uncommitted changes detected - update would fail"
            uncommitted_files=$(cd "$INSTALL_DIR" && git status --short 2>/dev/null)
            if [ -n "$uncommitted_files" ]; then
                echo "[DRY RUN]   Uncommitted files:"
                echo "$uncommitted_files" | while read -r line; do
                    echo "[DRY RUN]     $line"
                done
            fi
        fi

        echo "[DRY RUN]   git fetch --tags"
        current_branch=$(cd "$INSTALL_DIR" && git branch --show-current)
        if [ "$current_branch" != "main" ]; then
            echo "[DRY RUN]   git checkout main (from branch '$current_branch')"
        fi
        echo "[DRY RUN]   git pull origin main"
    else
        echo "Updating to the latest version..."
        cd "$INSTALL_DIR"
        git fetch --tags

        # Check current branch and switch to main if needed
        current_branch=$(git branch --show-current)
        if [ "$current_branch" != "main" ]; then
            echo "Switching from branch '$current_branch' to 'main'..."
            git checkout main
        fi

        git pull origin main
        echo -e "${GREEN}✓ Updated successfully!${NC}"
    fi
else
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install PromptStash to $INSTALL_DIR:"
        if [ "$USE_SPARSE_CHECKOUT" = true ]; then
            echo "[DRY RUN]   git clone --no-checkout $REPO_URL $INSTALL_DIR"
            echo "[DRY RUN]   Configure sparse checkout for user-facing files only"
        else
            echo "[DRY RUN]   git clone $REPO_URL $INSTALL_DIR"
        fi
    else
        echo "Installing PromptStash to $INSTALL_DIR..."

        if [ "$USE_SPARSE_CHECKOUT" = true ]; then
            # Clone with --no-checkout to configure sparse checkout first
            if ! git clone --no-checkout "$REPO_URL" "$INSTALL_DIR"; then
                echo -e "${RED}✗ Failed to clone repository${NC}"
                exit 1
            fi
            cd "$INSTALL_DIR"

            # Enable sparse checkout
            if ! git sparse-checkout init --cone; then
                echo -e "${RED}✗ Failed to initialize sparse checkout${NC}"
                exit 1
            fi

            # Define user-facing paths only (no tests/, .github/, etc.)
            if ! git sparse-checkout set \
                .promptstash \
                bin \
                docs \
                static \
                .context \
                .gitignore \
                .version \
                LICENSE \
                README.md \
                install.sh; then
                echo -e "${RED}✗ Failed to configure sparse checkout paths${NC}"
                exit 1
            fi

            # Checkout the files
            if ! git checkout main; then
                echo -e "${RED}✗ Failed to checkout files${NC}"
                exit 1
            fi

            echo -e "${GREEN}✓ Installed PromptStash (user-facing files only)${NC}"
        else
            # Fallback: Full clone for older Git versions
            if ! git clone "$REPO_URL" "$INSTALL_DIR"; then
                echo -e "${RED}✗ Failed to clone repository${NC}"
                exit 1
            fi
            echo -e "${GREEN}✓ Installed PromptStash${NC}"
        fi
    fi
fi

# Make the CLI executable
if [ -f "$INSTALL_DIR/bin/promptstash" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would make CLI executable: chmod +x $INSTALL_DIR/bin/promptstash"
    else
        chmod +x "$INSTALL_DIR/bin/promptstash"
    fi
fi

# Run cleanup to remove unnecessary files
if [ "$DRY_RUN" = false ] && [ -x "$INSTALL_DIR/bin/promptstash" ]; then
    echo ""
    echo "Cleaning up unnecessary files..."
    "$INSTALL_DIR/bin/promptstash" cleanup
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
            echo "  export PROMPTSTASH_DIR=\"$INSTALL_DIR\""
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
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would create $rc_file"
        else
            touch "$rc_file"
        fi
    fi

    # Determine the correct syntax based on shell
    local export_line=""
    local path_line=""

    if [ "$shell_name" = "fish" ]; then
        export_line="set -gx PROMPTSTASH_DIR \"$INSTALL_DIR\""
        path_line="set -gx PATH \$PATH \"$INSTALL_DIR/bin\""
    else
        export_line="export PROMPTSTASH_DIR=\"$INSTALL_DIR\""
        path_line="export PATH=\"\$PATH:$INSTALL_DIR/bin\""
    fi

    # Check if already added (idempotent)
    if grep -q "PROMPTSTASH_DIR=" "$rc_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠ PROMPTSTASH_DIR is already configured in $rc_file${NC}"
    else
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would add to $rc_file:"
            echo "[DRY RUN]   # PromptStash"
            echo "[DRY RUN]   $export_line"
        else
            echo "" >> "$rc_file"
            echo "# PromptStash" >> "$rc_file"
            echo "$export_line" >> "$rc_file"
            echo -e "${GREEN}✓ Added PROMPTSTASH_DIR to $rc_file${NC}"
        fi
    fi

    # Check if PATH is already added
    if grep -q "PATH.*\.promptstash/bin" "$rc_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠ PromptStash bin is already in PATH in $rc_file${NC}"
    else
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN]   $path_line"
        else
            echo "$path_line" >> "$rc_file"
            echo -e "${GREEN}✓ Added PromptStash bin to PATH in $rc_file${NC}"
        fi
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
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}✓ Dry run complete!${NC}"
        echo ""
        echo "To actually install, run without --dry-run flag"
    else
        echo -e "${GREEN}✓ Installation complete!${NC}"
        echo ""
        echo "To start using PromptStash:"
        echo "  1. Reload your shell: source $rc_file"
        echo "  2. Or start a new terminal session"
        echo ""
        echo "Then you can use:"
        echo "  • promptstash self-update    - Update to the latest version"
        echo "  • \$PROMPTSTASH_DIR/commit.md - Access prompts directly"
    fi
    echo ""
else
    echo ""
    echo -e "${YELLOW}⚠ Could not automatically configure shell${NC}"
    echo "Please manually add to your shell's rc file:"
    echo ""
    echo "  export PROMPTSTASH_DIR=\"$INSTALL_DIR\""
    echo "  export PATH=\"\$PATH:$INSTALL_DIR/bin\""
    echo ""
fi

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Thank you for installing PromptStash!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
