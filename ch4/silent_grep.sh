#!/bin/bash

# sh silent_grep.sh linux tmp.txt

if [ $# -ne 2 ]; then
  echo "usage: $0 text file_name"
  exit 1
fi

target=$1
file_name=$2

grep -q "$target" $file_name # --quiet

if [ $? -eq 0 ]; then
  echo "in"
else
  echo "not in"
fi
