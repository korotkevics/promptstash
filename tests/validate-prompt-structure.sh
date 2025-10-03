#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Validating prompt structure..."

ERRORS=0
WARNINGS=0
CHECKED=0

# Find all markdown files in .promptstash
while IFS= read -r md_file; do
  CHECKED=$((CHECKED + 1))
  filename=$(basename "$md_file")

  # Check if file starts with a descriptive line (not a heading)
  first_line=$(head -n 1 "$md_file")
  if [[ ! "$first_line" =~ ^As\ a\ .*|^# ]]; then
    echo -e "${YELLOW}⚠ $filename: First line should describe the prompt's purpose${NC}"
    WARNINGS=$((WARNINGS + 1))
  fi

  # Check for numbered steps (prompts should have clear workflow)
  if ! grep -qE '^[0-9]+\.' "$md_file"; then
    echo -e "${RED}✗ $filename: Missing numbered steps for workflow${NC}"
    ERRORS=$((ERRORS + 1))
  fi

  # Check for trailing whitespace
  if grep -q '[[:space:]]$' "$md_file"; then
    echo -e "${YELLOW}⚠ $filename: Contains trailing whitespace${NC}"
    WARNINGS=$((WARNINGS + 1))
  fi

  # Check for blank file
  if [ ! -s "$md_file" ]; then
    echo -e "${RED}✗ $filename: File is empty${NC}"
    ERRORS=$((ERRORS + 1))
  fi

  # Check for proper emoji encoding (UTF-8 validity)
  if ! iconv -f UTF-8 -t UTF-8 "$md_file" >/dev/null 2>&1; then
    echo -e "${RED}✗ $filename: Contains invalid UTF-8 encoding (emojis may be corrupted)${NC}"
    ERRORS=$((ERRORS + 1))
  fi

done < <(find .promptstash -name "*.md")

echo ""
echo "Checked $CHECKED prompt files"

if [ $WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}⚠ Found $WARNINGS warning(s)${NC}"
fi

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All prompt structures are valid!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS structural error(s)${NC}"
  exit 1
fi