# from old configs but not used anymore

## set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

## set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac

##COLOR PROMPT
## set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac
#
#
#
#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#	# We have color support; assume it's compliant with Ecma-48
#	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#	# a case would tend to support setf rather than setaf.)
#	color_prompt=yes
#    else
#	color_prompt=
 #   fi
#fi
#
#if [ "$PS1" ]; then
#
 #   PS1='\u@\h:\w\$ '
  #  ROTH="\[\033[1;31m\]"
   # ROT="\[\033[0;31m\]"
    #GRUEN="\[\033[0;32m\]"
  #  BLAU="\[\033[0;34m\]"
  #  YELLOW="\[\033[0;33m\]"
  #  NOCOLOR="\[\033[0m\]"
  #  [ "$UID" == "0" ] && USRCLR="$ROT\\u$NOCOLOR" || USRCLR="\\u"
    
##PS1="$YELLOW[\$(date +%H:%M:%S)]${BLAU}[$GRUEN$USRCLR$ROT@$ROTH${debian_chroot:+($debian_chroot)}$GRUEN\w${BLAU}]\n$NOCOLOR#"
##PS1="${YELLOW}[\$(date +%H:%M:%S)]$ROT@${BLAU}[$GRUEN$USRCLR$ROT@$BLAU\h:${debian_chroot:+($debian_chroot)}$GRUEN\w${BLAU}]\n$NOCOLOR#"
##PS1="${BLAU}[$GRUEN$USRCLR$ROT@$BLAU\h:${debian_chroot:+($debian_chroot)}$GRUEN\w${BLAU}]\n$NOCOLOR#"
#PS1="${BLAU}[$GRUEN$USRCLR$ROT@$BLAU\h:${debian_chroot:+($debian_chroot)}$YELLOW\w${BLAU}]\n$NOCOLOR#"
#
#fi
#
#unset color_prompt force_color_prompt

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi