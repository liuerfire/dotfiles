#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias icat='kitten icat'
alias ls='eza --icons'
alias ip='ip -c=auto'
alias v='nvim +FF'
alias vi='/usr/bin/vim'
alias vim='nvim'
alias vimdiff='nvim -d'
alias docker-rm-dangling='docker rmi $(docker images -f "dangling=true" -q) -f'
alias kc='kubectl'
alias cdtmp='cd $(mktemp -d)'
alias pacman-list-orphans='pacman -Qtdq'
alias pacman-pkg-info='pacman -Q -i'
# Removes packages and unneeded dependencies.
alias pacx='sudo pacman --remove'
# Removes packages, their configuration, and unneeded dependencies.
alias pacX='sudo pacman --remove --nosave --recursive'

if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh='kitty +kitten ssh'
fi

export EDITOR=nvim
export BAT_PAGER="less -RXF"
export PATH=$HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH

[[ -s ~/.bash_private ]] && source ~/.bash_private

eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(atuin init bash)"
