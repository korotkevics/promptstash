Semantic versioning assistant: identify version files, analyze branch changes, determine appropriate bump per semver rules, update version.

Workflow:

1. Clean? `git status` → else `.promptstash/commit.md`

2. Load structure: `.promptstash/read-source-map.md` (or create via `.promptstash/create-simple-source-map.md`)

3. Locate version file:
   - Check project map
   - Scan: `find . -maxdepth 2 -type f \( -name ".version" -o -name "VERSION" -o -name "package.json" -o -name "pyproject.toml" -o -name "setup.py" -o -name "Cargo.toml" -o -name "pom.xml" -o -name "build.gradle" \) 2>/dev/null`
   - Deep scan: `grep -r "\"version\":" --include="*.json" . 2>/dev/null | head -5; grep -r "version =" --include="*.toml" --include="*.py" . 2>/dev/null | head -5`
   - Not found → abort: "❌ Could not locate semantic version. Specify version file path or create `.version` with current semver (e.g., '1.0.0')."

4. Validate version: `cat <file>` → must be `MAJOR.MINOR.PATCH` or `MAJOR.MINOR.PATCH.BUILD`. Invalid → abort with semver format explanation.

5. Detect base: `BASE=$(git merge-base HEAD $(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo main))` (fallback: main/master/develop)

6. Analyze: `git log --oneline $BASE..HEAD; git diff $BASE..HEAD --stat; git diff $BASE..HEAD`

7. Evaluate per semver:
   - **MAJOR (X.0.0)**: Breaking changes, incompatible API, removed features
   - **MINOR (0.X.0)**: New features, backwards-compatible additions
   - **PATCH (0.0.X)**: Bug fixes, patches, documentation

8. Present options:
    ```text
    ## Version Bump Analysis
    **Current:** X.Y.Z | **File:** <path> | **Base:** <branch> | **Commits:** N
    
    ## Changes
    [Key changes list]
    
    ## Options
    **1 (Recommended): <TYPE> → A.B.C**
    Why: [Rationale]
    
    **2: <TYPE> → A.B.C**
    Why: [Alternative]
    
    **3: Custom**
    
    Select (1/2/3):
    ```

9. Update version file (JSON: maintain format; plain: direct update). Verify: re-read.

10. Confirm:
    ```text
    ✓ Bumped: X.Y.Z → A.B.C (<path>)
    ```

11. `.promptstash/commit.md`:
    ```text
    Bump version to A.B.C
    
    <TYPE> bump for:
    - [change 1]
    - [change 2]
    ```

**Example:**
    ```text
    ## Version Bump Analysis
    **Current:** 0.8.5 | **File:** .version | **Base:** main | **Commits:** 7
    
    ## Changes
    - 3 new REST endpoints (user mgmt)
    - Auth token validation fix
    - Docs + tests
    
    ## Options
    **1 (Recommended): MINOR → 0.9.0**
    Why: New endpoints = backwards-compatible features
    
    **2: PATCH → 0.8.6**
    Why: If endpoints internal/experimental
    
    **3: Custom**
    
    Select (1/2/3):
    ```

**Constraints:** Validate semver format. Never decrease. Uncertain? Offer options. Breaking = MAJOR. Security = MINOR/MAJOR. Docs-only = PATCH. Maintain file format. Non-standard versioning (CalVer) → abort. Multiple version files → ask user.

