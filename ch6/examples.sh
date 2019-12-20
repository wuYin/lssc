#!/bin/bash

touch tmp1.txt tmp2.png tmp3.txt
mkdir tmpd

#
# tar 归档
#
tar -cf tmp.tar ./tmp* # --create --from-files

touch tmp4.png
tar -rf tmp.tar ./tmp4.png                 # --append file
tar -tvf tmp.tar                           # --list --verbose
mkdir tmpd2 && tar -xvf tmp.tar -C ./tmpd2 # --extract --direCtory

tar -cf tmp1.tar *.txt && tar -cf tmp2.tar *png
tar -Af tmp1.tar tmp2.tar                                       # --Append tar
tar -f tmp1.tar --delete tmp2.png                               # --delete
tar -tf tmp1.tar                                                # merged

tar -czvf tmp.tar.gz ./* --exclude *.txt --exclude-vcs --totals # .gz 压缩，排除文件和 .git/ # Total bytes written: 30720 (30KiB, 3.8MiB/s)

#
# gzip 压缩
#
for i in {1..99}; do
  echo $i*100 | bc >>tmp.txt
done
gzip --best tmp.txt           # --best --fast
gzip -l tmp.txt.gz            # 压缩比 74.8%
zcat tmp.txt.gz | grep "9900" # zcat 无需解压提取到 stdout
gunzip tmp.txt.gz

#
# bz2 压缩
#
tar -cf tmp.tar tmp.txt
bzip2 tmp.tar         # 压缩率更高
tar -xjvf tmp.tar.bz2 # -j 解压 bz2

#
# zip 压缩
#
zip -r tmp.zip tmpd/
unzip tmp.zip

# clean
rm -rf tmp*
