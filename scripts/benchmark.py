#!/usr/bin/env python3
"""Benchmark prompt token counts and update README."""

import json
import math
import os
import subprocess
import sys
from datetime import datetime, UTC
from pathlib import Path
from typing import Dict, List, Tuple

try:
    import tiktoken
except ImportError:
    print("Error: tiktoken is not installed.", file=sys.stderr)
    print("Please install it with: pip install tiktoken", file=sys.stderr)
    sys.exit(1)

# Use cl100k_base tokenizer (GPT-4, Claude)
TOKENIZER = tiktoken.get_encoding("cl100k_base")


def count_tokens(text: str) -> int:
    """Count tokens in text using tiktoken."""
    return len(TOKENIZER.encode(text))


def calculate_entropy(text: str) -> float:
    """Calculate Shannon entropy of text.

    H = -Σ(p(token) * log₂(p(token))) where p(token) = frequency/total

    Returns entropy in bits.
    """
    if not text:
        return 0.0

    # Tokenize the text
    tokens = TOKENIZER.encode(text)

    if not tokens:
        return 0.0

    # Count token frequencies
    token_counts = {}
    for token in tokens:
        token_counts[token] = token_counts.get(token, 0) + 1

    # Calculate probabilities and Shannon entropy
    total_tokens = len(tokens)
    entropy = 0.0

    for count in token_counts.values():
        probability = count / total_tokens
        entropy -= probability * math.log2(probability)

    return entropy


def get_current_version() -> str:
    """Read current version from .version file."""
    version_file = Path(".version")
    if version_file.exists():
        return version_file.read_text().strip()
    return "0.0.0"


def get_current_commit() -> str:
    """Get current git commit hash."""
    result = subprocess.run(
        ["git", "rev-parse", "--short", "HEAD"],
        capture_output=True,
        text=True,
        check=True
    )
    return result.stdout.strip()


def benchmark_prompts() -> Tuple[Dict[str, int], Dict[str, float]]:
    """Count tokens and calculate entropy for all prompts in .promptstash/.

    Returns:
        Tuple: (token_counts dict, entropy_values dict)
    """
    prompts_dir = Path(".promptstash")
    token_counts = {}
    entropy_values = {}

    for prompt_file in sorted(prompts_dir.glob("*.md")):
        content = prompt_file.read_text()
        token_count = count_tokens(content)
        entropy = calculate_entropy(content)
        token_counts[prompt_file.name] = token_count
        entropy_values[prompt_file.name] = entropy

    return token_counts, entropy_values


def load_benchmark_data() -> Dict:
    """Load existing benchmark data or create new."""
    data_file = Path(".benchmark/data.json")

    if data_file.exists():
        with open(data_file) as f:
            return json.load(f)

    return {"commits": []}


def save_benchmark_data(data: Dict):
    """Save benchmark data to file."""
    data_file = Path(".benchmark/data.json")
    data_file.parent.mkdir(exist_ok=True)

    with open(data_file, "w") as f:
        json.dump(data, f, indent=2)


def get_delta(current: int, previous: int | None) -> str:
    """Format delta with fancy indicators."""
    if previous is None or current == previous:
        return ""

    delta = current - previous
    if delta > 0:
        return f' <sub>🔴 +{delta}</sub>'
    else:
        return f' <sub>🟢 {delta}</sub>'


def get_dollar_signs(tokens: int) -> str:
    """Calculate dollar signs based on token count.
    
    Formula: max(ceiling(tokens / 200), 1)
    Examples:
    - 100 tokens → $ (1 sign)
    - 200 tokens → $ (1 sign)
    - 201 tokens → $$ (2 signs)
    - 600 tokens → $$$ (3 signs)
    - 710 tokens → $$$$ (4 signs)
    """
    num_signs = max(math.ceil(tokens / 200), 1)
    return " " + "$" * num_signs


