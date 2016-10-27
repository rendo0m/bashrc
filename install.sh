#!/bin/sh

rm -rf .bashrc 2> /dev/null && ln -s .bashrc.d/bashrc .bashrc
rm -rf .bash_profile 2> /dev/null && ln -s .bashrc.d/bash_profile .bash_profile
rm -rf .profile 2> /dev/null && ln -s .bashrc.d/profile .profile
rm -rf .weechat 2> /dev/null && ln -s .bashrc.d/weechat/ .weechat
rm -rf .tmux.conf 2> /dev/null && ln -s .bashrc.d/tmux.conf .tmux.conf
rm -rf .vim 2> /dev/null && ln -s .bashrc.d/vim .vim
rm -rf .minttyrc 2> /dev/null && ln -s .bashrc.d/minttyrc .minttyrc
rm -rf .ctags 2> /dev/null && ln -s .bashrc.d/ctags .ctags
rm -rf .dircolors 2> /dev/null && ln -s .bashrc.d/dircolors .dircolors
