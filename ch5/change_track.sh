#!/bin/bash

#
# 跟踪网页跟新
#
# 将最新的网页下载到 lastest.html，下次重新下载 diff 即可
if [ $# -ne 1 ]; then
  echo "usage: $0 URL"
  exit 1
fi

lastest="lastest.html"
current="current.html"
init=0
if [ ! -e "$lastest" ]; then
  init=1
fi

curl -s $1 -o $current

if [ $init -eq 0 ]; then
  changed=$(diff "$lastest" "$current")
  if [ -n "$changed" ]; then
    echo "$changed"
  else
    echo "nothing changed"
  fi
else
  echo "first time, snapshoting..."
fi

cp $current $lastest
