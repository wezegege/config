#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
        . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion   # --> Read /etc/bashrc, if present.
fi

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd"
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
set APPEND_HISTORY
set AUTO_CD

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
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
function CLASSIC_COLOR () { echo -ne "\[\e[1;$1m\]"; }
darkblue=`COLOR 74`
lightblue=`COLOR 116`
yellow=`COLOR 229`
green=`COLOR 150`
red=`COLOR 167`
if [ "$TERM" == "linux" ]; then
  darkblue=`CLASSIC_COLOR 34`
  lightblue=`CLASSIC_COLOR 36`
  yellow=`CLASSIC_COLOR 33`
  green=`CLASSIC_COLOR 32`
  red=`CLASSIC_COLOR 31`
fi
isroot=${lightblue}
isremote=${lightblue}
if [ "a$SSH_CLIENT" != "a" ]; then
  if [[ `hostname` == *valid* || `hostname` == *test* ]]; then
    isremote=${yellow}
  elif [[ `hostname` == *wez-* || `hostname` == *rmm-p* ]]; then
    isremote=${green}
  else
    isremote=${red}
  fi
fi
if [ "$USERNAME" == "root" ]; then
  isroot=${red}
fi
PS1="${darkblue}[${isroot}\u${darkblue}@${isremote}\h${darkblue}:${lightblue}\w${darkblue}]${green}(\t)
\$\[\e[0m\] "

# Completion

_fab() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  if [[ ${prev} == -H ]] ; then
    opts=`\grep "Host " ~/.ssh/config | \grep -v "*" | cut -d" " -f 2-`
    cur=${cur##*,}
  elif [[ ${prev} == -R ]] ; then
    opts=`python -c "import fabfile ; from fabric.api import env ; print '   '.join(env.roledefs.keys())"`
    cur=${cur##*,}
  else
    opts=`fab -l | tail -n +3`
  fi
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
  return 0
}
complete -F _fab fab
complete -o default -F _fab fab gfab

if [ -f ~/.commonrc ]; then
  . ~/.commonrc
fi

