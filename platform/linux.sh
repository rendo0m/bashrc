# Pretty much never makes sense to run service without sudo
[[ -e /usr/sbin/service ]] && alias service='sudo service'

# make less more friendly for non-text input files, see lesspipe(1)
eval "$(SHELL=/bin/sh lesspipe)"
