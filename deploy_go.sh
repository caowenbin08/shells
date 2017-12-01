#!/bin/bash

#------------------------------
# 请用root用户安装
# 安装 GO 脚本
# **安装包是统一管理与命名
# 使用方法：
#    deploy_go.sh 1.9.2
#
#------------------------------

download_url="http://ojcljv5tn.bkt.clouddn.com"

if [ ! -n "$1" ];then
  version="1.9.2"
else
  version=$1
fi

echo "download_url: ${download_url} \n version: ${version}"
# 临时安装包存放目录
temp_package_dir="/var/tmp/package"

if [ ! -d "${temp_package_dir}" ];then
    mkdir -p "${temp_package_dir}"
fi

sys_version=`arch`
echo "System Version: ${sys_version}"
if [ "${sys_version}" = "x86_64" ];then
	go_name="go${version}.linux-amd64.tar.gz"
else
	go_name="go${version}.linux-386.tar.gz"
fi
# 查看Linux系统版本的命令
sys_type=`cat /etc/issue | awk '{print $1}' | tr 'A-Z' 'a-z'`
echo "System: ${sys_type}"
which wget
if [ $? -ne 0 ]; then
	if [ "ubuntu" = "${sys_type}" ];then
		sudo apt-get install wget

	else
		sudo yum install wget
	fi
fi
# # 解决source: not found 问题
# sh_type=`ls -l /bin/sh | awk '{print $11}'`
# if [ "dash" = "${sh_type}" ];then
# 	# 解决source: not found 问题
# 	if [ "ubuntu" = "${sys_type}" ];then 
# 		echo ">>>>>>>>>>>把/bin/sh -> dash 设成 /bin/sh -> bash，在界面中选择no"
# 		sudo dpkg-reconfigure dash  # 在界面中选择no
# 	fi
# fi  

echo "\n\n>>>>>>>>>>>安装GO...."
cd "${temp_package_dir}"

if [ ! -f "${go_name}" ];then
  wget "${download_url}/${go_name}"
  if [ $? -ne 0 ];then
     echo "下载${go_name}失败"
     exit 1
  fi
fi

sudo mkdir -p /opt/lib/
sudo tar -C /opt/lib/ -zxf "${go_name}"

which go
if [ $? -ne 0 ]; then
  sudo echo "export PATH=$PATH:/opt/lib/go/bin">>/etc/profile
fi

echo "<<<<<<<<<<< 安装 GO 成功，请source /etc/profile<<<<<<<<<<<<<"