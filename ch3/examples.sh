#!/bin/bash

#
# 生成任意大小的文件
#
dd if=/dev/zero of=tmp.txt bs=10M count=2 # --input --output CHECK --block-size
ls -sh tmp.txt                            # 20971520 bytes (21 MB) copied, 0.0968148 s, 217 MB/s # 测内存 IOPS

#
# 文本文件的交集差集
#
cat <<EOF >tmp1.txt
D
B
A
EOF
cat <<EOF >tmp2.txt
C
D
A
EOF
sort tmp1.txt -o tmp1.txt && sort tmp2.txt -o tmp2.txt # comm 必须 sorted
comm tmp1.txt tmp2.txt -1 -2                           # 取第 3 列 common 交集
comm tmp1.txt tmp2.txt -3 | sed 's/^\t//g'             # 取第 1,2 列求差并 trim 头部 tab
comm tmp1.txt tmp2.txt -2 -3                           # 取第 2,3 列求 tmp1.txt 的差集

#
# 文件权限
#
chmod u=rwx tmp.txt # g=rw o=rw
chmod o+x tmp.txt
chmod a-x tmp.txt # all
chmod 765 tmp.txt

chown ubuntu:ubuntu tmp.txt
ls -l tmp.txt

if [ ! -e tmpd ]; then
  mkdir tmpd && touch tmpd/tmp.txt # sticky bit 粘着位
  chmod a+t tmpd                   # 除 owner 外其他用户不能删除文件夹内内容
fi

#
# 创建不可修改文件
#
rm tmp.txt && touch tmp.txt
chattr +i tmp.txt # --immutable # root > rm: cannot remove 'x.txt': Operation not permitted # 只能手动 -i

#
# 批量生成空文件
#
for f in test_{1..2}.c; do
  touch $f
done
find . -maxdepth 1 -type f -iname "*.c" -exec rm {} \;

touch -a -m tmp.txt                    # 更新文件 access modify time 为当前时间
touch -d "$(date '+%Y-%m-%d')" tmp.txt # --date 手动过期

#
# 链接文件
#
ln -s /etc/hostname tmp_hname # soft link
readlink tmp_hname
ls -l | grep "^l" # 查找 link 文件
find . -type l

#
# 查找文件差异并修正
#
cat <<EOF >tmp1.txt
START
line2
line3
line4
END
EOF
cat <<EOF >tmp2.txt
START
line2
line4
END
GNU is Not Unix
EOF

diff -u tmp1.txt tmp2.txt >version.txt # --unified 类 git
patch tmp1.txt <version.txt            # 相同
#patch tmp1.txt <version.txt           # 再次还原
rm version.txt

#
# 查看文件首尾
#
seq 10 | head -n -9  # - 向上，除最后 9 行
seq 10 | tail -n +10 # + 向下，除前 10) 行
f() {
  for i in {1..6}; do
    echo "$i" >>tmp.txt && sleep 0.5
  done
}
f &
#tail -f -s 1 tmp.txt # --follow --sleep 1s # --pid "$!"
kill $!

#
# 上下文文件夹切换
#
if [ "$HOST" = "fuwafuwa" ]; then
  cd /tmp || exit
  cd /usr/local/go/src/ || exit
  cd || exit
  dirs
  popd +2
  cd -
fi

#
# 文本计数
#
echo "abcd" | wc    # 1 1 5 # lines, words, chars
echo -n "abcd" | wc # 0 1 4 # --not newline

#
# 打印目录树
#
if [ ! -e /usr/bin/tree ]; then
  sudo apt-get install tree
fi
tree . -P "*.txt" # --pattern

# very cool
tree . -H https://zhihu.com -o text.html

# clean
rm -rf tmp*
