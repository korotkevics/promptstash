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

## 📊 Benchmarks

Token counts by version (latest 5):

| Prompt | **0.4.0** | **0.3.0** | **0.2.0** | **0.1.0** |
|---|---|---|---|---|
| **commit** | 137 | 137 | 137 <sub>🔴 +20</sub> | 117 |
| **create-pr** | 291 | - | - | - |
| **create-simple-source-map** | 124 | 124 | 124 | - |
| **debug** | 98 | 98 | 98 | 98 |
| **read-source-map** | 71 | 71 | 71 | - |
| **review-pr** | 267 <sub>🟢 -89</sub> | 356 | - | - |
| **ship** | 104 | 104 | 104 | 104 |
| **squash** | 531 | 531 | 531 | - |
| **TOTAL** | **1623** <sub>🔴 +202</sub> | **1421** <sub>🔴 +356</sub> | **1065** <sub>🔴 +746</sub> | **319** |

*Token counts are measured using the `cl100k_base` tokenizer (compatible with GPT-4 and Claude).*

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
