# anyenv
fish_add_path --path $HOME/.anyenv/bin
eval "$(anyenv init - fish)"

if status is-interactive
    # Aliases
    alias d='docker'
    alias dc='docker compose'
    alias g='git'
    alias grep='grep --color=auto'
    alias h='herdr'
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

    # Enable Starship
    starship init fish | source

    # WARNINGS: This direnv setup must be placed at the end of this file.
    # Refer to https://direnv.net/docs/hook.html#fish.
    direnv hook fish | source
end
