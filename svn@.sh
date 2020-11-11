#!bin/bash

if [ $# -lt 1 ];then
  echo "缺少参数，请指定脚本执行目录"
  exit 2
fi

for f in ./$1/*.png
do
  echo `svn add $f@`
done
