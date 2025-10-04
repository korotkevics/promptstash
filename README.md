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

| Prompt | **0.5.2** | **0.5.1** | **0.4.0** | **0.3.0** | **0.2.0** |
|---|---|---|---|---|---|
| **commit** | 137 | 137 | 137 | 137 | 137 |
| **create-pr** | 291 | 291 | 291 | - | - |
| **create-simple-source-map** | 124 | 124 | 124 | 124 | 124 |
| **debug** | 98 | 98 | 98 | 98 | 98 |
| **read-source-map** | 71 | 71 | 71 | 71 | 71 |
| **review-pr** | 267 | 267 | 267 <sub>🟢 -89</sub> | 356 | - |
| **ship** | 104 | 104 | 104 | 104 | 104 |
| **squash** | 531 | 531 | 531 | 531 | 531 |
| **TOTAL** | **1623** | **1623** | **1623** <sub>🔴 +202</sub> | **1421** <sub>🔴 +356</sub> | **1065** |


## Contributing

We welcome contributions! To add or improve prompts:

1. Fork the repository.
2. Create a new branch:
   ```zsh
   git checkout -b feature-branch
   ```
3. Make your changes and commit:
   ```zsh
   git commit -am 'Add new prompt'
   ```
4. Push your branch:
   ```zsh
   git push origin feature-branch
   ```
5. Open a Pull Request.

### Contribution Guidelines

- Ensure prompts are generic and reusable. Avoid overly specific names, places, or scenarios.
- If enhancing an existing prompt, explain your motivation in the PR description.
- Test prompts to ensure they work as intended.
- Follow existing formatting and style conventions.
- Whenever possible, leverage the ecosystem of existing prompts via referencing.

---

Enjoy using promptstash! If you have questions or suggestions, feel free to open an issue.
