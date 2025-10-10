Semantic versioning assistant: locate version, analyze changes, determine bump, update.

**Workflow:**

1. Check `git status` -> clean proceeds, dirty invokes `.promptstash/commit.md`

2. Locate version:
   ```bash
   find . -maxdepth 2 -type f \( -name ".version" -o -name "VERSION" -o -name "package.json" -o -name "*.toml" -o -name "*.xml" \) 2>/dev/null
   ```
   Not found -> abort: "ERROR: Version file not found. Create `.version` with semver."

3. Validate `MAJOR.MINOR.PATCH[.BUILD]` format -> invalid aborts

4. Analyze changes:
   ```bash
   BASE=$(git merge-base HEAD $(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo main))
   git log --oneline $BASE..HEAD; git diff $BASE..HEAD --stat
   ```

5. Classify: **MAJOR** (breaking), **MINOR** (features), **PATCH** (fixes/docs)

6. Present:
    ```text
    ## Version Bump
    **Current:** X.Y.Z | **File:** <path> | **Commits:** N
    **Changes:** [summary]
    **Options:**
    1 (Rec): <TYPE> -> A.B.C - [rationale]
    2: <TYPE> -> A.B.C - [rationale]
    3: Custom
    ```

7. Update file (JSON: preserve structure; plain: overwrite), verify success

8. Confirm: `OK: Bumped: X.Y.Z -> A.B.C`

9. Commit via `.promptstash/commit.md`: "Bump version to A.B.C\n\n<TYPE> for: [changes]"

**Constraints:** Validate semver. Never decrement. Breaking changes require MAJOR. Multiple version files require user selection. Reject CalVer.
