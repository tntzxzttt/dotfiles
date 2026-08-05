# Contributing

These notes are for maintaining this repository — for me, and for anyone who
forks it to keep their own copy.

## Contribution policy

Thank you for your interest in contributing!

This repository is maintained as a personal development environment and
engineering log. To preserve the integrity and continuity of its issue and
pull request history, **I'm not currently accepting external issues or pull
requests.**

Please feel free to fork this repository and modify your own copy!

## Repository structure

> [!NOTE]
> **Why `.config/` exists?**
>
> Tool-specific configs are intentionally grouped under `./.config/` instead of
> being placed directly at the repository root.
> This mirrors their destination under `~/.config/` and clearly separates
> managed application configs from repository-level files such as scripts,
> GitHub metadata, and development tooling.

Configs are symlinked into `~/.config/` with GNU Stow (see
[`install.sh`](install.sh)), which folds each managed directory into a single
symlink. Files added under an already-stowed directory are therefore picked up
automatically; only a brand-new top-level item needs another stow run to be
linked. The trade-off is that tools write their runtime files (plugins, logs,
sockets, session state) back into this repo's working tree, so those paths are
git-ignored.

## Adding a new config

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

3. Stow the new top-level item to fold it into `~/.config/`:

   ```sh
   cd ~/dotfiles
   stow --restow --target="$HOME/.config" .config
   ```

4. Commit the changes:

   ```sh
   git add .config/<tool> .gitignore
   git commit -m "feat(<tool>): add config"
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

## Commit messages

This repository uses [Lefthook](https://lefthook.dev/)
to run pre-commit hooks that check commit messages for compliance with
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

So you need to install Lefthook and set up the hooks before committing:

```sh
brew install lefthook
cd ~/dotfiles
lefthook install
```
