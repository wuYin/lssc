#!/bin/bash

#
# 探活
#
for ip in 192.168.0.{0..255}; do
  ping "$ip" -c 2 &>/dev/null
  if [ $? -eq 0 ]; then
    echo "[alive]: $ip"
  fi
done
