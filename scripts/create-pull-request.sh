#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <issue-number>"
  exit 1
fi

BASE="main"
HEAD="$(git rev-parse --abbrev-ref HEAD)"
issue_number=$(echo "$1" | grep -oE '[0-9]+')

# ANSI color support for tty output
if [[ -t 1 ]]; then
  red="\033[31m"
  cyan="\033[36m"
  bold="\033[1m"
  reset="\033[0m"
else
  red=""
  cyan=""
  bold=""
  reset=""
fi

# Check if the same pull request already exists
if gh pr view "$HEAD" > /dev/null 2>&1; then
  echo -e "${red}Error: a pull request for the current branch already exists.${reset}"
  exit 1
fi

# Check the commit messages
while IFS= read -r msg; do
  ./scripts/check-commit-msg.sh "$msg"
done < <(git log "$BASE..$HEAD" --format=%s)

# Confirm the pull request title and body before creating the pull request.
title="$(gh issue view "$issue_number" --json title,number -q '"\(.title) (#\(.number))"')"
body="$(cat <<EOF
## Overview

close #$issue_number
EOF
)"
echo "Creating a pull request with the following title and body:"
echo ""
echo -e "${bold}# ${cyan}${title}${reset}"
echo ""
echo -e "${cyan}${body}${reset}"
echo ""
read -p "Continue? [y/N] " answer
case "$answer" in
  [Yy]*) ;;
  *) echo -e "${red}Aborted.${reset}"; exit 1 ;;
esac

# Create the pull request
git push origin "$HEAD"
gh pr create \
  --base "$BASE" \
  --head "$HEAD" \
  --title "$title" \
  --body "$body" \
  --draft
echo -e "${cyan}Pull request created successfully.${reset}"
