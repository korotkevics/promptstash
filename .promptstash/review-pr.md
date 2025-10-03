As a developer, review a PR of another developer on GitHub.

1. Check if the working directory is clean
2. If not: Follow `commit.md` completely
3. Verify `gh` CLI is installed and authenticated:
   - Run `gh auth status`
   - If not installed, guide user to install: https://cli.github.com/
   - If not authenticated, run `gh auth login` and follow the prompts
4. Check if current branch has remote tracking:
   - Run `git rev-parse --abbrev-ref --symbolic-full-name @{u}`
   - If no remote tracking, help user push with `git push -u origin <branch-name>`
5. Find the PR on GitHub corresponding to the current active branch.
6. If no PR exists, suggest creating one.
7. If a user chooses not to create a PR, end here.
8. Analyze the changes thoroughly, considering:
   - Code quality and adherence to best practices
   - Potential bugs or edge cases
   - Security vulnerabilities
   - Performance implications
   - Test coverage
   - Documentation completeness
9. If improvements can be suggested, leave a comment in the format below:

   ```text
   <Concise summary, 1-2 sentences>

   **HIGH priority suggestions**
   - [ ] ...

   **MEDIUM priority suggestions**
   - [ ] ...

   **LOW priority suggestions**
   - [ ] ...

   ___

   Reviewed by an 🤖 AI Dev Agent with love ❤️
   ```

10. If no improvements can be suggested, leave the comment below:

    ```text
    LGTM!

    ___

    Reviewed by an 🤖 AI Dev Agent with love ❤️
    ```