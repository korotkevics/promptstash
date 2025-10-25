#!/usr/bin/env bash
#
# Integration tests for promptstash match command
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROMPTSTASH_BIN="$PROJECT_ROOT/bin/promptstash"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper to run tests
run_test() {
    local test_name="$1"
    local expected_exit="$2"
    local expected_output="$3"
    shift 3
    local cmd=("$@")

    echo -n "Testing: $test_name ... "

    # Run command and capture output and exit code
    set +e
    output=$("${cmd[@]}" 2>&1)
    exit_code=$?
    set -e

    # Check exit code
    if [ "$exit_code" -ne "$expected_exit" ]; then
        echo -e "${RED}FAIL${NC}"
        echo "  Expected exit code: $expected_exit"
        echo "  Got exit code: $exit_code"
        echo "  Output: $output"
        ((TESTS_FAILED++))
        return 1
    fi

    # Check output if expected pattern provided
    if [ -n "$expected_output" ]; then
        if echo "$output" | grep -F -q -- "$expected_output"; then
            echo -e "${GREEN}PASS${NC}"
            ((TESTS_PASSED++))
            return 0
        else
            echo -e "${RED}FAIL${NC}"
            echo "  Expected output to contain: $expected_output"
            echo "  Got: $output"
            ((TESTS_FAILED++))
            return 1
        fi
    else
        echo -e "${GREEN}PASS${NC}"
        ((TESTS_PASSED++))
        return 0
    fi
}

echo "Running promptstash match integration tests..."
echo ""

# Create temporary test fixtures
echo "Setting up test fixtures..."
TEST_FIXTURES_DIR=$(mktemp -d)
export PROMPTSTASH_DIR="$TEST_FIXTURES_DIR"

# Create .promptstash directory
mkdir -p "$TEST_FIXTURES_DIR/.promptstash"

# Create test prompts with known content
cat > "$TEST_FIXTURES_DIR/.promptstash/commit.md" <<'EOF'
Git commit helper for creating well-formatted commit messages.
EOF

cat > "$TEST_FIXTURES_DIR/.promptstash/debug.md" <<'EOF'
Debug assistant for troubleshooting issues.
EOF

cat > "$TEST_FIXTURES_DIR/.promptstash/ship.md" <<'EOF'
Ship features via TDD workflow assistant.
EOF

# Create additional fixtures for edge case testing
cat > "$TEST_FIXTURES_DIR/.promptstash/review-pr.md" <<'EOF'
PR review assistant providing constructive feedback.
EOF

cat > "$TEST_FIXTURES_DIR/.promptstash/create-pr.md" <<'EOF'
PR creation helper.
EOF

# Empty file for testing
touch "$TEST_FIXTURES_DIR/.promptstash/empty.md"

# Create fixtures for tiebreaker test - prompts that score identically for pattern "x"
# Both "a.md" and "b.md" will score the same (100 penalty for missing 'x' + length diff)
cat > "$TEST_FIXTURES_DIR/.promptstash/a.md" <<'EOF'
First alphabetically.
EOF

cat > "$TEST_FIXTURES_DIR/.promptstash/b.md" <<'EOF'
Second alphabetically.
EOF

# Cleanup function
cleanup_fixtures() {
    rm -rf "$TEST_FIXTURES_DIR"
}
trap cleanup_fixtures EXIT

echo -e "${GREEN}Test fixtures created in $TEST_FIXTURES_DIR${NC}"
echo ""

# Test 1: Match without mode shows error
run_test "Match without mode shows error" \
    1 \
    "Error: match command requires a mode and pattern" \
    "$PROMPTSTASH_BIN" match

# Test 2: Match without pattern shows error
run_test "Match name without pattern shows error" \
    1 \
    "Error: match command requires a mode and pattern" \
    "$PROMPTSTASH_BIN" match name

# Test 2a: Match with empty string pattern shows error
run_test "Match name with empty string pattern shows error" \
    1 \
    "Error: match command requires a mode and pattern" \
    "$PROMPTSTASH_BIN" match name ""

# Test 3: Match with invalid mode shows error
run_test "Match with invalid mode shows error" \
    1 \
    "Unknown match mode" \
    "$PROMPTSTASH_BIN" match invalid commit

