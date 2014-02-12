#!/bin/bash
# -*- coding: utf-8 -*-

function put_link {
    link=$1
    dest=$2
    [[ -e $(dirname ${dest}) ]] || mkdir -p $(dirname ${dest})
    if [[ -e ${dest} && $(readlink ${dest}) == ${config_folder}/${config_file} ]] ; then
        ln -sf ${config_folder}/${config_file} ${dest}
    else
        ln -sbf ${config_folder}/${config_file} ${dest}
    fi

}

config_folder="${HOME}/config/config"
for config_file in $(ls ${config_folder}); do
    path="${HOME}/.$(echo ${config_file} | tr '-' '/')"
    put_link ${config_folder}/${config_file} ${path}
done

if [[ $# -ge 1 ]] ; then
    uncommonrc=${HOME}/config/uncommonrc/$1
    put_link ${uncommonrc} ${HOME}/.uncommonrc
fi

pushd .
cd ~/.vim/bundle
git clone https://github.com/gmarik/vundle.git
vim +BundleInstall +qall
install cmake clang
mkdir ~/ycm_build
cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . ~/.vim/bundle/YouCompleteMe/cpp
make ycm_support_libs
popd
rm -rf ~/ycm_build

