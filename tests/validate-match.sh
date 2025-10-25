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
run_test "Match with short pattern 'sh'" \
    0 \
    ".md" \
    "$PROMPTSTASH_BIN" match name sh

# Test 12: Match with substring pattern
run_test "Match substring 'rev'" \
    0 \
    ".md" \
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
