# dotfiles

This repository stores configuration files for various tools and applications.
The configs live under `~/dotfiles/.config/` and are symlinked into `~/.config/`
using [GNU Stow](https://www.gnu.org/software/stow/),
so the actual files are version-controlled here while the tools
find them at their expected paths.

> [!NOTE]
> **Why `.config/` exists?**
>
> Tool-specific configs are intentionally grouped under `./.config/` instead of
> being placed directly at the repository root.
> This mirrors their destination under `~/.config/` and clearly separates
> managed application configs from repository-level files such as scripts,
> GitHub metadata, and development tooling.

## Requirements

- **macOS**
- **git** – to clone the repository (with submodule support)
- **GNU Stow** – to create the symlinks

  ```sh
  brew install stow
  ```

- **JetBrainsMono Nerd Font** – set as `font-family` in [Ghostty config](.config/ghostty/config)

  ```sh
  brew install --cask font-jetbrains-mono-nerd-font
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
   bash -c 'for item in fish nvim git ghostty helix tmux starship.toml; do mv ~/.config/$item ~/.config/${item}.bak; done'
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

## Customization

### fish

See [`./.config/fish/README.md`](./.config/fish/README.md) for details on
`conf.d/` conventions and runtime dependencies (e.g. Bash 5.x for SDKMAN!).

#### Machine-local functions

| Directory          | Tracked          | Purpose                                             |
| ------------------ | ---------------- | --------------------------------------------------- |
| `functions/`       | Yes              | Version-controlled functions shared across machines |
| `functions.local/` | No (git-ignored) | Machine-specific functions that stay local          |

`functions.local/` is registered on `$fish_function_path` by
`conf.d/00-autoload-local-functions.fish` and is prepended so that a local
function can override a tracked one of the same name.

> **Note on `funcsave`:** `funcsave` (and `funced --save`) always writes to
> `~/.config/fish/functions/`, the tracked directory. It does not honor the
> priority order of `$fish_function_path`, so a function saved this way is
> created as a new tracked file and will appear in `git status`. For a
> machine-local function, do not rely on `funcsave`; create or move the file
> under `functions.local/` by hand.

### Go

In `./.config/fish/config.fish`:

- `GOPATH` is set to `~/.go`
- `$GOPATH/bin` is added to `PATH`

This keeps the home directory visually cleaner by avoiding a visible `~/go` directory.

## Development

### Commit Message Format

This repository uses [Lefthook](https://lefthook.dev/)
to run pre-commit hooks that check commit messages for compliance with
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

So you need to install Lefthook and set up the hooks before committing:

```sh
brew install lefthook
cd ~/dotfiles
lefthook install
```

## Contributions

Thank you for your interest in contributing!

This repository is maintained as a personal development environment and engineering log.
To preserve the integrity and continuity of its issue and pull request history,
**I'm not currently accepting external issues or pull requests.**

Please feel free to fork this repository and modify your own copy!

## License

[MIT](LICENSE)
