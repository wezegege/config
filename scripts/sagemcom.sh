#!/bin/sh
export https_proxy=http://10.66.243.130:8080
git clone https://wezegege@bitbucket.org/wezegege/config.git
cd ~/config
git submodule update --init

. ~/config/scripts/setup.sh

source ${HOME}/.bashrc
