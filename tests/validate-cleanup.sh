#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Testing cleanup functionality..."

ERRORS=0
TESTS=0

# Test 1: Verify cleanup command exists
TESTS=$((TESTS + 1))
if grep -q "check_alien_files" bin/promptstash; then
  echo -e "${GREEN}✓ check_alien_files function exists${NC}"
else
  echo -e "${RED}✗ check_alien_files function is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 2: Verify cleanup is registered as a command
TESTS=$((TESTS + 1))
if grep -q "cleanup)" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup command is registered${NC}"
else
  echo -e "${RED}✗ cleanup command is not registered${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 3: Verify help message includes cleanup
TESTS=$((TESTS + 1))
CLI_HELP=$(./bin/promptstash help)
if echo "$CLI_HELP" | grep -q "cleanup"; then
  echo -e "${GREEN}✓ CLI help includes cleanup command${NC}"
else
  echo -e "${RED}✗ CLI help missing cleanup command${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 4: Verify alien patterns are defined
TESTS=$((TESTS + 1))
if grep -q "alien_patterns=" bin/promptstash; then
  echo -e "${GREEN}✓ alien_patterns array is defined${NC}"
else
  echo -e "${RED}✗ alien_patterns array is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 5: Verify tests directory is in alien patterns
TESTS=$((TESTS + 1))
if grep -A 10 "alien_patterns=" bin/promptstash | grep -q '"tests"'; then
  echo -e "${GREEN}✓ tests directory is marked as alien${NC}"
else
  echo -e "${RED}✗ tests directory is not in alien patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 6: Verify .github directory is in alien patterns
TESTS=$((TESTS + 1))
if grep -A 10 "alien_patterns=" bin/promptstash | grep -q '".github"'; then
  echo -e "${GREEN}✓ .github directory is marked as alien${NC}"
else
  echo -e "${RED}✗ .github directory is not in alien patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 7: Verify .benchmark directory is in alien patterns
TESTS=$((TESTS + 1))
if grep -A 10 "alien_patterns=" bin/promptstash | grep -q '".benchmark"'; then
  echo -e "${GREEN}✓ .benchmark directory is marked as alien${NC}"
else
  echo -e "${RED}✗ .benchmark directory is not in alien patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 8: Verify preference file handling exists
TESTS=$((TESTS + 1))
if grep -q ".promptstash_cleanup_pref" bin/promptstash; then
  echo -e "${GREEN}✓ preference file handling exists${NC}"
else
  echo -e "${RED}✗ preference file handling is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 9: Verify install.sh calls cleanup
TESTS=$((TESTS + 1))
if grep -q "promptstash.*cleanup" install.sh; then
  echo -e "${GREEN}✓ install.sh calls cleanup command${NC}"
else
  echo -e "${RED}✗ install.sh doesn't call cleanup${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 10: Verify cleanup function handles no alien files case
TESTS=$((TESTS + 1))
if grep -q "If no alien files found" bin/promptstash || grep -q "# If no alien files" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup handles no alien files case${NC}"
else
  echo -e "${RED}✗ cleanup missing no-files handling${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 11: Verify user can opt for "never ask again"
TESTS=$((TESTS + 1))
if grep -q "3.*never" bin/promptstash && grep -q "Never ask again" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup includes 'never ask again' option${NC}"
else
  echo -e "${RED}✗ cleanup missing 'never ask again' option${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 12: Verify colored output for alien files
TESTS=$((TESTS + 1))
if grep -q "YELLOW.*Found unnecessary files" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup uses colored output for warnings${NC}"
else
  echo -e "${RED}✗ cleanup missing colored warnings${NC}"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "Ran $TESTS tests"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All cleanup tests passed!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
  exit 1
fi
