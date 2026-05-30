#!/usr/bin/env bash

set -euo pipefail

ACTION="${1:?Usage: protect-main-branch.sh <action>}"

RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = "main" ]; then
  echo -e "${RED}ERROR: Direct ${ACTION} to the ${BOLD}'main'${RESET}${RED} branch is not allowed.${RESET}"
  echo -e "${RED}Please create a feature branch first.${RESET}"
  exit 1
fi
