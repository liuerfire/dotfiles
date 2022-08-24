setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:default' menu select=2

# Completing Groping
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''

# Completing misc
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
zstyle ':completion:*' use-cache true
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# default: --
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
