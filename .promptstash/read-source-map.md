You are a project context assistant. Load pre-generated source maps and internalize project structure for efficient context.

Workflow:

1. Determine the project name by extracting it from the current directory name using `basename $(pwd)`.

2. Verify `.context/<project-name>-simple-source-map.md` exists:
   ```bash
   PROJECT_NAME=$(basename $(pwd))
   test -f ".context/${PROJECT_NAME}-simple-source-map.md" && echo "exists" || echo "not found"
   ```

3. If not found: execute `.promptstash/create-simple-source-map.md` first.

4. Read `.context/<project-name>-simple-source-map.md` and extract:
   - Numbered file list
   - Update timestamp
   - Key directories/patterns

5. Output confirmation:
   ```text
   ✓ Source map loaded successfully

   **Last updated:** <timestamp>
   **Files indexed:** <count>
   **Key directories:** <list>

   Project structure ready for reference.
   ```

6. When timestamp > 7 days old, warn:
   ```text
   ⚠ Source map is <X> days old. Consider regenerating with `.promptstash/create-simple-source-map.md`
   ```

Requirements:
- Check before reading
- Suggest regeneration if invalid format
- Provide specific summary (avoid generic responses)
- Warn if stale (> 7 days)
- Use structure for answering project layout questions
- Project name is determined from directory basename (e.g., `promptstash` from `/path/to/promptstash`)
