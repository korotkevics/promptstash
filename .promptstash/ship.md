Ship features via TDD: select ad-hoc, load plan, or create plan.

**Flow:**

1. Follow `.promptstash/switch-branches.md` completely

2. Pick mode: (1) ad-hoc (2) plan (3) plan-creator

3. Plan: search `$PROMPTSTASH_DIR/.context` for `Status: Ready`, pick, execute

4. Ad-hoc: gather requirements, review via `read-source-map.md`, TDD for complexity

5. Plan-creator: invoke `plan-shipping.md` then mode 2

6. Build (TDD: tests->code), doc, check plan boxes

7. Validate -> errors: `debug.md`

8. Summary:
   ```text
   **Changes:** overview
   **Files:** modified
   **Tests:** results
   **Plan:** completion %
   ```

9. Finished plan: flip Ready->Done status

10. Commit (`.promptstash/commit.md`) or iterate (step 6)

**Samples:**
JWT: auth.js, jwt.js, 15/15
Plan: 8/8 complete

**Bounds:** Test mandatory. Complexity needs TDD. Plans tracked. Failures debugged.
