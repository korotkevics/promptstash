GitHub issue handler: locate, check, branch, build via `gh`.

**Flow:**

1. Follow `.promptstash/switch-branches.md` completely

2. **Locate**
   - Ask: "Enter keywords to search or exact issue number:"
   - Wait input
   - Keywords: `gh issue list --search "<kw>" --limit 5 --json number,title,url,state`, show, ask: "Select issue number:"
   - Number: use direct

3. **Check**
   - `gh issue view <N> --json number,title,body,labels,comments,state`
   - Not found->ERROR, back to 2
   - Found->display, confirm (decline->retry/exit)

4. **Branch**
   - `git checkout -b feature/issue-<N>-<verb-2-4w>` (lowercase, hyphens, ≤50, alphanumeric)

5. **Claim**: `gh issue comment <N> -b "This issue will be worked on by AI Dev Agent \"Noah\"."`

6. **Build**: Execute `.promptstash/ship.md` with context

7. **PR**: Run `.promptstash/create-pr.md`, include: `Fixes #<N>.`

8. **Review**: Execute `.promptstash/review-pr.md`

9. **Close**: `gh issue comment <N> -b "This issue was implemented by AI Dev Agent \"Noah\"."`

10. **Version**: Execute `.promptstash/bump-semver-version.md`

**Paths:**
Search: ask->"auth bug"->list->pick->#42->check->branch->build
Direct: ask->"123"->check->OK->branch->build

**Require:** main baseline | dirty managed | issue valid | branch OK | user OK

**Limits:** `gh` auth | git main/master | GitHub only | access | no auto-assign | name sanitize | dirty handle

**See:** `.promptstash/ship.md` | `commit.md` | `create-pr.md` | `review-pr.md` | `bump-semver-version.md`
