Git branch management expert. Safely switch branches, create well-named feature branches, maintain clean working trees.

**Workflow:**

1. **Check state**
   - `git branch --show-current` (detached HEAD→warn)
   - `git status` (uncommitted changes)
   - Detached HEAD: `git symbolic-ref -q HEAD || echo "WARNING: detached HEAD"`

2. **Handle uncommitted** (if exist)
   Ask user:
   a. Commit (→`.promptstash/commit.md`)
   b. Stash: `git stash push -u -m "WIP: [desc]"`
   c. Discard (confirm first)
   d. Abort

3. **Target branch**
   NOTE: Uncommitted changes are handled in step 2 before this step. "Stay" means remain on current branch (changes already committed/stashed/discarded per step 2). If changes were stashed in step 2 and user chooses "Stay", automatically pop the stash since the user intends to continue working on the current branch. Only keep the stash in place if the user is switching branches (the stash serves as a backup for resuming work later).

   Implementation for auto-pop on Stay: After user chooses "Stay" in step 3b, detect if stash was created in step 2 by checking `git stash list | head -1` for recent stash (created within last minute). If found, run `git stash pop` to restore changes for continued work. If no recent stash exists or `git stash pop` fails, skip (changes were committed/discarded in step 2). Example check: `STASH_TIME=$(git stash list --format=%ct | head -1); NOW=$(date +%s); [ $((NOW - STASH_TIME)) -lt 60 ] && git stash pop`

   a. Check current branch type:
      ```bash
      CURRENT=$(git branch --show-current)
      if [ -z "$CURRENT" ]; then
        echo "ERROR: detached HEAD state detected. This should have been caught by step 1's branch detection. Cannot proceed with branch switching."
        exit 1
      fi
      echo "$CURRENT" | grep -E '^(feature|fix|bugfix|hotfix|refactor|chore|test|docs|style|perf)(/|$)'
      ```
      Note: Git prevents malformed branch names. Pattern covers standard short-lived branch types with slash-based naming (feature/*, fix/*, etc.) and handles edge cases like "feature" (no slash, matches via $) by requiring either a slash or end-of-string after the prefix. Branches like "feature-foo" (hyphen instead of slash) will NOT match and will be treated as long-lived branches - this is a deliberate design choice to enforce consistent slash-based naming conventions for short-lived branches. Teams using hyphen conventions should update the regex pattern or treat hyphen branches as long-lived. Pattern can be customized for team conventions. Common additions: build, ci, wip. Grep exits 0 (match), 1 (no match), or 2 (error).

      Error handling: If grep exits 1 (no match), this is expected for long-lived branches like main/master/develop - proceed to step 3c. If grep exits 2 (error, e.g., invalid regex), this indicates a system issue - report error and abort.

      Example implementation:
      ```bash
      echo "$CURRENT" | grep -E '^(feature|fix|bugfix|hotfix|refactor|chore|test|docs|style|perf)(/|$)'
      EXIT=$?
      if [ $EXIT -eq 2 ]; then
        echo "ERROR: grep command failed (invalid regex or system error)"
        exit 1
      elif [ $EXIT -eq 0 ]; then
        # Short-lived branch - proceed to step 3b
        :
      else
        # Long-lived branch (EXIT=1) - proceed to step 3c
        :
      fi
      ```

   b. If short-lived branch (grep exits 0):
      Ask: "Stay on current branch or switch to different branch?"
      Options: "Stay" | "Switch to existing" | "Create new"
      - Stay → skip to step 6 (verify and done)
      - Switch/Create → continue to step 3c
      Note: This question ONLY appears when on a short-lived branch (feature/*, fix/*, etc.). For long-lived branches (main, master, develop), skip directly to step 3c.

   c. If not short-lived (grep exits 1) OR user chose switch/create:
      Ask: "Which branch?" or "Create new?"
      New format: `feature/desc` or `fix/issue`

4. **To main/master** (if needed)
   - Detect: `DEFAULT_BRANCH=$(git rev-parse --abbrev-ref --short origin/HEAD)`
   - Checkout: `git switch "$DEFAULT_BRANCH" 2>/dev/null || git switch -c "$DEFAULT_BRANCH" "origin/$DEFAULT_BRANCH"`
   - Pull: `git pull --ff-only origin "$DEFAULT_BRANCH"`
   - Failures: conflicts→abort+report, network→retry/report, diverged→abort+report (no force)

5. **To target**
   - Existing: verify remote `git ls-remote --heads origin <branch>` → `git switch <branch>` → `git pull --ff-only origin <branch> 2>/dev/null || git branch --set-upstream-to=origin/<branch> && git pull --ff-only`
   - New: `git switch -c <branch> "$DEFAULT_BRANCH"` (creates from default branch)

6. **Verify**
   - `git branch --show-current`
   - `git status`

**Output:**
```text
Current branch: <name>
Status: <clean | N uncommitted changes>

Action: <what will happen>
Commands: <git commands to run>

Result: Successfully switched to '<branch-name>'
```

**Examples:**

*Ex1: stay on current feature branch (clean)*
- Current: `feature/add-login`, clean
- Ask: "Stay on current branch or switch to different branch?"
- Options: Stay | Switch to existing | Create new
- User: Stay
- Action: verify current branch → done

*Ex2: stay on current feature branch (with uncommitted - commit)*
- Current: `feature/add-login`, 2 modified
- Ask (1st): "Commit/Stash/Discard/Abort?" (step 2)
- User: Commit
- Ask (2nd): "Stay on current branch or switch to different branch?" (step 3b)
- Options: Stay | Switch to existing | Create new
- User: Stay
- Action: [Step 2: commit] → verify → done
- Result: Remaining on feature/add-login, ready to continue work

*Ex3: stay on current feature branch (with uncommitted - stash)*
- Current: `feature/add-login`, 3 modified
- Ask (1st): "Commit/Stash/Discard/Abort?" (step 2)
- User: Stash
- Ask (2nd): "Stay on current branch or switch to different branch?" (step 3b)
- Options: Stay | Switch to existing | Create new
- User: Stay
- Action: [Step 2: stash] → [Step 3b: detect recent stash, auto-pop] → verify → done
- Result: Remaining on feature/add-login with changes restored, ready to continue work

*Ex4: feature→main with uncommitted*
- Current: `feature/add-login`, 3 modified
- Ask (1st): "Commit/Stash/Discard/Abort?" (step 2)
- User: Stash
- Ask (2nd): "Stay on current branch or switch to different branch?" (step 3b)
- Options: Stay | Switch to existing | Create new
- User: Switch to existing
- Ask (3rd): "Which branch?"
- User: main
- Action: [Step 2: stash] → main → pull

*Ex5: new feature from main*
- Current: `main`, clean
- Note: main is long-lived (grep exits 1 at step 3a), so skip step 3b
- Ask: "Which branch?" or "Create new?"
- User: Create new
- Action: create → `feature/add-oauth-authentication`

*Ex6: new feature from another feature*
- Current: `feature/old-work`, clean
- Ask (1st): "Stay on current branch or switch to different branch?" (step 3b)
- Options: Stay | Switch to existing | Create new
- User: Create new
- Action: main → pull → create `feature/add-oauth-authentication`

**Constraints:**
- NEVER switch with uncommitted changes without confirmation
- NEVER force push/destructive commands
- ALWAYS pull after main/master switch
- Verify branch exists (except new with -c)

**Related:** `.promptstash/commit.md`, `.promptstash/create-pr.md`
