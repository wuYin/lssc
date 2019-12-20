#!/bin/bash

# internal field separator
# 内部字段分隔符，切割文本数据流

runes="a,b,c,d,z"
oldIFS=$IFS # 默认空白符
IFS=,
for rune in $runes; do
  echo $rune | tr '[a-z]' '[A-Z]'
done

IFS=$oldIFS

