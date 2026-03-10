# ==============================================================================
# Environment & Paths
# ==============================================================================

fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.npm/bin
fish_add_path $HOME/.local/bin

set -g fish_greeting
set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx PAGER less -RFXM
set -gx BAT_PAGER less -RXF

# Fish git prompt defaults
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_use_informative_chars 1

# ==============================================================================
# Interactive Session
# ==============================================================================

if status is-interactive
    # Standard Aliases
    alias vi /usr/bin/vim
    alias vim nvim
    alias icat 'kitten icat'
    alias cdtmp 'cd $(mktemp -d)'
    alias docker-rm-dangling 'docker rmi $(docker images -f "dangling=true" -q) -f'

    # eza (better ls)
    if command -sq eza
        alias ls 'eza --icons --group-directories-first'
        alias ll 'ls -lh'
        alias la 'ls -a'
        alias lla 'ls -lha'
        alias lt 'ls --tree'
    else
        alias ls 'ls --color=auto'
        alias ll 'ls -lh'
        alias la 'ls -A'
    end

    # Abbreviations (expanded on space/enter)
    abbr -a ip ip -c=auto
    abbr -a pacman-list-orphans pacman -Qtdq
    abbr -a pacman-pkg-info pacman -Q -i
    abbr -a pacx sudo pacman --remove
    abbr -a pacX sudo pacman --remove --nosave --recursive

    # GPG Configuration
    set -gx GPG_TTY (tty)
end

# ==============================================================================
# Tool Initializations
# ==============================================================================

if command -sq zoxide
    zoxide init fish | source
end

if command -sq atuin
    atuin init fish --disable-up-arrow | source
end

# Private settings
if test -f ~/.fish_private
    source ~/.fish_private
end
