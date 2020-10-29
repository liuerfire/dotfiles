alias ls='exa'
alias j='z'
alias v='nvim $(fzf)'
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'
alias cat='bat'
alias docker-rm-dangling='docker rmi $(docker images -f "dangling=true" -q) -f'
alias kc='kubectl'
alias cdtmp='cd $(mktemp -d)'

alias pacman-list-orphans='pacman -Qtdq'
alias pacman-pkg-info='pacman -Q -i'
# Removes packages and unneeded dependencies.
alias pacx='sudo pacman --remove'
# Removes packages, their configuration, and unneeded dependencies.
alias pacX='sudo pacman --remove --nosave --recursive'
