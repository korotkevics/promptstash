# PromptStash CLI Usage Guide

The PromptStash CLI provides a set of commands to manage and interact with your prompt collection.

## Commands

### `promptstash list`

Lists all available prompts in alphabetical order (non-interactive).

**Usage:**
```bash
promptstash list
```

**Example output:**
```
bump-semver-version.md
commit.md
create-pr.md
debug.md
...
```

**Use case:** Quickly see all available prompts in your collection.

---

### `promptstash pick name`

Interactive prompt picker that copies the selected filename to your clipboard.

**Usage:**
```bash
promptstash pick name
```

**Interactive flow:**
1. Displays a numbered list of all available prompts
2. Prompts you to select a number
3. Copies the filename to your clipboard
4. Displays a success message in green

**Example:**
```bash
$ promptstash pick name

Available prompts:

1 - commit.md
2 - debug.md
3 - ship.md

Select a prompt number (or 'q' to quit): 2
✓ Saved to clipboard: debug.md
```

**Use case:** When you need to reference a prompt filename in documentation or scripts.

---

### `promptstash pick content`

Interactive prompt picker that copies the selected file's contents to your clipboard.

**Usage:**
```bash
promptstash pick content
```

**Interactive flow:**
1. Displays a numbered list of all available prompts
2. Prompts you to select a number
3. Copies the entire file contents to your clipboard
4. Displays a success message in green

**Example:**
```bash
$ promptstash pick content

Available prompts:

1 - commit.md
2 - debug.md
3 - ship.md

Select a prompt number (or 'q' to quit): 3
✓ Saved to clipboard: contents of ship.md
```

**Use case:** When you want to paste a prompt's contents directly into your AI assistant or text editor.

---

### `promptstash pick path`

Interactive prompt picker that copies the selected file's absolute path to your clipboard.

**Usage:**
```bash
promptstash pick path
```

**Interactive flow:**
1. Displays a numbered list of all available prompts
2. Prompts you to select a number
3. Copies the absolute file path to your clipboard
4. Displays a success message in green

**Example:**
```bash
$ promptstash pick path

Available prompts:

1 - commit.md
2 - debug.md
3 - ship.md

Select a prompt number (or 'q' to quit): 1
✓ Saved to clipboard: /Users/username/.promptstash/.promptstash/commit.md
```

**Use case:** When you need to reference a prompt file in commands or scripts using its full path.

---

### `promptstash self-update`

Updates PromptStash to the latest version from the GitHub repository.

**Usage:**
```bash
promptstash self-update
```

**What it does:**
- Checks for uncommitted changes to essential files
- Fetches latest changes from GitHub
- Updates to the latest version
- Runs cleanup to remove unnecessary files
- Displays version information

**Example:**
```bash
$ promptstash self-update
Updating PromptStash...
Fetching latest changes...
✓ Successfully updated from v0.2.2 to v0.3.0
```

---

### `promptstash cleanup`

Checks for and removes unnecessary files from your PromptStash installation.

**Usage:**
```bash
promptstash cleanup
```

**What it does:**
- Scans for files not essential for using PromptStash (like test files, CI configs, etc.)
- Prompts you to delete, keep, or never ask again
- Removes selected files and untracks them from git

**Example:**
```bash
$ promptstash cleanup
⚠ Found unnecessary files in your PromptStash installation:

  • tests
  • .github

Delete these files?
  1) Yes - Delete now
  2) No - Keep them for now
  3) Never ask again

Your choice (1/2/3):
```

---

### `promptstash version`

Shows the current version of PromptStash.

**Usage:**
```bash
promptstash version
```

**Example:**
```bash
$ promptstash version
PromptStash v0.3.0
```

---

### `promptstash help`

Displays help information about all available commands.

**Usage:**
```bash
promptstash help
```

Also works with:
```bash
promptstash --help
promptstash -h
promptstash  # (no arguments)
```

---

## Environment Variables

### `PROMPTSTASH_DIR`

Path to the PromptStash installation directory. By default, this is set to `$HOME/.promptstash`.

**Usage:**
```bash
export PROMPTSTASH_DIR="/custom/path/to/promptstash"
```

### `PROMPTSTASH_NO_UPDATE_CHECK`

Set to `1` to disable automatic update checks when running commands.

**Usage:**
```bash
export PROMPTSTASH_NO_UPDATE_CHECK=1
```

---

## Clipboard Support

The `pick` commands require a clipboard utility to be installed:

- **macOS**: `pbcopy` (pre-installed)
- **Linux (X11)**: `xclip` - Install with `sudo apt install xclip` or `sudo yum install xclip`
- **Linux (Wayland)**: `wl-copy` - Install with `sudo apt install wl-clipboard`

If no clipboard utility is found, the `pick` command will display an error with installation instructions.

---

## Tips

1. **Quick listing**: Use `promptstash list` to get a quick overview of all available prompts without leaving your terminal.

2. **Quitting pick mode**: Press `q` at any selection prompt to quit without copying anything.

3. **Invalid input handling**: The `pick` commands validate your input and will re-prompt if you enter an invalid number.

4. **Staying updated**: PromptStash checks for updates every 24 hours automatically. You'll see a notification if a new version is available.

5. **Combining with other tools**: Since the output of `promptstash list` is plain text, you can pipe it to other commands:
   ```bash
   promptstash list | grep "commit"
   promptstash list | wc -l  # Count total prompts
   ```

---

## Troubleshooting

### "No clipboard command found" error

**Problem**: You see an error when using `pick` commands about missing clipboard utilities.

**Solution**: Install a clipboard utility for your system:
- macOS: Already has `pbcopy` installed
- Linux (X11): `sudo apt install xclip`
- Linux (Wayland): `sudo apt install wl-clipboard`

### "Prompts directory not found" error

**Problem**: The CLI can't find your prompts directory.

**Solution**:
1. Verify your `PROMPTSTASH_DIR` environment variable is set correctly
2. Check that the `.promptstash` subdirectory exists in your installation
3. Re-run the installation script if needed

### Update checks are annoying

**Problem**: You don't want to see update notifications.

**Solution**: Disable update checks by setting the environment variable:
```bash
export PROMPTSTASH_NO_UPDATE_CHECK=1
```

Add this to your shell's rc file (`.bashrc`, `.zshrc`, etc.) to make it permanent.

---

## Learn More

- [Installation Guide](installation.md)
- [GitHub Repository](https://github.com/korotkevics/promptstash)
- [Report Issues](https://github.com/korotkevics/promptstash/issues)
