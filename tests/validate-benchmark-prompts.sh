#!/usr/bin/env bash
# Validate that all prompts mentioned in the benchmark table exist in .promptstash/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Validating benchmark table prompts..."

# Extract benchmark table content
BENCHMARK_TABLE=$(grep -A 100 "## 📊 Benchmarks" README.md | \
    grep "^| \*\*" | \
    grep -v "^| Prompt |" | \
    grep -v "^| \*\*TOTAL\*\*")

if [ -z "$BENCHMARK_TABLE" ]; then
    echo -e "${RED}✗ No prompts found in benchmark table${NC}"
    exit 1
fi

TOTAL=0
MISSING=0
SKIPPED=0

# Process each line to extract prompt name and check if it exists in latest version
while IFS= read -r line; do
    # Extract prompt name (between first pair of **)
    prompt=$(echo "$line" | sed 's/^| \*\*//' | sed 's/\*\*.*//')

    # Extract the first version column value (4th column after Prompt, Cost, Entropy)
    # Split by | and get the 4th field, then strip whitespace and HTML
    latest_value=$(echo "$line" | awk -F'|' '{print $4}' | sed 's/<[^>]*>//g' | tr -d ' ')

    # If latest version shows "-", it's a historical prompt that no longer exists
    if [ "$latest_value" = "-" ]; then
        echo -e "${YELLOW}⊘${NC} $prompt.md is historical (not in latest version)"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    TOTAL=$((TOTAL + 1))
    FILE=".promptstash/${prompt}.md"

    if [ -f "$FILE" ]; then
        echo -e "${GREEN}✓${NC} $prompt.md exists"
    else
        echo -e "${RED}✗${NC} $prompt.md is missing"
        MISSING=$((MISSING + 1))
    fi
done <<< "$BENCHMARK_TABLE"

echo ""
if [ $SKIPPED -gt 0 ]; then
    echo -e "${YELLOW}ℹ Skipped $SKIPPED historical prompt(s)${NC}"
fi

if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ All $TOTAL current benchmark prompts exist${NC}"
    exit 0
else
    echo -e "${RED}✗ $MISSING of $TOTAL current benchmark prompts are missing${NC}"
    exit 1
fi
