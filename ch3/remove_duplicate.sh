#!/bin/bash

#
# 查找并删除重复文件
#
# 原理：相同 checksum 即同一文件

init() {
  echo "_" >tmp1.txt
  cp tmp1.txt tmp2.txt && cp tmp1.txt tmp3.txt
  echo "-" >TMP10.txt
}
init

ls -lS --time-style=long-iso | awk 'BEGIN{
  getline; # total 20560 忽略统计信息
  getline;
  name1=$8; size=$5; # 读取首行切割
}
{
  name2=$8;
  if (size==$5) # awk 脚本中取变量反而无需 $var
  {
    "md5sum " name1 | getline; csum1=$1; # 执行命令并读取输出要按 awk way 来，getline 读取命令输出并切割，有点 trick
    "md5sum " name2 | getline; csum2=$1;
    if (csum1==csum2)
    {
      print name1; # 此处输出 2 个文件，
      print name2;
    }
  };

  size=$5;
  name1=name2;
}' | sort -u >dup.files

cat <dup.files | xargs -I {} md5sum {} | sort | uniq -w 32 | awk '{ print $2 }' | sort -u >dup.samples

comm dup.files dup.samples -2 -3 | tee /dev/null | xargs rm

# clean
rm -rf tmp* TMP* dup*
