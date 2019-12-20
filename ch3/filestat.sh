#!/bin/bash

#
# 列举文件类型统计信息
#

cat <<EOF >tmp.c
#include<stdio.h>
int main() {}
EOF
\cc tmp.c

if [ $# -ne 1 ]; then
  echo "usage: $0 file_path"
  exit
fi
path=$1

declare -A t2l # type to lines
while read line;
do
  t=$(file -b "$line" | cut -d, -f1) # cut 切割 a.out 文件类型 ELF 64-bit LSB  executable
  ((t2l["$t"]++))
done< <(find "$path" -type f -print) # 将 find 子进程的输出重定向 < 为文件，找出文件并遍历内容 <，cool

# map traverse
for k in "${!t2l[@]}"
do
  echo "$k: ${t2l[$k]}"
done

# clean
rm -rf a.out
