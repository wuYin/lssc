#!/bin/bash

#
# 批量图片下载
#
# ./img_downloader.sh https://en.wikipedia.org/wiki/Dennis_Ritchie wiki
if [ $# -ne 2 ]; then
  echo "usage: $0 URL IMG_DIR"
  exit 1
fi
full_url=$1
dir=$2

if [ -d "$dir" ]; then
  echo -e "directory $dir existed, remove?[y/N]:"
  read ok
  if [ "$ok" = "y" ]; then
    rm -rf "$dir"
  else
    exit 2
  fi
fi

mkdir -p "$dir"
base_url=$(echo "$full_url" | grep -o -E "https?://[a-z.]+")

echo "downloading images from $full_url..."

# 先拉取 HTML 源码
# 正则取 <img /> 标签
# 在 sed 匹配并回显输出 src 属性值存入文件
curl -s "$full_url" | grep -o -E "<img src=[^>]*>" |
  sed 's/<img src=\"\([^"]*\).*/\1/g' >/tmp/urls.txt

# 将所有 / 开头的地址加上 base_url 前缀
sed -i "s|^/|$base_url/|" /tmp/urls.txt

cd "$dir" || exit 1

# 读取图片链接列表并下载
while read img_url; do
  ext=$(echo ${img_url##*.} | tr '[:upper:]' '[:lower:]')
  case $ext in
  png | jpg | jpeg | gif)
    echo "downloading image $img_url"
    curl -s -O "$img_url"
    ;; # case 语句实现 flag 解析，或 in list 逻辑
  *)
    echo "invalid URL: $img_url"
    ;;
  esac
done </tmp/urls.txt
