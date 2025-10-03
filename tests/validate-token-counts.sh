#!/usr/bin/env bash
# Validate that token counts in benchmark table are within reasonable ranges

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Validating token counts in benchmark table..."

# Extract token counts from README benchmark table
# Look for lines like: | **prompt-name** | 123 | ...
TOKEN_COUNTS=$(grep -A 100 "## 📊 Benchmarks" README.md | \
    grep "^| \*\*" | \
    grep -v "^| Prompt |" | \
    grep -v "^| \*\*TOTAL\*\*" | \
    sed 's/|/ /g' | \
    sed 's/<[^>]*>//g' | \
    awk '{for(i=2;i<=NF;i++) if($i ~ /^[0-9]+$/) print $i}')

if [ -z "$TOKEN_COUNTS" ]; then
    echo -e "${RED}✗ No token counts found in benchmark table${NC}"
    exit 1
fi

TOTAL=0
INVALID=0
MIN_TOKENS=10
MAX_TOKENS=10000

for count in $TOKEN_COUNTS; do
    TOTAL=$((TOTAL + 1))

    if [ "$count" -lt $MIN_TOKENS ]; then
        echo -e "${RED}✗${NC} Token count $count is below minimum ($MIN_TOKENS)"
        INVALID=$((INVALID + 1))
    elif [ "$count" -gt $MAX_TOKENS ]; then
        echo -e "${RED}✗${NC} Token count $count exceeds maximum ($MAX_TOKENS)"
        INVALID=$((INVALID + 1))
    fi
done

echo ""
if [ $INVALID -eq 0 ]; then
    echo -e "${GREEN}✓ All $TOTAL token counts are within valid range ($MIN_TOKENS-$MAX_TOKENS)${NC}"
    exit 0
else
    echo -e "${RED}✗ $INVALID of $TOTAL token counts are outside valid range${NC}"
    exit 1
fi
