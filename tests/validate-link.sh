#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Testing link command..."

ERRORS=0
TESTS=0

# Test 1: Verify link_llm function exists
TESTS=$((TESTS + 1))
if grep -q "link_llm()" bin/promptstash; then
  echo -e "${GREEN}✓ link_llm function exists${NC}"
else
  echo -e "${RED}✗ link_llm function missing${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 2: Verify link command is in main handler
TESTS=$((TESTS + 1))
if grep -q "link)" bin/promptstash; then
  echo -e "${GREEN}✓ link command is in main handler${NC}"
else
  echo -e "${RED}✗ link command not in main handler${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 3: Verify link command appears in help
TESTS=$((TESTS + 1))
if ./bin/promptstash help | grep -q "link claude"; then
  echo -e "${GREEN}✓ link command appears in help text${NC}"
else
  echo -e "${RED}✗ link command missing from help text${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 4: Verify link command validates LLM type
TESTS=$((TESTS + 1))
if grep -q 'if \[ "$llm_type" != "claude" \] && \[ "$llm_type" != "copilot" \]' bin/promptstash; then
  echo -e "${GREEN}✓ link command validates LLM type${NC}"
else
  echo -e "${RED}✗ link command doesn't validate LLM type${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 5: Verify link command handles .claude directory
TESTS=$((TESTS + 1))
if grep -q '\.claude' bin/promptstash; then
  echo -e "${GREEN}✓ link command handles .claude directory${NC}"
else
  echo -e "${RED}✗ link command doesn't handle .claude directory${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 6: Verify link command handles .copilot directory
TESTS=$((TESTS + 1))
if grep -q '\.copilot' bin/promptstash; then
  echo -e "${GREEN}✓ link command handles .copilot directory${NC}"
else
  echo -e "${RED}✗ link command doesn't handle .copilot directory${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 7: Verify link command checks for existing promptstash entry
TESTS=$((TESTS + 1))
if grep -q 'grep -Fq "$marker"' bin/promptstash; then
  echo -e "${GREEN}✓ link command checks for existing promptstash entry${NC}"
else
  echo -e "${RED}✗ link command doesn't check for existing entry${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 8: Verify link command handles .gitignore
TESTS=$((TESTS + 1))
if grep -A 200 'link_llm()' bin/promptstash | grep -q 'gitignore'; then
  echo -e "${GREEN}✓ link command handles .gitignore${NC}"
else
  echo -e "${RED}✗ link command doesn't handle .gitignore${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 9: Verify link command confirms directory is project root
TESTS=$((TESTS + 1))
if grep -q 'Is this the project root directory?' bin/promptstash; then
  echo -e "${GREEN}✓ link command confirms project root directory${NC}"
else
  echo -e "${RED}✗ link command doesn't confirm project root${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 10: Verify link command creates proper content with marker
TESTS=$((TESTS + 1))
if grep -A 5 'local content=' bin/promptstash | grep -q 'Global Workflow Instructions'; then
  echo -e "${GREEN}✓ link command creates proper content${NC}"
else
  echo -e "${RED}✗ link command doesn't create proper content${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 11: Functional test - create temp directory and test claude link
TESTS=$((TESTS + 1))
TEMP_TEST_DIR=$(mktemp -d)
cd "$TEMP_TEST_DIR"

# Simulate user input: confirm directory (y), don't add to gitignore (n)
echo -e "y\nn" | "$OLDPWD/bin/promptstash" link claude > /dev/null 2>&1 || true

if [ -f ".claude/CLAUDE.md" ] && grep -q "@" ".claude/CLAUDE.md"; then
  echo -e "${GREEN}✓ Functional test: claude link creates .claude/CLAUDE.md${NC}"
else
  echo -e "${RED}✗ Functional test: claude link failed to create file${NC}"
  ERRORS=$((ERRORS + 1))
fi
cd "$OLDPWD"
rm -rf "$TEMP_TEST_DIR"

# Test 12: Functional test - verify copilot link
TESTS=$((TESTS + 1))
TEMP_TEST_DIR=$(mktemp -d)
cd "$TEMP_TEST_DIR"

# Simulate user input: confirm directory (y), don't add to gitignore (n)
echo -e "y\nn" | "$OLDPWD/bin/promptstash" link copilot > /dev/null 2>&1 || true

if [ -f ".copilot/copilot-instructions.md" ] && grep -q "@" ".copilot/copilot-instructions.md"; then
  echo -e "${GREEN}✓ Functional test: copilot link creates .copilot/copilot-instructions.md${NC}"
else
  echo -e "${RED}✗ Functional test: copilot link failed to create file${NC}"
  ERRORS=$((ERRORS + 1))
fi
cd "$OLDPWD"
rm -rf "$TEMP_TEST_DIR"

# Test 13: Functional test - verify abort on existing entry
TESTS=$((TESTS + 1))
TEMP_TEST_DIR=$(mktemp -d)
cd "$TEMP_TEST_DIR"

# First create a file with the marker
mkdir -p .claude
echo "@${PROMPTSTASH_DIR}/.promptstash" > .claude/CLAUDE.md

# Try to link again - should abort
OUTPUT=$(echo "y" | "$OLDPWD/bin/promptstash" link claude 2>&1 || true)

if echo "$OUTPUT" | grep -q "already linked"; then
  echo -e "${GREEN}✓ Functional test: link aborts when entry already exists${NC}"
else
  echo -e "${RED}✗ Functional test: link doesn't abort on existing entry${NC}"
  ERRORS=$((ERRORS + 1))
fi
cd "$OLDPWD"
rm -rf "$TEMP_TEST_DIR"

# Test 14: Functional test - verify append to existing file
TESTS=$((TESTS + 1))
TEMP_TEST_DIR=$(mktemp -d)
cd "$TEMP_TEST_DIR"

# First create a file without the marker
mkdir -p .claude
echo "# Some other content" > .claude/CLAUDE.md

# Link should append
echo -e "y\nn" | "$OLDPWD/bin/promptstash" link claude > /dev/null 2>&1 || true

if [ -f ".claude/CLAUDE.md" ] && grep -q "Some other content" ".claude/CLAUDE.md" && grep -q "@" ".claude/CLAUDE.md"; then
  echo -e "${GREEN}✓ Functional test: link appends to existing file${NC}"
else
  echo -e "${RED}✗ Functional test: link doesn't append properly${NC}"
  ERRORS=$((ERRORS + 1))
fi
cd "$OLDPWD"
rm -rf "$TEMP_TEST_DIR"

# Summary
echo ""
echo "Tests: $TESTS"
echo "Errors: $ERRORS"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}All link command tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some link command tests failed!${NC}"
  exit 1
fi
