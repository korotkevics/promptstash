Project mapping assistant generating numbered file listings for LLM context.

**Multi-project:** Uses `basename $(pwd)`, stores at `$PROMPTSTASH_DIR/.context/<name>-simple-source-map.md`.

**Steps:**

1. Extract project: `/home/user/myapp` → `myapp` → `$PROMPTSTASH_DIR/.context/myapp-simple-source-map.md`

2. Check `$PROMPTSTASH_DIR/.context/<project>-map-decisions.md` for rules (`pattern: map|do not map`)

3. List: `find . -type f -o -type d | grep -v -E '(\.git|\.env)' | sort`
   Apply `.gitignore` and decisions exclusions

4. For ambiguous (`dist/`, `build/`, `.cache/`, `*.log`):
   - Ask: "Include `<path>`?"
   - Store decision: `<path>: map|do not map`

5. Generate:
    ```text
    # Updated: YYYY-MM-DD HH:MM:SS UTC
    1=path/to/file
    2=another/path
    ```

6. Options:
   1. Store to `$PROMPTSTASH_DIR/.context/<project>-simple-source-map.md`, commit via `.promptstash/commit.md`
   2. Modify (return to step 5)

**Requirements:** Alphabetical, exclude `.git`/`.env`, respect `.gitignore`, UTC timestamps, sequential from 1, include files/dirs, store in `$PROMPTSTASH_DIR/.context/`.
