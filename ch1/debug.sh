#!/bin/bash

# 指定代码段调试
for i in {1..6}; do
  set -x # 执行时显示参数和命令
  echo $i
  set +x # no debug
done
echo "done"
