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

Prompts can be used directly in your chat tool or programmatically:

**Example 1: Basic Usage**

```text
Follow the instructions in the prompt at $PROMPTSTASH_DIR/commit.md.
```

**Example 2: With Additional Context**

```text
Follow the instructions in the prompt at $PROMPTSTASH_DIR/debug.md to investigate the stacktrace below:
...
```

## 📊 Benchmarks

Token counts by version (latest 5):

| Prompt | **0.9.2** | **0.9.1** | **0.9.0** | **0.8.1** | **0.8.0** |
|---|---|---|---|---|---|
| **commit** | 286 | 286 | 286 <sub>🟢 -101</sub> | 387 <sub>🔴 +250</sub> | 137 |
| **create-pr** | 490 | 490 | 490 <sub>🔴 +12</sub> | 478 <sub>🔴 +187</sub> | 291 |
| **create-simple-source-map** | 634 | 634 | 634 <sub>🔴 +39</sub> | 595 <sub>🔴 +471</sub> | 124 |
| **debug** | 317 | 317 | 317 <sub>🟢 -178</sub> | 495 <sub>🔴 +397</sub> | 98 |
| **fix-pr** | 580 | 580 | 580 <sub>🔴 +22</sub> | 558 <sub>🔴 +264</sub> | 294 |
| **improve-prompt** | 416 | 416 | 416 <sub>🟢 -138</sub> | 554 <sub>🔴 +59</sub> | 495 |
| **optimize-prompt** | 1186 | 1186 | 1186 | - | - |
| **read-source-map** | 250 | 250 | 250 <sub>🟢 -256</sub> | 506 <sub>🔴 +435</sub> | 71 |
| **review-pr** | 625 | 625 | 625 <sub>🟢 -187</sub> | 812 <sub>🔴 +495</sub> | 317 |
| **ship** | 202 | 202 | 202 <sub>🟢 -423</sub> | 625 <sub>🔴 +521</sub> | 104 |
| **squash** | 180 | 180 | 180 <sub>🟢 -708</sub> | 888 <sub>🔴 +356</sub> | 532 |
| **TOTAL** | **5166** | **5166** | **5166** <sub>🟢 -732</sub> | **5898** <sub>🔴 +3435</sub> | **2463** |


## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to add or improve prompts.
