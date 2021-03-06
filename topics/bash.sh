# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
HISTCONTROL=ignoreboth
HISTIGNORE='&:clear:ls:cd:[bf]g:exit:[ t\]*'

# Some handy shell options
shell_options=(
  checkhash
  checkwinsize
  histappend
  extglob
  cdspell
  dirspell
  globstar
  autocd
)

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

if ! shopt -qs "${shell_options[@]}"; then
  echo "
Warning! Not all shell options were set.
You are probably running an older verison of bash:
$(bash --version)

The following shell options are set:
$(shopt -s)
"
fi

case ${PLATFORM} in
  darwin)
    # Set up bash completion on OSX with brew
    if [[ -f "${brew_prefix}/share/bash-completion/bash_completion" ]]; then
        source "${brew_prefix}/share/bash-completion/bash_completion"
    fi
    ;;
  *)
    # Completion is critical; this needs to be set up before my aliases file
    if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
      source /etc/bash_completion
    fi
    ;;
esac
