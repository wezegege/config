#!/bin/bash
# -*- coding: utf-8 -*-

config_folder="${HOME}/config/config"
for config_file in $(ls ${config_folder}); do
    path="${HOME}/.$(echo ${config_file} | tr '-' '/')"
    [[ -e $(dirname ${path}) ]] || mkdir -p $(dirname ${path})
    if [[ -e ${path} && $(readlink ${path}) == ${config_folder}/${config_file} ]] ; then
        ln -sf ${config_folder}/${config_file} ${path}
    else
        ln -sbf ${config_folder}/${config_file} ${path}
    fi
done
