# some more ls aliases
alias l='ls -CF'
alias ll='ls -alhF'
alias la='ls -A'
alias lla='ls -lA'

# some more cd aliases
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# some more command aliases
alias apt='sudo apt'
alias update='sudo apt update && sudo apt upgrade'
alias vi=vim
alias svi='sudo vim'
alias edit='vim'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'

# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

alias ducks='du -cksh * | sort -rn | head'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
