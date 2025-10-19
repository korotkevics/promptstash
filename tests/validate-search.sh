#!/usr/bin/env bash
#
# Integration tests for promptstash search command
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
    shift

    # Last two args are expected_exit and expected_output
    local expected_exit="${@: -2:1}"
    local expected_output="${@: -1}"

    # Remaining args form the command
    local cmd=( "${@:1:$#-2}" )
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
        if echo "$output" | grep -Fq "$expected_output"; then
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

echo "Running promptstash search integration tests..."
echo ""

# Test 1: Search without query shows error
run_test "Search without query shows error" \
    "$PROMPTSTASH_BIN" search \
    1 \
    "Error: search command requires a query"

# Test 2: Search with query that doesn't match
run_test "Search with non-matching query" \
    "$PROMPTSTASH_BIN" search xyz123notfound456 \
    0 \
    "No matches found"

# Test 3: Search for common word (should find matches)
run_test "Search for 'commit' finds matches" \
    "$PROMPTSTASH_BIN" search commit \
    0 \
    ".md"

# Test 4: Search is case-insensitive
run_test "Search is case-insensitive (uppercase)" \
    "$PROMPTSTASH_BIN" search COMMIT \
    0 \
    ".md"

# Test 5: Search name without query shows error
run_test "Search name without query shows error" \
    "$PROMPTSTASH_BIN" search name \
    1 \
    "Error: search command requires a query"

# Test 6: Search content without query shows error
run_test "Search content without query shows error" \
    "$PROMPTSTASH_BIN" search content \
    1 \
    "Error: search command requires a query"

# Test 7: Search path without query shows error
run_test "Search path without query shows error" \
    "$PROMPTSTASH_BIN" search path \
    1 \
    "Error: search command requires a query"

# Test 8: Search handles special regex characters safely (literal matching)
run_test "Search handles brackets literally" \
    "$PROMPTSTASH_BIN" search "[test]" \
    0 \
    ""  # Just check it doesn't crash

# Test 9: Search handles asterisk literally
run_test "Search handles asterisk literally" \
    "$PROMPTSTASH_BIN" search "*" \
    0 \
    ""  # Just check it doesn't crash

# Test 10: Search handles backslash literally
run_test "Search handles backslash literally" \
    "$PROMPTSTASH_BIN" search "\\" \
    0 \
    ""  # Just check it doesn't crash

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
