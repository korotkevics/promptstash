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

# Test 4: Verify essential patterns are defined (whitelist approach)
TESTS=$((TESTS + 1))
if grep -q "essential_patterns=" bin/promptstash; then
  echo -e "${GREEN}✓ essential_patterns array is defined${NC}"
else
  echo -e "${RED}✗ essential_patterns array is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 5: Verify .promptstash is marked as essential
TESTS=$((TESTS + 1))
if awk '/essential_patterns=\(/{flag=1; next} flag && /^\s*\)/{flag=0} flag' bin/promptstash | grep -q '".promptstash"'; then
  echo -e "${GREEN}✓ .promptstash directory is marked as essential${NC}"
else
  echo -e "${RED}✗ .promptstash directory is not in essential patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 6: Verify bin is marked as essential
TESTS=$((TESTS + 1))
if awk '/essential_patterns=\(/{flag=1; next} flag && /^\s*\)/{flag=0} flag' bin/promptstash | grep -q '"bin"'; then
  echo -e "${GREEN}✓ bin directory is marked as essential${NC}"
else
  echo -e "${RED}✗ bin directory is not in essential patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 7: Verify .git is marked as essential
TESTS=$((TESTS + 1))
if awk '/essential_patterns=\(/{flag=1; next} flag && /^\s*\)/{flag=0} flag' bin/promptstash | grep -q '".git"'; then
  echo -e "${GREEN}✓ .git directory is marked as essential${NC}"
else
  echo -e "${RED}✗ .git directory is not in essential patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 8: Verify .gitignore is marked as essential
TESTS=$((TESTS + 1))
if awk '/essential_patterns=\(/{flag=1; next} flag && /^\s*\)/{flag=0} flag' bin/promptstash | grep -q '".gitignore"'; then
  echo -e "${GREEN}✓ .gitignore file is marked as essential${NC}"
else
  echo -e "${RED}✗ .gitignore file is not in essential patterns${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 9: Verify preference file handling exists
TESTS=$((TESTS + 1))
if grep -q ".promptstash_cleanup_pref" bin/promptstash; then
  echo -e "${GREEN}✓ preference file handling exists${NC}"
else
  echo -e "${RED}✗ preference file handling is missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 10: Verify install.sh calls cleanup
TESTS=$((TESTS + 1))
if grep -q "promptstash.*cleanup" install.sh; then
  echo -e "${GREEN}✓ install.sh calls cleanup command${NC}"
else
  echo -e "${RED}✗ install.sh doesn't call cleanup${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 11: Verify cleanup function handles no alien files case
TESTS=$((TESTS + 1))
if grep -q "no alien files" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup handles no alien files case${NC}"
else
  echo -e "${RED}✗ cleanup missing no-files handling${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 12: Verify user can opt for "never ask again"
TESTS=$((TESTS + 1))
if grep -qi "never ask again" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup includes 'never ask again' option${NC}"
else
  echo -e "${RED}✗ cleanup missing 'never ask again' option${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 13: Verify warning message for alien files
TESTS=$((TESTS + 1))
if grep -q "Found unrelated files" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup issues warning for unrelated files${NC}"
else
  echo -e "${RED}✗ cleanup missing warning for unrelated files${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 14: Verify self-update calls cleanup
TESTS=$((TESTS + 1))
if awk '/^[[:space:]]*self_update[[:space:]]*\(\)[[:space:]]*{/{flag=1; brace=1; next} flag{brace+=gsub(/{/,"{")-gsub(/}/,"}"); if(brace==0){flag=0} if(flag) print}' bin/promptstash | grep -q "check_alien_files"; then
  echo -e "${GREEN}✓ self-update calls cleanup after update${NC}"
else
  echo -e "${RED}✗ self-update doesn't call cleanup${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 15: Verify self-update checks specific paths (not all files)
TESTS=$((TESTS + 1))
self_update_content=$(awk '/^[[:space:]]*self_update[[:space:]]*\(\)[[:space:]]*{/{flag=1; brace=1; next} flag{brace+=gsub(/{/,"{")-gsub(/}/,"}"); if(brace==0){flag=0} if(flag) print}' bin/promptstash)
if echo "$self_update_content" | grep -q 'git diff-index.*--.*"\$path"' && echo "$self_update_content" | grep -q '\.promptstash'; then
  echo -e "${GREEN}✓ self-update checks specific whitelisted paths${NC}"
else
  echo -e "${RED}✗ self-update doesn't check whitelisted paths only${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 16: Verify deleted aliens tracking file is referenced
TESTS=$((TESTS + 1))
if grep -q ".promptstash_deleted_aliens" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup tracks deleted alien files${NC}"
else
  echo -e "${RED}✗ cleanup doesn't track deleted alien files${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 17: Verify cleanup saves deleted aliens to tracking file
TESTS=$((TESTS + 1))
if grep -q 'echo "\$alien" >> "\$deleted_file"' bin/promptstash; then
  echo -e "${GREEN}✓ cleanup saves deleted aliens to tracking file${NC}"
else
  echo -e "${RED}✗ cleanup doesn't save deleted aliens${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 18: Verify cleanup loads previously deleted aliens
TESTS=$((TESTS + 1))
if grep -q "while IFS= read -r line" bin/promptstash && grep -q "deleted_aliens" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup loads previously deleted aliens${NC}"
else
  echo -e "${RED}✗ cleanup doesn't load previously deleted aliens${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 19: Verify cleanup filters out previously deleted aliens
TESTS=$((TESTS + 1))
if grep -q "was_deleted=false" bin/promptstash && grep -q "was_deleted=true" bin/promptstash; then
  echo -e "${GREEN}✓ cleanup filters out previously deleted aliens${NC}"
else
  echo -e "${RED}✗ cleanup doesn't filter previously deleted aliens${NC}"
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
