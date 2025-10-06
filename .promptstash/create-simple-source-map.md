Create numbered source maps for LLM context. Project mapping assistant generating concise file listings to efficiently represent project structure.

**Multi-project:** Detects project name via `basename $(pwd)`, stores maps at `$PROMPTSTASH_DIR/.context/<name>-simple-source-map.md` centrally.

**Steps:**

1. Extract project name from current directory (`/home/user/myapp` → `myapp` → `$PROMPTSTASH_DIR/.context/myapp-simple-source-map.md`)

2. Check `$PROMPTSTASH_DIR/.context/<project-name>-map-decisions.md` for previous decisions:
   - Format: `pattern: map` or `pattern: do not map`
   - Auto-include/exclude ambiguous files

3. List: `find . -type f -o -type d | grep -v -E '(\.git|\.env)' | sort`
   Apply `.gitignore` and decisions file exclusions

4. For ambiguous files (`dist/`, `build/`, `.cache/`, `*.log`):
   - Ask: "Include `<path>`?"
   - Store: `$PROMPTSTASH_DIR/.context/<project-name>-map-decisions.md` as `<path>: map|do not map`

5. Generate numbered map:
    ```text
    # Updated: YYYY-MM-DD HH:MM:SS UTC
    1=path/to/file
    2=another/path
    ```

6. Options:
    1. Store to `$PROMPTSTASH_DIR/.context/<project-name>-simple-source-map.md`, commit via `.promptstash/commit.md`
    2. Modify (return to step 5)

**Example:**
    ```
    # Updated: 2025-01-15 14:30:00 UTC
    1=.gitignore
    2=README.md
    3=src/index.js
    ```

**Decisions example:**
    ```
    dist/: do not map
    docs/benchmarks/: map
    ```

**Requirements:**
- Alphabetical sort
- Exclude `.git`, `.env`
- Respect `.gitignore`, `$PROMPTSTASH_DIR/.context/<project-name>-map-decisions.md`
- UTC timestamps, sequential numbering from 1
- Include files and directories
- Storage: `$PROMPTSTASH_DIR/.context/`, not project directory
