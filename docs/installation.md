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

## Claude Code Integration (Optional)

If you're using [Claude Code](https://claude.com/claude-code), you can configure it to automatically access your PromptStash workflows. This setup provides a seamless experience by allowing Claude Code to reference workflow documentation from your prompt stash directory.

Run the integration setup script:

```bash
$PROMPTSTASH_DIR/scripts/setup-claude-code.sh
```

This will:
- Configure Claude Code's `config.json` to grant access to your PromptStash directory
- Update your global `CLAUDE.md` with instructions to reference PromptStash workflows
- Safely append to existing configurations if they already exist

After running the script, restart Claude Code to apply the changes.

### What Gets Configured

The script updates two files in your `~/.claude` directory:

1. **config.json** - Adds permissions:
   ```json
   {
     "permissions": {
       "additionalDirectories": [
         "$PROMPTSTASH_DIR/.promptstash/**"
       ]
     }
   }
   ```

2. **CLAUDE.md** - Adds workflow instructions:
   ```md
   # User Memory

   ## Global Workflow Instructions

   Always reference all workflow documentation from the prompt stash directory:

   @$PROMPTSTASH_DIR/.promptstash
   ```

With this integration, Claude Code will automatically have access to your PromptStash workflows and documentation.

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
