#!/bin/bash
# Integration test for self-update with generated files
# This test verifies that self-update works even when generated files are modified

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Testing self-update with generated files..."

ERRORS=0
TESTS=0

# Save current git state
echo "Saving current git state..."
ORIGINAL_BRANCH=$(git branch --show-current)
ORIGINAL_COMMIT=$(git rev-parse HEAD)

# Ensure we're on a clean state for testing
git stash --include-untracked > /dev/null 2>&1 || true

# Test 1: Verify self-update check passes with no changes
TESTS=$((TESTS + 1))
if git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
  echo -e "${GREEN}✓ Test 1: self-update check passes with no changes${NC}"
else
  echo -e "${RED}✗ Test 1: self-update check failed with no changes${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Test 2: Modify README.md (generated file) and verify check still passes
TESTS=$((TESTS + 1))
echo "# Test modification" >> README.md
if git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
  echo -e "${GREEN}✓ Test 2: self-update check passes with README.md modified${NC}"
else
  echo -e "${RED}✗ Test 2: self-update check failed with README.md modified${NC}"
  ERRORS=$((ERRORS + 1))
fi
git checkout README.md > /dev/null 2>&1

# Test 3: Modify .benchmark/data.json and verify check still passes
TESTS=$((TESTS + 1))
echo '{"test": true}' > .benchmark/data.json
if git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
  echo -e "${GREEN}✓ Test 3: self-update check passes with .benchmark/data.json modified${NC}"
else
  echo -e "${RED}✗ Test 3: self-update check failed with .benchmark/data.json modified${NC}"
  ERRORS=$((ERRORS + 1))
fi
git checkout .benchmark/data.json > /dev/null 2>&1

# Test 4: Modify static/prompt-graph.svg and verify check still passes
TESTS=$((TESTS + 1))
if [ -f static/prompt-graph.svg ]; then
  echo "<!-- test -->" >> static/prompt-graph.svg
  if git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
    echo -e "${GREEN}✓ Test 4: self-update check passes with static/prompt-graph.svg modified${NC}"
  else
    echo -e "${RED}✗ Test 4: self-update check failed with static/prompt-graph.svg modified${NC}"
    ERRORS=$((ERRORS + 1))
  fi
  git checkout static/prompt-graph.svg > /dev/null 2>&1
else
  echo -e "${YELLOW}⚠ Test 4: static/prompt-graph.svg not found, skipping${NC}"
fi

# Test 5: Modify ALL generated files and verify check still passes
TESTS=$((TESTS + 1))
echo "# Test" >> README.md
echo '{"test": true}' > .benchmark/data.json
[ -f static/prompt-graph.svg ] && echo "<!-- test -->" >> static/prompt-graph.svg
if git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
  echo -e "${GREEN}✓ Test 5: self-update check passes with ALL generated files modified${NC}"
else
  echo -e "${RED}✗ Test 5: self-update check failed with ALL generated files modified${NC}"
  ERRORS=$((ERRORS + 1))
fi
git checkout README.md .benchmark/data.json > /dev/null 2>&1
[ -f static/prompt-graph.svg ] && git checkout static/prompt-graph.svg > /dev/null 2>&1

# Test 6: Modify a non-generated file and verify check FAILS
TESTS=$((TESTS + 1))
echo "# Test" >> CONTRIBUTING.md
if ! git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
  echo -e "${GREEN}✓ Test 6: self-update check correctly detects non-generated file changes${NC}"
else
  echo -e "${RED}✗ Test 6: self-update check failed to detect non-generated file changes${NC}"
  ERRORS=$((ERRORS + 1))
fi
git checkout CONTRIBUTING.md > /dev/null 2>&1

# Test 7: Mix of generated and non-generated files - should FAIL
TESTS=$((TESTS + 1))
echo "# Test" >> README.md
echo "# Test" >> CONTRIBUTING.md
if ! git diff-index --quiet HEAD -- ':!.benchmark/' ':!README.md' ':!static/prompt-graph.svg' ':!static/prompt-graph.dot' 2>/dev/null; then
  echo -e "${GREEN}✓ Test 7: self-update check correctly detects mixed file changes${NC}"
else
  echo -e "${RED}✗ Test 7: self-update check failed to detect mixed file changes${NC}"
  ERRORS=$((ERRORS + 1))
fi
git checkout README.md CONTRIBUTING.md > /dev/null 2>&1

# Restore original state
git checkout "$ORIGINAL_COMMIT" > /dev/null 2>&1
git stash pop > /dev/null 2>&1 || true

echo ""
echo "Ran $TESTS tests"

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ All self-update tests passed!${NC}"
  exit 0
else
  echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
  exit 1
fi
