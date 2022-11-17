#alias docker='sudo docker'
#make-completion-wrapper _docker _docker_alias
#complete -F _docker_alias docker

alias dockervol='if [ ${EUID} -eq 0 ]; then cd /var/lib/docker/volumes; else sudo su root -c "cd /var/lib/docker/volumes; /bin/bash"; fi'
make-completion-wrapper _docker _dockervol
complete -F _dockeer_vol dockervol
