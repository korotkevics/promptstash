# PromptStash CLI Usage Guide

## Commands

### `promptstash list`

Lists all available prompts in alphabetical order.

```bash
promptstash list
```

**Output:**
```
bump-semver-version.md
commit.md
create-pr.md
debug.md
...
```

---

### `promptstash pick name`

Interactive prompt picker that copies the filename to clipboard.

```bash
promptstash pick name
```

**Example:**
```bash
Available prompts:

1 - commit.md
2 - debug.md
3 - ship.md

Select a prompt number (or 'q' to quit): 2
✓ Saved to clipboard: debug.md
```

---

### `promptstash pick content`

Interactive prompt picker that copies the file contents to the clipboard.

```bash
promptstash pick content
```

**Example:**
```bash
Available prompts:

1 - commit.md
2 - debug.md
3 - ship.md

Select a prompt number (or 'q' to quit): 3
✓ Saved to clipboard: contents of ship.md
```

---

### `promptstash pick path`

Interactive prompt picker that copies the absolute file path to the clipboard.

```bash
promptstash pick path
```

**Example:**
```bash
Available prompts:

1 - commit.md
2 - debug.md
3 - ship.md

Select a prompt number (or 'q' to quit): 1
✓ Saved to clipboard: $PROMPTSTASH_DIR/.promptstash/commit.md
```

---

### `promptstash self-update`

Updates PromptStash to the latest version.

```bash
promptstash self-update
```

**Output:**
```bash
Updating PromptStash...
Fetching latest changes...
✓ Successfully updated from v0.27.4 to v0.28.0
```

---

### `promptstash cleanup`

Removes unnecessary files from installation (tests, CI configs, etc.).

```bash
promptstash cleanup
```

---

### `promptstash version`

Shows the current version.

```bash
promptstash version
```

**Output:**
```bash
PromptStash v0.28.0
```

---

### `promptstash help`

Displays help information.

```bash
promptstash help
```

Also works with `--help`, `-h`, or no arguments.

---

## Environment Variables

**`PROMPTSTASH_DIR`** - Installation directory path (default: `$HOME/.promptstash`)

**`PROMPTSTASH_NO_UPDATE_CHECK`** - Set to `1` to disable update checks

---

## Clipboard Support

The `pick` commands require a clipboard utility:

- **macOS**: `pbcopy` (pre-installed)
- **Linux (X11)**: Install `xclip` with `sudo apt install xclip`
- **Linux (Wayland)**: Install `wl-clipboard` with `sudo apt install wl-clipboard`

---

## Learn More

- [Installation Guide](installation.md)
- [GitHub Repository](https://github.com/korotkevics/promptstash)
- [Report Issues](https://github.com/korotkevics/promptstash/issues)
