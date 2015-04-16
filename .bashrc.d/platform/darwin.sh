# make less more friendly for non-text input files, see lesspipe(1)
if command -v lesspipe.sh &> /dev/null; then
  eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

emptytrash() {
  # Empty the Trash on all mounted volumes and the main HDD
  # Also, clear Apple’s System Logs to improve shell startup speed
  sudo rm -rfv /Volumes/*/.Trashes
  sudo rm -rfv ~/.Trash
  sudo rm -rfv /private/var/log/asl/*.asl
}

# Recursively delete `.DS_Store` files
alias dsclean="find . -type f -name '*.DS_Store' -ls -delete"

#Setup brew
path-prepend /usr/local/bin
path-append /usr/local/sbin

if command -v brew &> /dev/null; then
  brew_prefix=$(brew --prefix)

  # GRC colorizes nifty unix tools all over the place
  if command -v grc &> /dev/null && [[ -n "${brew_prefix}" ]]; then
    source "${brew_prefix}/etc/grc.bashrc"
  fi

  # Use GNU userland.
  path-prepend /usr/local/opt/coreutils/libexec/gnubin
  path-prepend /usr/local/opt/coreutils/libexec/gnuman MANPATH
fi