# Test 4: Match name with exact pattern
run_test "Match name 'commit' returns commit.md" \
    0 \
    "commit.md" \
    "$PROMPTSTASH_BIN" match name commit

# Test 5: Match name with fuzzy pattern (typo)
run_test "Match name 'commt' fuzzy matches to commit.md" \
    0 \
    "commit.md" \
    "$PROMPTSTASH_BIN" match name commt

# Test 6: Match path returns full path
run_test "Match path 'debug' returns full path" \
    0 \
    ".promptstash/debug.md" \
    "$PROMPTSTASH_BIN" match path debug

# Test 7: Match content returns file contents
run_test "Match content 'ship' returns ship.md contents" \
    0 \
    "Ship features via TDD" \
    "$PROMPTSTASH_BIN" match content ship

# Test 8: Match with non-existent pattern shows error
run_test "Match with non-existent pattern shows error" \
    1 \
    "No matching prompt found" \
    "$PROMPTSTASH_BIN" match name xyz123notfound456

# Test 9: Match is case-insensitive
run_test "Match is case-insensitive (uppercase)" \
    0 \
    "commit.md" \
    "$PROMPTSTASH_BIN" match name COMMIT

# Test 10: Match is case-insensitive (mixed case)
run_test "Match is case-insensitive (mixed case)" \
    0 \
    "commit.md" \
    "$PROMPTSTASH_BIN" match name CoMmIt

# Test 11: Match with short pattern
run_test "Match with short pattern 'sh' returns ship.md" \
    0 \
    "ship.md" \
    "$PROMPTSTASH_BIN" match name sh

# Test 12: Match finds prompt containing substring pattern
run_test "Match finds prompt containing substring 'rev' returns review-pr.md" \
    0 \
    "review-pr.md" \
    "$PROMPTSTASH_BIN" match name rev

# Test 13: Deterministic results - same pattern always gives same result
first_result=$("$PROMPTSTASH_BIN" match name pr 2>&1 || true)
second_result=$("$PROMPTSTASH_BIN" match name pr 2>&1 || true)
if [ "$first_result" = "$second_result" ]; then
    echo -n "Testing: Match results are deterministic ... "
    echo -e "${GREEN}PASS${NC}"
    ((TESTS_PASSED++))
else
    echo -n "Testing: Match results are deterministic ... "
    echo -e "${RED}FAIL${NC}"
    echo "  First run:  $first_result"
    echo "  Second run: $second_result"
    ((TESTS_FAILED++))
fi

# Test 14: Alphanumeric tiebreaker test
# Verifies that when multiple prompts score identically, the alphabetically
# first prompt is selected. Test fixtures a.md and b.md both score the same
# for pattern "x" (both missing the character 'x', same length), so the
# tiebreaker should consistently choose a.md over b.md.
echo -n "Testing: Alphanumeric tiebreaker selects alphabetically first ... "
result=$("$PROMPTSTASH_BIN" match name x 2>&1 || true)
# Should match a.md (alphabetically before b.md) when both score identically
if echo "$result" | grep -q "a.md"; then
    echo -e "${GREEN}PASS${NC} (selected: $result)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    echo "  Expected: a.md (alphabetically first)"
    echo "  Got: $result"
    ((TESTS_FAILED++))
fi

# Test 15: Pattern with special characters (should be treated literally)
run_test "Match with special chars pattern treats them literally" \
    1 \
    "No matching prompt found" \
    "$PROMPTSTASH_BIN" match name "commit*"

# Test 16: Very long pattern (should fail gracefully)
run_test "Match with very long pattern fails gracefully" \
    1 \
    "No matching prompt found" \
    "$PROMPTSTASH_BIN" match name "this-is-a-very-long-pattern-that-should-not-match-anything-at-all-because-it-is-way-too-long"

# Test 17: Empty file handling
run_test "Match empty.md returns empty content" \
    0 \
    "" \
    "$PROMPTSTASH_BIN" match content empty

# Test 18: Unicode/emoji in filenames (if locale supports it)
# Create a test fixture with Unicode characters
cat > "$TEST_FIXTURES_DIR/.promptstash/café.md" <<'EOF'
Coffee-themed prompts.
EOF

