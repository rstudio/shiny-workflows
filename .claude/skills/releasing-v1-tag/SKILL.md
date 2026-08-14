---
name: releasing-v1-tag
description: Use when merged changes in shiny-workflows need to reach consumer repos, when moving or force-pushing the v1 tag, when rolling v1 back, or when a consumer pinned to @v1 is not picking up a merged fix.
---

# Releasing the v1 tag

## Overview

Consumers reference this repo only through the moving `v1` tag (`rstudio/shiny-workflows/...@v1`). Merging to `main` ships nothing. Force-moving `v1` ships *everything* on `main` to *every* consumer repo at once, with no staged rollout and no review.

**Treat moving `v1` as a production deploy, not a git chore.**

## The confirmation gate

**STOP after the pre-flight checks. Show the user what will ship and get explicit approval before the force-push.**

No exceptions:

- Not when the user said "merge and release" earlier — approval to merge is not approval to deploy.
- Not when your own change is trivial. `v1` ships every unreleased commit on `main`, not just yours.
- Not when the commit range "looks obviously fine". You are not the one who owns the consumer repos.
- Not when re-running after a failed push. Re-confirm.

Silence is not approval. Ask, then wait.

| Rationalization | Reality |
|---|---|
| "The user asked for a release, so pushing is implied" | They asked for *a* release. Show them *which commits* first — the range usually holds other people's unreleased work. |
| "It's docs-only" | Then there is no urgency, so there is no cost to asking. |
| "CLAUDE.md documents the commands, so just run them" | It documents *how*, not *whether now*. |
| "I'll push and roll back if it breaks" | Consumer CI runs in the gap. Roll-forward damage is already done. |

## Procedure

1. **Verify the merge landed:** `gh pr view <N> --json state,mergeCommit`.
2. **Fetch, never trust local refs:** `git fetch origin main --tags`. Local `main` is often stale or checked out in another worktree; the current branch HEAD is often the *pre-squash* commit. Always tag `origin/main` explicitly.
3. **Check `main` is green:** `gh run list --branch main --limit 5`. A red `main` becomes a red `v1` for everyone.
4. **List what ships:** `git log --oneline v1..origin/main`.
5. **Check for leftover branch refs:** `grep -rn '@' --include='*.yaml' .github/workflows */action.yaml | grep -vE '@v1|@[0-9a-f]{40}'`. A cross-reference still pointing at a test branch breaks consumers the moment the tag moves.
6. **Record the rollback point:** `git rev-parse v1`.
7. **Confirm with the user** (see gate above) — show the step-4 commit list and the step-6 sha.
8. **Move and push:**
   ```bash
   git tag -f v1 origin/main
   git rev-parse v1              # must equal origin/main
   git push origin v1 --force
   ```
9. **Verify:** `git ls-remote origin refs/tags/v1` equals `origin/main`.

## Notes

- Prefer `git push origin v1 --force` over `git push origin --tags -f`. Same result today, but the scoped push cannot collaterally move some other tag.
- Keep `v1` **lightweight**. No `-a`/`-m` — annotating changes what `actions/checkout` resolves.
- **Rollback:** `git tag -f v1 <old-sha> && git push origin v1 --force`.

## Red flags — stop and ask

- About to run `git push ... --force` without having shown the user a commit list
- Tagging `HEAD`, `main`, or a branch name instead of `origin/main`
- `git log v1..origin/main` contains commits you did not write and did not mention
- Skipping the pre-flight checks because "it's just a tag move"
