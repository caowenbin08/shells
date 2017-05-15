#!/bin/bash

#------------------------------
# 安装 多个py版本与虚拟环境工具 脚本
# **安装包是统一管理与命名
# 安装方法：
#    install.sh http://ojcljv5tn.bkt.clouddn.com/ 20160726 /opt/work/lib
#
# 1、可以外部传入下载路径，pyenv版本号、安装目录 ，反之采用默认值
#      download_url="http://ojcljv5tn.bkt.clouddn.com/"
#      version=20160726
#      install_path="/opt/work/lib"
# 2、pyenv-20160726.tar.gz安装包主要包含
#      pyenv、pyenv-virtualenv这2个安装包
#
# pyenv命令使用方法：
#  查看现在使用的python版本 pyenv version
#  查看可供pyenv使用的python版本  pyenv versions
#  查看所以可以安装的版本  pyenv install --list
#  安装python版本 pyenv install <python版本>
#  卸载 pyenv uninstall <python版本>
#  设置全局python版本，一般不建议改变全局设置 pyenv global <python版本>
#  设置局部python版本 pyenv local <python版本>
#   ***设置之后可以在目录内外分别试下which python或python --version看看效果,
#     如果没变化的话可以$ python rehash之后再试试
#  安装的版本会在 /opt/work/lib/pyenv/versions目录下
#  pyenv-virtualenv使用命令
#  mkdir virtual_env
#  cd virtual_env/
#  ~/virtual_env$ pyenv virtualenv <python版本> <虚拟环境名称>
#  激活 pyenv activate <虚拟环境名称>
#  退出 pyenv deactivate
#------------------------------

if [ ! -n "$1" ];then
  download_url="http://ojcljv5tn.bkt.clouddn.com/"
else
  download_url=$1
fi

if [ ! -n "$2" ];then
  version="20160726"
else
  version=$2
fi

if [ ! -n "$3" ];then
  install_path="/opt/work/lib"
else
  install_path=$3
fi


# 临时安装包存放目录
temp_package_dir="/var/packagetemps"

if [ ! -d "${temp_package_dir}" ];then
    mkdir -p "${temp_package_dir}"
fi

if [ ! -d "${install_path}" ];then
    mkdir -p "${install_path}"
fi

package_name="pyenv-${version}.tar.gz"

cd "${temp_package_dir}"
if [ ! -f "${package_name}" ];then
  wget "${download_url}${package_name}"
  if [ $? -ne 0 ];then
     echo "下载${package_name}失败"
     exit 1
  fi
fi
echo "开始安装"
tar -zxf "${package_name}"
mv pyenv ${install_path}
mv pyenv-virtualenv ${install_path}/pyenv/plugins
# 如果使用的是bash
if [ -f "~/.bashrc" ]; then
    echo "install to bash shell"
    pyenv_root="export PYENV_ROOT=${install_path}/pyenv"
    echo ${pyenv_root} >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi

# 如果使用的是zsh
if [ -f "~/.zshrc" ]; then
    echo "install to zsh shell"
    echo ${pyenv_root} >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi

# 重新加载shell
# exec $SHELL -l
echo "安装完成"