def generate_readme_table(data: Dict) -> str:
    """Generate fancy benchmark table for README."""
    commits = data["commits"]
    if not commits:
        return "No benchmark data available yet."

    # Get latest 5 commits (most recent first, for left-to-right display)
    recent_commits = commits[-5:]
    recent_commits.reverse()  # Most recent on the left

    # Get all unique prompt names
    all_prompts = set()
    for commit in recent_commits:
        all_prompts.update(commit["prompts"].keys())
    all_prompts = sorted(all_prompts)

    # Build table header
    versions = [c["version"] for c in recent_commits]
    header = "| Prompt | Cost | Entropy | " + " | ".join(f"**{v}**" for v in versions) + " |\n"
    separator = "|" + "|".join(["---"] * (len(versions) + 3)) + "|\n"

    # Build table rows
    rows = []
    for prompt in all_prompts:
        # Get latest token count and entropy for this prompt (from most recent commit)
        latest_token_count = recent_commits[0]["prompts"].get(prompt, 0)
        latest_entropy = recent_commits[0].get("entropy", {}).get(prompt, 0.0)
        dollar_signs = get_dollar_signs(latest_token_count) if latest_token_count > 0 else ""

        prompt_name = f"**{prompt.replace('.md', '')}**"
        cost_cell = dollar_signs.strip()  # Remove leading space for cost column
        entropy_cell = f"{latest_entropy:.2f}" if latest_entropy > 0 else "-"
        cells = [prompt_name, cost_cell, entropy_cell]

        # Calculate deltas from right to left (oldest to newest)
        reversed_commits = list(reversed(recent_commits))
        prompt_values = []
        prev_value = None
        for commit in reversed_commits:
            value = commit["prompts"].get(prompt)
            if value is None:
                prompt_values.append("-")
            else:
                delta = get_delta(value, prev_value)
                prompt_values.append(f"{value}{delta}")
                prev_value = value

        # Reverse back for display (newest on left)
        cells.extend(reversed(prompt_values))
        rows.append("| " + " | ".join(cells) + " |")

    # Add total row
    total_cells = ["**TOTAL**", "", ""]  # Empty cost and entropy cells for total row
    reversed_commits = list(reversed(recent_commits))
    total_values = []
    prev_total = None
    for commit in reversed_commits:
        total = sum(commit["prompts"].values())
        delta = get_delta(total, prev_total)
        total_values.append(f"**{total}**{delta}")
        prev_total = total

    # Reverse back for display (newest on left)
    total_cells.extend(reversed(total_values))
    rows.append("| " + " | ".join(total_cells) + " |")

    table = header + separator + "\n".join(rows)

    return f"""## 📊 Benchmarks

Token counts by version (latest 5):

{table}
"""


def update_readme(table: str):
    """Update README.md with new benchmark table."""
    readme_file = Path("README.md")

    # Read README with error handling
    try:
        content = readme_file.read_text()
    except FileNotFoundError:
        print(f"Error: {readme_file} not found", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error reading {readme_file}: {e}", file=sys.stderr)
        sys.exit(1)

    # Find benchmark section
    benchmark_marker = "## 📊 Benchmarks"

    if benchmark_marker in content:
        # Replace existing section
        lines = content.split("\n")
        start_idx = None
        end_idx = None

        for i, line in enumerate(lines):
            if line.startswith(benchmark_marker):
                start_idx = i
            elif start_idx is not None and line.startswith("## ") and i > start_idx:
                end_idx = i
                break

        if start_idx is not None:
            if end_idx is not None:
                # Replace section
                new_lines = lines[:start_idx] + table.split("\n") + [""] + lines[end_idx:]
            else:
                # Section is at the end
                new_lines = lines[:start_idx] + table.split("\n")

            content = "\n".join(new_lines)
        else:
            # Benchmark marker found but start_idx is None (shouldn't happen)
            print(f"Warning: Could not locate benchmark section properly", file=sys.stderr)
            content = content.rstrip() + "\n\n" + table + "\n"
    else:
        # Append to end
        content = content.rstrip() + "\n\n" + table + "\n"

    # Write README with error handling
    try:
        readme_file.write_text(content)
    except Exception as e:
        print(f"Error writing {readme_file}: {e}", file=sys.stderr)
        sys.exit(1)


def generate_prompt_graph():
    """Generate prompt reference graph."""
    try:
        result = subprocess.run(
            [sys.executable, "scripts/generate_graph.py"],
            capture_output=True,
            text=True,
            check=True
        )
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Warning: Failed to generate graph: {e}", file=sys.stderr)
        print(e.stderr, file=sys.stderr)
    except FileNotFoundError:
        print("Warning: generate_graph.py not found, skipping graph generation", file=sys.stderr)


def main():
    """Main benchmark workflow."""
    version = get_current_version()
    commit = get_current_commit()
    timestamp = datetime.now(UTC).isoformat()

    print(f"Benchmarking version {version} (commit {commit})...")

    # Count tokens and calculate entropy
    token_counts, entropy_values = benchmark_prompts()
    total_tokens = sum(token_counts.values())

    print(f"Token counts and entropy:")
    for prompt in sorted(token_counts.keys()):
        tokens = token_counts[prompt]
        entropy = entropy_values[prompt]
        print(f"  {prompt}: {tokens} tokens, {entropy:.2f} bits")
    print(f"  TOTAL: {total_tokens} tokens")

    # Load and update benchmark data
    data = load_benchmark_data()

    # Check if this version already exists
    existing = next((c for c in data["commits"] if c["commit"] == commit), None)
    if existing:
        print(f"Commit {commit} already benchmarked, updating...")
        existing["prompts"] = token_counts
        existing["entropy"] = entropy_values
        existing["timestamp"] = timestamp
        existing["version"] = version
    else:
        data["commits"].append({
            "commit": commit,
            "version": version,
            "timestamp": timestamp,
            "prompts": token_counts,
            "entropy": entropy_values
        })

    # Save benchmark data
    save_benchmark_data(data)
    print(f"Saved benchmark data to .benchmark/data.json")

    # Generate and update README
    table = generate_readme_table(data)
    update_readme(table)
    print("Updated README.md")

    # Generate prompt reference graph
    print("\nGenerating prompt reference graph...")
    generate_prompt_graph()


if __name__ == "__main__":
    main()