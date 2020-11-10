#!/bin/bash


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


echo "\n将要执行重命名的目录为： ".$rootpath"\n\n\t\t\t\t您确认执行？(y/n)"
read -n 1 yesOrNo   #读入参数
if [ "y" == "$yesOrNo" ] || [ "Y" == "$yesOrNo" ]
then
echo "\n确认执行！\n"
else
echo "\n取消执行，退出程序！\n"
exit
fi


path=$rootpath

[ -d $path ] && cd $path
for file in `ls`
do
 # mv $file `echo $file|sed 's/\(.*\)\.\(.*\)/\1_aaa.\2/g'`   # \1 增加后缀 _aaa \2
 
 # mv $file `echo $file|sed 's/.*-//g'`     #  去掉  xxxxxx-

mv $file `echo $file|sed 's/best-buy-\(.*\)\.html/\1.html/g'`     #  去掉  best-buy- 
 
done