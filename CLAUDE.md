# CLAUDE.md

## Repository Structure

- Configs are managed under `.config/` using GNU Stow
- Each directory under `.config/` corresponds to an application and is treated as a valid scope
- Always run `ls .config/` to confirm the current list of scopes before starting work
- When deriving a scope from a filename (e.g. `starship.toml`), use the base name without extension (e.g. `starship`)
- `.config/nvim` and `.tmux` are git submodules — do not edit them directly in this repository
- `.config/tmux/tmux.conf` is a symlink into the `.tmux` submodule (`.tmux/.tmux.conf`); never edit it, as doing so can break oh-my-tmux
- To change tmux settings, edit only `.config/tmux/tmux.conf.local` (a regular file tracked in this repo, loaded by oh-my-tmux as the user override)

## GitHub Workflow

### Branches

- Never push directly to `main` or work on the `main` branch
- Always create a feature branch before making changes
- Format: `<type>/N-<title>` if an issue exists, otherwise `<type>/<title>`
  - `<type>`: Conventional Commits type (e.g. `feat`, `fix`, `chore`)
  - `N`: issue number
  - `<title>`: derived from the issue title, with the scope removed (the scope should be apparent from the title itself)
- Rules: lowercase only, characters limited to `[a-z0-9]` and `/-`
- Abbreviate or omit words if the title is too long (e.g. `kubernetes` → `k8s`)

Examples:

- `feat/12-add-popup-menu-keybind` (for issue `[tmux] Add popup menu keybind`)
- `chore/3-update-theme-colors` (for issue `[ghostty] Update theme colors`)

### Issues

- Open an issue before making changes to document the motivation, context, and goal
- This keeps a knowledge base of why each change was made, not just what changed
- Minor adjustments that need no discussion can skip an issue, but still require a PR
- The title format and body structure are defined solely by the issue template — do not restate or maintain a separate copy here:
  - `.github/ISSUE_TEMPLATE/default.md`
- When creating an issue non-interactively (e.g. via `gh`), read that template file first and fill in its sections; do not invent a different structure

### Commit Messages

- Format: Conventional Commits
- Include scope when the change targets a specific application config
- Append `(#N)` if an issue exists; omit if not
- When `git commit` is run, lefthook executes `.githooks`, one of which checks that the commit message contains both a scope and an issue number
- If either is missing, the hook would normally prompt for confirmation via stdin — but Claude Code runs in a non-interactive shell and cannot respond to such prompts
- Therefore, always use `-n` (`--no-verify`) when either scope or issue number is absent

```text
<type>(<scope>): <description> (#N)
```

Examples:

- `feat(tmux): add popup menu keybind (#12)`
- `fix(fish): remove hardcoded PATH from fish_variables (#5)`
- `chore: update README`  ← no scope for non-application changes

### Pull Requests

**If linked to an issue:**

Run the following script:

```sh
./scripts/create-pull-request.sh N
```

**If not linked to an issue:**

- Title: sentence case (first word capitalized only)
- Use `##` or lower for headings (never `#`)

**Description:**

- The body structure (the `## Overview` section and its content for both
  linked and non-linked cases) is defined solely by the PR template — do not
  restate or maintain a separate copy here:
  - `.github/pull_request_template.md`
- Note: a PR template defines the body only; it cannot set the title.
  So the title rule above is not covered by the template and must stay here.
