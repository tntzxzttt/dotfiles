#!/usr/bin/env bash

set -euo pipefail

BASE="main"
NVIM_DIR=".config/nvim"

# ANSI color support for tty output
if [[ -t 1 ]]; then
  cyan="\033[36m"
  reset="\033[0m"
else
  cyan=""
  reset=""
fi

# Get the latest commit hash of the nvim config directory.
hash=$(git -C "$NVIM_DIR" log -1 --format=%h)
if [ -z "$hash" ]; then
  echo "cannot find the latest commit hash for $NVIM_DIR" >&2
  exit 1
fi
branch="chore/update-nvim-config-to-$hash"
current_branch="$(git branch --show-current)"

# Switch to the target branch if not already on it.
if [ "$current_branch" == "$branch" ]; then
  :
elif [ "$current_branch" == "$BASE" ]; then
  git switch -C "$branch"
else
  echo "Current branch is $current_branch, expected to be either $BASE or $branch." >&2
  exit 1
fi

# Commit and push the submodule update.
git add "$NVIM_DIR"
git commit --no-verify -m "chore(nvim): update nvim config to $hash"
git push -u origin "$branch"

# Create a pull request.
title="Update Neovim config to \`$hash\`"
body="$(
  cat <<EOF
## Overview

Update Neovim config to https://github.com/tntzxzttt/nvim/commit/$hash
EOF
)"
gh pr create \
  --base "$BASE" \
  --head "$branch" \
  --title "$title" \
  --body "$body" \
  --draft
echo -e "${cyan}Pull request created successfully.${reset}"
