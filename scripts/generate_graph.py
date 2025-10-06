#!/usr/bin/env python3
"""Generate a graph visualization of prompt references."""

import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, Set


def extract_references(prompt_file: Path) -> Set[str]:
    """Extract references to other prompts from a prompt file."""
    content = prompt_file.read_text()
    # Match patterns like .promptstash/filename.md
    pattern = r'\.promptstash/([a-z-]+)\.md'
    matches = re.findall(pattern, content)
    return set(matches)


def build_reference_graph() -> Dict[str, Set[str]]:
    """Build a graph of prompt references."""
    prompts_dir = Path(".promptstash")
    graph = {}
    
    for prompt_file in sorted(prompts_dir.glob("*.md")):
        prompt_name = prompt_file.stem  # filename without .md
        references = extract_references(prompt_file)
        graph[prompt_name] = references
    
    return graph


def generate_dot_graph(graph: Dict[str, Set[str]]) -> str:
    """Generate DOT format graph specification."""
    lines = [
        'digraph PromptReferences {',
        '    // Graph settings',
        '    rankdir=LR;',
        '    node [shape=circle, style=filled, fillcolor=white, fontname="Arial"];',
        '    bgcolor=transparent;',
        '',
        '    // Nodes',
    ]
    
    # Add all nodes
    for prompt in sorted(graph.keys()):
        # Use newline for multi-word prompts to fit in circles
        label = prompt.replace('-', '-\\n')
        lines.append(f'    "{prompt}" [label="{label}"];')
    
    lines.append('')
    lines.append('    // Edges')
    
    # Add edges with colors:
    # - Green for outbound edges (from nodes with outgoing references)
    # - Blue for inbound edges (to nodes with no outgoing references - terminal/utility nodes)
    for prompt, references in sorted(graph.items()):
        for ref in sorted(references):
            if ref in graph:  # Only add edge if target exists
                # If target has no outbound references, it's a terminal node - use blue (inbound focus)
                # Otherwise, use green (outbound reference)
                if len(graph[ref]) == 0:
                    # Terminal node - use blue for inbound arrows
                    lines.append(f'    "{prompt}" -> "{ref}" [color="#1E90FF"];  // Dodger blue - inbound to terminal node')
                else:
                    # Non-terminal node - use green for outbound arrows
                    lines.append(f'    "{prompt}" -> "{ref}" [color="#228B22"];  // Forest green - outbound reference')
    
    lines.append('}')
    return '\n'.join(lines)


def generate_svg(dot_content: str, output_path: Path):
    """Generate SVG from DOT content using Graphviz."""
    try:
        # Check if dot is available
        subprocess.run(['dot', '-V'], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("Error: Graphviz 'dot' command not found.", file=sys.stderr)
        print("Please install Graphviz: sudo apt-get install graphviz", file=sys.stderr)
        sys.exit(1)
    
    # Generate SVG
    process = subprocess.run(
        ['dot', '-Tsvg'],
        input=dot_content.encode(),
        capture_output=True,
        check=True
    )
    
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(process.stdout)


def main():
    """Main workflow to generate prompt reference graph."""
    print("Generating prompt reference graph...")
    
    # Build graph
    graph = build_reference_graph()
    print(f"Found {len(graph)} prompts")
    
    # Count references
    total_refs = sum(len(refs) for refs in graph.values())
    print(f"Found {total_refs} references")
    
    # Generate DOT format
    dot_content = generate_dot_graph(graph)
    
    # Save DOT file
    dot_file = Path("static/prompt-graph.dot")
    dot_file.parent.mkdir(exist_ok=True)
    dot_file.write_text(dot_content)
    print(f"Saved DOT file to {dot_file}")
    
    # Generate SVG
    svg_file = Path("static/prompt-graph.svg")
    generate_svg(dot_content, svg_file)
    print(f"Saved SVG graph to {svg_file}")


if __name__ == "__main__":
    main()
