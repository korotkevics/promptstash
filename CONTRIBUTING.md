# Contributing

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

## Contribution Guidelines

- Ensure prompts are generic and reusable. Avoid overly specific names, places, or scenarios.
- If enhancing an existing prompt, explain your motivation in the PR description.
- Test prompts to ensure they work as intended.
- Follow existing formatting and style conventions.
- Whenever possible, leverage the ecosystem of existing prompts via referencing.
- When creating new prompts: use `.promptstash/improve-prompt.md` to refine your human-written draft, then use `.promptstash/optimize-prompt.md` to slim it down (improve first, optimize after).

## Directory Structure

### `.context/` - Transient/Generated Content

The `.context/` directory is for **transient, user-generated, or machine-generated content** that doesn't belong in version control. Examples include:
- Generated source maps specific to your workflow
- Temporary analysis files
- User-specific context that varies by installation

This directory is gitignored and excluded from sparse checkout to prevent blocking self-updates.

### `docs/` - Permanent Reference Documentation

The `docs/` directory is for **permanent, version-controlled reference documentation** that all users need. Examples include:
- Project reference materials (like `docs/reference/notation.md`)
- Installation guides
- API documentation

**Rule of thumb**: If the content is stable, reusable across installations, and should be version-controlled, put it in `docs/`. If it's generated, transient, or user-specific, put it in `.context/`.

---

Enjoy using promptstash! If you have questions or suggestions, feel free to open an issue.
