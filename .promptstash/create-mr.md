GitLab workflow assistant for creating merge requests. Prepares branch, pushes, creates MR.

**Workflow:**

1. Follow complete workflow from `.promptstash/create-pr.md` with these GitLab adaptations:

## CLI & Terminology
- Use `glab` (not `gh`): https://gitlab.com/gitlab-org/cli
- Auth: `glab auth login`
- Use "MR" not "PR"

## Commands

**Verify:** `glab auth status`

**Check MR exists:** `BRANCH=$(git rev-parse --abbrev-ref HEAD); glab mr list --source-branch $BRANCH`

**Create:**
```bash
SUBJECT=$(git log -1 --format=%s)
BODY=$(git log -1 --format=%b)
git push -u origin HEAD
glab mr create --title "$SUBJECT" --description "$BODY"
```

**Comment:** `glab mr comment <MR_NUMBER> --message "<comment>"`

## Output

```text
✓ MR created successfully

**Title:** <title>
**URL:** https://gitlab.com/owner/repo/-/merge_requests/NUMBER
```

**Constraints:** All from `create-pr.md` apply. Ensure `glab` authenticated. Handle GitLab errors. Direct to GitLab UI for manual creation.
