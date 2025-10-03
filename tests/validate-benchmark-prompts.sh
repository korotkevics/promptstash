#!/usr/bin/env bash
# Validate that all prompts mentioned in the benchmark table exist in .promptstash/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Validating benchmark table prompts..."

# Extract prompt names from README benchmark table
# Look for lines like: | **prompt-name** | 123 | ...
PROMPTS=$(grep -A 100 "## 📊 Benchmarks" README.md | \
    grep "^| \*\*" | \
    grep -v "^| Prompt |" | \
    grep -v "^| \*\*TOTAL\*\*" | \
    sed 's/^| \*\*//' | \
    sed 's/\*\*.*//' | \
    sort -u)

if [ -z "$PROMPTS" ]; then
    echo -e "${RED}✗ No prompts found in benchmark table${NC}"
    exit 1
fi

TOTAL=0
MISSING=0

for prompt in $PROMPTS; do
    TOTAL=$((TOTAL + 1))
    FILE=".promptstash/${prompt}.md"

    if [ -f "$FILE" ]; then
        echo -e "${GREEN}✓${NC} $prompt.md exists"
    else
        echo -e "${RED}✗${NC} $prompt.md is missing"
        MISSING=$((MISSING + 1))
    fi
done

echo ""
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ All $TOTAL benchmark prompts exist${NC}"
    exit 0
else
    echo -e "${RED}✗ $MISSING of $TOTAL benchmark prompts are missing${NC}"
    exit 1
fi
