#!/usr/bin/env python3
"""Unit tests for scripts/generate_graph.py"""

import sys
from pathlib import Path

# Add scripts directory to path so we can import generate_graph
sys.path.insert(0, str(Path(__file__).parent.parent / "scripts"))

try:
    import generate_graph
except ImportError as e:
    print(f"Error importing generate_graph module: {e}")
    sys.exit(1)


def test_extract_references():
    """Test reference extraction from prompt files."""
    # Create a temporary test file
    test_content = """
    Follow the instructions in `.promptstash/commit.md`.
    Then use `.promptstash/debug.md` for investigation.
    Reference to `.promptstash/create-pr.md` is also included.
    """
    
    # Create temp file
    test_file = Path("/tmp/test-prompt.md")
    test_file.write_text(test_content)
    
    # Extract references
    refs = generate_graph.extract_references(test_file)
    
    # Verify
    assert len(refs) == 3, f"Expected 3 references, got {len(refs)}"
    assert "commit" in refs, "Should extract 'commit' reference"
    assert "debug" in refs, "Should extract 'debug' reference"
    assert "create-pr" in refs, "Should extract 'create-pr' reference"
    
    # Clean up
    test_file.unlink()
    
    print("✓ test_extract_references passed")


def test_extract_references_no_refs():
    """Test extraction when there are no references."""
    test_content = """
    This is a prompt with no references to other prompts.
    It's an island node.
    """
    
    test_file = Path("/tmp/test-prompt-no-refs.md")
    test_file.write_text(test_content)
    
    refs = generate_graph.extract_references(test_file)
    
    assert len(refs) == 0, f"Expected 0 references, got {len(refs)}"
    
    test_file.unlink()
    
    print("✓ test_extract_references_no_refs passed")


def test_build_reference_graph():
    """Test building the complete reference graph."""
    graph = generate_graph.build_reference_graph()
    
    # Check that we found prompts
    assert len(graph) > 0, "Should find at least one prompt"
    
    # Check that known prompts exist
    assert "commit" in graph, "Should include 'commit' prompt"
    assert "debug" in graph, "Should include 'debug' prompt"
    
    # commit should have no references (island node)
    assert len(graph["commit"]) == 0, "'commit' should have no references"
    
    # Check that references are valid (point to existing prompts)
    for prompt, refs in graph.items():
        for ref in refs:
            # Self-references are allowed (optimize-prompt references itself)
            assert ref in graph, f"Reference '{ref}' from '{prompt}' should exist in graph"
    
    print("✓ test_build_reference_graph passed")


def test_generate_dot_graph():
    """Test DOT format generation."""
    # Create a test graph with both terminal and non-terminal nodes
    test_graph = {
        "commit": set(),
        "debug": {"commit"},
        "create-pr": {"squash", "debug"},  # debug is non-terminal, squash is terminal
        "squash": set()
    }
    
    dot = generate_graph.generate_dot_graph(test_graph)
    
    # Check structure
    assert "digraph PromptReferences {" in dot, "Should have digraph declaration"
    assert "rankdir=LR;" in dot, "Should set left-to-right layout"
    assert 'shape=circle' in dot, "Should use circle nodes"
    
    # Check nodes are declared
    assert '"commit"' in dot, "Should declare 'commit' node"
    assert '"debug"' in dot, "Should declare 'debug' node"
    assert '"create-pr"' in dot, "Should declare 'create-pr' node"
    assert '"squash"' in dot, "Should declare 'squash' node"
    
    # Check edges exist
    assert '"debug" -> "commit"' in dot, "Should have edge from debug to commit"
    assert '"create-pr" -> "squash"' in dot, "Should have edge from create-pr to squash"
    assert '"create-pr" -> "debug"' in dot, "Should have edge from create-pr to debug"
    
    # Check edge colors (blue for inbound to terminal nodes, green for outbound to non-terminal)
    assert '#1E90FF' in dot, "Should have blue color for inbound edges"
    assert '#228B22' in dot, "Should have green color for outbound edges"
    
    # Terminal nodes (no outbound edges) should have blue inbound arrows
    assert '"debug" -> "commit" [color="#1E90FF"]' in dot, "Edge to terminal 'commit' should be blue"
    assert '"create-pr" -> "squash" [color="#1E90FF"]' in dot, "Edge to terminal 'squash' should be blue"
    
    # Non-terminal nodes should have green outbound arrows
    assert '"create-pr" -> "debug" [color="#228B22"]' in dot, "Edge to non-terminal 'debug' should be green"
    
    # Nodes without references should not have outgoing edges
    assert '"commit" ->' not in dot, "'commit' should not have outgoing edges"
    assert '"squash" ->' not in dot, "'squash' should not have outgoing edges"
    
    print("✓ test_generate_dot_graph passed")


def test_generate_dot_graph_self_reference():
    """Test handling of self-references."""
    test_graph = {
        "optimize-prompt": {"optimize-prompt", "improve-prompt"},
        "improve-prompt": set()
    }
    
    dot = generate_graph.generate_dot_graph(test_graph)
    
    # Should handle self-reference (green since optimize-prompt is not terminal)
    assert '"optimize-prompt" -> "optimize-prompt"' in dot, "Should handle self-reference"
    assert '"optimize-prompt" -> "optimize-prompt" [color="#228B22"]' in dot, "Self-reference should be green"
    
    # Edge to terminal node should be blue
    assert '"optimize-prompt" -> "improve-prompt"' in dot, "Should have other references too"
    assert '"optimize-prompt" -> "improve-prompt" [color="#1E90FF"]' in dot, "Edge to terminal node should be blue"
    
    print("✓ test_generate_dot_graph_self_reference passed")


def run_all_tests():
    """Run all tests."""
    print("Running generate_graph.py unit tests...\n")
    
    test_extract_references()
    test_extract_references_no_refs()
    test_build_reference_graph()
    test_generate_dot_graph()
    test_generate_dot_graph_self_reference()
    
    print("\n✓ All tests passed!")


if __name__ == "__main__":
    run_all_tests()
