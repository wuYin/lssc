#!/bin/bash

#
# ps
#
ps -af -o pid,pcpu,pmem | head -4 # --all --full --or
ps aux --sort -pcpu | head -4     # sort pcpu 降序

whereis ls
file "$(which ls)"
whatis ls

#
# 系统信息
#
hostname
uname -a
cat /proc/cpuinfo | head -5
cat /proc/meminfo | head -5
cat /proc/partitions | head -5

# lshw 系统详细信息诊断

#
# 定时作业
#
crontab <<EOF
http_proxy="http://127.0.0.1:2333"
00 02 * * * /sbin/shutdown -h
EOF
crontab -l
