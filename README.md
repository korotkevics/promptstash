# promptstash

<div style="display: flex; justify-content: center; align-items: center; width: 100%;">
  <img src="static/logo.png" alt="Promptstash Logo" style="width:35%;height:35%;object-fit:contain;" />
</div>


![Version](https://img.shields.io/github/v/release/korotkevics/promptstash)
![Tests](https://github.com/korotkevics/promptstash/actions/workflows/test.yml/badge.svg?branch=main)

A free, open-source collection of generic, reusable developer prompts for various workflows.

## Overview

Promptstash offers prompts designed to help developers automate, debug, and streamline their work. Prompts are generic and reusable—copy, adapt, or integrate them into your favorite AI tools or applications. Prompts work with any AI assistant, with a focus on getting the most from standard copilots.

## Getting Started

### Installation

Install PromptStash with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
```

Or if you don't have `curl`:

```bash
wget -qO- https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
```

For detailed installation options, updating, manual installation, and uninstalling instructions, see the [Installation Guide](docs/installation.md).

### Using Prompts

PromptStash prompts are stored in `$PROMPTSTASH_DIR/.promptstash/`. When working with your AI assistant, reference these prompts by their full path so the assistant can load and follow the instructions.

> **Tip:** If your AI assistant supports context memory well, you can first ask it to remember this path: `Load prompts in $PROMPTSTASH_DIR/.promptstash/ and remember to search there when I ask you to follow an *.md prompt.` This allows you to reference prompts more simply, like `follow commit.md` instead of using the full path each time.

Here are practical examples:

**Example 1: Creating a well-formatted commit**

```text
Load the prompt at $PROMPTSTASH_DIR/.promptstash/commit.md and follow its instructions to create a commit message.
```

**Example 2: Getting a PR reviewed**

```text
Follow the instructions in $PROMPTSTASH_DIR/.promptstash/review-pr.md to analyze my current PR and provide feedback.
```

**Example 3: Debugging an issue with context**

```text
Load $PROMPTSTASH_DIR/.promptstash/debug.md and help me investigate this error:
[paste your error message or stack trace here]
```

## 📊 Benchmarks

Token counts by version (latest 5):

| Prompt | **0.16.1** | **0.16.0** | **0.16.0** | **0.15.1** | **0.15.0** |
|---|---|---|---|---|---|
| **bump-semver-version** $$$ | 442 | 442 | 442 | 442 <sub>🟢 -422</sub> | 864 |
| **commit** $$ | 325 <sub>🔴 +39</sub> | 286 | 286 | 286 | 286 |
| **create-mr** $$ | 272 | 272 | 272 | 272 <sub>🟢 -318</sub> | 590 |
| **create-pr** $$$ | 490 | 490 | 490 | 490 | 490 |
| **create-simple-source-map** $$ | 332 | 332 | 332 | 332 <sub>🟢 -173</sub> | 505 |
| **debug** $$ | 317 | 317 | 317 | 317 | 317 |
| **fix-pr** $$ | 275 | 275 | 275 | 275 <sub>🟢 -305</sub> | 580 |
| **improve-prompt** $$$ | 416 | 416 | 416 | 416 | 416 |
| **optimize-prompt** $$$$$$ | 1186 | 1186 | 1186 | 1186 | 1186 |
| **read-source-map** $$ | 308 | 308 | 308 | 308 | 308 |
| **review-pr** $$ | 282 | 282 | 282 | 282 <sub>🟢 -343</sub> | 625 |
| **ship** $$ | 202 | 202 | 202 | 202 | 202 |
| **squash** $ | 180 | 180 | 180 | 180 | 180 |
| **suggest-better-function-names** $$ | 303 | 303 | 303 | 303 <sub>🟢 -317</sub> | 620 |
| **TOTAL** | **5330** <sub>🔴 +39</sub> | **5291** | **5291** | **5291** <sub>🟢 -1878</sub> | **7169** |


## Prompt Reference Graph

Visual representation of how prompts reference each other:

<div style="display: flex; justify-content: center; align-items: center; width: 100%;">
  <img src="static/prompt-graph.svg" alt="Prompt Reference Graph" style="width:100%;max-width:800px;height:auto;" />
</div>

Prompts are represented as circles with arrows showing references. Island nodes (like `commit` and `squash`) have no outbound references, while others form a reference network.

**Color Legend:**
- <span style="color: #228B22; font-weight: bold;">Green arrows</span>: Outbound references to non-terminal nodes (nodes that also reference other prompts)
- <span style="color: #1E90FF; font-weight: bold;">Blue arrows</span>: Inbound references to terminal nodes (utility nodes like 'commit' and 'squash' that don't reference others)

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to add or improve prompts.
