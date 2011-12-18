#
# ~/.profile
#

#====================================================================
# environment
#====================================================================

export PATH=$PATH:~/workspace/binaries

#====================================================================
# aliases
#====================================================================

# ls

alias ls="ls --color=auto"
alias ll="ls -A --group-directories-first"
alias lq="ls -oh"
alias la="ll -oh"

# common commands

alias less="less -R"
alias grep="egrep -n --color=auto"
alias mkdir="mkdir -p"
alias cdd="cd .."

# applications

alias untar="tar xvf"
alias sqlite="sqlite3"
