#!/bin/sh
export https_proxy=http://10.66.243.130:8080
git clone https://wezegege@bitbucket.org/wezegege/config.git
mv .bashrc .bashrc.old
ln -s config/bashrc .bashrc
ln -s config/vimrc .vimrc
ln -s config/vim .vim
ln -s config/inputrc .inputrc
ln -s config/commonrc .commonrc
ln -s config/gitconfig .gitconfig
ln -s config/uncommonrc/sagemcom .uncommonrc
cd config
git submodule update --init
cd ~
mkdir -p .local/share/vim
mkdir .ssh
mv authorized_keys .ssh

source ~/.bashrc
