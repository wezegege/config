#!/usr/bin/sh
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

export PROJECTPATH=~"/workspace:/usr/local/lib:/usr/local/share:/usr/lib:/usr/include:/usr/share:/var/lib:/var/www:/etc"
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
#
alias ..="parent_dir"
alias cdd="project_root"

# applications

alias sqlite="sqlite3"
alias fmake="make -j 4"
alias vi="vim"
