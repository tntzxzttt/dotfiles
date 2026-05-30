if status is-interactive
# Commands to run in interactive sessions can go here
end

# PATH
fish_add_path --path /opt/homebrew/bin
fish_add_path --path /opt/homebrew/opt/mysql-client/bin
fish_add_path --path /opt/homebrew/opt/asdf/libexec/bin
fish_add_path --path /Applications/Ghostty.app/Contents/MacOS

# Enable Starship
starship init fish | source

# anyenv
fish_add_path --path $HOME/.anyenv/bin
eval "$(anyenv init - fish)"

# Go
set -gx GOPATH $HOME/.go
fish_add_path --path $GOPATH/bin

# WARNINGS: This direnv setup must be placed at the end of this file.
# Refer to https://direnv.net/docs/hook.html#fish.
direnv hook fish | source
