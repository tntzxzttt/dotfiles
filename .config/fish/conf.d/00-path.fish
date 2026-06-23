# PATH
# Loaded before other conf.d/ files to ensure tools like
# /opt/homebrew/bin/bash are available during initialization.

fish_add_path --path --prepend --move /opt/homebrew/bin
fish_add_path --path $HOME/.local/bin
fish_add_path --path /opt/homebrew/opt/mysql-client/bin
fish_add_path --path /opt/homebrew/opt/asdf/libexec/bin
fish_add_path --path /Applications/Ghostty.app/Contents/MacOS
