if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='wterm-256color'
else
  export TERM='xterm-color'
