#!/usr/bin/env bash

set -euo pipefail

YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

if ! command -v claude >/dev/null 2>&1; then
  echo -e "${YELLOW}Skipping pre-push review: claude command not found.${RESET}"
  exit 0
fi

echo -e "${YELLOW}Running pre-push review with Claude...${RESET}"

output=$(claude -p /pre-push-review --allowedTools 'Read,Grep' 2>&1)

echo "$output"

if echo "$output" | grep -qi "Safe to push"; then
  echo ""
  echo -e "${GREEN}Pre-push review passed.${RESET}"
  exit 0
fi

echo ""
echo -e "${RED}${BOLD}Push blocked by pre-push review.${RESET}"
echo -e "${RED}Please fix the issues above, or use --no-verify to bypass.${RESET}"
exit 1
