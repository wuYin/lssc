#!/bin/bash

# 运行命令直到成功
function repeat() {
  #  while true; do
  while :; do # : 返回 0 并总是执行成功，像 Go 的 _
    "$@" && return
    sleep 10
  done
}

repeat host zhihu.com
