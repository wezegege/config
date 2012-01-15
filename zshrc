#!/bin/zsh

#====================================================================
# Prompt
#====================================================================

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

#====================================================================
# Completion
#====================================================================

autoload -U compinit compinit
compinit -C
# colors
zmodload zsh/complist

# create a cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ignore already selected files
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes

# ignore case in completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-slashes true

# command completions
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# ssh hosts completion
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

setopt completeinword
setopt extendedglob
set autocorrect

#====================================================================
# History
#====================================================================

HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd .."
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

#====================================================================
# Stuff
#====================================================================
bindkey -e
bindkey "OH" beginning-of-line # Home
bindkey "OF" end-of-line # End
bindkey "[5~" beginning-of-history # PageUp
bindkey "[6~" end-of-history # PageDown
bindkey "[3~" delete-char # Del

# Set default editor
export EDITOR="vim"
if [[ -x $(which vim) ]]
then
  export EDITOR="vim"
  export USE_EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi

setopt AUTO_CD

export REPORTTIME=30

# wildcard move
autoload zmv

#====================================================================
# aliases
#====================================================================

# global aliases

alias -g L="| less"
alias -g S="2>/dev/null"
alias -g G="| grep"

# applications

alias pacclean='pacman -Rsn $(pacman -Qqdt)'

#====================================================================
# Extra config files
#====================================================================

if [ -f ~/.profile ]; then
  source ~/.profile
fi

if [ -f ~/.commonrc ]; then
  source ~/.commonrc
fi
