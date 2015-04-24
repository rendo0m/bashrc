# Oh, THE COLORS!
# enable color support of ls and also add handy aliases

if command -v dircolors &> /dev/null; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
  
  export LS_OPTIONS='--color=auto'
  
  alias ls='ls $LS_OPTIONS'
  alias dir='dir $LS_OPTIONS'
  alias vdir='vdir $LS_OPTIONS'

  alias grep='grep $LS_OPTIONS -n'
  alias fgrep='fgrep $LS_OPTIONS -n'
  alias egrep='egrep $LS_OPTIONS -n'
fi

# Use custom colors for the ant console output
export ANT_OPTS="-Dant.logger.defaults=${HOME}/.ant_settings"

# Create aliases for color version of optional commands if they both exist
smart-alias svn 'colorsvn'
smart-alias ant 'ant -logger org.apache.tools.ant.listener.AnsiColorLogger'
