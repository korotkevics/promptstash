#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Validating CLI documentation coverage..."

ERRORS=0
CHECKED=0

# CLI commands that should be documented
# Format: "command" or "command subcommand" or "command subcommand <arg>"
declare -a COMMANDS=(
  "list"
  "pick name"
  "pick content"
  "pick path"
  "search <query>"
  "search name <query>"
  "search content <query>"
  "search path <query>"
  "match name <pattern>"
  "match content <pattern>"
  "match path <pattern>"
  "self-update"
  "cleanup"
  "version"
  "help"
)

CLI_DOCS="docs/cli-usage.md"

if [ ! -f "$CLI_DOCS" ]; then
  echo -e "${RED}✗ CLI documentation file not found: $CLI_DOCS${NC}"
  exit 1
fi

# Read the docs file once
DOCS_CONTENT=$(cat "$CLI_DOCS")

# Check each command
for cmd in "${COMMANDS[@]}"; do
  CHECKED=$((CHECKED + 1))

  # Create search pattern: `promptstash command`
  search_pattern="promptstash $cmd"

  if ! echo "$DOCS_CONTENT" | grep -q "$search_pattern"; then
    echo -e "${RED}✗ Missing documentation for: promptstash $cmd${NC}"
    ERRORS=$((ERRORS + 1))
  fi
done

echo ""
echo "Checked $CHECKED CLI commands"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All CLI commands are documented in $CLI_DOCS!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS undocumented command(s)${NC}"
  exit 1
fi
