
# Prompt

autoload -U colors && colors

function COLOR () {
  echo -ne "%{\033[38;5;$1m%}";
}

darkblue=`COLOR 74`
lightblue=`COLOR 116`
yellow=`COLOR 150`
PROMPT="${darkblue}[${lightblue}%n${darkblue}@${lightblue}%M${darkblue}:${lightblue}%~${darkblue}]${yellow}(%*)
%#%f "
PROMPT2="${yellow}%_>%f "

# completion
autoload -U compinit compinit
compinit -C
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# create a cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
# colors
zmodload zsh/complist
setopt extendedglob
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# Set default editor
export EDITOR="vim"
if [[ -x $(which vim) ]]
then 
  export EDITOR="vim"
  export USE_EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi
bindkey -e

# history

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd .."
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt AUTO_CD

set autocorrect

export REPORTTIME=30

if [ -f ~/.profile ]; then
  source ~/.profile
fi
