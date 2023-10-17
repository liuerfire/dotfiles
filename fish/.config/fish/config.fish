fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin

set -g fish_greeting
set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx PAGER less -RFXM
set -gx BAT_PAGER less -RXF
set -gx GOPROXY https://goproxy.cn,direct
set -gx BAT_THEME 'Visual Studio Dark+'
set -gx https_proxy http://127.0.0.1:7890
set -gx no_proxy localhost,127.0.0.1

if test -n "$PYTHONPATH"
    set -x PYTHONPATH '/usr/lib/python3.10/site-packages/pdm/pep582' $PYTHONPATH
else
    set -x PYTHONPATH '/usr/lib/python3.10/site-packages/pdm/pep582'
end

if status is-interactive
    alias ls eza
    alias vi /usr/bin/vim
    alias vim nvim
    alias v 'nvim +FF'
    alias vimdiff 'nvim -d'

    alias docker-rm-dangling 'docker rmi $(docker images -f "dangling=true" -q) -f'
    alias kc kubectl
    alias cdtmp 'cd $(mktemp -d)'
    alias icat 'kitten icat'

    alias mycli '~/workspace/tmp/venv/bin/mycli'

    abbr -a ip ip -c=auto
    abbr -a pacman-list-orphans pacman -Qtdq
    abbr -a pacman-pkg-info pacman -Q -i
    abbr -a pacx sudo pacman --remove
    abbr -a pacX sudo pacman --remove --nosave --recursive

    if command -sq fzf
        set fzf_fd_opts --hidden --exclude=.git
        set fzf_preview_dir_cmd exa --all --color=always
    end

    set -x GPG_TTY (tty)
end

zoxide init fish | source
