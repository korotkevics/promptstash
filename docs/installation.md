# Installation Guide

## Quick Installation

Install PromptStash with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
```

Or if you don't have `curl`:

```bash
wget -qO- https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash
```

## What the Installer Does

The installer will:
- Clone the repository to `~/.promptstash`
- Automatically configure your shell environment (`~/.bashrc` or `~/.zshrc`)
- Add the `promptstash` CLI to your PATH

After installation, reload your shell or start a new terminal session:

```bash
source ~/.bashrc  # or ~/.zshrc for zsh users
```

## Dry Run

To preview what the installer would do without making any changes, use the `--dry-run` flag:

```bash
curl -fsSL https://raw.githubusercontent.com/korotkevics/promptstash/main/install.sh | bash -s -- --dry-run
```

## Updating

Keep PromptStash up to date with:

```bash
promptstash self-update
```

You'll also receive automatic notifications when a new version is available. To disable update checks, set:

```bash
export PROMPTSTASH_NO_UPDATE_CHECK=1
```

## Manual Installation

If you prefer to install manually:

```bash
git clone https://github.com/korotkevics/promptstash.git ~/.promptstash
export PROMPTSTASH_DIR="$HOME/.promptstash"
export PATH="$PATH:$HOME/.promptstash/bin"
```

Add the export lines to your shell's rc file (`~/.bashrc` or `~/.zshrc`) to make them permanent.

## Uninstalling

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
