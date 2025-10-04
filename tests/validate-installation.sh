#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Testing installation features..."

ERRORS=0
TESTS=0

# Test 1: Verify install.sh exists and is executable
TESTS=$((TESTS + 1))
if [ -f "install.sh" ] && [ -x "install.sh" ]; then
  echo -e "${GREEN}✓ install.sh exists and is executable${NC}"
else
  echo -e "${RED}✗ install.sh is missing or not executable${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 2: Verify promptstash CLI exists and is executable
TESTS=$((TESTS + 1))
if [ -f "bin/promptstash" ] && [ -x "bin/promptstash" ]; then
  echo -e "${GREEN}✓ bin/promptstash exists and is executable${NC}"
else
  echo -e "${RED}✗ bin/promptstash is missing or not executable${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 3: Verify install.sh has proper shell safety
TESTS=$((TESTS + 1))
if grep -q "set -e" install.sh; then
  echo -e "${GREEN}✓ install.sh uses 'set -e' for safety${NC}"
else
  echo -e "${RED}✗ install.sh missing 'set -e'${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 4: Verify install.sh checks for git
TESTS=$((TESTS + 1))
if grep -q "command -v git" install.sh; then
  echo -e "${GREEN}✓ install.sh checks for git installation${NC}"
else
  echo -e "${RED}✗ install.sh doesn't check for git${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 5: Verify install.sh supports idempotency
TESTS=$((TESTS + 1))
if grep -q "PROMPTSTASH_DIR=" install.sh; then
  echo -e "${GREEN}✓ install.sh checks for existing configuration${NC}"
else
  echo -e "${RED}✗ install.sh missing idempotency check${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 6: Verify CLI has self-update command
TESTS=$((TESTS + 1))
if grep -q "self-update" bin/promptstash; then
  echo -e "${GREEN}✓ CLI includes self-update command${NC}"
else
  echo -e "${RED}✗ CLI missing self-update command${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 7: Verify CLI has version command
TESTS=$((TESTS + 1))
if grep -q "show_version" bin/promptstash; then
  echo -e "${GREEN}✓ CLI includes version command${NC}"
else
  echo -e "${RED}✗ CLI missing version command${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 8: Verify CLI respects PROMPTSTASH_NO_UPDATE_CHECK
TESTS=$((TESTS + 1))
if grep -q "PROMPTSTASH_NO_UPDATE_CHECK" bin/promptstash; then
  echo -e "${GREEN}✓ CLI respects PROMPTSTASH_NO_UPDATE_CHECK${NC}"
else
  echo -e "${RED}✗ CLI doesn't check PROMPTSTASH_NO_UPDATE_CHECK${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 9: Verify CLI check_for_updates function exists
TESTS=$((TESTS + 1))
if grep -q "check_for_updates" bin/promptstash; then
  echo -e "${GREEN}✓ CLI includes update checking functionality${NC}"
else
  echo -e "${RED}✗ CLI missing update check functionality${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 10: Test CLI help command
TESTS=$((TESTS + 1))
if ./bin/promptstash help > /dev/null 2>&1; then
  echo -e "${GREEN}✓ CLI help command works${NC}"
else
  echo -e "${RED}✗ CLI help command failed${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 11: Test CLI version command
TESTS=$((TESTS + 1))
if ./bin/promptstash version > /dev/null 2>&1; then
  echo -e "${GREEN}✓ CLI version command works${NC}"
else
  echo -e "${RED}✗ CLI version command failed${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 12: Verify install.sh supports both bash and zsh
TESTS=$((TESTS + 1))
if grep -q "bash)" install.sh && grep -q "zsh)" install.sh; then
  echo -e "${GREEN}✓ install.sh supports bash and zsh detection${NC}"
else
  echo -e "${RED}✗ install.sh missing bash/zsh detection${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 13: Verify .version file exists
TESTS=$((TESTS + 1))
if [ -f ".version" ]; then
  echo -e "${GREEN}✓ .version file exists${NC}"
else
  echo -e "${RED}✗ .version file is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 14: Verify install.sh has proper error handling for unknown shells
TESTS=$((TESTS + 1))
if grep -q "Unknown shell" install.sh; then
  echo -e "${GREEN}✓ install.sh handles unknown shells gracefully${NC}"
else
  echo -e "${RED}✗ install.sh missing unknown shell handling${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 15: Verify CLI help output is informative
TESTS=$((TESTS + 1))
CLI_HELP=$(./bin/promptstash help)
if echo "$CLI_HELP" | grep -q "self-update" && echo "$CLI_HELP" | grep -q "version"; then
  echo -e "${GREEN}✓ CLI help output includes all commands${NC}"
else
  echo -e "${RED}✗ CLI help output incomplete${NC}"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "Ran $TESTS tests"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All installation tests passed!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
  exit 1
fi
