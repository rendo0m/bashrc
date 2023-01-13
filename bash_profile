#set some super basic stuff
#export PATH="${HOME}/bin:${PATH}"
export LANG=en_US.UTF-8
if command -v locale-gen &> /dev/null; then 
  export LANG=de_DE.UTF-8
  export LC_ALL=de_DE.UTF-8
  export LANG=de_DE.UTF-8
  export LANGUAGE=de_DE.UTF-8
fi

source ~/.bashrc
