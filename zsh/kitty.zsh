alias ssh='kitty +kitten ssh'

function cwd() {
  pwd | sed "s|^$HOME|~|"
}

# Function to set terminal title
function set_terminal_title() {
  if [[ -n "$1" ]]; then
    # When a process is running, show the command and the current directory
    print -Pn "\e]0;$(cwd): $1\a"
  else
    # Default title showing only the current directory
    print -Pn "\e]0;$(cwd)\a"
  fi
}

# Pre-command hook to update the terminal title before each command
function preexec() {
  # Update the terminal title with the running command and the current directory
  set_terminal_title "$1"
}

# Post-command hook to reset the terminal title after each command
function precmd() {
  # Reset the terminal title to the current directory
  set_terminal_title
}

# Call the function to set the initial title when the shell starts
set_terminal_title
