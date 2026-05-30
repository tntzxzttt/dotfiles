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
