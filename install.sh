#!/usr/bin/env bash
#
# Install this dotfiles repo into ~/.config using GNU Stow.
#
# Each managed item under .config/ (e.g. nvim, fish, herdr) is symlinked into
# ~/.config/ as a whole (Stow's default directory folding), so files added under
# a managed directory later are picked up without re-running Stow.
#
# Adopting these dotfiles means starting from this repo's config: any existing
# ~/.config/<tool> is moved aside to ~/.config/<tool>.<timestamp>.bak before
# stowing, so your previous setup is preserved for reference but not merged. The
# timestamp is captured once at startup and shared across every backup in the
# run.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE=".config"
TARGET="$HOME/.config"
STAMP="$(date +%Y%m%dT%H%M%S)"
REPO_PHYS="$(cd "$REPO" && pwd -P)"
PKG_PHYS="$REPO_PHYS/$PACKAGE"

# Ensure GNU Stow is available. Homebrew's bin may not be on PATH yet (e.g. a
# fresh shell), so stow installed via `brew install stow` would not be found;
# prepend the standard Homebrew bin directories (Apple Silicon and Intel) first.
ensure_stow() {
  local brew_bin
  for brew_bin in /opt/homebrew/bin /usr/local/bin; do
    [ -d "$brew_bin" ] && PATH="$brew_bin:$PATH"
  done

  if ! command -v stow >/dev/null 2>&1; then
    echo "error: GNU Stow is not installed (brew install stow)" >&2
    exit 1
  fi
}

# True when $1 is a symlink already pointing into this repo's package, i.e. a
# folded link a previous run created. Such items are left for stow to restow, so
# re-running the installer makes no backups.
is_ours() {
  [ -L "$1" ] || return 1
  local link dir
  link="$(readlink "$1")"
  dir="$(cd "$(dirname "$1")" 2>/dev/null && cd "$(dirname "$link")" 2>/dev/null && pwd -P)" || return 1

  case "$dir/$(basename "$link")" in
  "$PKG_PHYS"/*) return 0 ;;
  *) return 1 ;;
  esac
}

# Move any pre-existing config aside so stow can fold each item into a clean
# directory symlink, e.g. ~/.config/nvim -> ~/.config/nvim.<timestamp>.bak.
backup_existing() {
  local path name target dest
  for path in "$PKG_PHYS"/*; do
    name="$(basename "$path")"
    target="$TARGET/$name"
    is_ours "$target" && continue
    if [ -e "$target" ] || [ -L "$target" ]; then
      dest="$target.$STAMP.bak"
      echo "backup: $target -> $dest"
      mv "$target" "$dest"
    fi
  done
}

main() {
  ensure_stow

  # Submodules (oh-my-tmux, nvim, tmux) must be checked out, otherwise stow
  # would link an empty tree.
  git -C "$REPO" submodule update --init --recursive

  mkdir -p "$TARGET"
  backup_existing

  stow --restow --dir="$REPO" --target="$TARGET" "$PACKAGE"
  echo "stowed $PACKAGE into $TARGET"
}

main "$@"
