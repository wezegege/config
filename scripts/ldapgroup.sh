#!/bin/bash

forge=$1
old=$2
new=$3

backups=/var/lib/snapvault

function search_backups {
  forge=$1
  user=$2
  months=$(ls $backups | sort -r)
  for month in ${months}; do
    file=$(zgrep ${user} "backup*${forge}*" | sort | tail -n 1)
    if [[ $? == 0 ]]; then
      echo ${backups}/${month}/${file}
      return 0
    fi
  done
  return 1
}

function ldif_add_to_modify {
  file=$1
  old=$2
  new=$3
  sed -e '
s#\n ##g
/^(seeAlso|test):/ d
s#^dn: .+\n\n##g
/^dn:/ a\
changeType: modify\
add: memberUid
/^memberUid:/ a\
-
' -e "s#${old}#${new}#g" ${file}
}
