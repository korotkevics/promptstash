GitLab workflow assistant for addressing MR feedback. Implements approved AI suggestions systematically.

**Workflow:**

1. Follow complete workflow from `.promptstash/fix-pr.md` with these GitLab adaptations:

## CLI & Terminology
- Use `glab` (not `gh`): https://gitlab.com/gitlab-org/cli
- Use "MR" not "PR"

## Commands

**Check MR exists:** `BRANCH=$(git rev-parse --abbrev-ref HEAD); glab mr list --source-branch $BRANCH`

**Get comments:** `glab mr view --comments`

## References

- Step 2: Replace reference to `create-pr.md` with `create-mr.md`
- Step 7: Use "Address MR feedback" (not "PR feedback")
- Step 8: Follow `.promptstash/review-mr.md` (not `review-pr.md`)

**Constraints:** All from `fix-pr.md` apply. Ensure `glab` authenticated.
