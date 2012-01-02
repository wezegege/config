#!/usr/bin/sh
#
# ~/.profile
#

#====================================================================
# environment
#====================================================================

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.local/lib/python" ] ; then
    PATH="$HOME/.local/lib/python:$PATH"
fi

# PROJECTPATH

PROJECTPATH="$HOME/.local/lib/python:$HOME/.local/lib"
PROJECTPATH="$PROJECTPATH:$HOME/workspace/cpp:$HOME/workspace/python"
PROJECTPATH="$PROJECTPATH:$HOME/workspace/wiki:$HOME/workspace"
PROJECTPATH="$PROJECTPATH:/usr/local/lib:/usr/local/share"
PROJECTPATH="$PROJECTPATH:/usr/lib/python2.7/site-packages:/usr/lib/python2.7:/usr/lib"
PROJECTPATH="$PROJECTPATH:/usr/include:/usr/share"
PROJECTPATH="$PROJECTPATH:/var/lib:/var/www"
PROJECTPATH="$PROJECTPATH:/etc"
export PROJECTPATH

# unset bell

xset b 0
setterm -blength 0

#====================================================================
# functions
#====================================================================

# parent_dir 3 -> cd ../../../
function parent_dir {
  count=1
  [ -z $1 ] || count=$1
  dir=""
  for i in `seq $count`; do
    dir="$dir../"
  done
  cd $dir
}


# goes to root of a svn or git project, or root of a project given its
# folder, or to home
function project_root {
  # svn project ?
  dest=""
  parent="."
  while [ -d "$parent/.svn" ]; do
    dest=$parent
    parent="$parent/.."
  done
  [[ $dest == "" ]] && root=`git rev-parse --show-cdup 2>/dev/null` && dest="$root."
  if [[ $dest == "" ]]; then
    current_dir=`pwd`
    for folder in $(echo $PROJECTPATH | tr ":" "\n"); do
      if [[ $current_dir == "${folder}/"* ]]; then
        dest=`echo $current_dir | sed -e "s#${folder}/\([^/]\+\).*#${folder}/\1#"`
        break
      fi
    done
  fi
  [[ $dest == "" ]] && dest=~
  cd $dest
}

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

# archive

alias dotar="tar pczf"
alias untar="tar xvf"
alias seetar="tar ztvf"

# functions

alias ..="parent_dir"
alias cdd="project_root"

# applications

alias sqlite="sqlite3"
alias fmake="make -j 4"
alias vi="vim"

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
