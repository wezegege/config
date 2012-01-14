#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
        . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd .."
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:ignorespace
set APPEND_HISTORY
set AUTO_CD

# append to the history file, don't overwrite it
shopt -s histappend

set completion-ignore-case on

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

shopt -s cdspell
shopt -s nocaseglob
shopt -s expand_aliases

# prompt

function COLOR () { echo -ne "\[\e[38;5;$1m\]"; }
darkblue=`COLOR 74`
lightblue=`COLOR 116`
yellow=`COLOR 150`
PS1="$darkblue[$lightblue\u$darkblue@$lightblue\h$darkblue:$lightblue\w$darkblue]$yellow(\t)
\$\[\e[0m\] "

if [ -f ~/.profile ]; then
  . ~/.profile
fi

if [ -f ~/.commonrc ]; then
  . ~/.commonrc
fi
