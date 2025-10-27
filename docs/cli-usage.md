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

Interactive prompt picker that copies the filename to the clipboard.

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
✓ Saved to clipboard: /Users/username/.promptstash/.promptstash/commit.md
```

**Note:** The actual path copied to clipboard is the fully expanded absolute path, not the `$PROMPTSTASH_DIR` variable.

---

### `promptstash search <query>`

Searches prompts by filename and content, listing all matches (non-interactive).

```bash
promptstash search foo
```

**Output:**
```
- `foo-this.md`
  when foo is enabled then...

- `bar.md`
  process foo before continuing...
```

*Note: The ellipsis (...) in examples indicates truncated content from matching lines.*

Searches are case-insensitive and match literal strings (not regex). Matches are highlighted in bold red on color-capable terminals.

---

### `promptstash search name <query>`

Interactive search that picks from matching prompts and copies the filename to the clipboard.

```bash
promptstash search name foo
```

**Example:**
```bash
1 - `foo-this.md`
  when foo is enabled then...

2 - `bar.md`
  process foo before continuing...

Please select a prompt number to copy to the clipboard (or 'q' to quit): 1
✓ Saved to clipboard: foo-this.md
```

---

### `promptstash search content <query>`

Interactive search that picks from matching prompts and copies the file contents to the clipboard.

```bash
promptstash search content foo
```

Works the same as `search name` but copies the file contents instead of the filename.

---

### `promptstash search path <query>`

Interactive search that picks from matching prompts and copies the absolute file path to the clipboard.

```bash
promptstash search path foo
```

Works the same as `search name` but copies the absolute path instead of the filename.

---

**Note:** For all `search` commands (`search`, `search name`, `search content`, and `search path`), if no matches are found, it displays:
```
No matches found in file names or file contents for `<query>`.
```

---

### `promptstash match name <pattern>`

Fuzzy matches prompts by filename and copies the best match filename to clipboard (non-interactive).

```bash
promptstash match name cmt
```

**Output:**
```
✓ Saved to clipboard: commit.md
```

Unlike `search` which finds all matches interactively, `match` returns the single best fuzzy match directly based on a scoring algorithm and copies it to clipboard.

---

### `promptstash match content <pattern>`

Fuzzy matches prompts by filename and copies the file contents of the best match to clipboard (non-interactive).

```bash
promptstash match content ship
```

**Output:**
```
✓ Saved to clipboard: contents of ship.md
```

Works the same as `match name` but copies the file contents to clipboard instead of the filename.

---

### `promptstash match path <pattern>`

Fuzzy matches prompts by filename and copies the absolute file path of the best match to clipboard (non-interactive).

```bash
promptstash match path dbg
```

**Output:**
```
✓ Saved to clipboard: /Users/username/.promptstash/.promptstash/debug.md
```

Works the same as `match name` but copies the absolute file path to clipboard instead of the filename.

---

**Fuzzy Matching Algorithm:**

The `match` commands use greedy left-to-right character matching. All pattern characters must appear in the filename in order.

**Examples:**
- `'commt'` matches `'commit.md'` (typo - missing 'i')
- `'cmt'` matches `'commit.md'` (abbreviation)
- `'dbg'` matches `'debug.md'` (abbreviation)

**Limitations:**
- Pattern characters must all be present (e.g., `'cmit'` missing 'm' fails)
- Uses greedy matching (first occurrence taken, not optimal arrangement)
- Pattern `'abc'` vs `'bca'` may score poorly due to character order mismatch

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
