function ssh -d "在 kitty 中自动使用 ssh kitten"
    if test $TERM = 'xterm-kitty'; and not string length -q -- $SSH_TTY
        kitty +kitten ssh $argv
    else
        /usr/bin/ssh $argv
    end
end
