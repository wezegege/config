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

alias dotar="tar pczf"
alias untar="tar xvf"
alias seetar="tar ztvf"
alias sqlite="sqlite3"

#===================================================================
# work specifics
#====================================================================

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export PYTHONSTARTUP=$HOME/.pythonstartup
export HTTP_PROXY=10.66.243.130:8080
export HTTPS_PROXY=10.66.243.130:8080
export NO_PROXY=localhost,10.66.0.0
