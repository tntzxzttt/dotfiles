# Homebrew Bundle — install everything with: brew bundle --no-upgrade
# (plain `brew bundle` upgrades outdated dependencies; --no-upgrade only adds
# what is missing.)
#
# The tools whose configs this repo manages (symlinked by install.sh), plus the
# dependencies they need. git is omitted on purpose — macOS ships it.
#
# Homebrew cannot pin versions, so this installs current releases. One caveat is
# tmux — see the status-bar note in .config/tmux/tmux.conf.local.

# GNU Stow — creates the ~/.config symlinks (used by install.sh)
brew 'stow'

# Managed tools
brew 'fish'
brew 'tmux'
brew 'herdr'
brew 'neovim'
brew 'helix'
brew 'starship'

# Dependency of the `ide` fish function (builds the herdr pane layout)
brew 'jq'

# GUI apps and font
cask 'ghostty'
cask 'zed'
cask 'font-jetbrains-mono-nerd-font'
