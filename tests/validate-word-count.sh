#!/bin/bash
set -e

# Maximum allowed words per prompt
MAX_WORDS=450

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Validating word counts in prompt files..."

ERRORS=0
CHECKED=0
VIOLATIONS=()

# Find all markdown files in .promptstash
while IFS= read -r md_file; do
  filename=$(basename "$md_file")

  # Exclude optimize-prompt.md from checking
  if [ "$filename" = "optimize-prompt.md" ]; then
    continue
  fi

  CHECKED=$((CHECKED + 1))
  word_count=$(wc -w < "$md_file" | tr -d ' ')

  if [ "$word_count" -gt "$MAX_WORDS" ]; then
    ERRORS=$((ERRORS + 1))
    VIOLATIONS+=("$filename: $word_count words (exceeds limit by $((word_count - MAX_WORDS)))")
  fi
done < <(find .promptstash -name "*.md")

echo ""
echo "Checked $CHECKED prompt files"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All prompts are within the $MAX_WORDS word limit!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS prompt(s) exceeding the $MAX_WORDS word limit:${NC}"
  echo ""
  for violation in "${VIOLATIONS[@]}"; do
    echo -e "  ${YELLOW}•${NC} $violation"
  done
  echo ""
  echo -e "${YELLOW}Suggestions:${NC}"
  echo "  1. Run optimize-prompt.md on the listed prompts to reduce word count"
  echo "  2. If the word count is justified, increase MAX_WORDS in tests/validate-word-count.sh"
  exit 1
fi
