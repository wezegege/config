#!/bin/sh
ln -sf ~/config/zshrc ~/.zshrc
ln -sf ~/config/bashrc ~/.bashrc
ln -sf ~/config/vimrc ~/.vimrc
ln -sf ~/config/vim ~/.vim
ln -sf ~/config/inputrc ~/.inputrc
ln -sf ~/config/commonrc ~/.commonrc
ln -sf ~/config/gitconfig ~/.gitconfig
ln -sf ~/config/config-terminator-config ~/.config/terminator/config
cd ~/config
git submodule update --init

source ~/.zshrc
