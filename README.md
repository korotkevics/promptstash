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

| Prompt | Cost | Entropy | **0.24.0** | **0.23.1** | **0.23.0** | **0.22.0** | **0.21.1** |
|---|---|---|---|---|---|---|---|
| **bump-semver-version** | $$$ | 7.33 | 422 | 422 | 422 | 422 <sub>🔴 +1</sub> | 421 |
| **commit** | $$ | 6.99 | 365 | 365 <sub>🔴 +41</sub> | 324 | 324 <sub>🟢 -1</sub> | 325 |
| **create-mr** | $$ | 6.93 | 272 | 272 | 272 | 272 | 272 |
| **create-pr** | $$$ | 7.18 | 403 | 403 | 403 | 403 | 403 |
| **create-source-map** | $$ | 7.06 | 332 | 332 | 332 | 332 | 332 |
| **debug** | $$ | 6.95 | 340 | 340 <sub>🔴 +12</sub> | 328 <sub>🔴 +11</sub> | 317 | 317 |
| **fix-mr** | $$ | 6.55 | 202 | 202 | 202 | 202 | 202 |
| **fix-pr** | $$ | 6.97 | 275 | 275 | 275 | 275 | 275 |
| **improve-prompt** | $$ | 6.80 | 350 | 350 | 350 | 350 <sub>🟢 -2</sub> | 352 |
| **optimize-prompt** | $$$$$$$ | 7.96 | 1258 <sub>🔴 +86</sub> | 1172 | 1172 | 1172 <sub>🔴 +150</sub> | 1022 |
| **plan-shipping** | $$ | 6.53 | 371 | 371 | 371 | 371 | 371 |
| **read-source-map** | $$ | 7.04 | 306 | 306 | 306 | 306 <sub>🟢 -2</sub> | 308 |
| **review-mr** | $$ | 6.68 | 228 | 228 | 228 | 228 | 228 |
| **review-pr** | $$$ | 7.55 | 503 <sub>🔴 +23</sub> | 480 | 480 <sub>🔴 +199</sub> | 281 <sub>🟢 -1</sub> | 282 |
| **ship-gh-issue** | $$$ | 7.22 | 511 | 511 <sub>🔴 +45</sub> | 466 <sub>🔴 +11</sub> | 455 | - |
| **ship** | $$ | 6.63 | 244 | 244 | 244 | 244 <sub>🟢 -225</sub> | 469 |
| **squash** | $ | 6.55 | 180 | 180 | 180 | 180 | 180 |
| **suggest-better-function-names** | $$ | 6.92 | 303 | 303 | 303 | 303 | 303 |
| **TOTAL** |  |  | **6865** <sub>🔴 +109</sub> | **6756** <sub>🔴 +98</sub> | **6658** <sub>🔴 +221</sub> | **6437** <sub>🔴 +375</sub> | **6062** |


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
