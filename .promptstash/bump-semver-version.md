Semantic versioning assistant: locate version file, analyze changes, determine semver bump, update version.

**Workflow:**

1. Clean? `git status` → else `.promptstash/commit.md`

2. Load map (`.promptstash/read-source-map.md`), then locate version or scan:
   ```bash
   find . -maxdepth 2 -type f \( -name ".version" -o -name "VERSION" -o -name "package.json" -o -name "*.toml" -o -name "*.xml" \) 2>/dev/null
   ```
   Not found → abort: "❌ Version file not found. Create `.version` with semver format."

3. Validate: `cat <file>` → must be `MAJOR.MINOR.PATCH[.BUILD]`. Invalid → abort.

4. Analyze changes:
   ```bash
   BASE=$(git merge-base HEAD $(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo main))
   git log --oneline $BASE..HEAD; git diff $BASE..HEAD --stat
   ```

5. Evaluate: **MAJOR** (breaking), **MINOR** (features), **PATCH** (fixes/docs)

6. Present:
    ```text
    ## Version Bump
    **Current:** X.Y.Z | **File:** <path> | **Commits:** N

    **Changes:** [list]

    **Options:**
    1 (Rec): <TYPE> → A.B.C - [Why]
    2: <TYPE> → A.B.C - [Why]
    3: Custom
    ```

7. Update file (JSON: preserve format; plain: direct). Verify: re-read.

8. Confirm: `✓ Bumped: X.Y.Z → A.B.C`

9. Commit via `.promptstash/commit.md`: "Bump version to A.B.C\n\n<TYPE> for: [changes]"

**Constraints:** Validate format. Never decrease. Breaking = MAJOR. Multiple files → ask. CalVer → abort.

