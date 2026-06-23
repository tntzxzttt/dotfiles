if status is-interactive
# Commands to run in interactive sessions can go here
end

# Enable Starship
starship init fish | source

# Aliases
alias d='docker'
alias dc='docker compose'
alias g='git'
alias grep='grep --color=auto'
alias k='kubectl'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias m='minikube'
alias myip='curl inet-ip.info'
alias n='npm'
alias nd='node'
alias ne='nodenv'
alias nv='nvim'
alias p='pnpm'
alias pe='pyenv'
alias po='poetry'
alias py='python'
alias ta='tmux attach -t'
alias tl='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias v='vim'
alias view='nvim -R'
alias y='yarn'

# anyenv
fish_add_path --path $HOME/.anyenv/bin
eval "$(anyenv init - fish)"

# Go
set -gx GOPATH $HOME/.go
fish_add_path --path $GOPATH/bin

# pnpm
set -gx PNPM_HOME $HOME/Library/pnpm
fish_add_path --path $PNPM_HOME

# Android SDK
set -gx ANDROID_HOME $HOME/Library/Android/sdk
fish_add_path --path $ANDROID_HOME/platform-tools

# WARNINGS: This direnv setup must be placed at the end of this file.
# Refer to https://direnv.net/docs/hook.html#fish.
direnv hook fish | source
