#!/bin/bash

#
# 终端打印
#
printf "%-8s %-10s %-4s\n" name age score
printf "%-8s %-10d %-4.2f\n" wuYin 22 99.566 # 进位
echo -e "xxx\n"                              # 转义

#
# 环境变量
#
pid=$(pgrep init)                          # process grep
sudo cat /proc/$pid/environ | tr '\0' '\n' # null 字符替换为 \n
echo "$USER, $UID, $SHELL, $0"             # $0 脚本名字 or $SHELL

a1=""
a2="a"
b="b"
echo ${a1:+b} # 空
echo ${a2:+b} # b # :+ 运算符，前非空则取第二个值

prepend() {
  [ -d "$2" ] && eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1 # 空环境变量则不加尾部 :
}
prepend PATHx /home/vagrant
echo $PATHx

#
#  数学运算
#
v1=11
v2=2
let v3=v1+v2 # bash demo.sh OK
let v3++
let v3+=6
echo $v3                       # 20
echo $((v3 + 1)), $(($v3 + 1)) # 21
echo $(expr $v3 + 1)           # 21

echo 4*5 | bc
echo "scale=1;1/4" | bc # 0.2
n=9
echo "obase=2;$n" | bc # 1001
b=1011
echo "obase=10;ibase=2;$b" | bc # 11
echo "2^10" | bc
echo "sqrt(64)" | bc

#
# 重定向
#
ls + demo.sh 2>/dev/null | tee tmp.txt | cat -n # 2 stderr 2>&1 将 stderr 转换为 stdout
echo "string" | tee -                              # - 即 stdin
cat <<EOF >tmp1.txt
  FILE HEADER # EOF 间文本原样当做 stdin
EOF

exec 100<tmp1.txt # 指定fd 并以 r 模式打开文件
cat <&100
exec 101>tmp1.txt # w
echo "DONE" >&101
cat tmp1.txt

#
# 数组
#
vs=('a' 'b' 'c' 'd')
vs[0]='A'
echo ${vs[0]}
echo ${vs[*]}  # A b c d
echo ${#vs[*]} # 4 # ${#} 取长度，字符串同理

declare -A cs
cs=([a]=1 [b]=2)
cs[dD]=44
echo ${cs[dD]}
echo ${!cs[*]} =\> ${cs[*]} # 类似于 php array_keys() 函数

#
# 别名
#
alias k='kubectl -n kafka'
alias rm='rm -rf /' # hacked
unalias rm
alias rm=    # also work
\rm tmp1.txt # 转义执行原命令

#
# 终端信息
#
echo -n "enter password: "
stty -echo # 禁止将输出发送到终端
read v
stty echo
echo -e "\npassword: $v"

#
# 日期时间
#
date +%s # 时间戳
d=$(date "+%Y-%m-%d %H:%M:%S")
echo $d | tee | date --date - +%s # 自动解析，注意时区差异

#
# 调试脚本
#
function DEBUG() {
  [ "$_DEBUG" == "on" ] && "$@" || : # $@ 执行，或 : 告知 shell 不执行任何指令
}
for i in {1..10}; do # _DEBUG=on bash examples.sh
  DEBUG echo $i
done

#
# 函数
#
f() {
  echo "$0, $1" # examples.sh, arg1
  echo $*
  for i in "$@"; do
    echo $i
  done
}
f arg1 arg2 3 4 5 # 传参方式很 shell
if [ $? -eq 0 ]; then
  echo "function f exec ok"
else
  echo "function f exec not ok"
fi

f1() {
  echo "child process also  ok"
}
export -f f1 # 函数也能 export 到 fork 出的子进程
(f1)

#
# 读取输入
#
cat <<EOF >tmp2.txt
aA
B
Cc
EOF
out=$(cat tmp2.txt) # 和 `cmds` 同理
echo $out

read -n 2 s1                                       # 读 2 个字符即可
read -t 10 -p "enter password again: " -s password # 10s timeout, print tips, and be silent
read -d ":" s3                                     # delimiter 输入结束符
echo "s1: $s1"
echo "password: $password"
echo "s3: $s3"

#
# 迭代器
#
echo {1..10}
for ((i=0;i<3;i++)) # 双括号整数运算，类 C for
{
  echo $[$i*100]
}

done=0
until [ $done -eq 1 ];
do
  let done++
done


#
# 比较与测试
#
v1=1
v2=20
if [ $v1 -eq 1 -a $v2 -lt 20 -o $v2 -ge 20 ]; then
  echo "and or"
fi

s1=""
s2="x"
if [[ $s1 = $s2 ]];then
  echo "equal"
fi
if [[ -n $s2 ]]; then
  echo "not empty"
fi

