#!/bin/bash

#
# wget
#
# --try 重试次数 --continue 断点续传  --limit-rate 限速 --quote 容量限制
#img="http://releases.ubuntu.com/18.04/ubuntu-18.04.3-desktop-amd64.iso"
#wget -t 2 -c $img -O tmp.iso -o tmp.log --limit-rate 10k -Q 100k

#
# curl
#
g="https://www.google.com.hk"
z="https://www.zhihu.com"
curl $g -o tmp.html --progress # --output # URL 无文件名必须手动 -o
curl --refer $g --cookie "name:wuyin;age:20" $z -o tmp.html
#curl -A "Mozilla/5.0" -X POST -H "Content-Type: application/json" -d @req.json "127.0.0.1/api"
