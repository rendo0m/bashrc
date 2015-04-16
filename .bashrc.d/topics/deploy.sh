path-append ~/ReadyTalk/deploy

alias deploy='deploy.sh'
make-completion-wrapper _deploy _deploy_alias deploy.sh
complete -F _deploy_alias deploy

alias deployme='deploy.sh dborg'
make-completion-wrapper _deploy _deployme deploy.sh dborg
complete -F _deployme deployme
