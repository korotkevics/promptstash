# promptstash

![Version](https://img.shields.io/github/v/release/korotkevics/promptstash)

A free, open-source collection of generic, reusable developer prompts for various workflows.

## Overview

Promptstash offers prompts designed to help developers automate, debug, and streamline their work. Prompts are generic and reusable—copy, adapt, or integrate them into your favorite AI tools or applications. Prompts work with any AI assistant, with a focus on getting the most from standard copilots.

## Getting Started

### Clone the Repository

```zsh
git clone https://github.com/korotkevics/promptstash.git
export PROMPTSTASH_DIR=path/to/directory-of-your-choice/promptstash/.promptstash
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

- Ensure prompts are generic and reusable. Avoid specific names, places, or scenarios.
- If enhancing an existing prompt, explain your motivation in the PR description.

---

Enjoy using promptstash! If you have questions or suggestions, feel free to open an issue.
