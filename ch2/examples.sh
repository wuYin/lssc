#!/bin/bash

#
# cat 拼接
#
cat <<EOF >tmp.txt
  TAB
    4SPACES


    line 5
EOF
cat -T -n -b -s tmp.txt # --show line number -b 跳过空白行 --skip empty line

#
# 文件查找
#
if [ ! -e tmpd ]; then
  mkdir tmpd
  cd tmpd && touch me.txt ME.jpeg me.png he.pdf && cd ..
fi
find . -iname "me.*" -o -iname "*.pdf"
find . ! -iname "me*"
find . -maxdepth 1 -type f -size -10k -name "tmp*" -print0 # NULL 分割
chmod 0666 tmpd/ME.jpeg
find . -mindepth 1 -type f -perm 666 -iname "me*" # 权限筛选
find . -type f -name "tmp*" -exec rm '{}' \;      # 需字符串化参数，转移 ; 号

#
# xargs
#
# 从标准输入读取数据，格式化后作为参数传给其他命令，多行与单行转换
cat <<EOF >tmp.txt
1 2 3 4 5 6 7
8 9
10 11 12
EOF
cat tmp.txt | xargs                                # \n -> ' ' # 多行转单行
cat tmp.txt | xargs -n 3                           # 每行 3 个
echo "I_living_in_China-Beijing" | xargs -d _ -n 2 # --delimiter

cat <<EOF >args.txt
arg1
arg2
arg3
EOF
cat args.txt | xargs -n 2 ./cecho.sh           # 实用
cat args.txt | xargs -I {} ./cecho.sh -p {} -l # -I 参数占位符

touch "a b.txt"
find . -type f -name "*.txt" -print0 | xargs -0 rm # 必须指定 find 输出列表文件分割符为 NULL，xargs -0 才能保持一致

#
# tr
#
# 对 stdin 内容字符替换、删除、压缩；translate
echo "demo z" | tr 'a-y' 'A-Z'              # DEMO z # ..yy -> ..YZ
echo "demo z" | tr 'a-z' 'A-Y'              # DEMO Y # ..yz -> ..YY

echo "x80_Ix3" | tr -d '3-8'                # x0_Ix # --delete
echo "demo _x" | tr '[:lower:]' '[:upper:]' # lower / upper / digit / alpha / alnum
echo "x80_Ix3" | tr -d -c '3-8\n'           # 83    # --delete --complete 删除补集，保留指定
echo "a  b  c" | tr -s ' '                  # a b c # --skip

cat <<EOF >tmp.txt
1
3
5
EOF
cat tmp.txt | echo $(($(tr '\n' '+')0)) # 1+3+5+0=9

#
# 校验和
#
md5sum tmp.txt >tmp.md5
echo " " >>tmp.txt
md5sum -c tmp.md5          # --check # md5sum: WARNING: 1 computed checksum did NOT match

#
# 加密
#
base64 tmp.txt | base64 -d # 命令从 stdin 读取输入，就能直接用文件作为参数读取内容

#
# 排序、唯一和重复
#
cat <<EOF >tmp.txt
1 mac 2000
2 winxp 4000
3 bsd 1000
4 linux 1000
EOF
sort -nrk 1,1 tmp.txt # -n 显式按数字排 --reverse 逆序 --key 指定列范围

cat <<EOF >tmp.txt
bash
foss
hack
hack
EOF
sort tmp.txt | uniq -u        # --unique    # 只显示不重复的
sort tmp.txt | uniq -d -c     # --duplicate # 显示重复并计数
sort tmp.txt | uniq -s 1 -w 1 # --skip --max-compare-word

#
# 临时文件命名与随机数
#
rand_f=$(mktemp test.XXX -u) # 模板，-u 只生成文件名
rand_d=$(mktemp -d)          # -d 创建目录
echo "$rand_f, $rand_d"      # test.udc, /tmp/tmp.lsAKHF9aen

#
# 根据扩展名切分文件名
#
# % 从右向左 / # 从左向右，是否贪婪进行匹配并剔除，多用于删除或取出前后缀
img_name="me.2019.smile.jpg"
echo ${img_name%.*}  # me.2019.smile
echo ${img_name%%.*} # me

site="www.google.com.hk"
echo ${site#*.}  # google.com.hk
echo ${site##*.} # hk

#
# 并行执行
#
# 原理：将命令丢入后台执行，只记录 PID，退出前 wait 全部进程
pids=() # 声明为数组
f() {
  echo "$1" >>"$2"
}
for i in {1..100}; do
  f $i tmp.txt &
  pids+=("$!") # arr+=("str") # append # $! 返回上一个进程 pid
done
wait "${pids[@]}" # 等待所有 pid 子进程执行结束

# clean
rm -rf tmp*
