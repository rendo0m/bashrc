# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/vim

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$PS1" ]; then

    PS1='\u@\h:\w\$ '
    ROTH="\[\033[1;31m\]"
    ROT="\[\033[0;31m\]"
    GRUEN="\[\033[0;32m\]"
    BLAU="\[\033[0;34m\]"
    YELLOW="\[\033[0;33m\]"
    NOCOLOR="\[\033[0m\]"
    [ "$UID" == "0" ] && USRCLR="$ROT\\u$NOCOLOR" || USRCLR="\\u"
    
#PS1="$YELLOW[\$(date +%H:%M:%S)]${BLAU}[$GRUEN$USRCLR$ROT@$ROTH${debian_chroot:+($debian_chroot)}$GRUEN\w${BLAU}]\n$NOCOLOR#"
#PS1="${YELLOW}[\$(date +%H:%M:%S)]$ROT@${BLAU}[$GRUEN$USRCLR$ROT@$BLAU\h:${debian_chroot:+($debian_chroot)}$GRUEN\w${BLAU}]\n$NOCOLOR#"
#PS1="${BLAU}[$GRUEN$USRCLR$ROT@$BLAU\h:${debian_chroot:+($debian_chroot)}$GRUEN\w${BLAU}]\n$NOCOLOR#"
PS1="${BLAU}[$GRUEN$USRCLR$ROT@$BLAU\h:${debian_chroot:+($debian_chroot)}$YELLOW\w${BLAU}]\n$NOCOLOR#"

fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'
# some more cd aliases
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# some more command aliases
alias apt-get='sudo apt-get'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias vi=vim
alias svi='sudo vi'
alias edit='vim'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'

function proxy(){
	echo -e
	echo -n "Username : "
	read -e username
		if ! which cntlm > /dev/null; then
			echo -n "Password : "
			read -es password
			echo -n "Proxy (host:port) : "
                        read -e proxyaddr
			export http_proxy=http://$username:$password@$proxyaddr/
			export https_proxy=$http_proxy
			export ftp_proxy=$http_proxy
			export rsync_proxy=$http_proxy
			export no_proxy="localhost,127.0.0.1"
			if which git > /dev/null; then
				git config --global http.proxy $http_proxy
				git config --global https.proxy $http_proxy
				git config --global git.proxy $http_proxy
			fi
			if which curl > /dev/null; then
				alias curl="curl -x $http_proxy"
			fi
			echo -e
			echo -e "\033[31m"
			sudo sh -c '(echo "Acquire::http::proxy \"'$http_proxy'\";"; echo "Acquire::ftp::proxy \"'$http_proxy'\";"; echo "Acquire::https::proxy \"'$http_proxy'\";") > /etc/apt/apt.conf'
			echo -e "\033[32mProxy environment variable set.\033[0m"
			echo -e
		else
		echo -n "Domain	: "
		read -e domain
		echo -n "Proxy (host:port) : "
		read -e proxyaddr
		sudo sh -c "/etc/init.d/cntlm stop"
		sudo sh -c "sed -i 's/Username.*/Username\t$username/g' /etc/cntlm.conf"
		sudo sh -c "sed -i 's/Domain.*/Domain\t\t$domain/g' /etc/cntlm.conf"
		sudo sh -c "sed -i 's/Proxy.*/Proxy\t\t$proxyaddr/g' /etc/cntlm.conf"
		sudo sh -c "cntlm -v -I -M http://www.heise.de -c /etc/cntlm.conf"
		echo -e ================================================================================
		echo -e
		echo -e "\033[31mJUST FILL IN THE HASH FROM ABOVE\033[0m"
		echo -e "(if there is none, wrong user/pass?)"
		echo -e
		echo -e	"Auth        NTLMv2"
		echo -n "PassNTLMv2: "
                read -e password
		sudo sh -c "sed -i 's/PassNTLMv2.*/PassNTLMv2\t$password/g' /etc/cntlm.conf"
		sudo sh -c "/etc/init.d/cntlm start"
		export http_proxy='http://localhost:3128'
		export https_proxy=$http_proxy
		export ftp_proxy=$http_proxy
		export rsync_proxy=$http_proxy
		export no_proxy="localhost,127.0.0.1"
		if which git > /dev/null; then
			git config --global http.proxy $http_proxy
			git config --global https.proxy $http_proxy
			git config --global git.proxy $http_proxy
		fi
		if which curl > /dev/null; then
			alias curl="curl -x $http_proxy"
		fi
		echo -e "\033[31m"
		sudo sh -c '(echo "Acquire::http::proxy \"'$http_proxy'\";"; echo "Acquire::ftp::proxy \"'$http_proxy'\";"; echo "Acquire::https::proxy \"'$http_proxy'\";") > /etc/apt/apt.conf'
		echo -e "\033[32mProxy environment variable set.\033[0m"
		echo -e
		fi
}

function proxyoff(){
		unset http_proxy
		unset https_proxy
		unset ftp_proxy
		unset rsync_proxy
			if which git > /dev/null; then
				git config --global --unset http.proxy
				git config --global --unset https.proxy
				git config --global --unset git.proxy
			fi
			if which curl > /dev/null; then
				unalias curl >/dev/null 2>&1
			fi
			if which cntlm > /dev/null; then
				echo -e
				sudo sh -c "/etc/init.d/cntlm stop"
				sudo sh -c "sed -i 's/Username.*/Username\tset_username_here/g' /etc/cntlm.conf"
				sudo sh -c "sed -i 's/PassNTLMv2.*/PassNTLMv2\tinsert_hash_here/g' /etc/cntlm.conf"
				sudo sh -c "sed -i 's/Domain.*/Domain\t\tset_domain_here/g' /etc/cntlm.conf"
				sudo sh -c "sed -i 's/Proxy.*/Proxy\t\tset_proxy_here/g' /etc/cntlm.conf"
			fi
		echo -e "\033[31m"
		sudo sh -c '(echo "";) > /etc/apt/apt.conf'
		echo -e "\033[32mProxy environment variable removed.\033[31m"
		echo -e
}

 function synctime(){
     sudo date -s "$(curl -sD - google.com | grep ^Date: | cut -d' ' -f3-6)Z"
}


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
