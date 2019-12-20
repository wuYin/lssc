#!/bin/bash

#
# 并发探活
#
for ip in 192.168.0.{1..255}; do
  (
    ping $ip -c 5 -i 0.2 &>/dev/null
    if [ $? -eq 0 ]; then
      echo "[pong]: $ip"
    fi
  ) &# 子进程
done

wait # 等待此进程 fork 出的所有子进程结束
