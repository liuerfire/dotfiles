export GOPROXY="https://goproxy.io,direct"
export EDITOR="nvim"
export RUSTUP_DIST_SERVER=https://mirrors.sjtug.sjtu.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.sjtug.sjtu.edu.cn/rust-static/rustup
export BAT_PAGER="less -RXF"

path=(
  $HOME/bin
  $HOME/go/bin
  $HOME/.cargo/bin
  $path
)
