# ==============================================================================
# Environment & Paths
# ==============================================================================

fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin

set -g fish_greeting
set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx PAGER less -RFXM
set -gx BAT_PAGER less -RXF

# ==============================================================================
# Interactive Session
# ==============================================================================

if status is-interactive
    # Standard Aliases
    alias vi /usr/bin/vim
    alias vim nvim
    alias v 'nvim +FF'
    alias vimdiff 'nvim -d'
    alias icat 'kitten icat'
    alias kc kubectl
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

    # FZF Configuration
    if command -sq fzf
        set -gx fzf_fd_opts --hidden --exclude=.git
        set -gx fzf_preview_dir_cmd eza --all --color=always
    end

    # GPG Configuration
    set -gx GPG_TTY (tty)

    # Prompt (Starship)
    if command -sq starship
        starship init fish | source
    end
end

# ==============================================================================
# Tool Initializations
# ==============================================================================

if command -sq zoxide
    zoxide init fish | source
end

if command -sq atuin
    atuin init fish | source
end

# Private settings
if test -f ~/.fish_private
    source ~/.fish_private
end
