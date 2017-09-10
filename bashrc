
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source_platform() {
  if [[ ${OS} =~ Windows ]]; then
    uname_flag='-o'
  else
    uname_flag='-s'
  fi

  export PLATFORM=$(uname ${uname_flag} | tr '[:upper:]' '[:lower:]')

  source "${HOME}/.bashrc.d/platform/${PLATFORM}.sh"
}

source_dir() {
  local dir=${HOME}/.bashrc.d/${1}

  if [[ -d ${dir} ]]; then
    local dotd
    while read dotd <&3; do
      source "${dotd}"
    done 3< <(find "${dir}" -name '*.sh')
  fi
}

# Source my functions and start setting up my PATH
source_dir functions
path-prepend "${HOME}/bin"

# Source platform dependent stuff first to help with paths, etc.
source_platform

# Source the rest of the things.
source_dir topics

# Start TMUX
# This should always be run last either in .bashrc or as a script in .bashrc.d
if [[ -z "$TMUX" ]]; then
    tmux has-session &> /dev/null
    if [ $? -eq 1 ]; then
       exec tmux new
       exit
    else
       exec tmux attach
       exit
    fi
fi
