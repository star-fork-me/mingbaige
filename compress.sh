#!/bin/sh



#注意：
#* 考虑png文件名中包含空格的情况
#* 考虑png文件不存在的情况
#* 考虑找不到pngquant的情况
#* 考虑文件夹不存在png的情况
#* 考虑文件夹在较高层级的路径的情况， /  ~  /Users/  等等目录都太深，包含子文件过多，程序跑不起来
#* bundle文件夹内的图片为第三方库图片，忽略


#1.检查pngquant是否在正确目录下
if [ ! -f ~/Desktop/pngquant/pngquant ]
then
echo "你的pngquant在哪啊？？？ 请放在桌面： ~/Desktop/pngquant"
echo "程序停止执行！"
exit    #pngquant放置路径不对，退出
fi
#end of 1.检查pngquant是否在正确目录下


#2.检查当前待运行的目录
rootpath=$(pwd)
userpath=$(echo ~)
if [ $(echo "$rootpath" | grep -o "/" | wc -l) -lt 2 ] || [ "$rootpath" == "$userpath" ]
then
echo "当前所在目录：$rootpath 包含子文件过多，某家不敢执行！"    #在这么高等级的目录里，目录包含子文件过多，谨慎执行！
echo "程序停止执行！\n"
exit
fi
#end of 2.检查当前待运行的目录

echo "\n将要执行压缩的目录为： ".$rootpath"\n\n\t\t\t\t您确认执行？(y/n)"
read -n 1 yesOrNo   #读入参数
if [ "y" == "$yesOrNo" ] || [ "Y" == "$yesOrNo" ]
then
echo "\n确认执行！\n"
else
echo "\n取消执行，退出程序！\n"
exit
fi

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "开始执行\n"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "


#参考 http://stackoverflow.com/users/login?returnurl=%2fquestions%2f9647920%2frecursively-batch-process-files-with-pngquant
#3.执行压缩
find . -name '*.png'  -print -exec ~/Desktop/pngquant/pngquant 256 --ext ".png" -s1 --force {} \;

find . -name '*.jpg'  -print -exec ~/Desktop/pngquant/pngquant 256 --ext ""  -s1 --force {} \;

find . -name '*.jpeg'  -print -exec ~/Desktop/pngquant/pngquant 256 --ext "" -s1 --force {} \;

# 不支持svg
# find . -name '*.svg'  -print -exec ~/Desktop/pngquant/pngquant 256 --ext ".svg" --force {} \;
#end of 3.执行压缩

#执行完毕
echo "\n批量压缩png文件执行完毕！\n"