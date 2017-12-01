#!/bin/bash

#------------------------------
# 请用root用户安装
# 安装 Kingshard 脚本
# **安装包是统一管理与命名
# 使用方法：
#    deploy_kingshard.sh 0.1
#
#------------------------------

download_url="http://ojcljv5tn.bkt.clouddn.com"

if [ ! -n "$1" ];then
  version="0.1"
else
  version=$1
fi

kingshard_name="kingshard-${version}.tar.gz"
echo "download_url: ${download_url} \nversion: ${version}"
# 临时安装包存放目录
temp_package_dir="/var/tmp/package"

if [ ! -d "${temp_package_dir}" ];then
    sudo mkdir -p "${temp_package_dir}"
fi

which make
if [ $? -ne 0 ];then
  # 查看Linux系统版本的命令
  sys_type=`cat /etc/issue | awk '{print $1}' | tr 'A-Z' 'a-z'`
  echo "System: ${sys_type}"
  if [ "ubuntu" = "${sys_type}" ];then
    sudo apt-get install make
  else
    sudo yum install make
  fi
fi
echo ""
echo ""
echo ">>>>>>>>>>>安装 Kingshard Mysql Proxy...."
cd "${temp_package_dir}"

if [ ! -f "${kingshard_name}" ];then
  wget "${download_url}/${kingshard_name}"
  if [ $? -ne 0 ];then
     echo "下载${kingshard_name}失败"
     exit 1
  fi
fi
base_dir="/opt/lib/kingshard/src/github.com/flike"
sudo mkdir -p "${base_dir}"
sudo tar -C "${base_dir}" -zxf "${kingshard_name}"

export VTTOP="${base_dir}/kingshard"
export VTROOT="${VTROOT:-${VTTOP/\/src\/github.com\/flike\/kingshard/}}"
if [[ "$VTTOP" == "${VTTOP/\/src\/github.com\/flike\/kingshard/}" ]]; then
  echo "WARNING: VTTOP($VTTOP) does not contain src/github.com/flike/kingshard"
fi
export GOTOP=$VTTOP
function prepend_path()
{
  # $1 path variable
  # $2 path to add
  if [ -d "$2" ] && [[ ":$1:" != *":$2:"* ]]; then
    echo "$2:$1"
  else
    echo "$1"
  fi
}
export GOPATH=$(prepend_path $GOPATH $VTROOT)
which kingshard
if [ $? -ne 0 ]; then
  cd "${VTTOP}"
  pwd
  make
  k_bin="/opt/lib/kingshard/bin"
  ln -s "${VTTOP}/bin" "${k_bin}"
  sudo echo "export PATH=$PATH:${k_bin}">>/etc/profile
fi

echo "<<<<<<<<<<< 安装 Kingshard 成功，请source /etc/profile<<<<<<<<<<<<<"