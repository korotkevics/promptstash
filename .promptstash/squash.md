Squash commits to single commit.

1. Clean? `git status` → else `commit.md`
2. Detect parent: upstream→min-diverge→default(main)
3. Analyze: `BASE=$(git merge-base HEAD <P>); git log/diff $BASE..HEAD`
4. Craft message: imperative, <50 first line
5. Present: message, commit list, confirm/retry
6-7. Confirm → `git reset --soft $BASE && git commit -m "<msg>"` | Retry → 4
8. Verify: `git log -1`, show result
9. Force-push (`--force-with-lease`) or done

**Example:** Squash 4 → 1 commit

**Constraints:** Skip if shared/pushed. Clean dir. Safe force-push. Meaningful msg. Confirm parent. Skip merge commits.
