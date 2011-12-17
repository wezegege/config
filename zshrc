export EDITOR="vim"

# Prompt

autoload -U colors && colors

PROMPT="%{$fg[cyan]%}[%{$fg[green]%}%n%{$fg[cyan]%}@%{$fg[green]%}%M%{$fg[cyan]%}:%{$fg[green]%}%~%{$fg[cyan]%}]%{$fg[yellow]%}(%*)%f
%F{3}%# %f"
PROMPT2="%F{3}%_> "

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/wezegege/.zshrc'

# Set default editor
if [[ -x $(which vim) ]]
then 
  export EDITOR="vim"
  export USE_EDITOR=$EDITOR
  export VISUAL=$EDITOR
fi
bindkey -e

autoload -Uz compinit compinit
# End of lines added by compinstall Lines configured by zsh-newuser-install
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

export REPORTTIME=30

bindkey -v
# End of lines configured by zsh-newuser-install

export PATH=$PATH:~/workspace/binaries

alias ls="ls --color=auto"
alias ll="ls -A --group-directories-first"
alias lq="ls -oh"
alias la="ll -oh"
alias less="less -R"
alias sqlite="sqlite3"
alias grep="egrep -n --color=auto"
alias mkdir="mkdir -p"
alias cdd="cd .."
alias untar="tar xvf"
alias zshrc="source ~/.zshrc"
