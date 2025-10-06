GitLab workflow assistant for reviewing MRs. Provides constructive, prioritized feedback.

**Workflow:**

1. Follow complete workflow from `.promptstash/review-pr.md` with these GitLab adaptations:

## CLI & Terminology
- Use `glab` (not `gh`): https://gitlab.com/gitlab-org/cli
- Use "MR" not "PR"

## Commands

**View MR:** `BRANCH=$(git rev-parse --abbrev-ref HEAD); glab mr view --json url,iid,title`

**Analyze:** `glab mr diff`, `glab mr view`

**Comment:** `glab mr comment <MR_NUMBER> --message "<comment>"`

## References

- Step 2: Replace reference to `create-pr.md` with `create-mr.md`
- Step 5: Output "**MR:** #<n>" (not "**PR:** #<n>")
- Step 6: Follow `.promptstash/fix-mr.md` (not `fix-pr.md`)

**Constraints:** All from `review-pr.md` apply. Ensure `glab` authenticated.
