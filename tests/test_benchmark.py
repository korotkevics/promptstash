#!/usr/bin/env python3
"""Unit tests for scripts/benchmark.py"""

import sys
from pathlib import Path

# Add scripts directory to path so we can import benchmark
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

try:
    import benchmark
except ImportError as e:
    print(f"Error importing benchmark module: {e}")
    sys.exit(1)


def test_count_tokens():
    """Test token counting function."""
    # Test empty string
    assert benchmark.count_tokens("") == 0

    # Test simple string
    text = "Hello, world!"
    count = benchmark.count_tokens(text)
    assert count > 0, "Token count should be positive for non-empty text"
    assert count < 100, "Token count for short text should be reasonable"

    # Test longer text
    long_text = "This is a longer text with multiple words and sentences. " * 10
    long_count = benchmark.count_tokens(long_text)
    assert long_count > count, "Longer text should have more tokens"

    print("✓ test_count_tokens passed")


def test_get_delta():
    """Test delta calculation function."""
    # Test with no previous value
    assert benchmark.get_delta(100, None) == ""

    # Test with same value (no change)
    assert benchmark.get_delta(100, 100) == ""

    # Test increase
    delta_increase = benchmark.get_delta(150, 100)
    assert "🔴" in delta_increase, "Increase should show red circle"
    assert "+50" in delta_increase, "Increase should show +50"

    # Test decrease
    delta_decrease = benchmark.get_delta(80, 100)
    assert "🟢" in delta_decrease, "Decrease should show green circle"
    assert "-20" in delta_decrease, "Decrease should show -20"

    print("✓ test_get_delta passed")


def test_generate_readme_table():
    """Test README table generation."""
    # Create test data
    test_data = {
        "commits": [
            {
                "commit": "abc123",
                "version": "0.1.0",
                "timestamp": "2025-01-01T00:00:00Z",
                "prompts": {
                    "test.md": 100
                }
            },
            {
                "commit": "def456",
                "version": "0.2.0",
                "timestamp": "2025-01-02T00:00:00Z",
                "prompts": {
                    "test.md": 120,
                    "another.md": 50
                }
            }
        ]
    }

    table = benchmark.generate_readme_table(test_data)

    # Check table structure
    assert "## 📊 Benchmarks" in table
    assert "Token counts by version" in table
    assert "0.2.0" in table, "Should include latest version"
    assert "0.1.0" in table, "Should include older version"
    assert "**test**" in table, "Should include prompt name without .md"
    assert "**TOTAL**" in table, "Should include total row"

    # Check deltas are shown
    assert "🔴" in table or "🟢" in table, "Should show delta indicators"

    print("✓ test_generate_readme_table passed")


def test_generate_readme_table_empty():
    """Test README table generation with empty data."""
    empty_data = {"commits": []}
    table = benchmark.generate_readme_table(empty_data)
    assert "No benchmark data available" in table

    print("✓ test_generate_readme_table_empty passed")


def test_generate_readme_table_sliding_window():
    """Test that table only shows latest 5 versions."""
    # Create test data with 7 commits
    test_data = {
        "commits": [
            {
                "commit": f"commit{i}",
                "version": f"0.{i}.0",
                "timestamp": f"2025-01-0{i}T00:00:00Z",
                "prompts": {"test.md": 100 + i}
            }
            for i in range(1, 8)
        ]
    }

    table = benchmark.generate_readme_table(test_data)

    # Should show latest 5 (0.7.0 down to 0.3.0)
    assert "0.7.0" in table
    assert "0.6.0" in table
    assert "0.5.0" in table
    assert "0.4.0" in table
    assert "0.3.0" in table

    # Should NOT show oldest 2
    assert "0.2.0" not in table
    assert "0.1.0" not in table

    print("✓ test_generate_readme_table_sliding_window passed")


def run_all_tests():
    """Run all tests."""
    print("Running benchmark.py unit tests...\n")

    test_count_tokens()
    test_get_delta()
    test_generate_readme_table()
    test_generate_readme_table_empty()
    test_generate_readme_table_sliding_window()

    print("\n✓ All tests passed!")


if __name__ == "__main__":
    run_all_tests()
