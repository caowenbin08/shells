#!/bin/bash

#------------------------------
# 安装 rabbitMQ 服务器脚本
# **安装包是统一管理与命名
# 使用方法：
#    install.sh http://ojcljv5tn.bkt.clouddn.com/ 3.6.6 19.1
#
# 1、可以外部传入下载路径、MQ版本、Erlang版本，反之采用默认值
#      download_url="http://ojcljv5tn.bkt.clouddn.com/"
#      rabbit_version=3.6.6
#      erlang_version=19.1
#------------------------------

if [ ! -n "$0" ];then
  download_url="http://ojcljv5tn.bkt.clouddn.com/"
else
  download_url=$0
fi

if [ ! -n "$1" ];then
  rabbit_version="3.6.6"
else
  rabbit_version=$1
fi

if [ ! -n "$2" ];then
  erlang_version="19.1"
else
  erlang_version=$2
fi

# 临时安装包存放目录
temp_package_dir="/var/tmp/package"

if [ ! -d "${temp_package_dir}" ];then
    mkdir -p "${temp_package_dir}"
fi

echo "安装依赖包"
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl-devel perl unixODBC-devel
echo "安装依赖包完成"
echo "start install Erlang...."
cd "${install_package_path}"
if [ ! -f "${erlang_file_name}.tar.gz" ];then
  wget "${download_domain}${erlang_file_name}.tar.gz"
  if [ $? -ne 0 ];then
     echo "download  ${erlang_file_name} Failed"
     exit 1
  fi
fi
tar xf "${erlang_file_name}.tar.gz"
cd "otp_src_19.1"
./configure --prefix=/opt/binwen/erlang --without-javac
make && make install

which erl
if [ $? -ne 0 ]; then
   echo "export PATH=/opt/binwen/erlang/bin:$PATH">>/etc/profile
   sleep 2
   source /etc/profile
fi

echo "start install RabbitMQ...."
cd "${install_package_path}"
if [ ! -f "${rabbitmq_file_name}.tar.gz" ];then
   wget "${download_domain}${rabbitmq_file_name}.tar.gz"

   if [ $? -ne 0 ];then
      echo "download  ${rabbitmq_file_name} Failed"
      exit 1
   fi
fi
tar zxf "${rabbitmq_file_name}.tar.gz"
mkdir -p /opt/binwen/rabbitmq
yes|cp -rp rabbitmq_server-3.6.6/* /opt/binwen/rabbitmq/

which rabbitmqctl
if [ $? -ne 0 ]; then
  echo "export PATH=/opt/binwen/rabbitmq/sbin:$PATH">>/etc/profile
  sleep 2
  source /etc/profile
fi
echo "start install RabbitMQ...."
chkconfig rabbitmq-server on
service rabbitmq-server start
rabbitmqctl add_user sql_audit sql_audit
rabbitmqctl set_user_tags sql_audit administrator
rabbitmqctl set_permissions -p / sql_audit ".*" ".*" ".*"
echo "<<<<<<<<<<< Install RabbitMQ Succeed <<<<<<<<<<<<<"
