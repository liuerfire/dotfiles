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
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
# }}

# plugins {{
if [[ ! -d ~/.zsh/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k
fi
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

if [[ ! -d ~/.zsh/fast-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zdharma/fast-syntax-highlighting ~/.zsh/fast-syntax-highlighting
fi
source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

if [[ ! -d ~/.zsh/zsh-z ]]; then
  git clone --depth=1 https://github.com/agkozak/zsh-z.git ~/.zsh/zsh-z
fi
source ~/.zsh/zsh-z/zsh-z.plugin.zsh
alias j='z'

if [[ ! -d ~/.zsh/zsh-completions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
fi
fpath=(~/.zsh/zsh-completions/src $fpath)

if [[ ! -d ~/.zsh/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# }}

function update-zsh-plugins {
  cd ~/.zsh
  find . -mindepth 1 -maxdepth 1 -type d -exec git --git-dir={}/.git --work-tree=$PWD/{} pull -v \;
}

# fzf config {{
if [[ -s ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
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

for file in ~/.zsh-custom/*.zsh; do
  source "$file"
done
[ -s ~/.zsh_private ] && source ~/.zsh_private

typeset -gU cdpath fpath mailpath path

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
