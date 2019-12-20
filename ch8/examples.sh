#!/bin/bash

mkdir tmpd
for i in {1..5}; do
  if [ $i -lt 3 ]; then
    f="tmp$i.txt"
  else
    f="tmpd/tmp$i.txt"
  fi
  dd if=/dev/zero of=$f bs=10M count=$i &>/dev/null
done

#
# 磁盘容量
#
du --max-depth=1 --exclude="*.go" -h -a -c .               # -a 递归统计目录文件 # -c total
du -am . | sort -nrk 1,1 | head -2                         # 找最大文件或目录
find . -type f -exec du -m {} \; | sort -nrk 1,1 | head -1 # 找出最大的文件

df -h      # disk free
sudo iotop # io top

#
# 用户相关
#
users  # 当前登录用户
uptime # 系统负载 1 5 30min

#
# watch 监测
#
(
  for i in $(seq 10); do
    echo "$i*100" | bc >tmp.txt
    sleep 1
  done
) &
watch -n 1 -d 'tail tmp.txt' # --interval --differences

#
# logger 日志
#
logger -t Redis "redis down"

# clean
rm -rf ./tmp*
