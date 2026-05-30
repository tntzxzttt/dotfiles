# dotfiles

This repository stores configuration files for various tools and applications.
The configs live under `~/dotfiles/.config/` and are symlinked into `~/.config/`
using [GNU Stow](https://www.gnu.org/software/stow/),
so the actual files are version-controlled here while the tools
find them at their expected paths.

## Requirements

- **macOS**
- **git** – to clone the repository (with submodule support)
- **GNU Stow** – to create the symlinks (`brew install stow`)

## Development

### Commit Message Format

This repository uses [Lefthook](https://lefthook.dev/)
to run pre-commit hooks that check commit messages for compliance with
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

So you need to install Lefthook and set up the hooks before committing:

```sh
brew install lefthook
cd path/to/this/repo # ~/dotfiles in most cases
lefthook install
```

## Set up

### Install

1. **Clone the repository** to `~/dotfiles`:

   ```sh
   git clone --recurse-submodules https://github.com/tntzxzttt/dotfiles.git ~/dotfiles
   ```

   The `--recurse-submodules` flag is required to pull in
   [oh-my-tmux](https://github.com/gpakosz/.tmux), which is included as a git
   submodule under `.tmux/`.

2. **Back up any existing configs** you want to preserve. For each managed
   directory (or file), move it out of `~/.config/` before running Stow:

   ```sh
   bash -c 'for item in fish nvim git ghostty tmux starship.toml; do mv ~/.config/$item ~/.config/${item}.bak; done'
   ```

3. **Run Stow** from `~/dotfiles` to create the symlinks:

   ```sh
   cd ~/dotfiles
   /opt/homebrew/bin/stow --target="$HOME/.config" .config
   ```

   This symlinks `~/dotfiles/.config/` → `~/.config/`, making every managed
   config available at its expected location.

### Uninstall

Remove the symlinks created by Stow:

```sh
cd ~/dotfiles
stow --target="$HOME/.config" -D .config
```

## Adding a New Config

1. Create the new config directory (or file) under `~/dotfiles/.config/`:

   ```sh
   mkdir -p ~/dotfiles/.config/<tool>

   # add a placeholder so the directory is committed
   touch ~/dotfiles/.config/<tool>/.gitkeep
   ```

2. Update `.gitignore` to whitelist the new directory:

   ```gitignore
   !.config/<tool>/
   !.config/<tool>/**
   ```

3. Re-run `stow --target="$HOME" .` from `~/dotfiles` to pick up the new entry.

4. Commit the changes:

   ```sh
   git add .config/<tool> .gitignore
   git commit -m "Add <tool> config"
   ```

## Updating oh-my-tmux

The `.tmux/` submodule tracks [gpakosz/.tmux](https://github.com/gpakosz/.tmux).
To update it:

```sh
cd ~/dotfiles
git submodule update --remote .tmux
```

Review the [changelog](https://github.com/gpakosz/.tmux/commits/master) before
updating — new versions may introduce breaking changes to `.tmux.conf.local`.

## Alternatives to Oh My Fish

Although Oh My Fish supports both package management and prompt customization,
it has not been actively maintained as of May 2026.
(The master branch was last updated 11 years ago...)

Instead, we use:

- [fisher](https://github.com/jorgebucaran/fisher) for package management
- [Starship](https://starship.rs) for prompt customization
