#!/bin/bash

#
# ifconfig
#
for i in $(ifconfig | cut -c 1-10 | tr -d ' ' | tr -s '\n'); do
  echo -n "$i: "
  ifconfig "$i" | grep -o -E "inet addr:[^ ]*" | grep -o -E "[0-9.]+" # 提取 ip
done

#
# DNS 查找
#
cat /etc/resolv.conf       # nameserver 10.0.2.3 # DNS Server
host baidu.com             # find all ip
nslookup baidu.com         # nameservser look up
route                      # Kernel IP routing table

#
# ping
#
ping -c 2 -i 0.2 baidu.com # --count --interval # rtt min/avg/max/mdev
#traceroute baidu.com

#
# 网络流量分析
#
lsof -i
netstat -tnp
