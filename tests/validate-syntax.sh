#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Validating code syntax in markdown files..."

ERRORS=0
CHECKED=0

# Clean up any existing temp files
rm -f /tmp/bash_snippet_*.sh

# Find all markdown files
while IFS= read -r md_file; do
  # Create unique temp directory for this file
  TEMP_DIR="/tmp/bash_syntax_$$_$(date +%s%N)"
  mkdir -p "$TEMP_DIR"

  # Extract bash code blocks using sed
  # Split file into segments at ```bash and ``` markers
  sed -n '/```bash/,/```/p' "$md_file" | \
    awk -v temp_dir="$TEMP_DIR" '
      /```bash/ {
        if (NR > 1 && block != "") {
          # Save previous block
          counter++
          file = temp_dir "/snippet_" counter ".sh"
          print block > file
          close(file)
        }
        in_block=1
        block=""
        next
      }
      /```/ && in_block {
        # End of block
        counter++
        file = temp_dir "/snippet_" counter ".sh"
        print block > file
        close(file)
        in_block=0
        block=""
        next
      }
      in_block {
        block = (block == "" ? $0 : block "\n" $0)
      }
    '

  # Validate each extracted bash snippet from this file
  snippet_count=0
  for snippet in "$TEMP_DIR"/snippet_*.sh; do
    if [ -f "$snippet" ] && [ -s "$snippet" ]; then
      snippet_count=$((snippet_count + 1))

      # Skip validation if block contains placeholders like <variable>
      if grep -q '<[A-Z_-]*>' "$snippet"; then
        continue
      fi

      CHECKED=$((CHECKED + 1))
      if ! bash -n "$snippet" 2>/dev/null; then
        echo -e "${RED}✗ Syntax error in $md_file (block #$snippet_count)${NC}"
        bash -n "$snippet" 2>&1 | head -5
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done

  # Clean up temp directory
  rm -rf "$TEMP_DIR"
done < <(find .promptstash -name "*.md")

echo ""
echo "Checked $CHECKED bash code blocks"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All code syntax is valid!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS syntax error(s)${NC}"
  exit 1
fi
