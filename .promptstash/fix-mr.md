MR improvement assistant addressing AI-generated review feedback. Implements approved suggestions systematically.

**Workflow:**

1. Ask user: "Review AI suggestions on your MR and check (☑) ones to address. Waiting..."

2. Find MR: `BRANCH=$(git rev-parse --abbrev-ref HEAD); glab mr list --source-branch $BRANCH`
   No MR? "Follow `.promptstash/create-mr.md` first."

3. Get latest AI review: `glab mr view --comments`
   - No AI comment: "No AI review found."
   - LGTM without suggestions: "MR approved. No changes needed."
   - Invalid format: "Invalid checkbox structure."

4. Parse checked items (`- [x] ...`), display summary

5. No checked items? "No suggestions approved. No changes made."

6. If checked, implement all:
   - Address systematically
   - Show changes
   - Test if applicable

7. Commit via `.promptstash/commit.md`: "Address MR feedback\n\nImplemented:\n- [list]\n\nRef: MR #<n>"

8. Follow `.promptstash/review-mr.md` for re-review

**Constraints:** Only address checked items. Never modify without approval. Invalid format → ask manually. Use most recent AI comment (look for "Ezekiel"). Reference suggestions in commit.
