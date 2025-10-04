As a developer and an author of a PR, address suggestions left in a comment by an AI Dev Agent named "Ezekiel" on the PR on GitHub.

1. Ask the user 'Please review the latest suggestions I made on the PR and check (checked = approved) the ones I should address?' And wait for their input.
2. Find the PR on GitHub corresponding to the current active branch.
   - If no PR is found for the current branch: "No PR found. Run `create-pr.md` first."
3. Find the latest comment made by you (the AI Dev Agent) on the PR.
   - If no AI (by "Ezekiel") comment is found: "No AI review comment found. Nothing to fix."
4. Check which suggestions were checked (checked = approved by the user).
5. If no suggestions were checked, print: `No suggestions were approved by the user. No changes made.`
6. If suggestions were checked, address all of them in the codebase.
7. Follow `commit.md` completely, ensuring the commit message references the PR and the addressed.
8. Proceed to `review-pr.md` completely.