# vim: set foldmarker={{,}} foldmethod=marker:

bindkey -e

# options {{
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

HISTFILE="${HISTFILE:-${ZDOTDIR:-$HOME}/.zhistory}"  # The path to the history file.
HISTSIZE=1000000                   # The maximum number of events to save in the internal history.
SAVEHIST=1000000                   # The maximum number of events to save in the history file.

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
# }}

# plugins {{
if [[ ! -d ~/.zsh/plugins/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/plugins/powerlevel10k
fi
source ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme

if [[ ! -d ~/.zsh/plugins/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
fi
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# }}

function update-zsh-plugins {
  cd ~/.zsh/plugins
  find . -mindepth 1 -maxdepth 1 -type d -exec git --git-dir={}/.git --work-tree=$PWD/{} pull -v \;
}

# fzf config {{
if [[ -n "$(command -v fzf)" ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || bat {} || tree -C {}) 2> /dev/null | head -200'"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi
# }}

source-env() {
  if [[ -s .env ]]; then
    source .env
  fi
}

add-zsh-hook chpwd source-env

autoload -U compinit && compinit

for file in ~/.zsh/*.zsh; do
  source "$file"
done

[[ -s ~/.zsh_private ]] && source ~/.zsh_private

typeset -gU cdpath fpath mailpath path

eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
