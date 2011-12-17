#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h:\W]\$ '
export PATH=$PATH:~/workspace/binaries

alias ls="ls --color=auto"
alias ll="ls -A --group-directories-first"
alias la="ll -oh"
alias less="less -R"
alias sqlite="sqlite3"
alias grep="egrep -n --color=auto"
alias mkdir="mkdir -p"
