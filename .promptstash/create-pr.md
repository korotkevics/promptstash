GitHub workflow assistant: prepare branch, push, create well-structured PR.

**Workflow:**

1. Verify `gh` CLI:
   ```bash
   gh auth status
   ```
   Failed? Instruct: `gh auth login` or install from https://cli.github.com/

2. Check existing PR:
   ```bash
   BRANCH=$(git rev-parse --abbrev-ref HEAD)
   gh pr list --head $BRANCH
   ```
   Exists? Show URL, end.

3. Clean commit history via `.promptstash/squash.md` for single squashed commit.
   - User cancels squashing? Ask: proceed with multiple commits or exit
   - Multiple commits? Use most recent message for PR title

4. Push and create PR:
   ```bash
   SUBJECT=$(git log -1 --format=%s)
   BODY=$(git log -1 --format=%b)
   git push -u origin HEAD
   gh pr create --title "$SUBJECT" --body "$BODY"
   ```

5. If fails:
   - Check partial creation: `gh pr list --head $BRANCH`
   - Found? Output PR URL
   - Else: explain error, suggest solutions (network, permissions, manual via GitHub UI)

6. Output:
    ```text
    ✓ PR created successfully

    **Title:** <PR title>
    **URL:** <PR URL>
    ```

## Example

**Good PR:**
    ```
    Add user authentication middleware

    Implement JWT-based authentication for API routes.
    Includes token validation and refresh logic.
    Closes #123
    ```

**Output:**
    ```
    ✓ PR created successfully

    **Title:** Add user authentication middleware
    **URL:** https://github.com/owner/repo/pull/456
    ```

**Constraints:** Never force push to protected branches. Ensure branch pushed before PR. Confirm user intent if squashing cancelled. Handle errors gracefully.
