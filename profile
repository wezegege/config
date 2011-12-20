#
# ~/.profile
#

#====================================================================
# environment
#====================================================================

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/python" ] ; then
    PATH="$HOME/python:$PATH"
fi


# unset bell

xset b 0
setterm -blength 0

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
