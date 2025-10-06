# promptstash

<div style="display: flex; justify-content: center; align-items: center; width: 100%;">
  <img src="static/logo.png" alt="Promptstash Logo" style="width:35%;height:35%;object-fit:contain;" />
</div>


![Version](https://img.shields.io/github/v/release/korotkevics/promptstash)
![Tests](https://github.com/korotkevics/promptstash/actions/workflows/test.yml/badge.svg)

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

The installer will:
- Clone the repository to `~/.promptstash`
- Automatically configure your shell environment (`~/.bashrc` or `~/.zshrc`)
- Add the `promptstash` CLI to your PATH

After installation, reload your shell or start a new terminal session:

```bash
source ~/.bashrc  # or ~/.zshrc for zsh users
```

To preview what the installer would do without making any changes, use the `--dry-run` flag:

```bash
curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash -s -- --dry-run
```

### Updating

Keep PromptStash up to date with:

```bash
promptstash self-update
```

You'll also receive automatic notifications when a new version is available. To disable update checks, set:

```bash
export PROMPTSTASH_NO_UPDATE_CHECK=1
```

### Manual Installation

If you prefer to install manually:

```bash
git clone https://github.com/korotkevics/promptstash.git ~/.promptstash
export PROMPTSTASH_DIR="$HOME/.promptstash"
export PATH="$PATH:$HOME/.promptstash/bin"
```

Add the export lines to your shell's rc file (`~/.bashrc` or `~/.zshrc`) to make them permanent.

### Uninstalling

To uninstall PromptStash:

1. Remove the installation directory:
   ```bash
   rm -rf ~/.promptstash
   ```

2. Remove the environment variables from your shell's rc file (`~/.bashrc`, `~/.zshrc`, or `~/.config/fish/config.fish`):
   ```bash
   # Remove these lines:
   export PROMPTSTASH_DIR="$HOME/.promptstash"
   export PATH="$PATH:$HOME/.promptstash/bin"
   ```

3. Remove the update check cache (optional):
   ```bash
   rm -f ~/.promptstash_update_check
   ```

4. Reload your shell:
   ```bash
   source ~/.bashrc  # or ~/.zshrc for zsh users
   ```

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

| Prompt | **0.9.0** | **0.8.1** | **0.8.0** | **0.7.0** | **0.6.0** |
|---|---|---|---|---|---|
| **commit** | 286 <sub>🟢 -101</sub> | 387 <sub>🔴 +250</sub> | 137 | 137 | 137 |
| **create-pr** | 490 <sub>🔴 +12</sub> | 478 <sub>🔴 +187</sub> | 291 | 291 | 291 |
| **create-simple-source-map** | 634 <sub>🔴 +39</sub> | 595 <sub>🔴 +471</sub> | 124 | 124 | 124 |
| **debug** | 317 <sub>🟢 -178</sub> | 495 <sub>🔴 +397</sub> | 98 | 98 | 98 |
| **fix-pr** | 580 <sub>🔴 +22</sub> | 558 <sub>🔴 +264</sub> | 294 | 294 | - |
| **improve-prompt** | 416 <sub>🟢 -138</sub> | 554 <sub>🔴 +59</sub> | 495 | - | - |
| **optimize-prompt** | 1186 | - | - | - | - |
| **read-source-map** | 250 <sub>🟢 -256</sub> | 506 <sub>🔴 +435</sub> | 71 | 71 | 71 |
| **review-pr** | 625 <sub>🟢 -187</sub> | 812 <sub>🔴 +495</sub> | 317 | 317 <sub>🔴 +50</sub> | 267 |
| **ship** | 202 <sub>🟢 -423</sub> | 625 <sub>🔴 +521</sub> | 104 | 104 | 104 |
| **squash** | 180 <sub>🟢 -708</sub> | 888 <sub>🔴 +356</sub> | 532 | 532 <sub>🔴 +1</sub> | 531 |
| **TOTAL** | **5166** <sub>🟢 -732</sub> | **5898** <sub>🔴 +3435</sub> | **2463** <sub>🔴 +495</sub> | **1968** <sub>🔴 +345</sub> | **1623** |


## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to add or improve prompts.
