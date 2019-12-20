#!/bin/bash

#
# 正则表达式
#
# ^ 前缀
# $ 后缀

# [] 字符集匹配
# [-] 字符集范围匹配
# [^] 字符集排除匹配

# ? 匹配前项 0/1 次
# + 匹配前项 >= 1 次
# * 匹配前项 0/N 次

# () 新建子串不解释为字符集

# {n}   匹配前项 n 次
# {n,}  匹配至少 [n,) 次
# {n,m} 匹配 [n,m] 次

# | 或匹配
# \ 匹配符转义

f() {
  for v in "$@"; do
    echo "$v"
  done
}
f "123" "demo1" "  demo str " | grep -E "( ?[a-zA-Z]+ ?)" # 非标准

#
# grep 文本搜索
#
cat <<EOF >tmp.txt
linux
macOS darwin
Unix
Win7
EOF
grep -v -E '[[[:upper:]]]?' tmp.txt                    # linux # --inVert 排除
grep --color=auto -E '[0-9]+' -o tmp.txt               # 7     # --only 只输出匹配部分，color 标记，extend 支持正则
grep --color=auto -i -e "linux" -e "unix" tmp.txt      # --ignore-case -e --pattErn

echo -e "1 2 3 \n 4 5 6" | grep -c -E '[0-9]+'         # 2     # 统计匹配行
echo -e "1 2 3 \n 4 5 6" | grep -o -E '[0-9]+' | wc -l # 6     # 统计匹配项

echo "IS demo is x" | grep -b -i -o "is" # 0:IS 8:is  # --bytes-offset 类似 substr()
grep -l "linux" -R .                     # --list files, --recursive # -L not list

for f in tmp.go tmp.c "tmp 1.cc"; do
  echo -e "main(){}" >"$f"
done
grep "main()" -R . --include=*.go --exclude=*.{c,cc} --exclude-dir=tmpd # 排除和指定文件，文件夹

# -l 指定 -Z 零字符结尾，xargs 按 NULL 分割，避免空格分割
grep "main" --exclude=examples.sh -l -Z -R . | xargs -0 rm # rm: cannot remove './tmp', '1.cc': No such file or directory

seq 10 | grep 5 -B 2 -A 3 -C 4 # --before --after --context

#
# cut 切分文件
#
cat <<EOF >tmp.txt
id name age
1;Jack Ma;31
2;Tonny;30
EOF
cut -f1,3 -d ";" --output-delimiter="_" tmp.txt # 可在 1、3 列间手动重新指定分割符
cut -c 1-2,5-6 tmp.txt                          # -c 与 -f 统计，--char 范围分割

#
# sed 文本替换
#
# stream editor
cat <<EOF >tmp.txt
this is /

Kiss
EOF
sed -i 's/is/IS/g' tmp.txt                                    # --inplace 写回
sed '/^$/d' tmp.txt                                           # --delete ^$ 空行

echo "this is kiss" | sed -e 's/i/I/g' -e 's/s/S/2g'          # thIs IS kISS # --expression --global /Ng 从第 N 个开始替换
echo "this is kiss" | sed 's/\w\+/[&]/g'                      # & 依次替换已匹配字串 # \word [this] [is] [kiss]
echo "this is kiss" | sed 's/\([a-z]\+\) \([a-z]\+\)/\2 \1/g' # \n 正则匹配后按序替换 # is this kiss

#
# awk 文本处理
#
# awk 'BEGIN{ perint "start" } pattern { commands } END { print "end" }' in_file
# BEING 预处理                         # 变量初始化，输出表头
# 对 in_file 中每行都匹配模式并执行语句块 # 默认 { print } 打印每一行
# END 退出前处理                        # 信息汇总
awk 'BEGIN { i=0 } { i++ } END { print i }' tmp.txt        # 3       # awk 的语法类 C 而非 SHELL，变量非 $，输出非 echo
echo | awk '{i="I"; j="J"; print i, j, i "-" j}'           # I J I-J # print 变量列表默认 , 分割，可 "XXX" 指定
echo "root:x:0:0:root:/bin/bash" | awk -F: '{print $(NF)}' # --Field

# awk 特殊变量，如 $(NF)
# NR number of current row
# NF number of fileds
# $0 当前行文本 $N 第 N 个字段文本
cat <<EOF >tmp.txt
line1 f1 f2
line2 f3 f4
line3 f5 f6
EOF
awk '{
  print "row:" NR   ",  fields:" NF ",  $0="$0   ",  $1="$1   ",  $(NF)="$(NF)
}' tmp.txt # 默认空格分割

awk 'END {print NR}' tmp.txt                         # 类 wc -l
seq 10 | awk 'BEING {sum=0}{sum+=$1}END {print sum}' # 55 # range cool
seq 10 | awk 'NR==1, NR==4 '                         # 打印 [1,4] 行

# 导入外部变量
cur_file="users.sql"
echo | awk -v file="$cur_file" '{print file}' # -v in_var=$out_var
awk '{print v1,v2}' v1="V1" v2="V2" tmp.txt   # 从文件读传变量

# 预读取行函数
seq 5 | awk 'BEGIN{
  getline; v1=$0; getline; v2=$0; print "pre read: " v1,v2 # 回顾 rm_dup.sh
} {
  print $0
}'

# awk 代码块支持读取命令输出、for 循环
echo | awk -F: '{
  "grep root /etc/passwd" | getline; print $1;
}'

# awk 丰富的内置函数
echo | awk '{
  print length("demo");            # 4
  print index("awk awesome", "e"); # 7
}'

#
# 按列合并文件，对比 cat 按行
#
echo -e "1\n2\n3" >tmp1.txt
echo -e "a\nb" >tmp2.txt
paste tmp1.txt tmp2.txt -d "," # 只能合并文件

#
# 逆序打印文本
#
echo "me;you;she" | tac -s ";"
cat <<EOF >tmp.txt
onerepublic
are you ok
bba
EOF
tac tmp.txt
awk '{
  lines[NR]=$0
} END {
  for(l=NR;l>0;l--){
    print lines[l];
  }
}' tmp.txt # awk awesome!!!

#
# 实践
#
echo "xsa,me@gmail.com<br/>jeff@google.com!_" | grep -o -E "[a-zA-Z0-9._]+@[a-zA-Z0-9.]+\.[a-zA-Z]{2,4}" # 正则匹配电子邮件
echo "me. I know it. And who" | sed 's/[^.]*I know it[^.]*\.//g'                                         # 匹配删除 .. 单词

# 特别实用
# 将目录中所有文本某段文本替换为新的文本
echo "// copyright wuYin" >tmpd/main.go && echo "# copyright jeff" >tmp.txt
find . ! -name examples.sh -type f -print0 | xargs -I {} -0 sed -i "s/copyright/CopyRight/g" {}

#
# 文本切片
#
s="who am i"                              # 简化版本 sed 's/x/y/g'
echo "${s/'i'/'I'}"                       # who am I
s="abcde"                                 # ${string:M:N} # 简化版本 cut
echo "${s:2}   ${s:3:4}   ${s:(-3):(-1)}" # cde   de   cd
