Git branch manager. Switch branches safely, create well-named features, maintain clean state.

**Workflow:**

1. **Check:** `git branch --show-current` (warn detached), `git status` (check uncommitted)

2. **Uncommitted?** Ask: (a) Commit→`.promptstash/commit.md`, (b) Stash: `git stash push -u -m "WIP: [desc]"`, (c) Discard (confirm), (d) Abort

3. **Branch type:**
   ```bash
   CURRENT=$(git branch --show-current)
   [ -z "$CURRENT" ] && echo "ERROR: detached HEAD" && exit 1
   echo "$CURRENT" | grep -E '^(feature|fix|bugfix|hotfix|refactor|chore|test|docs|style|perf)(/|$)'
   EXIT=$?
   [ $EXIT -eq 0 ] && : # Short-lived
   [ $EXIT -eq 1 ] && : # Long-lived
   ```
   Slash-based naming (feature/*). Hyphens (feature-foo) = long-lived.

   **Short-lived:** Ask "Stay | Switch | Create"
   - Stay → verify, auto-pop stash if <60s: `STASH_TIME=$(git stash list --format=%ct | head -1); NOW=$(date +%s); [ $((NOW - STASH_TIME)) -lt 60 ] && git stash pop`
   - Else → step 3c

   **Long-lived or switch/create:** Ask target or create new (format: `feature/desc`, `fix/issue`)

4. **To main:**
   ```bash
   DEFAULT_BRANCH=$(git rev-parse --abbrev-ref --short origin/HEAD)
   git switch "$DEFAULT_BRANCH" 2>/dev/null || git switch -c "$DEFAULT_BRANCH" "origin/$DEFAULT_BRANCH"
   git pull --ff-only origin "$DEFAULT_BRANCH"
   ```
   Failures: abort+report

5. **To target:**
   - Existing: `git ls-remote --heads origin <branch>` → `git switch <branch>` → `git pull --ff-only origin <branch> 2>/dev/null || git branch --set-upstream-to=origin/<branch> && git pull --ff-only`
   - New: `git switch -c <branch> "$DEFAULT_BRANCH"`

6. **Verify:** `git branch --show-current`, `git status`

**Output:**
```text
Current branch: <name>
Status: <clean | N uncommitted>
Action: <description>
Commands: <git commands>
Result: Successfully switched to '<branch>'
```

**Examples:**

Stay (stash+auto-pop): `feature/add-login` + 3 modified → Stash → Stay → auto-pop → verify

Feature→main: `feature/add-login` + uncommitted → Stash → Switch main → Pull

**Constraints:** NEVER switch with uncommitted without confirmation. NEVER force push. ALWAYS pull after main/master. Verify branch exists (except new with -c).

**Related:** `.promptstash/commit.md`, `.promptstash/create-pr.md`
