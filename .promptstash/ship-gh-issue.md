GitHub issue implementation: find, verify, branch, implement via `gh`.

**Workflow:**

1. **Prep branch**
   - `git branch --show-current`
   - Not main/master: handle uncommitted (commit→`.promptstash/commit.md`, stash→`git stash push -m "WIP"`, abort→exit), switch via `git rev-parse --verify main && git checkout main || git checkout master && git pull origin main || git pull origin master`

2. **Find issue**
   Ask user: "Enter keywords to search or exact issue number:"
   Wait for input.
   If keywords: `gh issue list --search "<kw>" --limit 5 --json number,title,url,state`
   Display results, ask: "Select issue number:"
   If direct number: use it

3. **Verify issue**
   `gh issue view <N> --json number,title,body,labels,comments,state`
   Not found→ERROR, retry step 2
   Found→summary, confirm (decline→retry/exit)

4. **Create branch**
   `git checkout -b feature/issue-<N>-<verb-2-4w>` (lowercase, hyphens, ≤50 chars, alphanumeric)

5. **Claim issue**
   Comment on issue: `gh issue comment <N> -b "This issue will be worked on by AI Dev Agent \"Noah\"."`

6. **Implement**
   Follow `.promptstash/ship.md` with issue context

7. **Create PR**
   Follow `.promptstash/create-pr.md`
   PR body must include: `Fixes #<N>.`

8. **Update issue**
   Comment on issue: `gh issue comment <N> -b "This issue was implemented by AI Dev Agent \"Noah\"."`

**Examples:**

Keyword flow: ask user→"auth bug"→list→ask selection→#42→verify→branch→implement
Direct flow: ask user→"123"→verify→confirm→branch→implement
Uncommitted: stash→switch→continue

**Validation:** main before branch | uncommitted handled | issue valid | branch valid | user confirms

**Constraints:** `gh` CLI auth | git main/master | GitHub only | access required | no auto-assign | sanitize names | handle uncommitted | new implementations

**Refs:** `.promptstash/ship.md` | `commit.md` | `create-pr.md`