run_test "Match with Unicode filename 'café' works correctly" \
    0 \
    "Coffee-themed prompts" \
    "$PROMPTSTASH_BIN" match content café

# Test 19: Symlinks in prompts directory
ln -s "$TEST_FIXTURES_DIR/.promptstash/commit.md" "$TEST_FIXTURES_DIR/.promptstash/symlink.md"
run_test "Match follows symlinks correctly" \
    0 \
    "Git commit helper" \
    "$PROMPTSTASH_BIN" match content symlink

# Test 20: Invalid PROMPTSTASH_DIR handling
echo -n "Testing: Invalid PROMPTSTASH_DIR shows error ... "
INVALID_DIR="/nonexistent/directory/that/does/not/exist"
output=$(PROMPTSTASH_DIR="$INVALID_DIR" "$PROMPTSTASH_BIN" match name commit 2>&1 || true)
if echo "$output" | grep -q "Prompts directory not found"; then
    echo -e "${GREEN}PASS${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    echo "  Expected error about directory not found"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

# Test 21: Greedy matching behavior - "abc" vs "bca"
# Documents the greedy matching limitation where the first match is always taken
cat > "$TEST_FIXTURES_DIR/.promptstash/bca.md" <<'EOF'
Test file for greedy matching.
EOF

echo -n "Testing: Greedy matching 'abc' vs 'bca' produces high score (>50) ... "
# Based on algorithm: 'a' matches at pos 2 (+2), then can't find 'b' or 'c' (+100 +100) = 202
output=$(PROMPTSTASH_MATCH_THRESHOLD=300 "$PROMPTSTASH_BIN" match name abc 2>&1 || true)
if echo "$output" | grep -q "bca.md"; then
    echo -e "${GREEN}PASS${NC} (matched with high threshold)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    echo "  Expected: bca.md to match with threshold=300"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

# Test 22: Greedy matching behavior - "abc" vs "cab"
cat > "$TEST_FIXTURES_DIR/.promptstash/cab.md" <<'EOF'
Test file for greedy matching.
EOF

echo -n "Testing: Greedy matching 'abc' vs 'cab' scores better than 'bca' ... "
# Based on algorithm: 'a' at pos 1 (+1), 'b' at pos 2 (+0), can't find 'c' (+100) = 101
# This should score better (101 < 202) than bca.md
# When both exist, cab.md should win with pattern "abc"
output=$(PROMPTSTASH_MATCH_THRESHOLD=150 "$PROMPTSTASH_BIN" match name abc 2>&1 || true)
# With both bca.md (202) and cab.md (101) present, cab.md should win
if echo "$output" | grep -q "cab.md"; then
    echo -e "${GREEN}PASS${NC} (cab.md scores better than bca.md)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    echo "  Expected: cab.md (score 101) to beat bca.md (score 202)"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

# Test 23: Greedy matching - "deb" vs "debug" (good match)
cat > "$TEST_FIXTURES_DIR/.promptstash/debug-test.md" <<'EOF'
Debug test file.
EOF

echo -n "Testing: Pattern 'deb' matches 'debug-test' with low score ... "
output=$("$PROMPTSTASH_BIN" match name deb 2>&1 || true)
if echo "$output" | grep -q "debug"; then
    echo -e "${GREEN}PASS${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    echo "  Expected: debug-test.md or debug.md to match"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

# Test 24: Greedy matching - "deb" vs "embed" (poor match)
cat > "$TEST_FIXTURES_DIR/.promptstash/embed-test.md" <<'EOF'
Embed test file.
EOF

echo -n "Testing: Pattern 'deb' vs 'embed-test' fails threshold (score >200) ... "
# Remove debug-test.md temporarily to test embed-test in isolation
rm "$TEST_FIXTURES_DIR/.promptstash/debug-test.md"
output=$("$PROMPTSTASH_BIN" match name deb 2>&1 || true)
if echo "$output" | grep -q "No matching prompt found"; then
    echo -e "${GREEN}PASS${NC} (correctly rejected high score)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}FAIL${NC}"
    echo "  Expected: Error 'No matching prompt found'"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

echo ""
echo "================================"
echo "Test Results:"
echo "  Passed: $TESTS_PASSED"
echo "  Failed: $TESTS_FAILED"
echo "================================"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
