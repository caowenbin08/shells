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
#
#  pyenv 常用命令

###  --- python配置

#      pyenv versions — 查看系统当前安装的python列表
#      pyenv install -v 3.5.1 — 安装python
#      pyenv uninstall 2.7.3 — 卸载python
#      pyenv rehash — 创建垫片路径（为所有已安装的可执行文件创建 shims，
#        如：~/.pyenv/versions/*/bin/*，因此，每当你增删了 Python 版本或带有可执行文件的包
#        （如 pip）以后，都应该执行一次本命令）
#  ----- python切换
#      pyenv global 3.4.0 — 设置全局的 Python 版本，通过将版本号写入 ~/.pyenv/version 文件的方式。
#      pyenv local 2.7.3 — 设置面向程序的本地版本，通过将版本号写入当前目录下的
#         .python-version 文件的方式。通过这种方式设置的 Python 版本优先级较 global 高。
#      pyenv 会从当前目录开始向上逐级查找 .python-version 文件，直到根目录为止。若找不到，就用 global 版本。
#      pyenv shell pypy-2.2.1 — 设置面向 shell 的 Python 版本，
#           通过设置当前 shell 的 PYENV_VERSION 环境变量的方式。这个版本的优先级
#           比 local 和 global 都要高。–unset 参数可以用于取消当前 shell 设定的版本。
#      pyenv shell --unset
#----- python优先级
#      shell > local > global

#  查看现在使用的python版本 pyenv version
#  查看可供pyenv使用的python版本  pyenv versions
#  查看所以可以安装的版本  pyenv install --list
#  安装python版本 pyenv install <python版本>
#     1）使用搜狐源进行安装
#        v=2.7.5;wget http://mirrors.sohu.com/python/$v/Python-$v.tar.xz -P /opt/work/lib/pyenv/cache/;pyenv install $v
#     2）更换源
#
#  卸载 pyenv uninstall <python版本>
#  设置全局python版本，一般不建议改变全局设置 pyenv global <python版本>
#  设置局部python版本 pyenv local <python版本>
#   ***设置之后可以在目录内外分别试下which python或python --version看看效果,
#     如果没变化的话可以$ python rehash之后再试试
#  安装的版本会在 /opt/work/lib/pyenv/versions目录下

#  ----------------- pyenv-virtualenv使用命令 --------------------------
#  mkdir virtual_env
#  cd virtual_env/
#  ~/virtual_env$ pyenv virtualenv <python版本> <虚拟环境名称>
#  激活 pyenv activate <虚拟环境名称>
#  退出 pyenv deactivate
#  创建虚拟环境 $ pyenv virtualenv 2.7.10 my-virtual-env-2.7.10
#  若不指定python 版本，会汇报认使用当前环境python版本。
#  列出当前虚拟环境 pyenv virtualenvs
#  激活虚拟环境 pyenv activate
#  退出虚拟环境 pyenv deactivate
#  删除虚拟环境 pyenv uninstall my-virtual-env
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
cur_time=`date +%Y%m%d`
if [ "`ls -a ${install_path}/pyenv`" = "" ]; then
    echo "${install_path}/pyenv is empty"
else
    echo "${install_path}/pyenv is not empty, backup..."
    mv ${install_path}/pyenv ${install_path}/pyenv.backup-${cur_time}
fi
mv pyenv ${install_path}
mv pyenv-virtualenv ${install_path}/pyenv/plugins

if [ ! -f "/etc/profile.d/pyenv.sh" ]; then
    echo "set config to /etc/profile.d/pyenv.sh"
    pyenv_root="export PYENV_ROOT=${install_path}/pyenv"
    pyenv_conf=/etc/profile.d/pyenv.sh
    echo ${pyenv_root} >> ${pyenv_conf}
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ${pyenv_conf}
    echo 'if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi' >> ${pyenv_conf}
fi

# 重新加载shell
# exec $SHELL -l
echo "安装完成"
