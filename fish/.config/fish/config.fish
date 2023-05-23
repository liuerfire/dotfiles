fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin

set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx PAGER less -RFXM
set -gx RUSTUP_DIST_SERVER https://mirrors.sjtug.sjtu.edu.cn/rust-static
set -gx RUSTUP_UPDATE_ROOT https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup
set -gx BAT_PAGER less -RXF
set -gx GOPROXY https://goproxy.cn,direct
set -gx BAT_THEME 'Visual Studio Dark+'

if test -n "$PYTHONPATH"
    set -x PYTHONPATH '/usr/lib/python3.10/site-packages/pdm/pep582' $PYTHONPATH
else
    set -x PYTHONPATH '/usr/lib/python3.10/site-packages/pdm/pep582'
end

if status is-interactive
    alias ls exa
    alias vi /usr/bin/vim
    alias vim nvim
    alias v 'nvim +FF'

    alias docker-rm-dangling 'docker rmi $(docker images -f "dangling=true" -q) -f'
    alias kc kubectl
    alias cdtmp 'cd $(mktemp -d)'

    abbr -a ip ip -c=auto
    abbr -a pacman-list-orphans pacman -Qtdq
    abbr -a pacman-pkg-info pacman -Q -i
    abbr -a pacx sudo pacman --remove
    abbr -a pacX sudo pacman --remove --nosave --recursive

    set -x GPG_TTY (tty)
end

starship init fish | source
zoxide init fish | source
