#!/usr/bin/env bash

# This script checks if the commit message follows the conventional commit format.
# It validates:
#   1. The presence of a scope and its value against an allowed list.
#   2. The presence of an issue number (e.g. (#123)) at the end of the title.
#
# [Example — scope]
# feat: add new feature              -> WARNING (no scope)
# feat!: add new feature             -> WARNING (no scope)
# feat(scope): add new feature       -> OK
# feat(scope)!: add new feature      -> OK
# feat(invalid): add new feature     -> ERROR (invalid scope)
#
# [Example — issue number]
# feat(fish): add aliases            -> WARNING (no issue number)
# feat(fish): add aliases (#11)      -> OK
#
# When multiple warnings are found, they are reported together in a single
# prompt so the user only has to confirm once.

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <commit-message>"
  exit 2
fi

commit_msg="$1"

# Valid scopes — update this list when adding new tool configurations.
valid_scopes=(
  fish
  ghostty
  git
  helix
  nvim
  starship
  tmux
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

setup_colors() {
  if [[ -t 1 ]]; then
    red="\033[31m"
    yellow="\033[33m"
    cyan="\033[36m"
    bold="\033[1m"
    reset="\033[0m"
  else
    red=""
    yellow=""
    cyan=""
    bold=""
    reset=""
  fi
}

# Prompt the user with a yes/no question via /dev/tty.
# Exits 1 if the user declines or no TTY is available.
confirm_or_abort() {
  if [[ ! -r /dev/tty ]]; then
    echo "Error: cannot read user input because no TTY is available."
    echo "Hint: set 'interactive: true' for this lefthook command, or fix the commit message."
    exit 1
  fi

  printf "Continue anyway? [y/N] " > /dev/tty
  IFS= read -r answer < /dev/tty

  case "$answer" in
    [Yy]*) ;;
    *) echo -e "${red}Aborted.${reset}"; exit 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

warnings=()

# Warn if the commit message has a type but no scope.
check_scope_presence() {
  if printf '%s\n' "$commit_msg" | grep -Eq '^[a-z]+!?:' \
    && ! printf '%s\n' "$commit_msg" | grep -Eq '^[a-z]+\(.+\)!?:'; then
    warnings+=("No scope")
  fi
}

# Validate the scope value against the allowed list.
check_scope_value() {
  local scope
  scope=$(printf '%s\n' "$commit_msg" | sed -n 's/^[a-z]*(\([^)]*\))!*:.*/\1/p')

  if [[ -z "$scope" ]]; then
    return
  fi

  local is_valid=false
  for s in "${valid_scopes[@]}"; do
    if [[ "$s" == "$scope" ]]; then
      is_valid=true
      break
    fi
  done

  if [[ "$is_valid" == false ]]; then
    echo ""
    echo -e "${red}[ERROR] invalid scope '${bold}${scope}${reset}${red}' in commit message:${reset}"
    echo -e "${cyan}${bold}$commit_msg${reset}"
    echo ""
    echo -e "Allowed scopes: ${cyan}${valid_scopes[*]}${reset}"
    exit 1
  fi
}

# Warn if the commit title does not end with an issue number like (#123).
check_issue_number() {
  local title
  title=$(printf '%s\n' "$commit_msg" | head -n 1)

  if ! printf '%s\n' "$title" | grep -Eq '\(#[0-9]+\)\s*$'; then
    warnings+=("No issue number")
  fi
}

# Print all collected warnings and prompt the user once.
report_warnings() {
  if [[ ${#warnings[@]} -eq 0 ]]; then
    return
  fi

  echo ""
  echo -e "${yellow}[WARNING] issues found in the commit message:${reset}"
  for w in "${warnings[@]}"; do
    echo -e "  - $w"
  done
  echo ""
  echo -e "Got:      ${cyan}${bold}$commit_msg${reset}"
  echo -e "Expected: ${cyan}type(scope): description (#123)${reset}"
  echo ""

  confirm_or_abort
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

setup_colors
check_scope_presence
check_scope_value
check_issue_number
report_warnings
