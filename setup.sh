#!/bin/bash

folder=`pwd`/$0
folder=`dirname $folder`
name=`basename $0`
files=`ls -A -I $name`

cd ~
for file in $files; do
  mv .$file .$file.old
  ln -s $folder/$file .$file
done
