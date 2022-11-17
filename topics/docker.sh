#alias docker='sudo docker'
#make-completion-wrapper _docker _docker_alias
#complete -F _docker_alias docker

alias dockervol='sudo su root -c "cd /var/lib/docker/volumes; /bin/bash"'
make-completion-wrapper _docker _dockervol
complete -F _dockeer_vol dockervol
