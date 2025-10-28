One-shot PR review for external contributions. Provides constructive, prioritized feedback.

**Workflow:**

1. Get PR: Ask user for PR number/URL if not provided

2. Fetch PR: `gh pr view <NUMBER> --json url,number,title,author`

3. Analyze (`gh pr diff <NUMBER>`, `gh pr view <NUMBER>`): quality, correctness, security, performance, testing, docs

   **Review focus:**
   - Code correctness and potential bugs
   - Security vulnerabilities
   - Performance concerns
   - Test coverage
   - Documentation quality
   - Edge cases and error handling

4. Post review via `gh pr comment <NUMBER> --body "<comment>"`:

   **With issues:**
   ```text
   [1-2 sentence summary]

   **HIGH priority**
   - [ ] [Critical/blocking issue with file:line reference]

   **MEDIUM priority**
   - [ ] [Quality improvement with file:line reference]

   **LOW priority**
   - [ ] [Nice-to-have enhancement with file:line reference]

   ___
   Reviewed by AI Dev Agent "Ezekiel"
   ```

   **No issues:** `LGTM!\n___\nReviewed by AI Dev Agent "Ezekiel"`

5. Output: `OK: Review posted\n**PR:** #<n> - <title>\n**Suggestions:** <count>`

**Constraints:** Be specific. Explain WHY. Prioritize correctly (HIGH=blocking). Include paths/lines. Professional tone.
