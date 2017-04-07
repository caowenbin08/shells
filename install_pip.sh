#!/bin/bash

download_domain="http://ojcljv5tn.bkt.clouddn.com/"
setuptools_filename="setuptools-24.0.1"
pip_filename="pip-9.0.1"

install_package_path="/tmp/install_packages"

if [ ! -d "${install_package_path}" ]; then
    mkdir -p "${install_package_path}"
    echo "mkdir tmp dir ${install_package_path}"
fi

type pip 1>/dev/null 2>&1

if [ $? -ne 0 ]; then
   echo "start install pip...."
   cd "${install_package_path}"

   if [ ! -f "${setuptools_filename}.tar.gz" ];then
      wget "${download_domain}${setuptools_filename}.tar.gz"

      if [ $? -ne 0 ];then
         echo "download  ${setuptools_filename} Failed"
         exit 1
      fi
   fi

   tar zxf "${setuptools_filename}.tar.gz"
   cd "${setuptools_filename}"
   python setup.py install
   cd ../

   if [ ! -f "${pip_filename}.tar.gz" ]; then
      wget "${download_domain}${pip_filename}.tar.gz"
      if [ $? -ne 0 ]; then
         echo "download ${pip_filename} Failed"
         exit 1
      fi
   fi

   tar zxf "${pip_filename}.tar.gz"
   cd "${pip_filename}"
   python setup.py install
   cd ../
   rm -rf ${setuptools_filename} ${pip_filename}
   echo "pip install successful"

else
    echo "pip already exist"

fi

