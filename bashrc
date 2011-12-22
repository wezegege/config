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
set APPEND_HISTORY
set HIST_IGNORE_DUPS
set HIST_IGNORE_ALL_DUPS
set HIST_IGNORE_SPACE
set HIST_REDUCE_BLANKS
set AUTO_CD

shopt -s cdspell

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
