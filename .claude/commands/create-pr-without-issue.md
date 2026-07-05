---
description: Stash current changes, sync main, create a branch, and open a PR (no issue required)
allowed-tools: Bash, Read, Grep, AskUserQuestion
---

<!-- markdownlint-disable MD040 MD041 -->

## Instructions

Commit the current working-tree changes and create a PR **without** a linked issue.
Always ask the user for approval before committing and before creating the PR.

**Do not `git add` changes under `.config/nvim/` or `.tmux/`** — these are git
submodules managed separately. Ignore any modifications in those directories.

## Pre-flight

Current status:

!`git status`

Current diff (staged + unstaged):

!`git diff HEAD`

If there are no changes to commit, tell the user and stop.

## Steps

### 1. Prepare the branch

Run these commands **in order**. If any step fails, stop and report the error.

```
git stash
git switch main
git pull
```

Then create a feature branch. Derive the branch name from the changes using the
CLAUDE.md branch naming rules (`<type>/<title>`, lowercase, `[a-z0-9/-]` only).

```
git switch -c <branch>
git stash pop
```

**If `git stash pop` produces a conflict, stop immediately.** Tell the user
there is a merge conflict and do not proceed further.

### 2. Commit

**Do not `git add` changes under `.config/nvim/` or `.tmux/`** — these are git
submodules managed separately. Ignore any modifications in those directories.

Review the changes and split them into commits at an appropriate granularity.
Follow the Conventional Commits format defined in CLAUDE.md.
Since there is no linked issue, omit the `(#N)` suffix.
Since the commit-msg hook requires interactive confirmation for missing scope/issue,
use `-n` (`--no-verify`) when either is absent.

**Before running each `git commit`, show the user the files to be staged and the
proposed commit message, then ask for approval.**

### 3. Push & create PR

Push the branch and create a PR using `gh pr create`.

- Title: sentence case (first word capitalized only)
- Body: follow the PR template at `.github/pull_request_template.md`
  (read the template first; use the "not linked to an issue" variant)

**Before creating the PR, show the user the proposed title and body, then ask
for approval.**

Return the PR URL when done.
