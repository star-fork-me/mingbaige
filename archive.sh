#!/bin/bash

if [ $# -lt 2 ];then
echo "Error! 输入你要编译的工程所在目录，以及要编译的target名 (可选参数，build-type)"
echo "       例如: sh build-archive.sh . Mahjong-iPad-Double (Distribution)"
exit 2
fi

if [ ! -d $1 ];then
echo "Error! 第一个参数必须是路径。如果在当前目录，输入小数点符号 . "
exit 2
fi

#工程绝对路径
cd $1
project_path=$(pwd)

#build文件夹路径
build_path=${project_path}/build

rm -rf ${build_path}

#编译的configuration，默认为Debug
build_config=Debug  #   Distribution   Release

if [ $# -gt 2 ];then
build_config=$3
fi


#生成的app文件目录
appdirname=Debug-iphoneos
if [ $build_config = Release ];then
appdirname=Release-iphoneos
fi
if [ $build_config = Distribution ];then
appdirname=Distribution-iphoneos
fi

xcodebuild clean

###############################################

#组合编译命令
build_cmd=(xcodebuild)

findXcodeproj=$(echo | find . -type d -name "*.xcodeproj")  #找到当前目录下的xcodeproj文件

#编译project
destination="platform=iOS,name=generic/iOS Device"  #generic是通用匹配符，不限定为某个特定机器
build_cmd+=( -project $findXcodeproj -destination "${destination}" -target $2 -configuration ${build_config} ONLY_ACTIVE_ARCH=NO)


#编译工程
cd $project_path
"${build_cmd[@]}" || exit

###############################################


#进入build路径
cd $build_path

#创建ipa-build文件夹
if [ -d ./ipa-build ];then
rm -rf ipa-build
fi
mkdir ipa-build

#app文件名称
appname=$(basename ./${appdirname}/*.app)
#通过app文件名获得工程target名字
target_name=$(echo $appname | awk -F. '{print $1}')
#app文件中Info.plist文件路径
app_infoplist_path=${build_path}/${appdirname}/${appname}/Info.plist
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${app_infoplist_path})
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${app_infoplist_path})

#IPA名称
ipa_name="${target_name}"
echo $ipa_name

#xcrun打包
xcrun -sdk iphoneos PackageApplication -v ./${appdirname}/*.app -o ${build_path}/ipa-build/${ipa_name}.ipa || exit