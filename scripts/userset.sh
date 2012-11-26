#!/bin/sh
export https_proxy=http://10.66.243.130:8080
git clone https://wezegege@bitbucket.org/wezegege/config.git
cd ~/config
git submodule update --init
mv .bashrc .bashrc.old
mkdir ~/.ssh ~/.config/terminator
ln -sf ~/config/zshrc ~/.zshrc
ln -sf ~/config/bashrc ~/.bashrc
ln -sf ~/config/vimrc ~/.vimrc
ln -sf ~/config/vim ~/.vim
ln -sf ~/config/inputrc ~/.inputrc
ln -sf ~/config/commonrc ~/.commonrc
ln -sf ~/config/gitconfig ~/.gitconfig
ln -sf ~/config/config-terminator-config ~/.config/terminator/config
ln -sf ~/config/ssh-config ~/.ssh/config

source ~/.bashrc
