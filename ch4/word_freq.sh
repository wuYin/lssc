#!/bin/bash
#
# 统计文件中各单词的词频
#

if [ "$#" -ne 1 ]; then
  echo "usage: $0 input_file"
  exit 1
fi

filename=$1

# awk 十分灵活
# for (i=0;i!=10;i++) {...}
# for (v in arr) {...}
# \b 正则单词边界
grep -o -E "\b[[:alpha:]]+\b" "$filename" | awk '{
  count[$0]++
} END {
  printf("%-10s%s\n", "word", "count"); # 类 C 的格式化输出
  for (word in count){
    printf("%-10s%d\n",word, count[word]);
  }
}'
