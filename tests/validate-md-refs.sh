#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Validating markdown cross-references..."

ERRORS=0
CHECKED=0

# Find all markdown files
while IFS= read -r md_file; do
  # Extract references to .md files
  # Matches patterns like: `commit.md`, Follow `commit.md`, etc.
  # Excludes variable references like $VAR/file.md
  while IFS= read -r ref; do
    if [ -n "$ref" ]; then
      # Skip if it contains $ (variable reference)
      if echo "$ref" | grep -q '\$'; then
        continue
      fi

      CHECKED=$((CHECKED + 1))

      # Get directory of the current markdown file
      md_dir=$(dirname "$md_file")

      # Try to resolve the reference
      resolved_path=""

      # Check if it's a path relative to current file
      if [ -f "$md_dir/$ref" ]; then
        resolved_path="$md_dir/$ref"
      # Check if it's relative to repo root
      elif [ -f "$ref" ]; then
        resolved_path="$ref"
      # Check in .promptstash directory
      elif [ -f ".promptstash/$ref" ]; then
        resolved_path=".promptstash/$ref"
      # Check in docs directory
      elif [ -f "docs/$ref" ]; then
        resolved_path="docs/$ref"
      fi

      if [ -z "$resolved_path" ]; then
        # Skip .map_decisions.md as it's optional (can be referenced with any path)
        if [[ "$ref" == *".map_decisions.md" ]]; then
          continue
        fi
        echo -e "${RED}✗ Broken reference in $md_file: $ref${NC}"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done < <(grep -oE '`[^`]*\.md`' "$md_file" | sed 's/`//g' || true)
done < <(find .promptstash -name "*.md")

echo ""
echo "Checked $CHECKED markdown references"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All markdown references are valid!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS broken reference(s)${NC}"
  exit 1
fi
