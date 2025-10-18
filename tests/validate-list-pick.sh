#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Testing list and pick commands functionality..."

ERRORS=0
TESTS=0

# Test 1: Verify list_prompts function exists
TESTS=$((TESTS + 1))
if grep -q "list_prompts" bin/promptstash; then
  echo -e "${GREEN}✓ list_prompts function exists${NC}"
else
  echo -e "${RED}✗ list_prompts function is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 2: Verify pick_prompts function exists
TESTS=$((TESTS + 1))
if grep -q "pick_prompts" bin/promptstash; then
  echo -e "${GREEN}✓ pick_prompts function exists${NC}"
else
  echo -e "${RED}✗ pick_prompts function is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 3: Verify list command is registered
TESTS=$((TESTS + 1))
if grep -q "list)" bin/promptstash; then
  echo -e "${GREEN}✓ list command is registered${NC}"
else
  echo -e "${RED}✗ list command is not registered${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 4: Verify pick command is registered
TESTS=$((TESTS + 1))
if grep -q "pick)" bin/promptstash; then
  echo -e "${GREEN}✓ pick command is registered${NC}"
else
  echo -e "${RED}✗ pick command is not registered${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 5: Verify help message includes list command
TESTS=$((TESTS + 1))
CLI_HELP=$(./bin/promptstash help)
if echo "$CLI_HELP" | grep -q "list"; then
  echo -e "${GREEN}✓ CLI help includes list command${NC}"
else
  echo -e "${RED}✗ CLI help missing list command${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 6: Verify help message includes pick command
TESTS=$((TESTS + 1))
if echo "$CLI_HELP" | grep -q "pick"; then
  echo -e "${GREEN}✓ CLI help includes pick command${NC}"
else
  echo -e "${RED}✗ CLI help missing pick command${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 7: Verify pick command supports 'name' subcommand
TESTS=$((TESTS + 1))
if grep -q "name)" bin/promptstash; then
  echo -e "${GREEN}✓ pick command supports 'name' subcommand${NC}"
else
  echo -e "${RED}✗ pick command missing 'name' subcommand${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 8: Verify pick command supports 'content' subcommand
TESTS=$((TESTS + 1))
if grep -q "content)" bin/promptstash; then
  echo -e "${GREEN}✓ pick command supports 'content' subcommand${NC}"
else
  echo -e "${RED}✗ pick command missing 'content' subcommand${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 9: Verify pick command supports 'path' subcommand
TESTS=$((TESTS + 1))
if grep -q "path)" bin/promptstash; then
  echo -e "${GREEN}✓ pick command supports 'path' subcommand${NC}"
else
  echo -e "${RED}✗ pick command missing 'path' subcommand${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 10: Verify clipboard detection (pbcopy or xclip)
TESTS=$((TESTS + 1))
if grep -q "pbcopy\|xclip\|wl-copy" bin/promptstash; then
  echo -e "${GREEN}✓ clipboard command detection exists${NC}"
else
  echo -e "${RED}✗ clipboard command detection is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 11: Verify PROMPTSTASH_DIR is used for finding prompts
TESTS=$((TESTS + 1))
if grep -Eq 'INSTALL_DIR/\.promptstash|PROMPTSTASH_DIR' bin/promptstash; then
  echo -e "${GREEN}✓ uses proper prompt directory${NC}"
else
  echo -e "${RED}✗ prompt directory path is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 12: Verify error handling for invalid pick input
TESTS=$((TESTS + 1))
if grep -q "Invalid\|invalid" bin/promptstash; then
  echo -e "${GREEN}✓ includes input validation${NC}"
else
  echo -e "${RED}✗ input validation is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 13: Verify success message when copying to clipboard
TESTS=$((TESTS + 1))
if grep -q "clipboard\|Copied" bin/promptstash; then
  echo -e "${GREEN}✓ includes clipboard success message${NC}"
else
  echo -e "${RED}✗ clipboard success message is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 14: Verify alphanumeric sorting for list command
TESTS=$((TESTS + 1))
if grep -q "sort" bin/promptstash; then
  echo -e "${GREEN}✓ includes sorting functionality${NC}"
else
  echo -e "${RED}✗ sorting functionality is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 15: Verify numbered list output for pick commands
TESTS=$((TESTS + 1))
if grep -q "printf.*%.*d" bin/promptstash; then
  echo -e "${GREEN}✓ includes numbered list formatting${NC}"
else
  echo -e "${RED}✗ numbered list formatting is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "Ran $TESTS tests"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All list and pick tests passed!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
  exit 1
fi