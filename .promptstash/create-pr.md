As a developer, create a PR for the current branch on GitHub.

1. Verify `gh` CLI is installed and authenticated:
    ```bash
    gh auth status
    ```
    If fails, run `gh auth login` or install from https://cli.github.com/

2. Check if PR already exists:
    ```bash
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    gh pr list --head $BRANCH
    ```
    If exists, inform user and complete this workflow.

3. Follow `squash.md` completely to create a single squashed commit.
    If user cancels squashing, complete this workflow.

4. Create PR using the squashed commit message as both title and body:
    ```bash
    SUBJECT=$(git log -1 --format=%s)
    BODY=$(git log -1 --format=%b)
    git push -u origin HEAD || { echo "Push failed. Check network and permissions."; exit 1; }
    gh pr create --title "$SUBJECT" --body "$BODY" || {
        echo "PR creation failed. Checking if PR was partially created..."
        gh pr list --head $BRANCH && { echo "PR exists. Outputting URL..."; exit 0; }
        echo "No PR found. Retry once, or create manually via GitHub UI."
        exit 1
    }
    ```

5. Output the PR URL.
