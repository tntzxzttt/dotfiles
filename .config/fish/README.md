# fish

## conf.d/ naming convention

| Range | Purpose |
| --- | --- |
| `00-09` | Foundation: PATH, locale, `XDG_*`, `EDITOR`, and other exported variables |
| `10-49` | Tool setup and initialization (one file per tool) |
| `50-79` | Interactive use: abbreviations, key bindings, completions |
| `90-99` | Overrides and final adjustments |
| `*.local.fish` | Machine-specific (gitignored; use a number matching the purpose) |

Installer-managed files (e.g. `sdk.fish` from fisher) are exceptions to this numbering rule.

## Bash 5.x dependency

The [sdkman-for-fish](https://github.com/reitzig/sdkman-for-fish) plugin
runs `bash -c "source sdkman-init.sh"` during initialization in `conf.d/sdk.fish`.
SDKMAN! uses Bash 4+ syntax (`${var^^}`), which is incompatible with
the macOS default `/bin/bash` (Bash 3.2).

To avoid this, `conf.d/00-path.fish` prepends `/opt/homebrew/bin` to PATH
so that Homebrew's Bash 5.x is resolved first. This requires:

```sh
brew install bash
```
