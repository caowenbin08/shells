#!/bin/bash

#------------------------------
# 安装 Ngnix 脚本
# **安装包是统一管理与命名
# 使用方法：
#    install.sh http://ojcljv5tn.bkt.clouddn.com/ 1.10.3 /opt/work/lib/nginx
#
# 1、可以外部传入下载路径，nignx版本号、安装目录 ，反之采用默认值
#      download_url="http://ojcljv5tn.bkt.clouddn.com/"
#      nginx_version=1.10.3
#      install_path="/opt/work/lib"
# 2、nignx-1.10.3.tar.gz安装包主要包含
#      nginx-1.10.3、openssl-1.1.0、pcre-8.40、zlib-1.2.11这4个安装包
#------------------------------

if [ ! -n "$1" ];then
  download_url="http://ojcljv5tn.bkt.clouddn.com/"
else
  download_url=$1
fi

if [ ! -n "$2" ];then
  nginx_version="1.10.3"
else
  nginx_version=$2
fi

if [ ! -n "$3" ];then
  install_path="/opt/work/lib/nginx"
else
  install_path=$3
fi


# 临时安装包存放目录
temp_package_dir="/var/packagetemps"

if [ ! -d "${temp_package_dir}" ];then
    mkdir -p "${temp_package_dir}"
fi

nginx_name="nignx-${nginx_version}.tar.gz"

echo "安装依赖包"
yum -y install make gcc gcc-c++
echo "安装依赖包完成，开始安装Ngnix"

cd "${temp_package_dir}"
if [ ! -f "${nginx_name}" ];then
  wget "${download_url}${nginx_name}"
  if [ $? -ne 0 ];then
     echo "下载${nginx_name}失败"
     exit 1
  fi
fi

tar -zxf "${nginx_name}"
cd "openssl-1.1.0"
./config
make && make install

cd "../zlib-1.2.11"
./configure
make && make install

cd "../pcre-8.40"
./configure
make && make install

ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1

cd "../nginx-1.10.3"
./configure --prefix=${install_path} --with-pcre=../pcre-8.40 --with-zlib=../zlib-1.2.11 --with-openssl=../openssl-1.1.0
make && make install
chmod -R 777 ${install_path}/sbin/*
${install_path}/sbin/nig
echo "安装完成"
