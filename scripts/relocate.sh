#!/bin/bash

if [[ $# == 0 ]]; then
  echo "Please specify the module to relocate"
  exit 1
fi

OLD="forge-valid13.rmm.sagem"
NEW="forge-valid13.sierrawireless.local"

module=$1

svn co file:///svn/${module} --ignore-externals > /dev/null
cd ${module}
for branch in `find BO/{branches,tags}/* BP/*/{branches,tags}/* -type d -prune \( ! -name .svn \) 2>/dev/null`; do
  externals=`svn propget svn:externals ${branch} | sed "s#${OLD}#${NEW}#g"`
  svn propset svn:externals "${externals}" ${branch}
done
svn commit -m ":doc: switching externals to sierrawireless location"
cd ..
rm -rf ${module}
