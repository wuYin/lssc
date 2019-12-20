#!/bin/bash

echo -n "count: "
tput sc # store cursor

count=0

# 实现擦写动态效果
while true; do
  if [ $count -lt 20 ]; then
    let count++
    sleep 1
    tput rc # recover cursor
    tput ed # erase to end
    echo -n $count
  else
    exit 0
  fi
done
