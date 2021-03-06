# Change git author information if I am at home.
if [[ "${PLATFORM}" == "cygwin" ]]; then
  hostname="${COMPUTERNAME}.${USERDNSDOMAIN}"
else
  hostname=$(hostname -f)
fi

# @PERSONALIZE@
if [[ ${hostname} =~ .+\.(raspe|outerspace) ]]; then
  export GIT_AUTHOR_EMAIL="andi.arbait@gmail.com"
  export GIT_COMMITTER_EMAIL=${GIT_AUTHOR_EMAIL}
fi

# git shortcuts
alias g='git status'
alias gco='git checkout'
alias gf='git fetch'
alias gb='git branch'
alias gd='git diff'

function gils(){
    echo "$*" >> .git/info/exclude
}

function gi(){
    echo "$*" >> .gitignore
}

function gc(){
    git commit -a -m "$*"
}

# git completion for shortcuts
complete -o default -o nospace -F _git_status g
complete -o default -o nospace -F _git_checkout gco
complete -o default -o nospace -F _git_fetch gf
complete -o default -o nospace -F _git_branch gb
complete -o default -o nospace -F _git_diff gd
complete -o default -o nospace -F _git_cherry_pick gcp
