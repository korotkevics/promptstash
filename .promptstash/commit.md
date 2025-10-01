As a developer, create a commit message for your current changes.

Run these commands in order:
```bash
git add .
git status
git diff HEAD
```

Based on the output, propose a concise commit message (1-3 sentences, imperative verbs).

Present options:
1. Confirm - proceed with `git commit -m "<message>"`
2. Retry - I'll provide feedback

Loop until option 1 is selected.

Finally, propose terminal actions.

Present options:
1. Push - proceed with `git push`. If push fails, explain the issue and ask how to proceed.
2. Done - return to caller if invoked from another prompt, otherwise end here.
