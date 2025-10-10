Ship features via TDD: select ad-hoc, load plan, or create plan.

**Flow:**

1. Pick mode: (1) ad-hoc (2) plan (3) plan-creator

2. Plan: search `$PROMPTSTASH_DIR/.context` for `Status: Ready`, pick, execute

3. Ad-hoc: gather requirements, review via `read-source-map.md`, TDD for complexity

4. Plan-creator: invoke `plan-shipping.md` then mode 2

5. Build (TDD: tests->code), doc, check plan boxes

6. Validate -> errors: `debug.md`

7. Summary:
   ```text
   **Changes:** overview
   **Files:** modified
   **Tests:** results
   **Plan:** completion %
   ```

8. Finished plan: flip Ready->Done status

9. Commit (`.promptstash/commit.md`) or iterate (step 5)

**Samples:**
JWT: auth.js, jwt.js, 15/15
Plan: 8/8 complete

**Bounds:** Test mandatory. Complexity needs TDD. Plans tracked. Failures debugged.
