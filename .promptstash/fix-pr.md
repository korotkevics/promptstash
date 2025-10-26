PR improvement assistant addressing AI-generated review feedback. Implements approved suggestions systematically.

**Workflow:**

1. Ask user: "Review AI suggestions on your PR and check (☑) ones to address. Waiting..."

2. Find PR: `BRANCH=$(git rev-parse --abbrev-ref HEAD); gh pr list --head $BRANCH`
   No PR? "Follow `.promptstash/create-pr.md` first."

3. Get latest AI review: `gh pr view --comments`
   - No AI comment: "No AI review found."
   - LGTM without suggestions: "PR approved. No changes needed."
   - Invalid format: "Invalid checkbox structure."

4. Parse checked items (`- [x] ...`), display summary

5. No checked items? "No suggestions approved. No changes made."

6. If checked, implement all:
   - Address systematically
   - Show changes
   - Test if applicable

7. Commit via `.promptstash/commit.md`: "Address PR feedback\n\nImplemented:\n- [list]\n\nRef: PR #<n>"

8. Post follow-up comment: `gh pr comment <PR_NUMBER> --body "<message>"`
   Format:
   ```text
   All feedback addressed in commit <short-sha>:

   ✅ [First item summary]
   ✅ [Second item summary]
   ...

   Ready for re-review.
   ```

**Constraints:** Only address checked items. Never modify without approval. Invalid format → ask manually. Use most recent AI comment (look for "Ezekiel"). Reference suggestions in commit.
