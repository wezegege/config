#!/bin/zsh

##################################################################################
# Prompt
##################################################################################

autoload -U colors && colors

function COLOR () {
  echo -ne "%{\033[38;5;$1m%}";
}

darkblue=`COLOR 74`
lightblue=`COLOR 116`
yellow=`COLOR 150`
PROMPT="${darkblue}[${lightblue}%n${darkblue}@${lightblue}%M${darkblue}"
PROMPT="$PROMPT:${lightblue}%~${darkblue}]${yellow}(%*)
%#%f "
PROMPT2="${yellow}%_>%f "

##################################################################################
# Completion
##################################################################################

autoload -U compinit compinit
compinit -C
# colors
zmodload zsh/complist

# create a cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

# command completions
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# ignore case in completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true

setopt completeinword
setopt extendedglob
set autocorrect

##################################################################################
# History
##################################################################################

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd .."
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

##################################################################################
# Stuff
##################################################################################

autoload select-word-style
select-word-style shell

# Set default editor
export EDITOR="vim"
if [[ -x $(which vim) ]]
then
  export EDITOR="vim"
  export USE_EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi
bindkey -e

setopt AUTO_CD

export REPORTTIME=30

# wildcard move
autoload zmv

##################################################################################
# Extra config files
##################################################################################

if [ -f ~/.profile ]; then
  source ~/.profile
fi

if [ -f ~/.commonrc ]; then
  source ~/.commonrc
fi
