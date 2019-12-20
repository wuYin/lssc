#!/bin/bash

# 批量重命名和移动
touch me.jpg he.JPG me.2019.png

count=1
for f1 in $(find . -maxdepth 1 -type f -iname "*.jpg" -o -iname "*.png"); do
  f2=img-$count.${f1##*.}
  mv "$f1" "$f2"
  ((count++))
done

rm -rf img*
