if [[ -x /usr/local/bin/virtualenvwrapper.sh ]]; then
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/Devel
  . /usr/local/bin/virtualenvwrapper.sh
fi
