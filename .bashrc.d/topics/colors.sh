# Oh, THE COLORS!
if command -v dircolors &> /dev/null; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto -n'
  alias fgrep='fgrep --color=auto -n'
  alias egrep='egrep --color=auto -n'
fi

# Use custom colors for the ant console output
export ANT_OPTS="-Dant.logger.defaults=${HOME}/.ant_settings"

# Create aliases for color version of optional commands if they both exist
smart-alias svn 'colorsvn'
smart-alias ant 'ant -logger org.apache.tools.ant.listener.AnsiColorLogger'
