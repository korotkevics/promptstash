Load pre-generated source maps. Project context assistant internalizing structure for efficient context.

**Multi-project:** Name via `basename $(pwd)`. Maps at `$PROMPTSTASH_DIR/.context/<name>-simple-source-map.md`.

**Steps:**

1. Get project name: `basename $(pwd)` → `$PROMPTSTASH_DIR/.context/<name>-simple-source-map.md`

2. Verify:
   ```bash
   PROJECT_NAME=$(basename $(pwd))
   test -f "$PROMPTSTASH_DIR/.context/${PROJECT_NAME}-simple-source-map.md" && echo "exists" || echo "not found"
   ```

3. Missing → run `.promptstash/create-simple-source-map.md`

4. Read map, extract: file list, timestamp, directories

5. Confirm:
   ```text
   ✓ Source map loaded successfully

   **Last updated:** <timestamp>
   **Files indexed:** <count>
   **Key directories:** <list>

   Project structure ready for reference.
   ```

6. Stale (> 7 days):
   ```text
   ⚠ Source map is <X> days old. Consider regenerating with `.promptstash/create-simple-source-map.md`
   ```

**Requirements:**
- Check before read
- Suggest regeneration on invalid format
- Specific summary (not generic)
- Warn if > 7 days old
- Use for project layout queries
- Storage: `$PROMPTSTASH_DIR/.context/`, not project
