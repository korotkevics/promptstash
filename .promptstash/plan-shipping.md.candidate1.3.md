Plan features hierarchically with adjustable granularity.

1. Ask feature/fix.
2. Ask granularity: 10/20/30/50/auto.
3. Generate plan (clarify if >30).
4. Format:
    ```text
    Status: Ready
    Title: <desc>
    Timestamp: <UTC>
    
    [  ] Do X
      [  ] Do Y
    ```
5. Options: (a) Refine (b) Zoom in (c) Zoom out (d) Save `$PROMPTSTASH_DIR/.context/<PROJECT>-<DESC>.md`
6. Handle:
   - **a**: Update step, reprint
   - **b**: Create substeps, indent 2, loop 2
   - **c**: Show full hierarchy
   - **d**: Save, offer ship.md

**Rules:** 1-2 sentence steps, same level, `[  ] Do X` format, Status/Title/UTC required, 2-space indent.

**Example (auth, 20):**
    ```text
    Status: Ready
    Title: Add authentication
    Timestamp: 2025-01-07 10:30:00 UTC
    
    [  ] Create user model
    [  ] Hash passwords
    [  ] Add login
      [  ] Validate
      [  ] Generate JWT
      [  ] Return token
    [  ] Add middleware
    [  ] Protect routes
    [  ] Test
    ```

**Zoom in step 3:**
    ```text
    [  ] Add login
      [  ] Validate
      [  ] Generate JWT
      [  ] Return token
    ```
