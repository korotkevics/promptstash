As a developer, squash all commits into a single commit.

1. Check if the working directory is clean
2. If not: Follow `commit.md` completely
3. Analyze changes from both semantic (commits) and factual (diff) perspectives. Detect parent branch:

    First, try to get configured upstream:
    ```bash
    git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null
    ```

    If empty, find the remote branch with fewest diverging commits (likely the parent):
    ```bash
    bash << 'EOF'
    CURRENT=$(git rev-parse --abbrev-ref HEAD)
    git for-each-ref --format='%(refname:short)' refs/remotes/origin/ | grep -v "origin/$CURRENT" | while read branch; do
      BASE=$(git merge-base HEAD $branch 2>/dev/null)
      if [ -n "$BASE" ]; then
        COUNT=$(git rev-list --count ${BASE}..HEAD)
        echo "$COUNT $branch"
      fi
    done | sort -n | head -1 | cut -d' ' -f2
    EOF
    ```

    If still empty, use default branch:
    ```bash
    git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'
    ```
    (fallback to `main` if empty)

    Use the detected branch as PARENT_BRANCH. Then get BASE:
    ```bash
    git merge-base HEAD <PARENT_BRANCH>
    ```

    Use BASE to analyze changes:
    ```bash
    git --no-pager log --oneline <BASE>..HEAD
    git --no-pager diff <BASE>..HEAD
    ```
4. Based on the changes, propose a concise commit message (1-3 sentences, imperative verbs).

    Present options:
    1. Confirm - proceed with squash
    2. Retry - I'll provide feedback

    Loop until option 4.1 is selected.

5. Squash commits:
    ```bash
    git reset --soft $(git merge-base HEAD <PARENT_BRANCH>)
    git commit -m "<agreed message>"
    ```

6. Verify with `git log` and output: `All changes squashed into a single commit.`
7. Propose terminal actions.
   Present options:
   1. Push - proceed with `git push --force-with-lease`
   2. No further actions - end here
